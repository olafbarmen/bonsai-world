//
//  MobileLibraryStore.swift
//  Bonsai World
//
//  iOS-owned local library package. Same relative JSON / original layout as Mac
//  (Database/Trees.json, Database/Work.json, Database/Collections.json,
//  Database/Locations.json, Database/Gardens.json, Database/Tasks.json,
//  Database/Yamadori.json, Images/Catalog.json, Images/Originals/<uuid>.jpg).
//  Atomic writes. Optional iCloud Documents root shared with Mac (Phase 2).
//

import Foundation
import UIKit

extension Notification.Name {
    /// Posted after the library location preference changes and the package is ready to reopen.
    static let bonsaiMobileLibraryLocationDidChange = Notification.Name("bonsai.mobile.libraryLocationDidChange")
}

enum MobileLibraryMoveError: LocalizedError {
    case iCloudUnavailable

    var errorDescription: String? {
        switch self {
        case .iCloudUnavailable:
            return "iCloud Drive is not available on this iPhone."
        }
    }
}

/// Relative paths inside the iOS library package. Values match Mac `LibraryPackageLayout`.
enum MobileLibraryPackageLayout {
    static let database = "Database"
    static let images = "Images"
    static let imagesOriginals = "Images/Originals"
    static let imagesThumbnails = "Images/Thumbnails"
    static let imagesPreviews = "Images/Previews"
    static let treesFileName = LibraryTreesCatalog.relativePath
    /// Same path as Mac `LibraryPackageLayout.catalogSyncStampFileName`.
    static let catalogSyncStampFileName = "Database/CatalogSyncStamp.json"
    /// Same path as Mac `LibraryPackageLayout.treesCatalogZipFileName`.
    static let treesCatalogZipFileName = LibraryTreesCatalogZip.packageRelativePath
    static let workFileName = "Database/Work.json"
    static let collectionsFileName = "Database/Collections.json"
    static let locationsFileName = "Database/Locations.json"
    static let gardensFileName = "Database/Gardens.json"
    static let tasksFileName = "Database/Tasks.json"
    /// Same path as Mac `LibraryPackageLayout.schedulesFileName`.
    static let schedulesFileName = "Database/Schedules.json"
    static let yamadoriFileName = "Database/Yamadori.json"
    static let seedBatchesFileName = "Database/SeedBatches.json"
    static let soilMixesFileName = "Database/SoilMixes.json"
    static let referenceCatalogFileName = "Database/ReferenceCatalog.json"
    static let inventoryStockFileName = "Database/InventoryStock.json"
    /// Same path as Mac `LibraryPackageLayout.potsFileName`.
    static let potsFileName = "Database/Pots.json"
    /// Same path as Mac `LibraryPackageLayout.nurseryPropagationProjectsFileName`.
    static let nurseryPropagationProjectsFileName = "Database/NurseryPropagationProjects.json"
    /// Same path as Mac `LibraryPackageLayout.potBrandsFileName`.
    static let potBrandsFileName = "Database/PotBrandsAndMakers.json"
    static let imagesCatalogFileName = "Images/Catalog.json"
    /// Same path as Mac `LibraryPackageLayout.userProfileFileName`.
    static let userProfileFileName = "Database/UserProfile.json"
    /// Same path as Mac `LibraryPackageLayout.treeMeasurementHistoryFileName`.
    static let treeMeasurementHistoryFileName = "Database/TreeMeasurementHistory.json"
}

enum MobileLibraryStoreError: Error, LocalizedError, Equatable {
    case encodeFailed(String)
    case writeFailed(String)
    case invalidRelativePath(String)
    /// The file exists in iCloud but its bytes are not on this device yet.
    case notLocal
    /// Another device holds the writer lease — catalog write blocked (S3).
    case foreignWriterActive(String)
    /// Local Trees.json is smaller than Mac’s lease count — refuse to overwrite the shared catalog.
    case catalogBehindRemote(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed(let name):
            return "Bonsai World could not encode \(name)."
        case .writeFailed(let detail):
            return "Bonsai World could not save the library (\(detail))."
        case .invalidRelativePath(let path):
            return "Bonsai World rejected an invalid library path (\(path))."
        case .notLocal:
            return "Bonsai World is still downloading this library file from iCloud."
        case .foreignWriterActive(let message):
            return message
        case .catalogBehindRemote(let message):
            return message
        }
    }
}

/// Envelope for `Database/UserProfile.json` — compatible with Mac `LibraryUserProfileFile` name field.
struct MobileUserProfileFile: Codable, Hashable, Sendable {
    var name: String
    var email: String

    init(name: String = "", email: String = "") {
        self.name = name
        self.email = email
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
    }
}

/// Envelope for `Database/Work.json` — same JSON shape as Mac `LibraryWorkFile`.
private struct MobileLibraryWorkFile: Codable {
    var records: [WorkRecord]
}

/// Envelope for `Database/Collections.json` — same JSON shape as Mac `LibraryCollectionsFile`.
private struct MobileLibraryCollectionsFile: Codable {
    var collections: [Collection]
}

/// Envelope for `Database/Locations.json` — same JSON shape as Mac `LibraryLocationsFile`.
private struct MobileLibraryLocationsFile: Codable {
    var locations: [Location]
}

