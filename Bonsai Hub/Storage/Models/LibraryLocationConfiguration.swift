//
//  LibraryLocationConfiguration.swift
//  Bonsai World
//
//  Configurable library location for Settings.
//  Does not expose absolute paths to Features — security-scoped bookmarks
//  (or equivalent) stay opaque until a provider resolves them.
//

import Foundation

/// Describes which library root the active `StorageProvider` should use.
struct LibraryLocationConfiguration: Hashable, Codable, Sendable {
    var kind: LibraryLocationKind
    /// Opaque bookmark for external / custom folders (Phase 1 Settings). Nil for default internal.
    var bookmarkData: Data?

    /// Default Phase 1 location: Internal SSD (Application Support library).
    static var defaultLocal: LibraryLocationConfiguration {
        LibraryLocationConfiguration(kind: .internalSSD, bookmarkData: nil)
    }
}
