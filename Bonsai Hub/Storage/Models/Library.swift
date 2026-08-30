//
//  Library.swift
//  Bonsai World
//
//  Describes the single Bonsai World Library package (metadata only).
//  Does not store absolute paths — location is a LibraryLocationConfiguration.
//

import Foundation

/// Metadata for the user’s Bonsai World Library.
struct Library: Codable, Hashable, Sendable, Identifiable {
    var id: UUID
    /// Display name (default: “Bonsai World Library”).
    var libraryName: String
    /// Where the package lives (Internal SSD today; Settings later).
    var libraryLocation: LibraryLocationConfiguration
    var createdDate: Date
    /// Library package format version (not the app marketing version).
    var version: String

    /// Current on-disk package format.
    static let currentVersion = "1.0"
    static let defaultName = "Bonsai World Library"

    init(
        id: UUID = UUID(),
        libraryName: String = Library.defaultName,
        libraryLocation: LibraryLocationConfiguration = .defaultLocal,
        createdDate: Date = .now,
        version: String = Library.currentVersion
    ) {
        self.id = id
        self.libraryName = libraryName
        self.libraryLocation = libraryLocation
        self.createdDate = createdDate
        self.version = version
    }
}

/// Canonical relative folders inside a Bonsai World Library package.
enum LibraryPackageLayout {
    static let metadataFileName = "Library.json"

    static let database = "Database"
    static let images = "Images"
    static let imagesOriginals = "Images/Originals"
    static let imagesHero = "Images/Hero"
    static let imagesThumbnails = "Images/Thumbnails"
    /// Persistent ImageAsset / Tree Photo metadata catalog.
    static let imagesCatalogFileName = "Images/Catalog.json"
    /// Non-destructive presentation crop recipes (Original bytes never modified).
    static let imagesPresentationsFileName = "Images/Presentations.json"
    /// Tree ↔ photo membership (primary + gallery order) until full Tree DB lands.
    static let treePhotoIndexFileName = "Database/TreePhotoIndex.json"
    /// Append-only Tree Measurement History (dated sessions).
    static let treeMeasurementHistoryFileName = "Database/TreeMeasurementHistory.json"
    /// Tree records for the library (LibraryTreeRepository).
    static let treesFileName = "Database/Trees.json"
    /// Per-species Bonsai Name sequence high-water marks.
    static let bonsaiNameSequencesFileName = "Database/BonsaiNameSequences.json"
    /// Collection records for the library (LibraryCollectionRepository).
    static let collectionsFileName = "Database/Collections.json"
    /// Garden records for the library (LibraryGardenRepository).
    static let gardensFileName = "Database/Gardens.json"
    /// LocationReference records for the library (LibraryLocationRepository).
    static let locationsFileName = "Database/Locations.json"
    /// WorkRecord entries for the library (LibraryWorkRepository).
    static let workFileName = "Database/Work.json"
    /// CareTask entries for the library (LibraryTaskRepository).
    static let tasksFileName = "Database/Tasks.json"
    /// CareSchedule entries for the library (LibraryScheduleRepository).
    static let schedulesFileName = "Database/Schedules.json"
    static let documents = "Documents"
    static let cache = "Cache"
    static let backups = "Backups"

    /// All folders that must exist (created if missing).
    static var requiredRelativeFolders: [String] {
        [
            database,
            images,
            imagesOriginals,
            imagesHero,
            imagesThumbnails,
            documents,
            cache,
            backups
        ]
    }
}