/// Envelope for `Database/Gardens.json` — same JSON shape as Mac `LibraryGardensFile`.
private struct MobileLibraryGardensFile: Codable {
    var gardens: [Garden]
}

/// Envelope for `Database/Tasks.json` — same JSON shape as Mac `LibraryTaskFile`.
private struct MobileLibraryTasksFile: Codable {
    var tasks: [CareTask]
}

/// Envelope for `Database/Schedules.json` — same JSON shape as Mac `LibraryScheduleFile`.
private struct MobileLibrarySchedulesFile: Codable {
    var schedules: [CareSchedule]
}

/// Envelope for `Database/Yamadori.json` — same JSON shape as Mac `LibraryYamadoriFile` (schema 2).
private struct MobileLibraryYamadoriFile: Codable {
    var schemaVersion: Int
    var trips: [Yamadori]
    var finds: [YamadoriFind]

    init(schemaVersion: Int = 2, trips: [Yamadori] = [], finds: [YamadoriFind] = []) {
        self.schemaVersion = schemaVersion
        self.trips = trips
        self.finds = finds
    }
}

/// Envelope for `Database/SeedBatches.json` — same JSON shape as Mac `LibrarySeedBatchesFile`.
private struct MobileLibrarySeedBatchesFile: Codable {
    var schemaVersion: Int
    var batches: [SeedBatch]

    init(schemaVersion: Int = 1, batches: [SeedBatch] = []) {
        self.schemaVersion = schemaVersion
        self.batches = batches
    }
}

/// Envelope for `Database/SoilMixes.json` — grower Soil Mix catalog on iOS.
private struct MobileLibrarySoilMixesFile: Codable {
    var schemaVersion: Int
    var mixes: [SoilMix]

    init(schemaVersion: Int = 1, mixes: [SoilMix] = []) {
        self.schemaVersion = schemaVersion
        self.mixes = mixes
    }
}

/// Envelope for `Database/ReferenceCatalog.json` — Settings → Reference Data lists.
private struct MobileLibraryReferenceCatalogFile: Codable {
    var catalog: MobileReferenceCatalog

    init(catalog: MobileReferenceCatalog) {
        self.catalog = catalog
    }
}

/// Envelope for `Database/InventoryStock.json` — same shape as Mac `LibraryInventoryStockFile`.
private struct MobileLibraryInventoryStockFile: Codable {
    var schemaVersion: Int
    var items: [InventoryStockItem]

    init(schemaVersion: Int = 1, items: [InventoryStockItem] = []) {
        self.schemaVersion = schemaVersion
        self.items = items
    }
}

/// Envelope for `Database/Pots.json` — same JSON shape as Mac `LibraryPotsFile`.
private struct MobileLibraryPotsFile: Codable {
    var pots: [Pot]

    init(pots: [Pot] = []) {
        self.pots = pots
    }
}

/// Envelope for `Database/NurseryPropagationProjects.json` — same shape as Mac.
private struct MobileLibraryNurseryPropagationFile: Codable {
    var schemaVersion: Int
    var projects: [NurseryPropagationProject]

    init(schemaVersion: Int = 1, projects: [NurseryPropagationProject] = []) {
        self.schemaVersion = schemaVersion
        self.projects = projects
    }
}

/// Envelope for `Database/PotBrandsAndMakers.json` — same shape as Mac.
private struct MobileLibraryPotBrandsFile: Codable {
    var seedVersion: Int?
    var brands: [PotBrand]
    var makers: [PotMaker]

    init(seedVersion: Int? = nil, brands: [PotBrand] = [], makers: [PotMaker] = []) {
        self.seedVersion = seedVersion
        self.brands = brands
        self.makers = makers
    }
}

/// Local JSON + JPEG package rooted at `rootURL` (injectable for tests).
struct MobileLibraryStore {
    let rootURL: URL
    /// Whether this store points at the shared iCloud package. Fixed at creation — no ubiquity lookup.
    let isICloudDrive: Bool
    private let fileManager: FileManager

    /// Process-wide bypass after Settings → Write anyway (S3).
    private static var libraryWriteBypassUntil: Date?

    init(rootURL: URL, isICloudDrive: Bool = false, fileManager: FileManager = .default) {
        self.rootURL = rootURL
        self.isICloudDrive = isICloudDrive
        self.fileManager = fileManager
    }

    /// Preference for where the iOS package lives (B2 first-launch choice).
    enum LocationPreference: String {
        case undecided
        case local
        case iCloud
    }

    private static let locationPreferenceKey = "bonsai.mobile.libraryLocationPreference"

