//
//  LibraryLocationKind.swift
//  Bonsai World
//
//  User-facing library location choices (Settings).
//  Maps to a StorageProvider + root; Phase 1 supports local kinds only.
//

import Foundation

/// Where the user’s Bonsai World Library lives.
enum LibraryLocationKind: String, Codable, CaseIterable, Sendable, Identifiable {
    case internalSSD
    case externalSSD
    case customFolder
    /// Phase 2 — not selectable until an iCloud provider exists.
    case iCloudDrive
    /// Phase 3 — not selectable until a OneDrive provider exists.
    case oneDrive
    /// Phase 4 — not selectable until Bonsai Cloud provider exists.
    case bonsaiCloud

    var id: String { rawValue }

    /// Kinds available in Phase 1 (local storage only).
    static var phase1Selectable: [LibraryLocationKind] {
        [.internalSSD, .externalSSD, .customFolder]
    }

    /// Phase 1 local + iCloud Drive when the ubiquity container is available.
    static var selectable: [LibraryLocationKind] {
        var kinds = phase1Selectable
        if BonsaiWorldICloudLibrary.isAvailable {
            kinds.append(.iCloudDrive)
        }
        return kinds
    }

    var isPhase1Local: Bool {
        switch self {
        case .internalSSD, .externalSSD, .customFolder:
            true
        case .iCloudDrive, .oneDrive, .bonsaiCloud:
            false
        }
    }

    /// Library package may live here in shipping Settings / First Launch.
    var isSelectableNow: Bool {
        Self.selectable.contains(self)
    }

    /// Settings label (human-facing).
    var displayName: String {
        switch self {
        case .internalSSD: "Internal SSD"
        case .externalSSD: "External SSD"
        case .customFolder: "Custom Folder"
        case .iCloudDrive: "iCloud Drive"
        case .oneDrive: "OneDrive"
        case .bonsaiCloud: "Bonsai Cloud"
        }
    }
}
