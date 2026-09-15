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
    /// Tree ↔ photo membership (primary + gallery order) — derived mirror of Tree fields.
    static let treePhotoIndexFileName = "Database/TreePhotoIndex.json"
    /// Lock that Tree is photo SSOT. Lives outside the mirror so a reset/corrupt
    /// TreePhotoIndex.json cannot re-arm legacy “fill trees from index” migration.
    static let treePhotoSSOTStateFileName = "Database/TreePhotoSSOT.json"
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
    /// JournalEntry records for the library (LibraryJournalRepository).
    static let journalFileName = "Database/Journal.json"
    /// CareTask entries for the library (LibraryTaskRepository).
    static let tasksFileName = "Database/Tasks.json"
    /// CareSchedule entries for the library (LibraryScheduleRepository).
    static let schedulesFileName = "Database/Schedules.json"
    /// Pot records for the library (LibraryPotRepository).
    static let potsFileName = "Database/Pots.json"
    static let yamadoriFileName = "Database/Yamadori.json"
    /// Seed batch propagation records (LibrarySeedBatchRepository).
    static let seedBatchesFileName = "Database/SeedBatches.json"
    /// Cuttings / Air Layers / Grafting projects (LibraryNurseryPropagationRepository).
    static let nurseryPropagationProjectsFileName = "Database/NurseryPropagationProjects.json"
    /// Media Documents / Videos / Notes / Audio catalog.
    static let mediaLibraryFileName = "Database/MediaLibrary.json"
    /// Knowledge Quick Guides / FAQ / Courses / Video Tutorials / External Links.
    static let knowledgeResourcesFileName = "Database/KnowledgeResources.json"
    /// Economy / Workshop calendar & tasks note entries (v1).
    static let simpleCatalogFileName = "Database/SimpleCatalog.json"
    /// Soil stock quantities (LibrarySoilStockRepository). Catalog types stay in Settings.
    static let soilStockFileName = "Database/SoilStock.json"
    /// Wire / Tools / Chemicals / Consumables stock (LibraryInventoryStockRepository).
    static let inventoryStockFileName = "Database/InventoryStock.json"
    /// PotBrand / PotMaker records for the library (LibraryPotBrandRepository).
    static let potBrandsFileName = "Database/PotBrandsAndMakers.json"
    /// User Profile fields (name, email, language, profile image ID) — included in ZIP backup.
    static let userProfileFileName = "Database/UserProfile.json"
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

    /// Personal library catalog files removed by Empty Personal Library.
    /// Keeps ``metadataFileName``, ``knowledgeResourcesFileName``, and ``potBrandsFileName``.
    static var personalCatalogRelativePaths: [String] {
        [
            treesFileName,
            collectionsFileName,
            potsFileName,
            yamadoriFileName,
            seedBatchesFileName,
            nurseryPropagationProjectsFileName,
            workFileName,
            journalFileName,
            tasksFileName,
            schedulesFileName,
            soilStockFileName,
            inventoryStockFileName,
            mediaLibraryFileName,
            simpleCatalogFileName,
            locationsFileName,
            gardensFileName,
            userProfileFileName,
            treePhotoIndexFileName,
            treePhotoSSOTStateFileName,
            treeMeasurementHistoryFileName,
            bonsaiNameSequencesFileName,
            imagesCatalogFileName,
            imagesPresentationsFileName
        ]
    }

    /// Folders whose *contents* are deleted by Empty Personal Library (folders kept).
    static var personalContentFolderRelativePaths: [String] {
        [
            imagesOriginals,
            imagesHero,
            imagesThumbnails,
            documents
        ]
    }
}