    static var locationPreference: LocationPreference {
        get {
            guard let raw = UserDefaults.standard.string(forKey: locationPreferenceKey),
                  let value = LocationPreference(rawValue: raw)
            else {
                return .undecided
            }
            return value
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: locationPreferenceKey)
        }
    }

    /// Sandboxed Application Support. Not the Mac “Bonsai World Library” folder.
    static func applicationSupport(fileManager: FileManager = .default) -> MobileLibraryStore {
        let support = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.temporaryDirectory
        let root = support.appendingPathComponent("Bonsai World iOS", isDirectory: true)
        return MobileLibraryStore(rootURL: root, fileManager: fileManager)
    }

    /// Shared iCloud package root (same as Mac). `nil` when iCloud is unavailable or does not answer in time.
    /// Uses the cached root when present; the ubiquity lookup never runs on the calling thread.
    static func iCloudDrive(fileManager: FileManager = .default) async -> MobileLibraryStore? {
        guard let root = await BonsaiWorldICloudLibrary.preferredLibraryRootURL() else {
            return nil
        }
        return MobileLibraryStore(rootURL: root, isICloudDrive: true, fileManager: fileManager)
    }

    /// Resolves the preferred store after first-launch choice.
    /// When preference is iCloud, never silently returns the On This iPhone package (that hid Mac updates).
    static func resolvedPreferred(fileManager: FileManager = .default) async -> MobileLibraryStore {
        switch locationPreference {
        case .iCloud:
            if let iCloud = await iCloudDrive(fileManager: fileManager) {
                return iCloud
            }
            if let root = BonsaiWorldICloudLibrary.cachedLibraryRootURL(fileManager: fileManager)
                ?? BonsaiWorldICloudLibrary.discoveredLibraryRootURL(fileManager: fileManager) {
                return MobileLibraryStore(rootURL: root, isICloudDrive: true, fileManager: fileManager)
            }
            #if targetEnvironment(simulator)
            return applicationSupport(fileManager: fileManager)
            #else
            // Expected Mobile Documents path — DemoLibrary stays on “Opening iCloud library” until Trees.json lands.
            let root = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
                .appendingPathComponent(
                    "Library/Mobile Documents/iCloud~no~olafbarmen~BonsaiWorld/Documents/Bonsai World Library",
                    isDirectory: true
                )
            return MobileLibraryStore(rootURL: root, isICloudDrive: true, fileManager: fileManager)
            #endif
        case .local, .undecided:
            return applicationSupport(fileManager: fileManager)
        }
    }

    /// Synchronous variant for non-async callers: cached/discovered iCloud root only, never a ubiquity lookup.
    static func resolvedPreferredWithoutLookup(fileManager: FileManager = .default) -> MobileLibraryStore {
        if locationPreference == .iCloud {
            if let root = BonsaiWorldICloudLibrary.cachedLibraryRootURL(fileManager: fileManager)
                ?? BonsaiWorldICloudLibrary.discoveredLibraryRootURL(fileManager: fileManager) {
                return MobileLibraryStore(rootURL: root, isICloudDrive: true, fileManager: fileManager)
            }
            #if targetEnvironment(simulator)
            return applicationSupport(fileManager: fileManager)
            #else
            let root = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
                .appendingPathComponent(
                    "Library/Mobile Documents/iCloud~no~olafbarmen~BonsaiWorld/Documents/Bonsai World Library",
                    isDirectory: true
                )
            return MobileLibraryStore(rootURL: root, isICloudDrive: true, fileManager: fileManager)
            #endif
        }
        return applicationSupport(fileManager: fileManager)
    }

    var treesFileExists: Bool {
        fileManager.fileExists(atPath: url(for: MobileLibraryPackageLayout.treesFileName).path)
    }

    /// True when the package root sits in the shared Bonsai World ubiquity container.
    var matchesExpectedICloudContainer: Bool {
        let path = rootURL.path
        return path.contains("iCloud~no~olafbarmen~BonsaiWorld")
            || path.contains("iCloud.no.olafbarmen.BonsaiWorld")
    }

    func ensureFolderStructure() throws {
        for relative in [
            MobileLibraryPackageLayout.database,
            MobileLibraryPackageLayout.images,
            MobileLibraryPackageLayout.imagesOriginals,
            MobileLibraryPackageLayout.imagesThumbnails,
            MobileLibraryPackageLayout.imagesPreviews
        ] {
            let url = rootURL.appendingPathComponent(relative, isDirectory: true)
            if !fileManager.fileExists(atPath: url.path) {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            }
        }
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadTrees() throws -> [Tree]? {
        guard let data = try loadPackageFile(relativePath: LibraryTreesCatalog.relativePath) else {
            return nil
        }
        return try LibraryTreesCatalog.decode(data)
    }

    func saveTrees(_ trees: [Tree]) throws {
        try beginLibraryCatalogWrite()
        try refuseTreesWriteIfBehindRemoteCatalog(proposedCount: trees.count)
        let disk = (try? loadTrees()) ?? []
        let merged = LibraryTreeCatalogMerge.merge(disk: disk, proposed: trees)
        let treesData = try LibraryTreesCatalog.encode(merged)
        try writeAtomically(treesData, relativePath: LibraryTreesCatalog.relativePath)
        let stamp = LibraryCatalogSyncStamp.make(from: merged, deviceName: UIDevice.current.name)
        let encoder = LibraryTreesCatalog.makeEncoder()
        try? saveJSON(
            stamp,
            encoder: encoder,
            name: "catalog sync stamp",
            relativePath: MobileLibraryPackageLayout.catalogSyncStampFileName
        )
        // Keep TreesCatalog.zip in lockstep so a peer can heal from this write.
        if let zipData = try? LibraryTreesCatalogZip.makeArchive(treesJSON: treesData) {
            try? writeAtomically(zipData, relativePath: MobileLibraryPackageLayout.treesCatalogZipFileName)
        }
        touchWriterLease(treeCount: stamp.treeCount, myTreesCount: stamp.myTreesCount)
    }

    func loadCatalogSyncStamp() -> LibraryCatalogSyncStamp? {
        guard let data = try? loadPackageFile(relativePath: MobileLibraryPackageLayout.catalogSyncStampFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(LibraryCatalogSyncStamp.self, from: data)
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadWork() throws -> [WorkRecord]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.workFileName) else {
            return nil
        }
        // Mac LibraryWorkRepository uses the default Date encoding (not ISO-8601).
        let decoder = JSONDecoder()
        return try decoder.decode(MobileLibraryWorkFile.self, from: data).records
    }

    func saveWork(_ records: [WorkRecord]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try saveJSON(
            MobileLibraryWorkFile(records: records),
            encoder: encoder,
            name: "work",
            relativePath: MobileLibraryPackageLayout.workFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadCollections() throws -> [Collection]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.collectionsFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try decoder.decode(MobileLibraryCollectionsFile.self, from: data).collections
    }

    func saveCollections(_ collections: [Collection]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try saveJSON(
            MobileLibraryCollectionsFile(collections: collections),
            encoder: encoder,
            name: "collections",
            relativePath: MobileLibraryPackageLayout.collectionsFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadLocations() throws -> [Location]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.locationsFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibraryLocationsFile.self, from: data).locations
    }

    func saveLocations(_ locations: [Location]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryLocationsFile(locations: locations),
            encoder: encoder,
            name: "locations",
            relativePath: MobileLibraryPackageLayout.locationsFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadGardens() throws -> [Garden]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.gardensFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibraryGardensFile.self, from: data).gardens
    }

    func saveGardens(_ gardens: [Garden]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryGardensFile(gardens: gardens),
            encoder: encoder,
            name: "gardens",
            relativePath: MobileLibraryPackageLayout.gardensFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadTasks() throws -> [CareTask]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.tasksFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibraryTasksFile.self, from: data).tasks
    }

    func saveTasks(_ tasks: [CareTask]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryTasksFile(tasks: tasks),
            encoder: encoder,
            name: "tasks",
            relativePath: MobileLibraryPackageLayout.tasksFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    /// Mac `LibraryScheduleRepository` uses default Date encoding (not ISO-8601).
    func loadSchedules() throws -> [CareSchedule]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.schedulesFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try decoder.decode(MobileLibrarySchedulesFile.self, from: data).schedules
    }

    func saveSchedules(_ schedules: [CareSchedule]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try saveJSON(
            MobileLibrarySchedulesFile(schedules: schedules),
            encoder: encoder,
            name: "schedules",
            relativePath: MobileLibraryPackageLayout.schedulesFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadYamadori() throws -> (trips: [Yamadori], finds: [YamadoriFind])? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.yamadoriFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let file = try decoder.decode(MobileLibraryYamadoriFile.self, from: data)
        return (file.trips, file.finds)
    }

    func saveYamadori(trips: [Yamadori], finds: [YamadoriFind]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryYamadoriFile(trips: trips, finds: finds),
            encoder: encoder,
            name: "yamadori",
            relativePath: MobileLibraryPackageLayout.yamadoriFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadSeedBatches() throws -> [SeedBatch]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.seedBatchesFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibrarySeedBatchesFile.self, from: data).batches
    }

    func saveSeedBatches(_ batches: [SeedBatch]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibrarySeedBatchesFile(batches: batches),
            encoder: encoder,
            name: "seed batches",
            relativePath: MobileLibraryPackageLayout.seedBatchesFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadSoilMixes() throws -> [SoilMix]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.soilMixesFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibrarySoilMixesFile.self, from: data).mixes
    }

    func saveSoilMixes(_ mixes: [SoilMix]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibrarySoilMixesFile(mixes: mixes),
            encoder: encoder,
            name: "soil mixes",
            relativePath: MobileLibraryPackageLayout.soilMixesFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadReferenceCatalog() throws -> MobileReferenceCatalog? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.referenceCatalogFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibraryReferenceCatalogFile.self, from: data).catalog
    }

    func saveReferenceCatalog(_ catalog: MobileReferenceCatalog) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryReferenceCatalogFile(catalog: catalog),
            encoder: encoder,
            name: "reference catalog",
            relativePath: MobileLibraryPackageLayout.referenceCatalogFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadInventoryStock() throws -> [InventoryStockItem]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.inventoryStockFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibraryInventoryStockFile.self, from: data).items
    }

    func saveInventoryStock(_ items: [InventoryStockItem]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryInventoryStockFile(items: items),
            encoder: encoder,
            name: "inventory stock",
            relativePath: MobileLibraryPackageLayout.inventoryStockFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadPots() throws -> [Pot]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.potsFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibraryPotsFile.self, from: data).pots
    }

    func savePots(_ pots: [Pot]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryPotsFile(pots: pots),
            encoder: encoder,
            name: "pots",
            relativePath: MobileLibraryPackageLayout.potsFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadNurseryPropagationProjects() throws -> [NurseryPropagationProject]? {
        guard let data = try loadPackageFile(
            relativePath: MobileLibraryPackageLayout.nurseryPropagationProjectsFileName
        ) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibraryNurseryPropagationFile.self, from: data).projects
    }

    func saveNurseryPropagationProjects(_ projects: [NurseryPropagationProject]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryNurseryPropagationFile(projects: projects),
            encoder: encoder,
            name: "nursery propagation",
            relativePath: MobileLibraryPackageLayout.nurseryPropagationProjectsFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadPotBrandsAndMakers() throws -> (seedVersion: Int?, brands: [PotBrand], makers: [PotMaker])? {
        guard let data = try loadPackageFile(
            relativePath: MobileLibraryPackageLayout.potBrandsFileName
        ) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let file = try decoder.decode(MobileLibraryPotBrandsFile.self, from: data)
        return (file.seedVersion, file.brands, file.makers)
    }

    func savePotBrandsAndMakers(
        brands: [PotBrand],
        makers: [PotMaker],
        seedVersion: Int?
    ) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryPotBrandsFile(seedVersion: seedVersion, brands: brands, makers: makers),
            encoder: encoder,
            name: "pot brands",
            relativePath: MobileLibraryPackageLayout.potBrandsFileName
        )
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadImageCatalog() throws -> [ImageAsset]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.imagesCatalogFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([ImageAsset].self, from: data)
    }

    func saveImageCatalog(_ assets: [ImageAsset]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            assets,
            encoder: encoder,
            name: "image catalog",
            relativePath: MobileLibraryPackageLayout.imagesCatalogFileName
        )
    }

    func loadUserProfile() throws -> MobileUserProfileFile? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.userProfileFileName) else {
            return nil
        }
        return try JSONDecoder().decode(MobileUserProfileFile.self, from: data)
    }

    /// Appends one measurement session. History is the shared record Mac reads.
    func appendTreeMeasurement(_ record: TreeMeasurementRecord) throws {
        var file = try loadTreeMeasurementHistoryFile()
        file.records.append(record)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(file)
        try writeAtomically(data, relativePath: MobileLibraryPackageLayout.treeMeasurementHistoryFileName)
    }

    /// Latest measurement for a tree from history, if any.
    func latestTreeMeasurement(for treeID: UUID) throws -> TreeMeasurementRecord? {
        try loadTreeMeasurementHistoryFile()
            .records
            .filter { $0.treeID == treeID }
            .sorted { $0.measuredAt > $1.measuredAt }
            .first
    }

    func saveUserProfile(_ profile: MobileUserProfileFile) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try saveJSON(
            profile,
            encoder: encoder,
            name: "user profile",
            relativePath: MobileLibraryPackageLayout.userProfileFileName
        )
    }

    /// `notReady` means iCloud has not finished listing the library. Do not seed over it.
    enum TreesFileState {
        case ready
        case missing
        case notReady
    }

    func treesFileState() -> TreesFileState {
        packageFileState(relativePath: MobileLibraryPackageLayout.treesFileName)
    }

    /// Same CloudDocs residency check as `Trees.json`, for any package file.
    func packageFileState(relativePath: String) -> TreesFileState {
        let fileURL = url(for: relativePath)
        if isICloudDrive {
            switch ubiquityLocalState(fileURL) {
            case .materialized:
                return .ready
            case .dataless:
                requestCloudDownload(at: fileURL)
                return .notReady
            case .missing:
                let parent = fileURL.deletingLastPathComponent()
                requestCloudDownload(at: parent)
                if ubiquityLocalState(parent) == .dataless {
                    return .notReady
                }
                return .missing
            }
        }
        return fileManager.fileExists(atPath: fileURL.path) ? .ready : .missing
    }

    /// Local bytes only. Prefer calling off the main actor on iCloud.
    func isImageResident(relativePath: String) -> Bool {
        guard let url = try? resolvedURL(relativePath: relativePath) else { return false }
        if !isICloudDrive {
            return fileManager.fileExists(atPath: url.path)
        }
        return ubiquityLocalState(url) == .materialized
    }

    /// Bytes already on this device. Returns nil when the file is still a cloud placeholder.
    func residentImageData(relativePath: String) -> Data? {
        guard let url = try? resolvedURL(relativePath: relativePath) else { return nil }
        if isICloudDrive {
            switch ubiquityLocalState(url) {
            case .materialized:
                break
            case .dataless:
                requestCloudDownload(at: url)
                return nil
            case .missing:
                requestCloudDownload(at: url)
                return nil
            }
        } else if !fileManager.fileExists(atPath: url.path) {
            return nil
        }
        return try? Data(contentsOf: url)
    }

    func loadImageData(relativePath: String) throws -> Data? {
        try loadPackageFile(relativePath: relativePath)
    }

    func saveImageData(_ data: Data, relativePath: String) throws {
        try writeAtomically(data, relativePath: relativePath)
    }

    func deleteImageData(relativePath: String) throws {
        let url = try resolvedURL(relativePath: relativePath)
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }

    /// Removes the entire library package folder (Database + Images).
    func wipePackage() throws {
        if fileManager.fileExists(atPath: rootURL.path) {
            try fileManager.removeItem(at: rootURL)
        }
        try ensureFolderStructure()
    }

    func url(for relativePath: String) -> URL {
        rootURL.appendingPathComponent(relativePath, isDirectory: false)
    }

    // MARK: - Private

    private func saveJSON<T: Encodable>(
        _ value: T,
        encoder: JSONEncoder,
        name: String,
        relativePath: String
    ) throws {
        let data: Data
        do {
            data = try encoder.encode(value)
        } catch {
            throw MobileLibraryStoreError.encodeFailed(name)
        }
        try writeAtomically(data, relativePath: relativePath)
    }

    private func loadTreeMeasurementHistoryFile() throws -> TreeMeasurementHistoryFile {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.treeMeasurementHistoryFileName) else {
            return TreeMeasurementHistoryFile()
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(TreeMeasurementHistoryFile.self, from: data)
    }

    private func loadPackageFile(relativePath: String) throws -> Data? {
        let url = try resolvedURL(relativePath: relativePath)
        if isICloudDrive {
            switch ubiquityLocalState(url) {
            case .materialized:
                break
            case .dataless:
                requestCloudDownload(at: url)
                throw MobileLibraryStoreError.notLocal
            case .missing:
                requestCloudDownload(at: url)
                return nil
            }
        } else if !fileManager.fileExists(atPath: url.path) {
            return nil
        }
        if isICloudDrive {
            return try readCoordinated(url)
        }
        return try Data(contentsOf: url)
    }

    /// Coordinated read so CloudDocs can finish a listed file. Do not call for dataless/missing.
    private func readCoordinated(_ url: URL) throws -> Data {
        var data: Data?
        var coordError: NSError?
        var readError: Error?
        let coordinator = NSFileCoordinator()
        coordinator.coordinate(readingItemAt: url, options: [], error: &coordError) { readURL in
            do {
                data = try Data(contentsOf: readURL)
            } catch {
                readError = error
            }
        }
        if let coordError { throw coordError }
        if let readError { throw readError }
        guard let data else { throw MobileLibraryStoreError.notLocal }
        return data
    }

    /// Cached `getattrlist` — call off the main actor when possible (Simulator bird can stall).
    private func ubiquityLocalState(_ url: URL) -> UbiquityLocalState {
        let path = url.path
        if let cached = UbiquityStateCache.value(for: path) { return cached }
        #if targetEnvironment(simulator)
        // Simulator CloudDocs often marks real files SF_DATALESS forever → endless
        // “Opening iCloud library”. Trust on-disk bytes when the path exists.
        if fileManager.fileExists(atPath: path) {
            UbiquityStateCache.set(.materialized, for: path)
            return .materialized
        }
        #endif
        var attributeList = attrlist()
        attributeList.bitmapcount = u_short(ATTR_BIT_MAP_COUNT)
        attributeList.commonattr = attrgroup_t(ATTR_CMN_FLAGS)
        var buffer = (length: UInt32(0), flags: UInt32(0))
        let read = url.withUnsafeFileSystemRepresentation { pathPtr -> Int32 in
            guard let pathPtr else { return -1 }
            return getattrlist(pathPtr, &attributeList, &buffer, MemoryLayout.size(ofValue: buffer), 0)
        }
        let state: UbiquityLocalState
        if read != 0 {
            state = .missing
        } else if buffer.flags & UInt32(SF_DATALESS) != 0 {
            state = .dataless
        } else {
            state = .materialized
        }
        UbiquityStateCache.set(state, for: path)
        return state
    }

    /// `SF_DATALESS` via getattrlist — local syscall, no bird/XPC.
    private func isDatalessFile(_ url: URL) -> Bool {
        ubiquityLocalState(url) == .dataless
    }

    /// CloudDocs download requests must not run on the main thread (Simulator XPC can hang forever).
    private func requestCloudDownload(at url: URL) {
        guard isICloudDrive else { return }
        CloudDownload.request(url)
    }

    private func writeAtomically(_ data: Data, relativePath: String) throws {
        try ensureFolderStructure()
        let url = try resolvedURL(relativePath: relativePath)
        do {
            try fileManager.createDirectory(
                at: url.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try data.write(to: url, options: .atomic)
        } catch {
            throw MobileLibraryStoreError.writeFailed(error.localizedDescription)
        }
        if isICloudDrive, relativePath != BonsaiWorldICloudLibrary.writerLeaseRelativePath {
            touchWriterLease()
        }
    }

    func touchWriterLease(treeCount: Int? = nil, myTreesCount: Int? = nil) {
        var retainedTreeCount = treeCount
        var retainedMyTreesCount = myTreesCount
        if retainedTreeCount == nil || retainedMyTreesCount == nil,
           let data = try? loadPackageFile(relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath),
           let existing = try? JSONDecoder().decode(LibraryWriterLease.self, from: data) {
            retainedTreeCount = retainedTreeCount ?? existing.treeCount
            retainedMyTreesCount = retainedMyTreesCount ?? existing.myTreesCount
        }
        let lease = LibraryWriterLease(
            deviceName: UIDevice.current.name,
            treeCount: retainedTreeCount,
            myTreesCount: retainedMyTreesCount
        )
        guard let data = try? JSONEncoder().encode(lease) else { return }
        try? writeAtomically(data, relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath)
    }

    func allowLibraryWriteDespiteForeignLease(duration: TimeInterval = 60) {
        Self.libraryWriteBypassUntil = Date().addingTimeInterval(duration)
    }

    func beginLibraryCatalogWrite() throws {
        guard isICloudDrive else { return }
        if let until = Self.libraryWriteBypassUntil, until > Date() {
            return
        }
        Self.libraryWriteBypassUntil = nil
        guard let data = try? loadPackageFile(relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath),
              let lease = try? JSONDecoder().decode(LibraryWriterLease.self, from: data)
        else {
            return
        }
        if lease.isForeignActive(comparedTo: UIDevice.current.name) {
            throw MobileLibraryStoreError.foreignWriterActive(
                lease.blockedWriteMessage(comparedTo: UIDevice.current.name)
            )
        }
    }

    func foreignWriterWarning() -> String? {
        guard isICloudDrive else { return nil }
        guard let data = try? loadPackageFile(relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath),
              let lease = try? JSONDecoder().decode(LibraryWriterLease.self, from: data)
        else {
            return nil
        }
        if lease.isForeignActive(comparedTo: UIDevice.current.name) {
            return lease.blockedWriteMessage(comparedTo: UIDevice.current.name)
        }
        return nil
    }

    private func resolvedURL(relativePath: String) throws -> URL {
        let cleaned = relativePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !cleaned.isEmpty, !cleaned.contains("..") else {
            throw MobileLibraryStoreError.invalidRelativePath(relativePath)
        }
        return rootURL.appendingPathComponent(cleaned, isDirectory: false)
    }
}

