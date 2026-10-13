//
//  MobileStoredZip.swift
//  Bonsai World
//
//  Minimal store-method (uncompressed) ZIP create/extract for iOS library export/import.
//  No third-party compression dependency.
//

import Foundation
import zlib

enum MobileStoredZipError: LocalizedError {
    case cannotCreateFile
    case invalidArchive
    case missingTreesFile

    var errorDescription: String? {
        switch self {
        case .cannotCreateFile: "Could not create the export archive."
        case .invalidArchive: "The selected file is not a valid Bonsai World library archive."
        case .missingTreesFile: "The archive does not contain Database/Trees.json."
        }
    }
}

enum MobileStoredZip {
    /// Creates an uncompressed ZIP of every file under `sourceDirectory`.
    static func zipDirectory(_ sourceDirectory: URL, to destinationURL: URL) throws {
        let fm = FileManager.default
        if fm.fileExists(atPath: destinationURL.path) {
            try fm.removeItem(at: destinationURL)
        }
        fm.createFile(atPath: destinationURL.path, contents: nil)
        guard let handle = try? FileHandle(forWritingTo: destinationURL) else {
            throw MobileStoredZipError.cannotCreateFile
        }
        defer { try? handle.close() }

        var centralDirectory = Data()
        var entryCount: UInt16 = 0
        var offset: UInt32 = 0

        let enumerator = fm.enumerator(
            at: sourceDirectory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        )
        while let item = enumerator?.nextObject() as? URL {
            let values = try item.resourceValues(forKeys: [.isRegularFileKey])
            guard values.isRegularFile == true else { continue }
            let base = sourceDirectory.standardizedFileURL.path
            let full = item.standardizedFileURL.path
            guard full.hasPrefix(base) else { continue }
            let relative = String(full.dropFirst(base.count).drop(while: { $0 == "/" }))
            guard !relative.isEmpty else { continue }
            let data = try Data(contentsOf: item)
            let nameData = Data(relative.utf8)
            let crc = crc32(data)
            let size = UInt32(data.count)

            var local = Data()
            local.append(contentsOf: UInt32(0x04034b50).leBytes)
            local.append(contentsOf: UInt16(20).leBytes)
            local.append(contentsOf: UInt16(0).leBytes)
            local.append(contentsOf: UInt16(0).leBytes) // stored
            local.append(contentsOf: UInt16(0).leBytes)
            local.append(contentsOf: UInt16(0).leBytes)
            local.append(contentsOf: crc.leBytes)
            local.append(contentsOf: size.leBytes)
            local.append(contentsOf: size.leBytes)
            local.append(contentsOf: UInt16(nameData.count).leBytes)
            local.append(contentsOf: UInt16(0).leBytes)
            local.append(nameData)
            local.append(data)
            try handle.write(contentsOf: local)

            var central = Data()
            central.append(contentsOf: UInt32(0x02014b50).leBytes)
            central.append(contentsOf: UInt16(20).leBytes)
            central.append(contentsOf: UInt16(20).leBytes)
            central.append(contentsOf: UInt16(0).leBytes)
            central.append(contentsOf: UInt16(0).leBytes)
            central.append(contentsOf: UInt16(0).leBytes)
            central.append(contentsOf: UInt16(0).leBytes)
            central.append(contentsOf: crc.leBytes)
            central.append(contentsOf: size.leBytes)
            central.append(contentsOf: size.leBytes)
            central.append(contentsOf: UInt16(nameData.count).leBytes)
            central.append(contentsOf: UInt16(0).leBytes)
            central.append(contentsOf: UInt16(0).leBytes)
            central.append(contentsOf: UInt16(0).leBytes)
            central.append(contentsOf: UInt16(0).leBytes)
            central.append(contentsOf: UInt32(0).leBytes)
            central.append(contentsOf: offset.leBytes)
            central.append(nameData)
            centralDirectory.append(central)

            offset += UInt32(local.count)
            entryCount += 1
        }

        let centralOffset = offset
        try handle.write(contentsOf: centralDirectory)
        var end = Data()
        end.append(contentsOf: UInt32(0x06054b50).leBytes)
        end.append(contentsOf: UInt16(0).leBytes)
        end.append(contentsOf: UInt16(0).leBytes)
        end.append(contentsOf: entryCount.leBytes)
        end.append(contentsOf: entryCount.leBytes)
        end.append(contentsOf: UInt32(centralDirectory.count).leBytes)
        end.append(contentsOf: centralOffset.leBytes)
        end.append(contentsOf: UInt16(0).leBytes)
        try handle.write(contentsOf: end)
    }

    /// Extracts a store-method ZIP into `destinationDirectory` (created if needed).
    static func unzip(_ archiveURL: URL, to destinationDirectory: URL) throws {
        let fm = FileManager.default
        if fm.fileExists(atPath: destinationDirectory.path) {
            try fm.removeItem(at: destinationDirectory)
        }
        try fm.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)

        let data = try Data(contentsOf: archiveURL)
        var cursor = 0
        while cursor + 30 <= data.count {
            let sig: UInt32 = data.readUInt32(at: cursor)
            if sig == 0x02014b50 || sig == 0x06054b50 { break }
            guard sig == 0x04034b50 else { throw MobileStoredZipError.invalidArchive }
            let method: UInt16 = data.readUInt16(at: cursor + 8)
            guard method == 0 else { throw MobileStoredZipError.invalidArchive }
            let compSize = Int(data.readUInt32(at: cursor + 18))
            let nameLen = Int(data.readUInt16(at: cursor + 26))
            let extraLen = Int(data.readUInt16(at: cursor + 28))
            let nameStart = cursor + 30
            let nameEnd = nameStart + nameLen
            guard nameEnd + extraLen + compSize <= data.count else { throw MobileStoredZipError.invalidArchive }
            let name = String(data: data.subdata(in: nameStart..<nameEnd), encoding: .utf8) ?? ""
            let payloadStart = nameEnd + extraLen
            let payload = data.subdata(in: payloadStart..<(payloadStart + compSize))
            let fileURL = destinationDirectory.appendingPathComponent(name)
            try fm.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try payload.write(to: fileURL, options: .atomic)
            cursor = payloadStart + compSize
        }
    }

    private static func crc32(_ data: Data) -> UInt32 {
        data.withUnsafeBytes { buffer -> UInt32 in
            let ptr = buffer.bindMemory(to: UInt8.self).baseAddress
            let length = uInt(buffer.count)
            return UInt32(zlib.crc32(0, ptr, length))
        }
    }
}

private extension FixedWidthInteger {
    var leBytes: [UInt8] {
        withUnsafeBytes(of: littleEndian) { Array($0) }
    }
}

private extension Data {
    func readUInt16(at offset: Int) -> UInt16 {
        UInt16(self[offset]) | (UInt16(self[offset + 1]) << 8)
    }

    func readUInt32(at offset: Int) -> UInt32 {
        UInt32(self[offset])
            | (UInt32(self[offset + 1]) << 8)
            | (UInt32(self[offset + 2]) << 16)
            | (UInt32(self[offset + 3]) << 24)
    }
}
