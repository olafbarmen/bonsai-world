//
//  LibraryImportPreview.swift
//  Bonsai World
//
//  Summary shown before applying an import.
//

import Foundation

struct LibraryImportIssue: Identifiable, Sendable, Hashable, Error {
    var id: String { "\(sheet)-\(row)-\(message)" }
    var sheet: String
    var row: Int
    var message: String
}

struct LibraryExcelImportPreview: Sendable {
    var treesToUpdate = 0
    var treesToCreate = 0
    var treesSkipped = 0
    var workToAdd = 0
    var workSkipped = 0
    var issues: [LibraryImportIssue] = []

    var canImport: Bool {
        treesToUpdate + treesToCreate + workToAdd > 0
    }

    var summary: String {
        var parts: [String] = []
        if treesToUpdate > 0 { parts.append("\(treesToUpdate) trees updated") }
        if treesToCreate > 0 { parts.append("\(treesToCreate) trees created") }
        if workToAdd > 0 { parts.append("\(workToAdd) work records added") }
        if treesSkipped + workSkipped > 0 {
            parts.append("\(treesSkipped + workSkipped) rows skipped")
        }
        return parts.isEmpty ? "Nothing to import." : parts.joined(separator: ", ")
    }
}

struct LibraryZipImportPreview: Sendable {
    var treeCount: Int
    var libraryFolderName: String
    var destinationPath: String

    var destinationPathDisplay: String {
        (destinationPath as NSString).abbreviatingWithTildeInPath
    }

    var summary: String {
        "The ZIP has \(treeCount) trees. Restoring replaces everything in the open library."
    }
}