/// Serial background downloads — `startDownloadingUbiquitousItem` talks to bird over XPC and must not run on main.
enum CloudDownload {
    private static let queue = DispatchQueue(label: "no.olafbarmen.BonsaiWorld.cloudDownload", qos: .utility)
    private static let lock = NSLock()
    private static var recentlyRequested: Set<String> = []

    static func request(_ url: URL) {
        request(url, force: false)
    }

    /// Bypasses the short debounce so foreground / foreign-lease pulls can ask bird again.
    static func forceRequest(_ url: URL) {
        request(url, force: true)
    }

    private static func request(_ url: URL, force: Bool) {
        let path = url.standardizedFileURL.path
        lock.lock()
        if force {
            recentlyRequested.remove(path)
        }
        let already = recentlyRequested.contains(path)
        if !already { recentlyRequested.insert(path) }
        lock.unlock()
        guard !already else { return }
        queue.async {
            do {
                try FileManager.default.startDownloadingUbiquitousItem(at: url)
            } catch {
                print("Bonsai World: iCloud download request failed for \(url.lastPathComponent): \(error.localizedDescription)")
            }
            queue.asyncAfter(deadline: .now() + 20) {
                lock.lock()
                recentlyRequested.remove(path)
                lock.unlock()
            }
        }
    }

