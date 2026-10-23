//
//  LibraryTreesCatalogZip.swift
//  BonsaiCore
//
//  Compact store-method ZIP of Trees.json for iCloud heal when CloudDocs
//  materializes a stale Trees.json while CatalogSyncStamp is already current.
//

import Foundation

enum LibraryTreesCatalogZipError: Error, LocalizedError, Sendable {
    case cannotBuild
    case invalidArchive
    case missingTreesEntry

    var errorDescription: String? {
        switch self {
        case .cannotBuild:
            return "Could not build TreesCatalog.zip."
        case .invalidArchive:
            return "TreesCatalog.zip is not a valid catalog archive."
        case .missingTreesEntry:
            return "TreesCatalog.zip does not contain Trees.json."
        }
    }
}

/// Single-file catalog archive written next to Trees.json as `Database/TreesCatalog.zip`.
enum LibraryTreesCatalogZip: Sendable {
    /// Entry name inside the archive (flat — not nested under Database/).
    static let entryName = "Trees.json"

    /// Relative path inside the library package (Mac + iPhone).
    static let packageRelativePath = "Database/TreesCatalog.zip"

    /// Builds an uncompressed ZIP containing one `Trees.json` entry.
    static func makeArchive(treesJSON: Data) throws -> Data {
        let nameData = Data(entryName.utf8)
        let crc = crc32(treesJSON)
        let size = UInt32(treesJSON.count)

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
        local.append(treesJSON)

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
        central.append(contentsOf: UInt32(0).leBytes) // local header at 0
        central.append(nameData)

        var end = Data()
        end.append(contentsOf: UInt32(0x06054b50).leBytes)
        end.append(contentsOf: UInt16(0).leBytes)
        end.append(contentsOf: UInt16(0).leBytes)
        end.append(contentsOf: UInt16(1).leBytes)
        end.append(contentsOf: UInt16(1).leBytes)
        end.append(contentsOf: UInt32(central.count).leBytes)
        end.append(contentsOf: UInt32(local.count).leBytes)
        end.append(contentsOf: UInt16(0).leBytes)

        var archive = Data()
        archive.reserveCapacity(local.count + central.count + end.count)
        archive.append(local)
        archive.append(central)
        archive.append(end)
        guard !archive.isEmpty else { throw LibraryTreesCatalogZipError.cannotBuild }
        return archive
    }

    /// Returns the Trees.json payload from a store-method catalog ZIP.
    static func extractTreesJSON(from archive: Data) throws -> Data {
        var cursor = 0
        while cursor + 30 <= archive.count {
            let sig: UInt32 = archive.readUInt32(at: cursor)
            if sig == 0x02014b50 || sig == 0x06054b50 { break }
            guard sig == 0x04034b50 else { throw LibraryTreesCatalogZipError.invalidArchive }
            let method: UInt16 = archive.readUInt16(at: cursor + 8)
            guard method == 0 else { throw LibraryTreesCatalogZipError.invalidArchive }
            let compSize = Int(archive.readUInt32(at: cursor + 18))
            let nameLen = Int(archive.readUInt16(at: cursor + 26))
            let extraLen = Int(archive.readUInt16(at: cursor + 28))
            let nameStart = cursor + 30
            let nameEnd = nameStart + nameLen
            guard nameEnd + extraLen + compSize <= archive.count else {
                throw LibraryTreesCatalogZipError.invalidArchive
            }
            let name = String(data: archive.subdata(in: nameStart..<nameEnd), encoding: .utf8) ?? ""
            let payloadStart = nameEnd + extraLen
            let payload = archive.subdata(in: payloadStart..<(payloadStart + compSize))
            let baseName = (name as NSString).lastPathComponent
            if baseName == entryName || name == entryName || name.hasSuffix("/\(entryName)") {
                return payload
            }
            cursor = payloadStart + compSize
        }
        throw LibraryTreesCatalogZipError.missingTreesEntry
    }

    /// Pure Swift CRC-32 (IEEE) — no zlib link required.
    private static func crc32(_ data: Data) -> UInt32 {
        var crc: UInt32 = 0xffff_ffff
        for byte in data {
            crc ^= UInt32(byte)
            for _ in 0..<8 {
                if crc & 1 != 0 {
                    crc = (crc >> 1) ^ 0xedb8_8320
                } else {
                    crc >>= 1
                }
            }
        }
        return crc ^ 0xffff_ffff
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
