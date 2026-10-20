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

/// Relative paths inside the iOS library package. Values match Mac `LibraryPackageLayout`.
enum MobileLibraryPackageLayout {
    static let database = "Database"
    static let images = "Images"
    static let imagesOriginals = "Images/Originals"
    static let treesFileName = "Database/Trees.json"
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
    static let inventoryStockFileName = "Database/InventoryStock.json"
    /// Same path as Mac `LibraryPackageLayout.potsFileName`.
    static let potsFileName = "Database/Pots.json"
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

/// Envelope for `Database/Trees.json` — same JSON shape as Mac `LibraryTreesFile`.
private struct MobileLibraryTreesFile: Codable {
    var trees: [Tree]
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

/// Local JSON + JPEG package rooted at `rootURL` (injectable for tests).
struct MobileLibraryStore {
    let rootURL: URL
    /// Whether this store points at the shared iCloud package. Fixed at creation — no ubiquity lookup.
    let isICloudDrive: Bool
    private let fileManager: FileManager

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

    /// Resolves the preferred store after first-launch choice (local fallback if iCloud fails or times out).
    static func resolvedPreferred(fileManager: FileManager = .default) async -> MobileLibraryStore {
        switch locationPreference {
        case .iCloud:
            if let iCloud = await iCloudDrive(fileManager: fileManager) {
                return iCloud
            }
            return applicationSupport(fileManager: fileManager)
        case .local, .undecided:
            return applicationSupport(fileManager: fileManager)
        }
    }

    /// Synchronous variant for non-async callers: cached/discovered iCloud root only, never a ubiquity lookup.
    static func resolvedPreferredWithoutLookup(fileManager: FileManager = .default) -> MobileLibraryStore {
        if locationPreference == .iCloud,
           let root = BonsaiWorldICloudLibrary.cachedLibraryRootURL(fileManager: fileManager)
            ?? BonsaiWorldICloudLibrary.discoveredLibraryRootURL(fileManager: fileManager) {
            return MobileLibraryStore(rootURL: root, isICloudDrive: true, fileManager: fileManager)
        }
        return applicationSupport(fileManager: fileManager)
    }

    var treesFileExists: Bool {
        fileManager.fileExists(atPath: url(for: MobileLibraryPackageLayout.treesFileName).path)
    }

    func ensureFolderStructure() throws {
        for relative in [
            MobileLibraryPackageLayout.database,
            MobileLibraryPackageLayout.images,
            MobileLibraryPackageLayout.imagesOriginals
        ] {
            let url = rootURL.appendingPathComponent(relative, isDirectory: true)
            if !fileManager.fileExists(atPath: url.path) {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            }
        }
    }

    /// `nil` when the file is missing. Throws when the file exists but cannot be decoded.
    func loadTrees() throws -> [Tree]? {
        guard let data = try loadPackageFile(relativePath: MobileLibraryPackageLayout.treesFileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MobileLibraryTreesFile.self, from: data).trees
    }

    func saveTrees(_ trees: [Tree]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try saveJSON(
            MobileLibraryTreesFile(trees: trees),
            encoder: encoder,
            name: "trees",
            relativePath: MobileLibraryPackageLayout.treesFileName
        )
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
        let treesURL = url(for: MobileLibraryPackageLayout.treesFileName)
        if fileManager.fileExists(atPath: treesURL.path) {
            if isDatalessFile(treesURL) {
                requestCloudDownload(at: treesURL)
                return .notReady
            }
            return .ready
        }
        if isICloudDrive {
            let database = rootURL.appendingPathComponent(MobileLibraryPackageLayout.database, isDirectory: true)
            requestCloudDownload(at: database)
            if fileManager.fileExists(atPath: database.path), isDatalessFile(database) {
                return .notReady
            }
            return .missing
        }
        return .missing
    }

    /// Local bytes only. No CloudDocs, no download scheduling — safe to call from SwiftUI layout.
    func isImageResident(relativePath: String) -> Bool {
        guard let url = try? resolvedURL(relativePath: relativePath) else { return false }
        guard fileManager.fileExists(atPath: url.path) else { return false }
        if !isICloudDrive { return true }
        return !isDatalessFile(url)
    }