    /// Container → Documents → library → Database → catalog files. Order matters.
    static func requestLibraryMaterialize(libraryRoot: URL) {
        for url in BonsaiWorldICloudLibrary.materializeURLs(forLibraryRoot: libraryRoot) {
            forceRequest(url)
        }
    }

    static func requestFolders(under root: URL, relativeFolders: [String]) {
        for folder in relativeFolders {
            request(root.appendingPathComponent(folder, isDirectory: true))
        }
    }
}

private enum UbiquityLocalState {
    case missing
    case dataless
    case materialized
}

/// Avoids repeating getattrlist on the same path during list scrolling.
private enum UbiquityStateCache {
    private static let lock = NSLock()
    private static var values: [String: (state: UbiquityLocalState, checkedAt: Date)] = [:]
    private static let ttl: TimeInterval = 5

    static func value(for path: String) -> UbiquityLocalState? {
        lock.lock()
        defer { lock.unlock() }
        guard let entry = values[path], Date().timeIntervalSince(entry.checkedAt) < ttl else {
            return nil
        }
        return entry.state
    }

    static func set(_ state: UbiquityLocalState, for path: String) {
        lock.lock()
        values[path] = (state, Date())
        lock.unlock()
    }

    static func invalidate(path: String) {
        lock.lock()
        values.removeValue(forKey: path)
        lock.unlock()
    }
}

