//
//  LibraryTreesCatalog.swift
//  BonsaiCore
//
//  Single catalog reader/writer for Database/Trees.json.
//  Mac and iPhone both decode through this type. Neither seeds demo data.
//

import Foundation

/// On-disk envelope for `Database/Trees.json`.
struct LibraryTreesFile: Codable, Hashable, Sendable {
    var trees: [Tree]

    init(trees: [Tree] = []) {
        self.trees = trees
    }
}

/// Shared tree-catalog codec and package path. File transport (iCloud download)
/// stays in each app; this type owns the JSON contract.
enum LibraryTreesCatalog: Sendable {
    static let relativePath = "Database/Trees.json"

    static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    static func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    static func decode(_ data: Data) throws -> [Tree] {
        try makeDecoder().decode(LibraryTreesFile.self, from: data).trees
    }

    static func encode(_ trees: [Tree]) throws -> Data {
        try makeEncoder().encode(LibraryTreesFile(trees: trees))
    }

    /// Reads `Trees.json` from a library package root.
    ///
    /// - Returns: `nil` when the file is missing. Never returns demo trees.
    /// - Throws: when the file exists but cannot be decoded, or I/O fails.
    static func read(
        packageRoot: URL,
        fileManager: FileManager = .default
    ) throws -> [Tree]? {
        let url = packageRoot.appendingPathComponent(relativePath, isDirectory: false)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try decode(data)
    }
}