    /// Bytes already on this device. Returns nil when the file is still a cloud placeholder.
    func residentImageData(relativePath: String) -> Data? {
        guard let url = try? resolvedURL(relativePath: relativePath) else { return nil }
        if deferCloudRead(at: url) { return nil }
        guard fileManager.fileExists(atPath: url.path) else { return nil }
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
        if deferCloudRead(at: url) {
            throw MobileLibraryStoreError.notLocal
        }
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    /// A dataless iCloud placeholder reports as existing, then `Data(contentsOf:)` blocks until the download finishes.
    /// Uses only local `getattrlist` — never CloudDocs resource values or `startDownloading` on this thread.
    private func deferCloudRead(at url: URL) -> Bool {
        guard fileManager.fileExists(atPath: url.path) else {
            requestCloudDownload(at: url)
            return false
        }
        let waiting = isDatalessFile(url)
        if waiting {
            requestCloudDownload(at: url)
        }
        return waiting
    }

    /// `SF_DATALESS` via getattrlist — local syscall, no bird/XPC. Results are cached per path.
    private func isDatalessFile(_ url: URL) -> Bool {
        let path = url.path
        if let cached = DatalessCache.value(for: path) { return cached }
        var attributeList = attrlist()
        attributeList.bitmapcount = u_short(ATTR_BIT_MAP_COUNT)
        attributeList.commonattr = attrgroup_t(ATTR_CMN_FLAGS)
        var buffer = (length: UInt32(0), flags: UInt32(0))
        let read = url.withUnsafeFileSystemRepresentation { pathPtr -> Int32 in
            guard let pathPtr else { return -1 }
            return getattrlist(pathPtr, &attributeList, &buffer, MemoryLayout.size(ofValue: buffer), 0)
        }
        let dataless = read == 0 && (buffer.flags & UInt32(SF_DATALESS) != 0)
        DatalessCache.set(dataless, for: path)
        return dataless
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

    func touchWriterLease() {
        let lease = LibraryWriterLease(deviceName: UIDevice.current.name)
        guard let data = try? JSONEncoder().encode(lease) else { return }
        try? writeAtomically(data, relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath)
    }

    func foreignWriterWarning() -> String? {
        guard isICloudDrive else { return nil }
        guard let data = try? loadPackageFile(relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath),
              let lease = try? JSONDecoder().decode(LibraryWriterLease.self, from: data)
        else {
            return nil
        }
        if lease.isForeignActive(comparedTo: UIDevice.current.name) {
            return "“\(lease.deviceName)” used this library recently. Avoid editing on Mac and iPhone at the same time."
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
        let path = url.standardizedFileURL.path
        lock.lock()
        let already = recentlyRequested.contains(path)
        if !already { recentlyRequested.insert(path) }
        lock.unlock()
        guard !already else { return }
        queue.async {
            try? FileManager.default.startDownloadingUbiquitousItem(at: url)
            queue.asyncAfter(deadline: .now() + 20) {
                lock.lock()
                recentlyRequested.remove(path)
                lock.unlock()
            }
        }
    }

    static func requestFolders(under root: URL, relativeFolders: [String]) {
        for folder in relativeFolders {
            request(root.appendingPathComponent(folder, isDirectory: true))
        }
    }
}

/// Avoids repeating getattrlist on the same path during list scrolling.
private enum DatalessCache {
    private static let lock = NSLock()
    private static var values: [String: (dataless: Bool, checkedAt: Date)] = [:]
    private static let ttl: TimeInterval = 5

    static func value(for path: String) -> Bool? {
        lock.lock()
        defer { lock.unlock() }
        guard let entry = values[path], Date().timeIntervalSince(entry.checkedAt) < ttl else {
            return nil
        }
        return entry.dataless
    }

    static func set(_ dataless: Bool, for path: String) {
        lock.lock()
        values[path] = (dataless, Date())
        lock.unlock()
    }
}