extension MobileLibraryStore {
    /// Clears cached SF_DATALESS / materialized state so the next read re-checks disk.
    func invalidateUbiquityCache(for relativePath: String) {
        UbiquityStateCache.invalidate(path: url(for: relativePath).path)
    }

    /// Evicts a local `Trees.json` only when it is the built-in 3-tree demo set.
    /// Does not write, upload, or delete Mac catalog bytes.
    func evictLocalDemoTreesFileIfPresent() {
        guard isICloudDrive else { return }
        let treesURL = url(for: LibraryTreesCatalog.relativePath)
        guard fileManager.fileExists(atPath: treesURL.path),
              let data = try? Data(contentsOf: treesURL),
              let trees = try? LibraryTreesCatalog.decode(data),
              DemoLibrary.isDemoSampleCatalog(trees)
        else { return }
        invalidateUbiquityCache(for: LibraryTreesCatalog.relativePath)
        try? fileManager.evictUbiquitousItem(at: treesURL)
        CloudDownload.forceRequest(treesURL)
    }

    /// Ask bird to download the container listing, then `Trees.json` (+ lease/stamp/ZIP). Never evicts local copies.
    func requestFreshTreesDownload() {
        guard isICloudDrive else { return }
        invalidateUbiquityCache(for: MobileLibraryPackageLayout.treesFileName)
        invalidateUbiquityCache(for: BonsaiWorldICloudLibrary.writerLeaseRelativePath)
        invalidateUbiquityCache(for: MobileLibraryPackageLayout.catalogSyncStampFileName)
        invalidateUbiquityCache(for: MobileLibraryPackageLayout.treesCatalogZipFileName)
        CloudDownload.requestLibraryMaterialize(libraryRoot: rootURL)
    }

