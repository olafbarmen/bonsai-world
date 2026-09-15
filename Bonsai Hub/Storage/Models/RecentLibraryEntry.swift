//
//  RecentLibraryEntry.swift
//  Bonsai World
//
//  A recently opened library package, for Switch Library (Settings).
//

import Foundation

/// One remembered library location (security-scoped bookmark + display path).
struct RecentLibraryEntry: Identifiable, Hashable, Codable, Sendable {
    var id: String
    var bookmarkData: Data
    var pathDisplay: String
    var openedAt: Date

    init(id: String, bookmarkData: Data, pathDisplay: String, openedAt: Date = .now) {
        self.id = id
        self.bookmarkData = bookmarkData
        self.pathDisplay = pathDisplay
        self.openedAt = openedAt
    }

    static func make(url: URL, bookmarkData: Data, openedAt: Date = .now) -> RecentLibraryEntry {
        let path = url.path
        return RecentLibraryEntry(
            id: path,
            bookmarkData: bookmarkData,
            pathDisplay: (path as NSString).abbreviatingWithTildeInPath,
            openedAt: openedAt
        )
    }
}