    /// Expected Mac catalog size from stamp or lease (nil when sidecars are absent).
    func expectedRemoteTreeCount() -> Int? {
        if let stamp = loadCatalogSyncStamp() { return stamp.treeCount }
        if let lease = loadWriterLeaseIfPresent(), let count = lease.treeCount { return count }
        return nil
    }

    /// Loads Trees.json from `TreesCatalog.zip` when resident. Returns nil if missing / not local yet.
    func loadTreesJSONFromCatalogZip() throws -> Data? {
        do {
            return try loadPackageFile(relativePath: MobileLibraryPackageLayout.treesCatalogZipFileName)
                .map { try LibraryTreesCatalogZip.extractTreesJSON(from: $0) }
        } catch MobileLibraryStoreError.notLocal {
            CloudDownload.forceRequest(url(for: MobileLibraryPackageLayout.treesCatalogZipFileName))
            return nil
        }
    }

    /// Replaces local `Trees.json` with heal bytes (Mac ZIP content). Does not touch stamp/lease.
    /// Refuses a ZIP that is smaller than the catalog already on this device.
    func replaceTreesJSONFromCatalogHeal(
        _ treesJSON: Data,
        minimumTreeCount: Int,
        currentLocalCount: Int = 0
    ) throws -> [Tree] {
        let trees = try LibraryTreesCatalog.decode(treesJSON)
        let count = trees.count
        if count < currentLocalCount {
            throw MobileLibraryStoreError.catalogBehindRemote(
                "TreesCatalog.zip has \(count) trees but this iPhone already has \(currentLocalCount)."
            )
        }
        if let stamp = loadCatalogSyncStamp(), stamp.isLocalCatalogBehind(localTreeCount: count) {
            throw MobileLibraryStoreError.catalogBehindRemote(
                "TreesCatalog.zip has \(count) trees but stamp expects \(stamp.treeCount)."
            )
        }
        if let lease = loadWriterLeaseIfPresent(), lease.isLocalCatalogBehind(localTreeCount: count) {
            throw MobileLibraryStoreError.catalogBehindRemote(
                "TreesCatalog.zip has \(count) trees but lease expects \(lease.treeCount ?? 0)."
            )
        }
        guard count + 2 >= minimumTreeCount else {
            throw MobileLibraryStoreError.catalogBehindRemote(
                "TreesCatalog.zip has \(count) trees but expected at least \(minimumTreeCount)."
            )
        }
        try writeAtomically(treesJSON, relativePath: LibraryTreesCatalog.relativePath)
        invalidateUbiquityCache(for: LibraryTreesCatalog.relativePath)
        return trees
    }

    /// Blocks saving a smaller in-memory catalog over a larger Mac catalog (lease / stamp).
    func refuseTreesWriteIfBehindRemoteCatalog(proposedCount: Int) throws {
        guard isICloudDrive else { return }
        if let stamp = loadCatalogSyncStamp(), stamp.isLocalCatalogBehind(localTreeCount: proposedCount) {
            throw MobileLibraryStoreError.catalogBehindRemote(
                "This iPhone has \(proposedCount) trees but Mac’s catalog stamp has \(stamp.treeCount). Not saving over iCloud — waiting for Trees.json to finish downloading."
            )
        }
        if let lease = loadWriterLeaseIfPresent(), lease.isLocalCatalogBehind(localTreeCount: proposedCount) {
            throw MobileLibraryStoreError.catalogBehindRemote(
                "This iPhone has \(proposedCount) trees but Mac’s writer lease has \(lease.treeCount ?? 0). Not saving over iCloud — waiting for Trees.json to finish downloading."
            )
        }
    }

    /// Writer lease from disk when resident; used to detect Mac catalog writes.
    func loadWriterLeaseIfPresent() -> LibraryWriterLease? {
        guard let data = try? loadPackageFile(relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath),
              let lease = try? JSONDecoder().decode(LibraryWriterLease.self, from: data)
        else {
            return nil
        }
        return lease
    }
}
