//
//  DemoLibrary.swift
//  Bonsai World
//
//  Mobile facade over the canonical Tree / WorkRecord / ImageAsset models.
//  Persists through MobileLibraryStore (iOS Application Support). Session-only
//  when constructed with `preview` for SwiftUI canvases.
//

import Darwin
import Foundation
import Observation
import UIKit

@Observable
final class DemoLibrary: @unchecked Sendable {
    private let store: MobileLibraryStore?

    private(set) var trees: [Tree]
    private(set) var workRecords: [WorkRecord]
    private(set) var collections: [Collection]
    private(set) var locations: [Location]
    private(set) var gardens: [Garden]
    private(set) var careTasks: [CareTask]
    private(set) var careSchedules: [CareSchedule]
    private(set) var yamadoriTrips: [Yamadori]
    private(set) var yamadoriFinds: [YamadoriFind]
    private(set) var seedBatches: [SeedBatch]
    private(set) var soilMixes: [SoilMix]
    /// Settings → Reference Data flat lists (standalone; seeded from PreviewData).
    private(set) var referenceCatalog: MobileReferenceCatalog
    private(set) var inventoryStock: [InventoryStockItem]
    private(set) var pots: [Pot]
    private(set) var nurseryPropagationProjects: [NurseryPropagationProject]
    private(set) var potBrands: [PotBrand]
    private(set) var potMakers: [PotMaker]
    /// Seed version written with Pot Brands & Makers (Mac `LibraryPotBrandsFile`).
    @ObservationIgnored private var potBrandsSeedVersion: Int?
    /// Grower display name (Settings → User Profile). Same field as Mac User Profile.
    private(set) var growerName: String
    /// Optional email (Settings → User Profile). Stored in UserProfile.json with Mac.
    private(set) var growerEmail: String
    /// Canonical ImageAsset catalog.
    private(set) var imageAssets: [UUID: ImageAsset]
    /// Original JPEG bytes keyed by ImageAsset.id (memory cache of on-disk originals).
    private(set) var imageJPEGData: [UUID: Data]
    @ObservationIgnored private var jpegOrder: [UUID] = []
    /// Must not be observed — mutating during image layout would re-enter SwiftUI forever.
    @ObservationIgnored private var pendingImagePaths: Set<String> = []
    private var waitingForICloudLibrary = false
    private let jpegCacheLimit = 4
    /// Set when load fails. Existing files are left untouched; demo is not reseeded.
    private(set) var lastLoadError: String?
    /// Set when a save fails. In-memory changes remain; files are not replaced with demo.
    private(set) var lastSaveError: String?
    /// Newest library-file modification seen at the last load. Used to pick up Mac saves.
    @ObservationIgnored private var loadedContentStamp: String?
    @ObservationIgnored private var refreshTimer: Timer?
    /// Ignores our own writes for a moment so a save does not reload the screen.
    @ObservationIgnored private var suppressRefreshUntil: Date?
    @ObservationIgnored private var derivativeBackfillTask: Task<Void, Never>?
    @ObservationIgnored private var isDerivativeBackfillRunning = false
    /// Last WriterLease.updatedAt successfully loaded (not merely requested).
    @ObservationIgnored private var lastAppliedWriterLeaseAt: Date? = DemoLibrary.storedLastAppliedWriterLeaseAt()
    private static let lastAppliedWriterLeaseKey = "bonsai.mobile.lastAppliedWriterLeaseAt"
    /// True only after a materialized iCloud Trees.json load that is not behind Mac stamp/lease.
    @ObservationIgnored private var iCloudCatalogReadyToWrite = false
    @ObservationIgnored private var lastCatalogDownloadAttemptAt: Date?
    @ObservationIgnored private var lastCatalogZipHealAttemptAt: Date?
    /// Set when CatalogSyncStamp says Mac has more trees than this session.
    private(set) var catalogSyncBehindMessage: String?
    @ObservationIgnored private var treesCatalogLocator: ICloudTreesCatalogLocator?

    /// App launch — load preferred package (local or iCloud). Missing local Trees.json starts empty.
    convenience init() {
        self.init(store: .resolvedPreferredWithoutLookup())
    }

    /// SwiftUI previews — sample data, no disk.
    static var preview: DemoLibrary {
        DemoLibrary(
            trees: DemoLibrary.sampleTrees,
            workRecords: [],
            imageAssets: [:],
            imageJPEGData: [:]
        )
    }

    init(store: MobileLibraryStore) {
        self.store = store
        self.trees = []
        self.workRecords = []
        self.collections = []
        self.locations = []
        self.gardens = []
        self.careTasks = []
        self.careSchedules = []
        self.yamadoriTrips = []
        self.yamadoriFinds = []
        self.seedBatches = []
        self.soilMixes = []
        self.referenceCatalog = .seededFromPreview()
        self.inventoryStock = []
        self.pots = []
        self.nurseryPropagationProjects = []
        self.potBrands = []
        self.potMakers = []
        self.potBrandsSeedVersion = nil
        self.growerName = ""
        self.growerEmail = ""
        self.imageAssets = [:]
        self.imageJPEGData = [:]
        loadOrSeed()
        // scenePhase.onChange does not fire for the initial .active — request a Trees download on launch.
        if store.isICloudDrive {
            startTreesCatalogLocatorIfNeeded()
            scheduleImmediateCloudCatalogPull()
        }
        startLibraryRefresh()
    }

    private func scheduleImmediateCloudCatalogPull() {
        DispatchQueue.main.async { [weak self] in
            self?.pullSharedLibraryFromCloud(forceReload: true)
        }
    }

    deinit {
        refreshTimer?.invalidate()
        treesCatalogLocator?.stop()
    }

    /// In-memory only (previews / isolated fixtures). Does not touch disk.
    init(
        trees: [Tree] = DemoLibrary.sampleTrees,
        workRecords: [WorkRecord] = [],
        imageAssets: [UUID: ImageAsset] = [:],
        imageJPEGData: [UUID: Data] = [:]
    ) {
        self.store = nil
        self.trees = trees
        self.collections = []
        self.locations = CanonicalLocationID.seedLocations
        self.gardens = Garden.seedCatalog
        self.careTasks = DemoLibrary.sampleTasks(for: trees)
        self.careSchedules = []
        self.yamadoriTrips = []
        self.yamadoriFinds = []
        self.seedBatches = []
        self.soilMixes = []
        self.referenceCatalog = .seededFromPreview()
        self.inventoryStock = []
        self.pots = []
        self.nurseryPropagationProjects = []
        self.potBrands = PotBrandPreviewData.all
        self.potMakers = PotBrandPreviewData.makers
        self.potBrandsSeedVersion = PotBrandPreviewData.seedVersion
        self.growerName = "Olaf"
        self.growerEmail = ""
        self.imageAssets = imageAssets
        self.imageJPEGData = imageJPEGData
        if workRecords.isEmpty {
            self.workRecords = DemoLibrary.sampleWork(for: trees)
        } else {
            self.workRecords = workRecords
        }
    }

    /// Garden trees in care — Mac “My Trees”, not Yamadori nursery or former trees.
    var myTrees: [Tree] {
        trees.filter { $0.isInCare && !$0.yamadoriNursery }
    }

    /// Trees still in the Yamadori nursery (after Mark Collected, before Move to My Trees).
    var yamadoriNurseryTrees: [Tree] {
        trees
            .filter { $0.isInCare && $0.yamadoriNursery }
            .sorted {
                MobileTreePresentation.title(for: $0)
                    .localizedStandardCompare(MobileTreePresentation.title(for: $1)) == .orderedAscending
            }
    }

    /// Finds still in the field (Mac Uncollected Findings).
    var uncollectedYamadoriFindings: [YamadoriFind] {
        yamadoriFinds
            .filter(\.status.isUncollected)
            .sorted {
                $0.yamadoriCode.localizedStandardCompare($1.yamadoriCode) == .orderedAscending
            }
    }

    /// Abandoned or archived Finds (Former Findings — pre-collection exits).
    var formerYamadoriFindings: [YamadoriFind] {
        yamadoriFinds
            .filter { $0.status == .abandoned || $0.status == .archived }
            .sorted {
                if $0.modifiedDate != $1.modifiedDate { return $0.modifiedDate > $1.modifiedDate }
                return $0.yamadoriCode.localizedStandardCompare($1.yamadoriCode) == .orderedAscending
            }
    }

    /// Trees graduated from Yamadori (Find Transferred).
    var transferredYamadoriTrees: [Tree] {
        let ids = Set(
            yamadoriFinds
                .filter { $0.status == .transferred }
                .compactMap(\.linkedTreeID)
        )
        return trees
            .filter { ids.contains($0.id) && $0.isInCare && !$0.yamadoriNursery }
            .sorted {
                MobileTreePresentation.title(for: $0)
                    .localizedStandardCompare(MobileTreePresentation.title(for: $1)) == .orderedAscending
            }
    }

    func tree(id: UUID) -> Tree? {
        trees.first { $0.id == id }
    }

    func collection(id: UUID) -> Collection? {
        collections.first { $0.id == id }
    }

    func trees(in collection: Collection) -> [Tree] {
        collection.treeIDs.compactMap { tree(id: $0) }
    }

    /// Creates an empty Manual Collection. Membership starts empty.
    @discardableResult
    func addCollection(name: String, description: String = "") -> Collection? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return nil }
        let collection = Collection(
            name: trimmedName,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            type: .manual,
            treeIDs: []
        )
        collections.append(collection)
        persistAll()
        return collection
    }

    /// Updates Collection name and description. Preserves type, membership, appearance, and watering.
    func updateCollection(id: UUID, name: String, description: String) {
        guard let index = collections.firstIndex(where: { $0.id == id }) else { return }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        collections[index].name = trimmedName
        collections[index].description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        persistAll()
    }

    /// Adds membership only — does not create or delete the Tree.
    func addTree(_ treeID: UUID, to collectionID: UUID) {
        guard let index = collections.firstIndex(where: { $0.id == collectionID }) else { return }
        guard collections[index].isManual else { return }
        guard tree(id: treeID) != nil else { return }
        guard !collections[index].treeIDs.contains(treeID) else { return }
        collections[index].treeIDs.append(treeID)
        persistAll()
    }

    /// Removes membership only — the Tree remains in the library.
    func removeTree(_ treeID: UUID, from collectionID: UUID) {
        guard let index = collections.firstIndex(where: { $0.id == collectionID }) else { return }
        guard collections[index].isManual else { return }
        guard collections[index].treeIDs.contains(treeID) else { return }
        collections[index].treeIDs.removeAll { $0 == treeID }
        persistAll()
    }

    /// Deletes a Manual Collection. Trees stay in the library.
    func deleteCollection(id: UUID) {
        guard let index = collections.firstIndex(where: { $0.id == id }) else { return }
        guard collections[index].isManual else { return }
        collections.remove(at: index)
        persistAll()
    }

    /// Test helper — persist a Collection catalog change through the store.
    func replaceCollection(_ collection: Collection) {
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[index] = collection
        } else {
            collections.append(collection)
        }
        persistAll()
    }

    func location(id: UUID) -> Location? {
        locations.first { $0.id == id }
    }

    func locationName(for id: UUID) -> String? {
        location(id: id)?.name
    }

    var orderedLocations: [Location] {
        locations.sorted {
            if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
            return $0.name.localizedStandardCompare($1.name) == .orderedAscending
        }
    }

    func locations(inGarden gardenID: UUID) -> [Location] {
        orderedLocations.filter { $0.gardenID == gardenID }
    }

    func garden(id: UUID) -> Garden? {
        gardens.first { $0.id == id }
    }

    func gardenName(for id: UUID) -> String? {
        garden(id: id)?.name ?? CanonicalLocationID.gardenName(for: id)
    }

    var defaultGarden: Garden? {
        gardens.first(where: \.isDefault) ?? gardens.first
    }

    var orderedGardens: [Garden] {
        gardens.sorted {
            if $0.isDefault != $1.isDefault { return $0.isDefault && !$1.isDefault }
            return $0.name.localizedStandardCompare($1.name) == .orderedAscending
        }
    }

    /// Creates a Garden. Map fields stay empty.
    @discardableResult
    func addGarden(
        name: String,
        isDefault: Bool = false,
        address: String = "",
        postalCode: String = "",
        city: String = "",
        country: String = "",
        hemisphere: GardenHemisphere? = nil,
        season: GardenSeason? = nil
    ) -> Garden? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return nil }
        let garden = Garden(
            name: trimmedName,
            address: address.trimmingCharacters(in: .whitespacesAndNewlines),
            postalCode: postalCode.trimmingCharacters(in: .whitespacesAndNewlines),
            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
            country: country.trimmingCharacters(in: .whitespacesAndNewlines),
            hemisphere: hemisphere,
            season: season,
            isDefault: isDefault || gardens.isEmpty
        )
        gardens.append(garden)
        if garden.isDefault {
            applyDefaultGarden(id: garden.id)
        } else {
            ensureOneDefaultGarden()
        }
        persistAll()
        return gardens.first { $0.id == garden.id }
    }

    /// Updates Garden Name, Default, and address fields. Preserves map coordinates unless `includePosition`.
    /// Climate is left unchanged unless `includeClimate` is true.
    func updateGarden(
        id: UUID,
        name: String,
        isDefault: Bool,
        address: String = "",
        postalCode: String = "",
        city: String = "",
        country: String = "",
        hemisphere: GardenHemisphere? = nil,
        season: GardenSeason? = nil,
        includeClimate: Bool = false,
        latitude: Double? = nil,
        longitude: Double? = nil,
        includePosition: Bool = false
    ) {
        guard let index = gardens.firstIndex(where: { $0.id == id }) else { return }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        gardens[index].name = trimmedName
        gardens[index].address = address.trimmingCharacters(in: .whitespacesAndNewlines)
        gardens[index].postalCode = postalCode.trimmingCharacters(in: .whitespacesAndNewlines)
        gardens[index].city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        gardens[index].country = country.trimmingCharacters(in: .whitespacesAndNewlines)
        if includeClimate {
            gardens[index].hemisphere = hemisphere
            gardens[index].season = season
        }
        if includePosition {
            gardens[index].latitude = latitude
            gardens[index].longitude = longitude
        }
        if isDefault {
            applyDefaultGarden(id: id)
        } else {
            gardens[index].isDefault = false
            ensureOneDefaultGarden()
        }
        persistAll()
        if includeClimate {
            syncSpeciesCare()
        }
    }

    /// Deletes a Garden. Locations keep their gardenID. Cannot remove the last Garden.
    func deleteGarden(id: UUID) {
        guard gardens.count > 1 else { return }
        guard gardens.contains(where: { $0.id == id }) else { return }
        let wasDefault = gardens.first(where: { $0.id == id })?.isDefault == true
        gardens.removeAll { $0.id == id }
        if wasDefault, let first = gardens.first {
            applyDefaultGarden(id: first.id)
        } else {
            ensureOneDefaultGarden()
        }
        persistAll()
    }

    private func applyDefaultGarden(id: UUID) {
        for index in gardens.indices {
            gardens[index].isDefault = gardens[index].id == id
        }
    }

    private func ensureOneDefaultGarden() {
        guard !gardens.contains(where: \.isDefault), let first = gardens.indices.first else { return }
        gardens[first].isDefault = true
    }

    /// Creates a Location. Garden and Location Type are stored on the record.
    @discardableResult
    func addLocation(
        name: String,
        description: String = "",
        notes: String = "",
        gardenID: UUID = CanonicalLocationID.defaultGardenID,
        locationTypeID: UUID = CanonicalLocationID.defaultLocationTypeID,
        geographicPosition: GeographicPosition? = nil
    ) -> Location? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return nil }
        let nextOrder = (locations.map(\.sortOrder).max() ?? 0) + 1
        let location = Location(
            name: trimmedName,
            gardenID: gardenID,
            locationTypeID: locationTypeID,
            locationDescription: description.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            sortOrder: nextOrder,
            geographicPosition: geographicPosition
        )
        locations.append(location)
        persistAll()
        return location
    }

    /// Updates Name, Description, Notes, Garden, Location Type, map pin, and Setting. Preserves sort and active.
    func updateLocation(
        id: UUID,
        name: String,
        description: String,
        notes: String,
        gardenID: UUID,
        locationTypeID: UUID,
        geographicPosition: GeographicPosition? = nil,
        environmentSetting: LocationEnvironmentSetting? = nil
    ) {
        guard let index = locations.firstIndex(where: { $0.id == id }) else { return }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        locations[index].name = trimmedName
        locations[index].locationDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        locations[index].notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        locations[index].gardenID = gardenID
        locations[index].locationTypeID = locationTypeID
        locations[index].geographicPosition = geographicPosition
        locations[index].environment.setting = environmentSetting
        persistAll()
    }

    /// Deletes a Location. Trees stay in the library; locationID is unchanged.
    func deleteLocation(id: UUID) {
        guard locations.contains(where: { $0.id == id }) else { return }
        locations.removeAll { $0.id == id }
        persistAll()
    }

    /// Marks (or clears) greenhouse spring heat / vent check year on a Location.
    func setGreenhouseSpringCheckYear(id: UUID, year: Int?) {
        guard let index = locations.firstIndex(where: { $0.id == id }) else { return }
        locations[index].greenhouseSpringCheckYear = year
        persistAll()
    }

    func trees(at locationID: UUID) -> [Tree] {
        trees
            .filter { $0.locationID == locationID }
            .sorted {
                MobileTreePresentation.title(for: $0)
                    .localizedStandardCompare(MobileTreePresentation.title(for: $1)) == .orderedAscending
            }
    }

    /// Bumps when a cloud photo finishes downloading, so lists can show it.
    private(set) var imageRevision = 0

    var isOpeningICloudLibrary: Bool {
        waitingForICloudLibrary && (trees.isEmpty || Self.isDemoSampleCatalog(trees))
    }

    /// Candidate relative paths for display (Thumbnail → Preview → Original). No disk I/O —
    /// safe on the main thread. Callers must resolve residency off the main actor.
    func imageDisplayCandidates(for imageID: UUID?, preferredMaxPixel: CGFloat = 512) -> (root: URL, paths: [String])? {
        guard let imageID,
              let originalPath = imageAssets[imageID]?.relativePath,
              let store
        else { return nil }
        let preferred = MobileImageDerivativeKind.preferred(forMaxPixel: preferredMaxPixel)
        let fallback: MobileImageDerivativeKind = preferred == .thumbnail ? .preview : .thumbnail
        return (
            store.rootURL,
            [
                preferred.relativePath(id: imageID),
                fallback.relativePath(id: imageID),
                originalPath
            ]
        )
    }

    /// Remember a path that failed to load so the refresh timer can promote it later.
    func notePendingImagePath(_ relativePath: String) {
        pendingImagePaths.insert(relativePath)
    }

    /// Local file for one photo. Prefers Thumbnail / Preview. Avoid calling from SwiftUI `body`
    /// on iCloud — use ``imageDisplayCandidates`` + background resolve instead.
    func residentImageURL(for imageID: UUID?, preferredMaxPixel: CGFloat = 512) -> URL? {
        guard let plan = imageDisplayCandidates(for: imageID, preferredMaxPixel: preferredMaxPixel),
              let store
        else { return nil }
        for relativePath in plan.paths {
            if store.isImageResident(relativePath: relativePath) {
                return store.url(for: relativePath)
            }
        }
        return nil
    }

    func jpegData(for imageID: UUID?) -> Data? {
        guard let imageID else { return nil }
        if let cached = imageJPEGData[imageID] { return cached }
        guard let relativePath = imageAssets[imageID]?.relativePath else { return nil }
        guard let data = store?.residentImageData(relativePath: relativePath), !data.isEmpty else {
            pendingImagePaths.insert(relativePath)
            return nil
        }
        rememberJPEG(imageID, data: data)
        return data
    }

    func asset(id: UUID) -> ImageAsset? {
        imageAssets[id]
    }

    /// Library catalog newest-first (Mac Media → Images browse order).
    var orderedImageAssets: [ImageAsset] {
        imageAssets.values.sorted { lhs, rhs in
            if lhs.captureDate != rhs.captureDate {
                return lhs.captureDate > rhs.captureDate
            }
            return lhs.id.uuidString > rhs.id.uuidString
        }
    }

    /// Tree that references this catalog image, if any.
    func tree(forImageID imageID: UUID) -> Tree? {
        trees.first { $0.imageIDs.contains(imageID) }
    }

    /// Adds a JPEG original. New UUID. Becomes primary only when the tree has none.
    @discardableResult
    func addPhoto(
        to treeID: UUID,
        jpegData: Data,
        width: Int,
        height: Int,
        fileName: String
    ) -> ImageAsset? {
        guard let index = trees.firstIndex(where: { $0.id == treeID }) else { return nil }
        guard !jpegData.isEmpty else { return nil }

        let id = UUID()
        let now = Date.now
        let becomesPrimary = trees[index].primaryImageID == nil
        let asset = ImageAsset(
            id: id,
            fileName: fileName,
            relativePath: ImageAsset.originalsRelativePath(id: id, fileExtension: "jpg"),
            createdDate: now,
            modifiedDate: now,
            fileSize: Int64(jpegData.count),
            width: width,
            height: height,
            isPrimary: becomesPrimary,
            photoDate: now
        )
        imageAssets[id] = asset
        imageJPEGData[id] = jpegData
        if !trees[index].imageIDs.contains(id) {
            trees[index].imageIDs.append(id)
        }
        if becomesPrimary {
            trees[index].primaryImageID = id
        }
        trees[index].modifiedDate = now
        persistPhoto(asset, jpegData: jpegData)
        return asset
    }

    func setPrimaryImage(treeID: UUID, imageID: UUID) {
        guard let index = trees.firstIndex(where: { $0.id == treeID }) else { return }
        guard trees[index].imageIDs.contains(imageID) else { return }
        trees[index].primaryImageID = imageID
        trees[index].modifiedDate = .now
        for id in trees[index].imageIDs {
            guard var asset = imageAssets[id] else { continue }
            asset.isPrimary = (id == imageID)
            imageAssets[id] = asset
        }
        persistCatalogAndTrees()
    }

    func removePhoto(fromTree treeID: UUID, imageID: UUID) {
        guard let index = trees.firstIndex(where: { $0.id == treeID }) else { return }
        guard trees[index].imageIDs.contains(imageID) else { return }
        trees[index].imageIDs.removeAll { $0 == imageID }
        if trees[index].primaryImageID == imageID {
            trees[index].primaryImageID = trees[index].imageIDs.first
        }
        trees[index].modifiedDate = .now
        discardImageAsset(id: imageID)
        persistAll()
    }

    func work(for treeID: UUID) -> [WorkRecord] {
        workRecords
            .filter { $0.treeIDs.contains(treeID) }
            .sorted { $0.performedAt > $1.performedAt }
    }

    /// Most recent Repotting work date for a tree, if any.
    func lastRepotDate(for treeID: UUID) -> Date? {
        work(for: treeID)
            .first { $0.workTypeID == CanonicalWorkTypeID.repotting }?
            .performedAt
    }

    /// Trees that currently reference this Soil Mix.
    func trees(usingSoilMix mixID: UUID) -> [Tree] {
        myTrees
            .filter { $0.soilMixID == mixID }
            .sorted {
                MobileTreePresentation.title(for: $0)
                    .localizedStandardCompare(MobileTreePresentation.title(for: $1)) == .orderedAscending
            }
    }

    /// Same health rule as Mac Dashboard Attention (`needsAttention` or `recovering`).
    var treesNeedingAttention: [Tree] {
        myTrees
            .filter { $0.healthStatus == .needsAttention || $0.healthStatus == .recovering }
            .sorted {
                MobileTreePresentation.title(for: $0)
                    .localizedStandardCompare(MobileTreePresentation.title(for: $1)) == .orderedAscending
            }
    }

    /// Mac Dashboard “In Progress” — Shaping areas marked In Progress.
    struct ShapingInProgressItem: Identifiable, Hashable, Sendable {
        let treeID: UUID
        let treeTitle: String
        let area: ShapingAreaID
        let nextAction: String

        var id: String { "\(treeID.uuidString)|\(area.rawValue)" }
    }

    var shapingInProgressItems: [ShapingInProgressItem] {
        let areaOrder = Dictionary(
            uniqueKeysWithValues: ShapingAreaID.allCases.enumerated().map { ($1, $0) }
        )
        return myTrees.flatMap { tree -> [ShapingInProgressItem] in
            guard let areas = tree.shaping?.areas else { return [] }
            return areas.compactMap { key, record in
                guard record.status == .inProgress, let area = ShapingAreaID(rawValue: key) else { return nil }
                return ShapingInProgressItem(
                    treeID: tree.id,
                    treeTitle: MobileTreePresentation.title(for: tree),
                    area: area,
                    nextAction: record.nextAction.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
        }
        .sorted { lhs, rhs in
            let byName = lhs.treeTitle.localizedStandardCompare(rhs.treeTitle)
            if byName != .orderedSame { return byName == .orderedAscending }
            return (areaOrder[lhs.area] ?? 0) < (areaOrder[rhs.area] ?? 0)
        }
    }

    func workPerformedToday() -> [WorkRecord] {
        workRecords
            .filter { Calendar.current.isDateInToday($0.performedAt) }
            .sorted { $0.performedAt > $1.performedAt }
    }

    func recentWork(limit: Int = 6) -> [WorkRecord] {
        Array(
            workRecords
                .sorted { $0.performedAt > $1.performedAt }
                .prefix(limit)
        )
    }

    func addWork(
        treeID: UUID,
        workTypeID: UUID,
        performedAt: Date = .now,
        notes: String = "",
        scheduleID: UUID? = nil,
        soilMixID: UUID? = nil,
        applySoilMix: Bool = false
    ) -> WorkRecord {
        let recordSoilMixID = (workTypeID == CanonicalWorkTypeID.repotting && applySoilMix) ? soilMixID : nil
        let record = WorkRecord(
            workTypeID: workTypeID,
            treeIDs: [treeID],
            performedAt: performedAt,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            soilMixID: recordSoilMixID,
            scheduleID: scheduleID
        )
        workRecords.insert(record, at: 0)
        if let index = trees.firstIndex(where: { $0.id == treeID }) {
            if workTypeID == CanonicalWorkTypeID.repotting, applySoilMix {
                trees[index].soilMixID = soilMixID
            }
            trees[index].modifiedDate = .now
        }
        persistAll()
        return record
    }

    /// Field Tasks horizons — Mac Tasks segmented control.
    enum MobileTasksHorizon: String, CaseIterable, Identifiable, Hashable, Sendable {
        case overdue
        case today
        case thisWeek
        case thisMonth
        case thisYear
        case nextYear

        var id: Self { self }

        var title: String {
            switch self {
            case .overdue: "Overdue"
            case .today: "Today"
            case .thisWeek: "This Week"
            case .thisMonth: "This Month"
            case .thisYear: "This Year"
            case .nextYear: "Next Year"
            }
        }

        /// Same primary cases as the Mac Tasks segmented control.
        static let primaryPickerCases: [MobileTasksHorizon] = [.overdue, .today, .thisWeek, .thisMonth]
    }

    /// One actionable row: a pending CareTask or a computed Schedule occurrence (Mac TaskOccurrence).
    struct MobileTaskItem: Identifiable, Hashable, Sendable {
        enum Source: Hashable, Sendable {
            case task(UUID)
            case schedule(UUID)
        }

        var id: String
        var source: Source
        var title: String
        var workTypeID: UUID
        var treeID: UUID
        var dueDate: Date
        var isInstant: Bool

        var careTaskID: UUID? {
            if case .task(let id) = source { return id }
            return nil
        }

        var scheduleID: UUID? {
            if case .schedule(let id) = source { return id }
            return nil
        }
    }

    func task(id: UUID) -> CareTask? {
        careTasks.first { $0.id == id }
    }

    func schedule(id: UUID) -> CareSchedule? {
        careSchedules.first { $0.id == id }
    }

    /// Creates a one-off CareTask for a single Tree. Title falls back to Work Type name.
    @discardableResult
    func addTask(
        title: String,
        workTypeID: UUID,
        treeID: UUID,
        dueDate: Date,
        notes: String = "",
        systemKind: CareTaskSystemKind? = nil
    ) -> CareTask? {
        guard tree(id: treeID) != nil else { return nil }
        guard CanonicalWorkTypeID.catalog.contains(where: { $0.id == workTypeID }) else { return nil }
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let resolvedTitle = trimmedTitle.isEmpty
            ? CanonicalWorkTypeID.name(for: workTypeID)
            : trimmedTitle
        let task = CareTask(
            title: resolvedTitle,
            workTypeID: workTypeID,
            treeIDs: [treeID],
            systemKind: systemKind,
            dueDate: dueDate,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        careTasks.append(task)
        persistAll()
        refreshTodayTasksNotification()
        return careTasks.first { $0.id == task.id }
    }

    /// Pending tree-scoped Tasks + due Schedule occurrences (Mac TaskService).
    func pendingTasks(due horizon: MobileTasksHorizon) -> [MobileTaskItem] {
        let now = Date.now
        let calendar = Calendar.current
        var items: [MobileTaskItem] = []

        for task in careTasks where task.status == .pending {
            let instant = Self.completesInstantly(workTypeID: task.workTypeID)
            let expires = Self.expiresIfMissed(workTypeID: task.workTypeID)
            if expires, Self.isOverdue(task.dueDate, now: now, calendar: calendar) {
                continue
            }
            for treeID in task.treeIDs {
                guard let tree = tree(id: treeID), tree.isInCare, !tree.yamadoriNursery else { continue }
                guard Self.belongs(dueDate: task.dueDate, expiresIfMissed: expires, to: horizon, now: now, calendar: calendar) else {
                    continue
                }
                items.append(
                    MobileTaskItem(
                        id: "\(task.id.uuidString)-\(treeID.uuidString)",
                        source: .task(task.id),
                        title: task.title,
                        workTypeID: task.workTypeID,
                        treeID: treeID,
                        dueDate: task.dueDate,
                        isInstant: instant
                    )
                )
            }
        }

        let currentMonth = calendar.component(.month, from: now)
        for schedule in careSchedules where schedule.isActive {
            if let window = schedule.seasonalWindow, !window.contains(month: currentMonth) {
                continue
            }
            // Day-part schedules stay Mac-only for now; interval cadences (incl. autoRepotting) expand here.
            guard schedule.recurrence.dayParts.isEmpty else { continue }
            let expires = Self.expiresIfMissed(workTypeID: schedule.workTypeID)
            for treeID in resolvedTreeIDs(for: schedule.target) {
                guard let tree = tree(id: treeID), tree.isInCare, !tree.yamadoriNursery else { continue }
                guard let rawDue = nextDueDate(for: schedule, treeID: treeID, calendar: calendar) else { continue }
                let dueDate: Date
                if expires, Self.isOverdue(rawDue, now: now, calendar: calendar) {
                    dueDate = calendar.startOfDay(for: now)
                } else {
                    dueDate = rawDue
                }
                guard Self.belongs(dueDate: dueDate, expiresIfMissed: expires, to: horizon, now: now, calendar: calendar) else {
                    continue
                }
                let title = schedule.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? CanonicalWorkTypeID.name(for: schedule.workTypeID)
                    : schedule.title
                items.append(
                    MobileTaskItem(
                        id: "schedule-\(schedule.id.uuidString)-\(treeID.uuidString)",
                        source: .schedule(schedule.id),
                        title: title,
                        workTypeID: schedule.workTypeID,
                        treeID: treeID,
                        dueDate: dueDate,
                        isInstant: true
                    )
                )
            }
        }

        // Prefer one row when Task and Schedule ask for the same work on the same tree.
        var seen = Set<String>()
        let deduped = items.filter { item in
            let key = "\(item.treeID.uuidString)-\(item.workTypeID.uuidString)"
            return seen.insert(key).inserted
        }

        return deduped.sorted {
            if $0.dueDate != $1.dueDate {
                return $0.dueDate < $1.dueDate
            }
            let left = taskSortTitle($0)
            let right = taskSortTitle($1)
            return left.localizedStandardCompare(right) == .orderedAscending
        }
    }

    /// Overdue then today tasks for one tree (field profile strip).
    func pendingTasks(forTree treeID: UUID) -> [MobileTaskItem] {
        pendingTasks(due: .overdue).filter { $0.treeID == treeID }
            + pendingTasks(due: .today).filter { $0.treeID == treeID }
    }

    /// Care Today — overdue + today (Mac Care → Today).
    func careTodayItems() -> [MobileTaskItem] {
        pendingTasks(due: .overdue) + pendingTasks(due: .today)
    }

    private func taskSortTitle(_ item: MobileTaskItem) -> String {
        let trimmed = item.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        return CanonicalWorkTypeID.name(for: item.workTypeID)
    }

    private func resolvedTreeIDs(for target: CareScheduleTarget) -> [UUID] {
        switch target {
        case .trees(let ids):
            return Array(ids)
        case .location(let locationID):
            return trees.filter { $0.locationID == locationID && $0.isInCare }.map(\.id)
        case .genus(let genusID):
            return trees.filter { $0.genusID == genusID && $0.isInCare }.map(\.id)
        }
    }

    /// Next due for an interval schedule (Mac TaskService.nextDueDate).
    private func nextDueDate(for schedule: CareSchedule, treeID: UUID, calendar: Calendar) -> Date? {
        let lastPerformed = workRecords
            .filter { $0.treeIDs.contains(treeID) && $0.workTypeID == schedule.workTypeID }
            .map(\.performedAt)
            .max()

        if let postponed = schedule.postponedDueByTreeID[treeID] {
            let postponedDay = calendar.startOfDay(for: postponed)
            if lastPerformed == nil || lastPerformed! < postponedDay {
                return postponedDay
            }
        }

        let base = lastPerformed ?? schedule.createdDate
        guard let raw = calendar.date(
            byAdding: schedule.recurrence.unit.calendarComponent,
            value: schedule.recurrence.interval,
            to: base
        ) else { return nil }
        if schedule.systemKind == .autoRepotting {
            return Self.clampToRepottingSeason(raw, calendar: calendar)
        }
        return raw
    }

    /// March–May snap (Mac RepottingCareService.clampToRepottingSeason).
    static func clampToRepottingSeason(_ date: Date, calendar: Calendar = .current) -> Date {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        if (3...5).contains(month) {
            return calendar.startOfDay(for: date)
        }
        if month < 3 {
            return calendar.date(from: DateComponents(year: year, month: 3, day: 1))
                ?? calendar.startOfDay(for: date)
        }
        return calendar.date(from: DateComponents(year: year + 1, month: 3, day: 1))
            ?? calendar.startOfDay(for: date)
    }

    /// Completes a Task or Schedule occurrence (instant path).
    @discardableResult
    func completeOccurrenceInstantly(_ item: MobileTaskItem) -> WorkRecord? {
        switch item.source {
        case .task(let taskID):
            return completeTaskInstantly(id: taskID)
        case .schedule(let scheduleID):
            return completeScheduleOccurrence(scheduleID: scheduleID, treeID: item.treeID, workTypeID: item.workTypeID)
        }
    }

    /// Watering completes instantly (Blueprint §5.9). Writes Work + marks Task completed.
    @discardableResult
    func completeTaskInstantly(id: UUID) -> WorkRecord? {
        guard let index = careTasks.firstIndex(where: { $0.id == id }) else { return nil }
        let task = careTasks[index]
        guard task.status == .pending else { return nil }
        guard Self.completesInstantly(workTypeID: task.workTypeID) else { return nil }
        guard let treeID = task.treeIDs.first else { return nil }

        let record = WorkRecord(
            workTypeID: task.workTypeID,
            treeIDs: task.treeIDs,
            performedAt: .now,
            notes: "",
            scheduleID: task.id
        )
        workRecords.insert(record, at: 0)
        careTasks[index].status = .completed
        careTasks[index].completedAt = .now
        careTasks[index].resultingWorkRecordID = record.id
        careTasks[index].modifiedDate = .now
        if let treeIndex = trees.firstIndex(where: { $0.id == treeID }) {
            trees[treeIndex].modifiedDate = .now
        }
        persistAll()
        refreshTodayTasksNotification()
        return record
    }

    /// Logs Work for a Schedule occurrence — resets the cadence (Mac completeOccurrence).
    @discardableResult
    func completeScheduleOccurrence(
        scheduleID: UUID,
        treeID: UUID,
        workTypeID: UUID,
        performedAt: Date = .now,
        notes: String = "",
        soilMixID: UUID? = nil,
        applySoilMix: Bool = false
    ) -> WorkRecord? {
        guard schedule(id: scheduleID) != nil else { return nil }
        guard tree(id: treeID) != nil else { return nil }
        let record = addWork(
            treeID: treeID,
            workTypeID: workTypeID,
            performedAt: performedAt,
            notes: notes,
            scheduleID: scheduleID,
            soilMixID: soilMixID,
            applySoilMix: applySoilMix
        )
        clearSchedulePostpone(scheduleID: scheduleID, treeID: treeID)
        refreshTodayTasksNotification()
        return record
    }

    /// Marks Task completed after Add Work saved a WorkRecord.
    func completeTask(id: UUID, resultingWorkRecordID: UUID?) {
        guard let index = careTasks.firstIndex(where: { $0.id == id }) else { return }
        guard careTasks[index].status == .pending else { return }
        careTasks[index].status = .completed
        careTasks[index].completedAt = .now
        careTasks[index].resultingWorkRecordID = resultingWorkRecordID
        careTasks[index].modifiedDate = .now
        persistAll()
        refreshTodayTasksNotification()
    }

    /// Moves this CareTask due date only (Mac Postpone — this time only).
    func postponeTask(id: UUID, to date: Date) {
        guard let index = careTasks.firstIndex(where: { $0.id == id }) else { return }
        guard careTasks[index].status == .pending else { return }
        careTasks[index].dueDate = Calendar.current.startOfDay(for: date)
        careTasks[index].modifiedDate = .now
        persistAll()
        refreshTodayTasksNotification()
    }

    /// Postpones one Task or Schedule occurrence (Mac postponeOccurrence).
    func postponeOccurrence(_ item: MobileTaskItem, to date: Date) {
        let due = Calendar.current.startOfDay(for: date)
        switch item.source {
        case .task(let taskID):
            postponeTask(id: taskID, to: due)
        case .schedule(let scheduleID):
            guard let index = careSchedules.firstIndex(where: { $0.id == scheduleID }) else { return }
            careSchedules[index].postponedDueByTreeID[item.treeID] = due
            careSchedules[index].modifiedDate = .now
            persistAll()
            refreshTodayTasksNotification()
        }
    }

    private func clearSchedulePostpone(scheduleID: UUID, treeID: UUID) {
        guard let index = careSchedules.firstIndex(where: { $0.id == scheduleID }) else { return }
        guard careSchedules[index].postponedDueByTreeID.removeValue(forKey: treeID) != nil else { return }
        careSchedules[index].modifiedDate = .now
        persistAll()
    }

    /// Mac SpeciesCareService.sync — pending pinch/cut jobs from garden climate.
    func syncSpeciesCare(now: Date = .now, calendar: Calendar = .current) {
        let hemisphere = defaultGarden?.hemisphere
        let season = defaultGarden?.season
        guard let hemisphere, let season, season != .tropical else { return }

        var changed = false
        for tree in trees where tree.isInCare {
            guard let job = SpeciesCareJob.job(
                speciesID: tree.speciesID,
                cultivarID: tree.cultivarID,
                botanicalName: tree.botanicalName
            ),
            CanonicalWorkTypeID.catalog.contains(where: { $0.id == job.workTypeID }),
            let window = SpeciesCareCalendar.activeWindow(
                job: job,
                on: now,
                hemisphere: hemisphere,
                season: season,
                calendar: calendar
            )
            else { continue }

            let related = careTasks.filter {
                $0.systemKind == job.systemKind && $0.treeIDs.contains(tree.id)
            }
            let pending = related.first { $0.status == .pending }
            let covered = related.contains { window.covers($0.dueDate, calendar: calendar) }
            switch SpeciesCareCalendar.action(
                now: now,
                window: window,
                pendingDue: pending?.dueDate,
                covered: covered,
                calendar: calendar
            ) {
            case .none:
                break
            case .retire:
                guard let pending, let index = careTasks.firstIndex(where: { $0.id == pending.id }) else { break }
                careTasks[index].status = .cancelled
                careTasks[index].modifiedDate = .now
                changed = true
            case .create(let due):
                let task = CareTask(
                    title: job.title,
                    workTypeID: job.workTypeID,
                    treeIDs: [tree.id],
                    systemKind: job.systemKind,
                    dueDate: due,
                    notes: job.notes
                )
                careTasks.append(task)
                changed = true
            }
        }
        if changed {
            persistAll()
            refreshTodayTasksNotification()
        }
    }

    /// Active CareSchedules that cover this Tree.
    func activeSchedules(forTree treeID: UUID) -> [CareSchedule] {
        guard let tree = tree(id: treeID) else { return [] }
        return careSchedules
            .filter { schedule in
                guard schedule.isActive else { return false }
                switch schedule.target {
                case .trees(let ids):
                    return ids.contains(treeID)
                case .location(let locationID):
                    return tree.locationID == locationID
                case .genus(let genusID):
                    return tree.genusID == genusID
                }
            }
            .sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
    }

    // MARK: - Yamadori

    var orderedYamadoriTrips: [Yamadori] {
        yamadoriTrips.sorted {
            let left = $0.tripDate ?? $0.createdDate
            let right = $1.tripDate ?? $1.createdDate
            if left != right { return left > right }
            return $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending
        }
    }

    func yamadoriTrip(id: UUID) -> Yamadori? {
        yamadoriTrips.first { $0.id == id }
    }

    func yamadoriFind(id: UUID) -> YamadoriFind? {
        yamadoriFinds.first { $0.id == id }
    }

    func finds(forYamadoriID tripID: UUID) -> [YamadoriFind] {
        yamadoriFinds
            .filter { $0.yamadoriID == tripID }
            .sorted {
                if $0.createdDate != $1.createdDate { return $0.createdDate < $1.createdDate }
                return $0.yamadoriCode.localizedStandardCompare($1.yamadoriCode) == .orderedAscending
            }
    }

    /// Creates a Yamadori trip only (Mac New Yamadori). Finds via Add Find.
    @discardableResult
    func addYamadoriTrip(
        displayName: String,
        discoveryDate: Date? = .now,
        latitude: Double? = nil,
        longitude: Double? = nil,
        locationDescription: String = "",
        countryRegion: String = "",
        permissionNotes: String = "",
        notes: String = ""
    ) -> Yamadori? {
        let name = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return nil }
        let now = Date.now
        let trip = Yamadori(
            displayName: name,
            tripDate: discoveryDate,
            createdDate: now,
            modifiedDate: now,
            latitude: latitude,
            longitude: longitude,
            locationDescription: locationDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            countryRegion: countryRegion.trimmingCharacters(in: .whitespacesAndNewlines),
            permissionNotes: permissionNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        yamadoriTrips.append(trip)
        persistAll()
        return yamadoriTrips.first { $0.id == trip.id }
    }

    func updateYamadoriFind(
        id: UUID,
        displayName: String,
        status: YamadoriStatus,
        notes: String,
        latitude: Double?,
        longitude: Double?,
        speciesEstimate: String? = nil,
        genusID: UUID? = nil,
        speciesID: UUID? = nil,
        cultivarID: UUID? = nil,
        evaluationTrunk: String? = nil,
        evaluationNebari: String? = nil,
        evaluationMovement: String? = nil,
        evaluationTaper: String? = nil,
        evaluationBranches: String? = nil,
        evaluationHealth: String? = nil,
        evaluationAccessibility: String? = nil,
        evaluationDifficulty: String? = nil,
        evaluationOverall: String? = nil,
        collectionDate: Date? = nil,
        clearCollectionDate: Bool = false,
        collectionObservations: String? = nil,
        rootNotes: String? = nil,
        transportNotes: String? = nil,
        initialPlacement: String? = nil,
        initialRecoveryNotes: String? = nil,
        recoveryLocationNotes: String? = nil,
        recoveryCareNotes: String? = nil,
        establishmentAssessment: String? = nil
    ) {
        guard let index = yamadoriFinds.firstIndex(where: { $0.id == id }) else { return }
        guard yamadoriFinds[index].status.isUncollected else { return }
        let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard status.isUncollected else { return }

        var find = yamadoriFinds[index]
        let previousStatus = find.status
        find.displayName = trimmed
        find.status = status
        find.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        find.latitude = latitude
        find.longitude = longitude
        find.genusID = genusID
        find.speciesID = speciesID
        find.cultivarID = cultivarID
        if let speciesEstimate {
            let estimate = speciesEstimate.trimmingCharacters(in: .whitespacesAndNewlines)
            find.speciesEstimate = estimate.isEmpty ? nil : estimate
        }
        if let evaluationTrunk {
            find.evaluationTrunk = evaluationTrunk.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let evaluationNebari {
            find.evaluationNebari = evaluationNebari.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let evaluationMovement {
            find.evaluationMovement = evaluationMovement.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let evaluationTaper {
            find.evaluationTaper = evaluationTaper.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let evaluationBranches {
            find.evaluationBranches = evaluationBranches.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let evaluationHealth {
            find.evaluationHealth = evaluationHealth.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let evaluationAccessibility {
            find.evaluationAccessibility = evaluationAccessibility.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let evaluationDifficulty {
            find.evaluationDifficulty = evaluationDifficulty.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let evaluationOverall {
            find.evaluationOverall = evaluationOverall.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if clearCollectionDate {
            find.collectionDate = nil
        } else if let collectionDate {
            find.collectionDate = collectionDate
        }
        if let collectionObservations {
            find.collectionObservations = collectionObservations.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let rootNotes {
            find.rootNotes = rootNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let transportNotes {
            find.transportNotes = transportNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let initialPlacement {
            find.initialPlacement = initialPlacement.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let initialRecoveryNotes {
            find.initialRecoveryNotes = initialRecoveryNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let recoveryLocationNotes {
            find.recoveryLocationNotes = recoveryLocationNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let recoveryCareNotes {
            find.recoveryCareNotes = recoveryCareNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let establishmentAssessment {
            find.establishmentAssessment = establishmentAssessment.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        find.modifiedDate = .now
        if previousStatus != status {
            find.history.append(
                YamadoriHistoryEntry(
                    kind: .statusChanged,
                    date: .now,
                    note: "\(previousStatus.title) → \(status.title)"
                )
            )
        }
        yamadoriFinds[index] = find
        persistAll()
    }

    /// Adds another Find on an existing trip (status Scout).
    @discardableResult
    func addFind(onYamadoriID tripID: UUID, displayName: String = "") -> YamadoriFind? {
        guard yamadoriTrip(id: tripID) != nil else { return nil }
        let now = Date.now
        let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let code = YamadoriIDService.nextCode(existing: yamadoriFinds)
        let find = YamadoriFind(
            yamadoriID: tripID,
            yamadoriCode: code,
            displayName: trimmed,
            status: .scout,
            createdDate: now,
            modifiedDate: now,
            discoveryDate: now,
            history: [YamadoriHistoryEntry(kind: .created, date: now)]
        )
        yamadoriFinds.append(find)
        if let tripIndex = yamadoriTrips.firstIndex(where: { $0.id == tripID }) {
            yamadoriTrips[tripIndex].modifiedDate = now
        }
        persistAll()
        return yamadoriFinds.first { $0.id == find.id }
    }

    /// Copies Find fields onto new Finds (Mac Duplicate Find). New YAM codes; no display name or photos.
    @discardableResult
    func duplicateYamadoriFind(id: UUID, count: Int = 1) -> [YamadoriFind] {
        guard let source = yamadoriFind(id: id) else { return [] }
        let copies = min(99, max(1, count))
        var created: [YamadoriFind] = []
        created.reserveCapacity(copies)
        let now = Date.now
        for _ in 0..<copies {
            let code = YamadoriIDService.nextCode(existing: yamadoriFinds + created)
            let observations = source.observations.map {
                YamadoriObservation(
                    date: $0.date,
                    text: $0.text,
                    category: $0.category,
                    imageIDs: []
                )
            }
            let status: YamadoriStatus = {
                switch source.status {
                case .transferred: return .collected
                case .abandoned, .archived: return .scout
                default: return source.status
                }
            }()
            let find = YamadoriFind(
                yamadoriID: source.yamadoriID,
                yamadoriCode: code,
                displayName: "",
                genusID: source.genusID,
                speciesID: source.speciesID,
                cultivarID: source.cultivarID,
                speciesEstimate: source.speciesEstimate,
                status: status,
                createdDate: now,
                modifiedDate: now,
                discoveryDate: source.discoveryDate ?? now,
                latitude: source.latitude,
                longitude: source.longitude,
                evaluationTrunk: source.evaluationTrunk,
                evaluationNebari: source.evaluationNebari,
                evaluationMovement: source.evaluationMovement,
                evaluationTaper: source.evaluationTaper,
                evaluationBranches: source.evaluationBranches,
                evaluationHealth: source.evaluationHealth,
                evaluationAccessibility: source.evaluationAccessibility,
                evaluationDifficulty: source.evaluationDifficulty,
                evaluationOverall: source.evaluationOverall,
                collectionDate: source.collectionDate,
                collectionObservations: source.collectionObservations,
                rootNotes: source.rootNotes,
                transportNotes: source.transportNotes,
                initialPlacement: source.initialPlacement,
                initialRecoveryNotes: source.initialRecoveryNotes,
                recoveryStartDate: source.recoveryStartDate,
                recoveryLocationNotes: source.recoveryLocationNotes,
                recoveryCareNotes: source.recoveryCareNotes,
                establishmentAssessment: source.establishmentAssessment,
                establishedDate: source.establishedDate,
                transferDate: nil,
                linkedTreeID: nil,
                transferNotes: "",
                primaryImageID: nil,
                imageIDs: [],
                observations: observations,
                history: [YamadoriHistoryEntry(kind: .created, date: now)],
                notes: source.notes
            )
            created.append(find)
        }
        yamadoriFinds.append(contentsOf: created)
        if let tripIndex = yamadoriTrips.firstIndex(where: { $0.id == source.yamadoriID }) {
            yamadoriTrips[tripIndex].modifiedDate = now
        }
        persistAll()
        return created
    }

    func updateYamadoriTrip(
        id: UUID,
        displayName: String,
        tripDate: Date?,
        latitude: Double? = nil,
        longitude: Double? = nil,
        updateCoordinates: Bool = false,
        locationDescription: String? = nil,
        countryRegion: String? = nil,
        permissionNotes: String? = nil,
        landOwnershipNotes: String? = nil,
        collectionWindowNotes: String? = nil,
        preparationNotes: String? = nil,
        equipmentNotes: String? = nil,
        collectionPlanNotes: String? = nil,
        preCollectionChecklist: [YamadoriChecklistItem]? = nil,
        collectionKitChecklist: [YamadoriChecklistItem]? = nil,
        notes: String? = nil
    ) {
        guard let index = yamadoriTrips.firstIndex(where: { $0.id == id }) else { return }
        let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        yamadoriTrips[index].displayName = trimmed
        yamadoriTrips[index].tripDate = tripDate
        if updateCoordinates {
            yamadoriTrips[index].latitude = latitude
            yamadoriTrips[index].longitude = longitude
        }
        if let locationDescription {
            yamadoriTrips[index].locationDescription = locationDescription
        }
        if let countryRegion {
            yamadoriTrips[index].countryRegion = countryRegion
        }
        if let permissionNotes {
            yamadoriTrips[index].permissionNotes = permissionNotes
        }
        if let landOwnershipNotes {
            yamadoriTrips[index].landOwnershipNotes = landOwnershipNotes
        }
        if let collectionWindowNotes {
            yamadoriTrips[index].collectionWindowNotes = collectionWindowNotes
        }
        if let preparationNotes {
            yamadoriTrips[index].preparationNotes = preparationNotes
        }
        if let equipmentNotes {
            yamadoriTrips[index].equipmentNotes = equipmentNotes
        }
        if let collectionPlanNotes {
            yamadoriTrips[index].collectionPlanNotes = collectionPlanNotes
        }
        if let preCollectionChecklist {
            yamadoriTrips[index].preCollectionChecklist = preCollectionChecklist
        }
        if let collectionKitChecklist {
            yamadoriTrips[index].collectionKitChecklist = collectionKitChecklist
        }
        if let notes {
            yamadoriTrips[index].notes = notes
        }
        yamadoriTrips[index].modifiedDate = .now
        persistAll()
    }

    /// Deletes the trip and all Finds on it (same as Mac). Linked Trees stay.
    func deleteYamadoriTrip(id: UUID) {
        guard yamadoriTrips.contains(where: { $0.id == id }) else { return }
        let findImageIDs = yamadoriFinds
            .filter { $0.yamadoriID == id }
            .flatMap(\.imageIDs)
        yamadoriFinds.removeAll { $0.yamadoriID == id }
        yamadoriTrips.removeAll { $0.id == id }
        for imageID in findImageIDs {
            discardImageAsset(id: imageID)
        }
        persistAll()
    }

    /// Deletes one Find. The trip stays (same as Mac). Linked Trees stay.
    func deleteYamadoriFind(id: UUID) {
        guard let find = yamadoriFinds.first(where: { $0.id == id }) else { return }
        let imageIDs = find.imageIDs
        yamadoriFinds.removeAll { $0.id == id }
        if let tripIndex = yamadoriTrips.firstIndex(where: { $0.id == find.yamadoriID }) {
            yamadoriTrips[tripIndex].modifiedDate = .now
        }
        for imageID in imageIDs {
            discardImageAsset(id: imageID)
        }
        persistAll()
    }

    func updateYamadoriTripSite(id: UUID, latitude: Double?, longitude: Double?) {
        guard let index = yamadoriTrips.firstIndex(where: { $0.id == id }) else { return }
        yamadoriTrips[index].latitude = latitude
        yamadoriTrips[index].longitude = longitude
        yamadoriTrips[index].modifiedDate = .now
        persistAll()
    }

    /// Move to My Trees — free-text Bonsai Name (A1). Find → Transferred.
    @discardableResult
    func moveYamadoriToMyTrees(
        findID: UUID,
        bonsaiName: String,
        nickname: String = "",
        locationID: UUID? = nil,
        transferNotes: String = "",
        copyImages: Bool = true
    ) -> Tree? {
        guard let findIndex = yamadoriFinds.firstIndex(where: { $0.id == findID }) else { return nil }
        var find = yamadoriFinds[findIndex]
        guard find.status.canTransferToTree else { return nil }
        guard let treeID = find.linkedTreeID,
              let treeIndex = trees.firstIndex(where: { $0.id == treeID })
        else { return nil }
        guard trees[treeIndex].yamadoriNursery else { return nil }

        let trimmedBonsai = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedBonsai.isEmpty else { return nil }
        if let locationID {
            guard location(id: locationID) != nil else { return nil }
            trees[treeIndex].locationID = locationID
        }

        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTransfer = transferNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        let now = Date.now

        trees[treeIndex].bonsaiName = trimmedBonsai
        trees[treeIndex].nickname = trimmedNickname
        trees[treeIndex].yamadoriNursery = false
        trees[treeIndex].modifiedDate = now
        if !trimmedTransfer.isEmpty {
            let prefix = trees[treeIndex].acquisitionNotes.isEmpty ? "" : "\n"
            trees[treeIndex].acquisitionNotes += "\(prefix)Moved to My Trees — \(trimmedTransfer)"
        }
        if copyImages {
            for imageID in find.imageIDs where !trees[treeIndex].imageIDs.contains(imageID) {
                trees[treeIndex].imageIDs.append(imageID)
            }
            if trees[treeIndex].primaryImageID == nil {
                trees[treeIndex].primaryImageID = find.primaryImageID ?? find.imageIDs.first
            }
        }

        find.status = .transferred
        find.transferDate = now
        find.transferNotes = trimmedTransfer
        find.modifiedDate = now
        find.history.append(
            YamadoriHistoryEntry(kind: .transferred, date: now, note: trimmedBonsai)
        )
        yamadoriFinds[findIndex] = find
        persistAll()
        return trees.first { $0.id == treeID }
    }

    func find(linkedToTreeID treeID: UUID) -> YamadoriFind? {
        yamadoriFinds.first { $0.linkedTreeID == treeID }
    }

    /// Mark Collected — Planned only. Creates a Yamadori Tree (nursery). Botanical name text only (A1).
    @discardableResult
    func markYamadoriCollected(
        findID: UUID,
        botanicalName: String,
        locationID: UUID,
        collectionNotes: String = "",
        copyImages: Bool = true
    ) -> Tree? {
        guard let findIndex = yamadoriFinds.firstIndex(where: { $0.id == findID }) else { return nil }
        var find = yamadoriFinds[findIndex]
        guard find.status == .planned else { return nil }
        if let existingID = find.linkedTreeID, let existing = tree(id: existingID) {
            return existing
        }
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return nil }
        guard location(id: locationID) != nil else { return nil }

        let now = Date.now
        let trip = yamadoriTrip(id: find.yamadoriID)
        var originNotes = "Collected as \(find.yamadoriCode)"
        let trimmedNotes = collectionNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedNotes.isEmpty {
            originNotes += " — \(trimmedNotes)"
        }
        if let site = trip?.locationDescription, !site.isEmpty {
            originNotes += "\nWild site: \(site)"
        }

        let imageIDs = copyImages ? find.imageIDs : []
        let primaryImageID = copyImages ? find.primaryImageID : nil

        let tree = Tree(
            botanicalName: botanical,
            bonsaiName: find.yamadoriCode,
            locationID: locationID,
            sourceYamadoriID: find.id,
            yamadoriNursery: true,
            acquisitionDate: now,
            acquisitionNotes: originNotes,
            notes: find.notes,
            primaryImageID: primaryImageID,
            imageIDs: imageIDs
        )
        trees.append(tree)

        find.status = .collected
        find.collectionDate = now
        find.linkedTreeID = tree.id
        find.modifiedDate = now
        find.history.append(
            YamadoriHistoryEntry(kind: .collected, date: now, note: tree.bonsaiName)
        )
        yamadoriFinds[findIndex] = find
        persistAll()
        return trees.first { $0.id == tree.id }
    }

    /// Adds a JPEG original to a Find. Becomes primary only when the Find has none.
    @discardableResult
    func addPhoto(
        toFind findID: UUID,
        jpegData: Data,
        width: Int,
        height: Int,
        fileName: String
    ) -> ImageAsset? {
        guard let index = yamadoriFinds.firstIndex(where: { $0.id == findID }) else { return nil }
        guard !jpegData.isEmpty else { return nil }

        let id = UUID()
        let now = Date.now
        let becomesPrimary = yamadoriFinds[index].primaryImageID == nil
        let asset = ImageAsset(
            id: id,
            fileName: fileName,
            relativePath: ImageAsset.originalsRelativePath(id: id, fileExtension: "jpg"),
            createdDate: now,
            modifiedDate: now,
            fileSize: Int64(jpegData.count),
            width: width,
            height: height,
            isPrimary: becomesPrimary,
            photoDate: now
        )
        imageAssets[id] = asset
        imageJPEGData[id] = jpegData
        if !yamadoriFinds[index].imageIDs.contains(id) {
            yamadoriFinds[index].imageIDs.append(id)
        }
        if becomesPrimary {
            yamadoriFinds[index].primaryImageID = id
        }
        yamadoriFinds[index].modifiedDate = now
        persistPhoto(asset, jpegData: jpegData)
        return asset
    }

    func setPrimaryImage(findID: UUID, imageID: UUID) {
        guard let index = yamadoriFinds.firstIndex(where: { $0.id == findID }) else { return }
        guard yamadoriFinds[index].imageIDs.contains(imageID) else { return }
        yamadoriFinds[index].primaryImageID = imageID
        yamadoriFinds[index].modifiedDate = .now
        for id in yamadoriFinds[index].imageIDs {
            guard var asset = imageAssets[id] else { continue }
            asset.isPrimary = (id == imageID)
            imageAssets[id] = asset
        }
        persistAll()
    }

    func removePhoto(fromFind findID: UUID, imageID: UUID) {
        guard let index = yamadoriFinds.firstIndex(where: { $0.id == findID }) else { return }
        guard yamadoriFinds[index].imageIDs.contains(imageID) else { return }
        yamadoriFinds[index].imageIDs.removeAll { $0 == imageID }
        if yamadoriFinds[index].primaryImageID == imageID {
            yamadoriFinds[index].primaryImageID = yamadoriFinds[index].imageIDs.first
        }
        yamadoriFinds[index].modifiedDate = .now
        discardImageAsset(id: imageID)
        persistAll()
    }

    /// Adds a field observation (text + date). Category unused on mobile (A1).
    @discardableResult
    func addYamadoriObservation(findID: UUID, text: String, date: Date = .now) -> YamadoriObservation? {
        guard let index = yamadoriFinds.firstIndex(where: { $0.id == findID }) else { return nil }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let observation = YamadoriObservation(date: date, text: trimmed, category: "")
        yamadoriFinds[index].observations.append(observation)
        yamadoriFinds[index].history.append(
            YamadoriHistoryEntry(kind: .observationAdded, date: date, note: String(trimmed.prefix(80)))
        )
        yamadoriFinds[index].modifiedDate = .now
        persistAll()
        return observation
    }

    /// Removes one observation from a Find.
    func removeYamadoriObservation(findID: UUID, observationID: UUID) {
        guard let index = yamadoriFinds.firstIndex(where: { $0.id == findID }) else { return }
        guard yamadoriFinds[index].observations.contains(where: { $0.id == observationID }) else { return }
        yamadoriFinds[index].observations.removeAll { $0.id == observationID }
        yamadoriFinds[index].modifiedDate = .now
        persistAll()
    }

    /// Abandon from Scout/Planned; Archive from Abandoned only (B1).
    @discardableResult
    func setYamadoriFindStatus(findID: UUID, to status: YamadoriStatus, note: String = "") -> YamadoriFind? {
        guard let index = yamadoriFinds.firstIndex(where: { $0.id == findID }) else { return nil }
        let previous = yamadoriFinds[index].status
        let allowed: Bool
        switch (previous, status) {
        case (.scout, .abandoned), (.planned, .abandoned):
            allowed = true
        case (.abandoned, .archived):
            allowed = true
        default:
            allowed = false
        }
        guard allowed else { return nil }

        let now = Date.now
        yamadoriFinds[index].status = status
        yamadoriFinds[index].modifiedDate = now
        let historyKind: YamadoriHistoryEntry.Kind = status == .archived ? .archived : .abandoned
        yamadoriFinds[index].history.append(
            YamadoriHistoryEntry(
                kind: historyKind,
                date: now,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        )
        persistAll()
        return yamadoriFinds[index]
    }

    // MARK: - Seeds

    var orderedSeedBatches: [SeedBatch] {
        seedBatches.sorted {
            if $0.updatedAt != $1.updatedAt { return $0.updatedAt > $1.updatedAt }
            return $0.batchCode.localizedStandardCompare($1.batchCode) == .orderedAscending
        }
    }

    var activeSeedBatchCount: Int {
        seedBatches.filter { $0.stage.isActive }.count
    }

    func seedBatch(id: UUID) -> SeedBatch? {
        seedBatches.first { $0.id == id }
    }

    /// Creates a Planned seed batch. Prefer catalog ``speciesID`` (Mac New Seed Batch).
    @discardableResult
    func addSeedBatch(
        name: String,
        species: String,
        nickname: String = "",
        speciesID: UUID? = nil,
        initialSeedCount: Int = 0,
        source: String = "",
        seedYear: Int? = nil,
        locationID: UUID? = nil,
        notes: String = ""
    ) -> SeedBatch? {
        let botanical = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let speciesText = species.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return nil }
        let year = seedYear ?? Calendar.current.component(.year, from: .now)
        let code = nextSeedBatchCode(botanicalName: botanical, year: year)
        let now = Date.now
        let count = max(0, initialSeedCount)
        let resolvedSpeciesID = speciesID
            ?? stratificationProfile(matchingScientificName: botanical)?.speciesID
            ?? UUID()
        let batch = SeedBatch(
            batchCode: code,
            speciesID: resolvedSpeciesID,
            botanicalName: botanical,
            nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            commonName: speciesText,
            source: source.trimmingCharacters(in: .whitespacesAndNewlines),
            acquisitionDate: now,
            seedYear: year,
            initialSeedCount: count,
            stage: .planned,
            locationID: locationID,
            events: [SeedBatchEvent(date: now, kind: .created)],
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            createdAt: now,
            updatedAt: now
        )
        seedBatches.append(batch)
        persistAll()
        return seedBatches.first { $0.id == batch.id }
    }

    /// Stratification catalog profile for a batch (Mac SeedStratificationCatalogService).
    func stratificationProfile(for batch: SeedBatch) -> SpeciesStratificationProfile? {
        stratificationProfile(speciesID: batch.speciesID)
            ?? stratificationProfile(matchingScientificName: batch.botanicalName)
    }

    func stratificationProfile(speciesID: UUID) -> SpeciesStratificationProfile? {
        SeedStratificationCatalogData.all.first { $0.speciesID == speciesID }
    }

    func stratificationProfile(matchingScientificName name: String) -> SpeciesStratificationProfile? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return SeedStratificationCatalogData.all.first {
            $0.scientificName.caseInsensitiveCompare(trimmed) == .orderedSame
        }
    }

    func matchingStratificationProfiles(search: String) -> [SpeciesStratificationProfile] {
        let query = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard query.count >= 2 else { return [] }
        return SeedStratificationCatalogData.all.filter { $0.searchText.contains(query) }
    }

    /// Mac Start Stratification — builds treatment phases from the catalog.
    @discardableResult
    func startSeedBatchStratification(
        id: UUID,
        mediumDescription: String = "",
        locationID: UUID? = nil,
        soilMixID: UUID? = nil,
        notes: String = ""
    ) -> SeedBatch? {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return nil }
        let stage = seedBatches[index].stage
        guard stage == .planned || stage == .readyToSow else { return nil }
        guard let profile = stratificationProfile(for: seedBatches[index]) else { return nil }

        let treatmentSteps = profile.treatmentPhasesForStart
        let now = Date.now
        let trimmedMedium = mediumDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let phaseMedium = trimmedMedium.isEmpty ? trimmedNotes : trimmedMedium

        if treatmentSteps.isEmpty || profile.treatmentType == .none {
            seedBatches[index].stage = .readyToSow
            seedBatches[index].events.append(
                SeedBatchEvent(
                    date: now,
                    kind: .noteAdded,
                    notes: "Species profile indicates no pretreatment normally required — ready to sow."
                )
            )
            seedBatches[index].updatedAt = now
            persistAll()
            return seedBatches[index]
        }

        var phases: [SeedBatchTreatmentPhase] = []
        for step in treatmentSteps {
            let suggested = SpeciesStratificationProfile.suggestedMidpointDays(
                minDays: step.durationMinDays,
                maxDays: step.durationMaxDays
            ) ?? step.durationMinDays ?? step.durationMaxDays
            var phase = SeedBatchTreatmentPhase(
                order: step.order,
                phaseType: step.type,
                recommendedTemperatureMin: step.temperatureMin,
                recommendedTemperatureMax: step.temperatureMax,
                recommendedDurationMinDays: step.durationMinDays,
                recommendedDurationMaxDays: step.durationMaxDays,
                selectedDurationDays: suggested,
                mediumDescription: phaseMedium,
                soilMixID: soilMixID,
                notes: step.notes
            )
            phases.append(phase)
        }
        guard !phases.isEmpty else { return nil }

        phases[0].startedAt = now
        if let days = phases[0].selectedDurationDays {
            phases[0].targetEndAt = Calendar.current.date(byAdding: .day, value: days, to: now)
        }

        seedBatches[index].treatmentPhases = phases
        seedBatches[index].currentTreatmentPhaseIndex = 0
        seedBatches[index].stage = .stratifying
        seedBatches[index].stratifiedSeedCount = seedBatches[index].viableSeedCount
        if let locationID {
            seedBatches[index].locationID = locationID
        }
        if let soilMixID {
            seedBatches[index].soilMixID = soilMixID
        }
        var eventParts = [phases[0].phaseType.title]
        if !trimmedMedium.isEmpty { eventParts.append(trimmedMedium) }
        if !trimmedNotes.isEmpty, trimmedNotes != trimmedMedium { eventParts.append(trimmedNotes) }
        seedBatches[index].events.append(
            SeedBatchEvent(
                date: now,
                kind: .stratificationStarted,
                quantity: seedBatches[index].stratifiedSeedCount,
                notes: eventParts.joined(separator: " — "),
                locationID: seedBatches[index].locationID,
                soilMixID: soilMixID
            )
        )
        seedBatches[index].updatedAt = now
        persistAll()
        return seedBatches[index]
    }

    /// Skip pretreatment — Ready to Sow (Mac).
    @discardableResult
    func skipSeedBatchToReadyToSow(id: UUID) -> SeedBatch? {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return nil }
        guard seedBatches[index].stage == .planned else { return nil }
        seedBatches[index].stage = .readyToSow
        seedBatches[index].events.append(
            SeedBatchEvent(date: .now, kind: .noteAdded, notes: "Skipped stratification — ready to sow.")
        )
        seedBatches[index].updatedAt = .now
        persistAll()
        return seedBatches[index]
    }

    /// Complete current treatment phase; advances to next or Ready to Sow (Mac).
    @discardableResult
    func completeSeedBatchTreatmentPhase(id: UUID, notes: String = "") -> SeedBatch? {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return nil }
        guard seedBatches[index].stage == .stratifying,
              seedBatches[index].treatmentPhases.indices.contains(seedBatches[index].currentTreatmentPhaseIndex)
        else { return nil }

        let now = Date.now
        let phaseIndex = seedBatches[index].currentTreatmentPhaseIndex
        seedBatches[index].treatmentPhases[phaseIndex].completedAt = now
        let phaseTitle = seedBatches[index].treatmentPhases[phaseIndex].phaseType.title
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        seedBatches[index].events.append(
            SeedBatchEvent(
                date: now,
                kind: .stratificationCompleted,
                notes: trimmed.isEmpty ? "Completed \(phaseTitle)" : trimmed
            )
        )

        let nextIndex = phaseIndex + 1
        if nextIndex < seedBatches[index].treatmentPhases.count {
            seedBatches[index].currentTreatmentPhaseIndex = nextIndex
            seedBatches[index].treatmentPhases[nextIndex].startedAt = now
            if let days = seedBatches[index].treatmentPhases[nextIndex].selectedDurationDays {
                seedBatches[index].treatmentPhases[nextIndex].targetEndAt =
                    Calendar.current.date(byAdding: .day, value: days, to: now)
            }
            seedBatches[index].events.append(
                SeedBatchEvent(
                    date: now,
                    kind: .stratificationStarted,
                    notes: "Started \(seedBatches[index].treatmentPhases[nextIndex].phaseType.title)"
                )
            )
        } else {
            seedBatches[index].stage = .readyToSow
        }
        seedBatches[index].updatedAt = now
        persistAll()
        return seedBatches[index]
    }

    /// Active batches needing attention today (phase end due / overdue, or Planned).
    func seedBatchesDueToday() -> [SeedBatch] {
        let cal = Calendar.current
        let start = cal.startOfDay(for: .now)
        return orderedSeedBatches.filter { batch in
            guard batch.stage.isActive else { return false }
            if batch.stage == .planned { return true }
            guard batch.stage == .stratifying,
                  let end = batch.currentPhase?.targetEndAt
            else { return false }
            return cal.startOfDay(for: end) <= start
        }
    }

    /// Stratifying batches with a future phase end (Mac Upcoming).
    func seedBatchesUpcoming() -> [SeedBatch] {
        let cal = Calendar.current
        let start = cal.startOfDay(for: .now)
        return orderedSeedBatches.filter { batch in
            guard batch.stage == .stratifying,
                  let end = batch.currentPhase?.targetEndAt
            else { return false }
            return cal.startOfDay(for: end) > start
        }
    }

    func updateSeedBatch(
        id: UUID,
        name: String,
        species: String,
        nickname: String = "",
        stage: SeedBatchStage,
        notes: String,
        soilMixID: UUID?,
        source: String? = nil,
        seedYear: Int? = nil,
        locationID: UUID? = nil,
        containerDescription: String? = nil,
        initialSeedCount: Int? = nil,
        viableSeedCount: Int? = nil,
        sownSeedCount: Int? = nil,
        germinatedSeedCount: Int? = nil,
        survivingSeedlingCount: Int? = nil,
        selectedTreeCount: Int? = nil
    ) {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return }
        let botanical = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return }
        seedBatches[index].botanicalName = botanical
        seedBatches[index].nickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        seedBatches[index].commonName = species.trimmingCharacters(in: .whitespacesAndNewlines)
        seedBatches[index].stage = stage
        seedBatches[index].notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        seedBatches[index].soilMixID = soilMixID
        if let source {
            seedBatches[index].source = source.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let seedYear {
            seedBatches[index].seedYear = seedYear
        }
        if let locationID {
            seedBatches[index].locationID = locationID
        }
        // Explicit nil clears location when caller passes Optional.none via overload below.
        if let containerDescription {
            seedBatches[index].containerDescription = containerDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let initialSeedCount {
            seedBatches[index].initialSeedCount = max(0, initialSeedCount)
        }
        if let viableSeedCount {
            seedBatches[index].viableSeedCount = max(0, viableSeedCount)
        }
        if let sownSeedCount {
            seedBatches[index].sownSeedCount = max(0, sownSeedCount)
        }
        if let germinatedSeedCount {
            seedBatches[index].germinatedSeedCount = max(0, germinatedSeedCount)
        }
        if let survivingSeedlingCount {
            seedBatches[index].survivingSeedlingCount = max(0, survivingSeedlingCount)
        }
        if let selectedTreeCount {
            seedBatches[index].selectedTreeCount = max(0, selectedTreeCount)
        }
        seedBatches[index].updatedAt = .now
        persistAll()
    }

    /// Sets or clears location independently of other optional fields.
    func setSeedBatchLocation(id: UUID, locationID: UUID?) {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return }
        seedBatches[index].locationID = locationID
        seedBatches[index].updatedAt = .now
        persistAll()
    }

    /// Advances along Planned → … → Developing. Returns new stage.
    @discardableResult
    func advanceSeedBatchStage(id: UUID) -> SeedBatchStage? {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return nil }
        guard let next = seedBatches[index].stage.nextActiveStage else { return nil }
        seedBatches[index].stage = next
        seedBatches[index].updatedAt = .now
        persistAll()
        return next
    }

    /// Marks a batch Failed (Mac Seed Work action).
    @discardableResult
    func markSeedBatchFailed(id: UUID, notes: String = "") -> Bool {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return false }
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        seedBatches[index].stage = .failed
        seedBatches[index].events.append(
            SeedBatchEvent(date: .now, kind: .failed, notes: trimmed.isEmpty ? "Marked failed by grower" : trimmed)
        )
        seedBatches[index].updatedAt = .now
        persistAll()
        return true
    }

    /// Records sowing counts and moves to Sown when still Planned / Stratifying / Ready to Sow.
    @discardableResult
    func recordSeedBatchSowing(
        id: UUID,
        sownCount: Int,
        soilMixID: UUID?,
        locationID: UUID?,
        containerDescription: String
    ) -> Bool {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return false }
        guard sownCount > 0 else { return false }
        seedBatches[index].sownSeedCount = sownCount
        if let soilMixID {
            seedBatches[index].soilMixID = soilMixID
        }
        if let locationID {
            seedBatches[index].locationID = locationID
        }
        let container = containerDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        if !container.isEmpty {
            seedBatches[index].containerDescription = container
        }
        switch seedBatches[index].stage {
        case .planned, .stratifying, .readyToSow:
            seedBatches[index].stage = .sown
        default:
            break
        }
        seedBatches[index].events.append(
            SeedBatchEvent(
                date: .now,
                kind: .seedsSown,
                quantity: sownCount,
                locationID: locationID ?? seedBatches[index].locationID,
                soilMixID: soilMixID ?? seedBatches[index].soilMixID
            )
        )
        seedBatches[index].updatedAt = .now
        persistAll()
        return true
    }

    /// Updates germination count and moves toward Germinating when appropriate.
    @discardableResult
    func recordSeedBatchGermination(id: UUID, germinatedCount: Int) -> Bool {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return false }
        guard germinatedCount >= 0 else { return false }
        seedBatches[index].germinatedSeedCount = germinatedCount
        if seedBatches[index].stage == .sown, germinatedCount > 0 {
            seedBatches[index].stage = .germinating
        }
        seedBatches[index].events.append(
            SeedBatchEvent(date: .now, kind: .germinationCountUpdated, quantity: germinatedCount)
        )
        seedBatches[index].updatedAt = .now
        persistAll()
        return true
    }

    /// Updates surviving seedling count (Mac Update Survival).
    @discardableResult
    func updateSeedBatchSurvival(id: UUID, survivingCount: Int) -> Bool {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return false }
        guard survivingCount >= 0 else { return false }
        let previous = seedBatches[index].survivingSeedlingCount
        let lost = previous - survivingCount
        seedBatches[index].survivingSeedlingCount = survivingCount
        if [.germinating, .sown].contains(seedBatches[index].stage), survivingCount > 0 {
            seedBatches[index].stage = .seedling
        }
        if lost > 0 {
            seedBatches[index].events.append(
                SeedBatchEvent(date: .now, kind: .seedlingLoss, quantity: lost)
            )
        } else {
            seedBatches[index].events.append(
                SeedBatchEvent(date: .now, kind: .noteAdded, quantity: survivingCount, notes: "Survival updated")
            )
        }
        seedBatches[index].updatedAt = .now
        persistAll()
        return true
    }

    /// Selects seedlings for development (Mac Separate Seedlings).
    @discardableResult
    func separateSeedBatchSeedlings(id: UUID, selectCount: Int) -> Bool {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return false }
        guard selectCount > 0 else { return false }
        guard selectCount <= seedBatches[index].survivingSeedlingCount else { return false }
        seedBatches[index].selectedTreeCount += selectCount
        seedBatches[index].survivingSeedlingCount -= selectCount
        seedBatches[index].stage = .developing
        seedBatches[index].events.append(
            SeedBatchEvent(
                date: .now,
                kind: .seedlingSeparated,
                quantity: selectCount,
                notes: "\(selectCount) selected for bonsai development; \(seedBatches[index].survivingSeedlingCount) remain in batch."
            )
        )
        seedBatches[index].updatedAt = .now
        persistAll()
        return true
    }

    // MARK: - Pots

    var orderedPots: [Pot] {
        pots.sorted {
            displayName(for: $0).localizedStandardCompare(displayName(for: $1)) == .orderedAscending
        }
    }

    var availablePots: [Pot] {
        orderedPots.filter { $0.status.isNormallyAvailable }
    }

    func pot(id: UUID) -> Pot? {
        pots.first { $0.id == id }
    }

    func pot(linkedToTreeID treeID: UUID) -> Pot? {
        if let pot = pots.first(where: { $0.linkedTreeID == treeID }) {
            return pot
        }
        if let potID = tree(id: treeID)?.currentPotID {
            return pot(id: potID)
        }
        return nil
    }

    func displayName(for pot: Pot) -> String {
        let trimmed = pot.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        let shape = pot.shape.trimmingCharacters(in: .whitespacesAndNewlines)
        if !shape.isEmpty { return shape }
        return "Untitled Pot"
    }

    @discardableResult
    func addPot(
        name: String = "",
        potTypeID: UUID? = nil,
        brandID: UUID? = nil,
        makerID: UUID? = nil,
        material: String = "",
        shape: String = "",
        notes: String = ""
    ) -> Pot? {
        let now = Date.now
        let pot = Pot(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            potTypeID: potTypeID,
            brandID: brandID,
            makerID: makerID,
            material: material.trimmingCharacters(in: .whitespacesAndNewlines),
            shape: shape.trimmingCharacters(in: .whitespacesAndNewlines),
            status: .available,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            history: [PotHistoryEntry(kind: .created, date: now)],
            createdDate: now,
            modifiedDate: now
        )
        pots.append(pot)
        persistAll()
        return pots.first { $0.id == pot.id }
    }

    // MARK: - Nursery Propagation (Cuttings / Air Layers)

    func nurseryPropagationProjects(kind: NurseryPropagationKind) -> [NurseryPropagationProject] {
        nurseryPropagationProjects
            .filter { $0.kind == kind }
            .sorted {
                if $0.updatedAt != $1.updatedAt { return $0.updatedAt > $1.updatedAt }
                return $0.projectCode.localizedStandardCompare($1.projectCode) == .orderedAscending
            }
    }

    func nurseryPropagationProject(id: UUID) -> NurseryPropagationProject? {
        nurseryPropagationProjects.first { $0.id == id }
    }

    @discardableResult
    func addNurseryPropagationProject(
        kind: NurseryPropagationKind,
        botanicalName: String,
        commonName: String = "",
        parentTreeID: UUID? = nil,
        quantity: Int = 1,
        locationID: UUID? = nil,
        notes: String = "",
        cuttingTakenAt: Date? = nil,
        cuttingWoodMaturity: NurseryCuttingWoodMaturity? = nil,
        cuttingBaseTechnique: NurseryCuttingBaseTechnique? = nil,
        cuttingStructure: NurseryCuttingStructure? = nil,
        airLayerStartedAt: Date? = nil,
        airLayerMethod: NurseryAirLayerMethod? = nil
    ) -> NurseryPropagationProject? {
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return nil }
        if kind == .airLayer, parentTreeID == nil { return nil }
        let qty = max(1, quantity)
        let code = nextNurseryPropagationCode(kind: kind)
        let now = Date.now
        var project = NurseryPropagationProject(
            kind: kind,
            projectCode: code,
            botanicalName: botanical,
            commonName: commonName.trimmingCharacters(in: .whitespacesAndNewlines),
            parentTreeID: parentTreeID,
            quantity: qty,
            stage: .planned,
            locationID: locationID,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            events: [
                NurseryPropagationEvent(
                    kind: .created,
                    quantity: qty,
                    notes: "\(kind.projectNoun) \(code) created."
                )
            ],
            cuttingTakenAt: kind == .cutting ? (cuttingTakenAt ?? now) : nil,
            cuttingWoodMaturity: kind == .cutting ? cuttingWoodMaturity : nil,
            cuttingBaseTechnique: kind == .cutting ? cuttingBaseTechnique : nil,
            cuttingStructure: kind == .cutting ? cuttingStructure : nil,
            airLayerMethod: kind == .airLayer ? (airLayerMethod ?? .completeRing) : nil,
            airLayerRootingAid: kind == .airLayer ? .none : nil,
            airLayerMediumPreset: kind == .airLayer ? .longFiberSphagnum : nil,
            airLayerRootDevelopment: kind == .airLayer ? .noRoots : nil,
            airLayerStartedAt: kind == .airLayer ? (airLayerStartedAt ?? now) : nil,
            createdAt: now,
            updatedAt: now
        )
        if let parentTreeID, let tree = tree(id: parentTreeID) {
            project.genusID = tree.genusID
            project.speciesID = tree.speciesID
            project.cultivarID = tree.cultivarID
            if project.botanicalName.isEmpty {
                project.botanicalName = tree.botanicalName
            }
            if project.commonName.isEmpty {
                project.commonName = tree.bonsaiName
            }
        }
        nurseryPropagationProjects.append(project)
        persistAll()
        return nurseryPropagationProjects.first { $0.id == project.id }
    }

    func updateNurseryPropagationProject(
        id: UUID,
        botanicalName: String,
        commonName: String,
        parentTreeID: UUID?,
        quantity: Int,
        locationID: UUID?,
        notes: String,
        stage: NurseryPropagationStage
    ) {
        guard let index = nurseryPropagationProjects.firstIndex(where: { $0.id == id }) else { return }
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return }
        let qty = max(1, quantity)
        let previousQuantity = nurseryPropagationProjects[index].quantity
        let previousStage = nurseryPropagationProjects[index].stage
        nurseryPropagationProjects[index].botanicalName = botanical
        nurseryPropagationProjects[index].commonName = commonName.trimmingCharacters(in: .whitespacesAndNewlines)
        nurseryPropagationProjects[index].parentTreeID = parentTreeID
        nurseryPropagationProjects[index].quantity = qty
        nurseryPropagationProjects[index].locationID = locationID
        nurseryPropagationProjects[index].notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        if stage != previousStage {
            nurseryPropagationProjects[index].stage = stage
            nurseryPropagationProjects[index].events.append(
                NurseryPropagationEvent(
                    kind: .stageChanged,
                    notes: "Stage set to \(stage.title(for: nurseryPropagationProjects[index].kind))."
                )
            )
        }
        if qty != previousQuantity {
            nurseryPropagationProjects[index].events.append(
                NurseryPropagationEvent(
                    kind: .quantityUpdated,
                    quantity: qty,
                    notes: "Quantity changed from \(previousQuantity) to \(qty)."
                )
            )
        }
        nurseryPropagationProjects[index].updatedAt = .now
        persistAll()
    }

    @discardableResult
    func advanceNurseryPropagationStage(id: UUID) -> NurseryPropagationStage? {
        guard let index = nurseryPropagationProjects.firstIndex(where: { $0.id == id }) else { return nil }
        let kind = nurseryPropagationProjects[index].kind
        var stage = nurseryPropagationProjects[index].stage
        if kind == .cutting, stage == .developing {
            stage = .potted
        } else if kind == .airLayer, stage == .developing {
            stage = .potted
        } else {
            let path = kind.mainPath
            guard let pathIndex = path.firstIndex(of: stage), pathIndex + 1 < path.count else { return nil }
            stage = path[pathIndex + 1]
        }
        nurseryPropagationProjects[index].stage = stage
        nurseryPropagationProjects[index].events.append(
            NurseryPropagationEvent(
                kind: .stageChanged,
                notes: "Moved to \(stage.title(for: kind))."
            )
        )
        nurseryPropagationProjects[index].updatedAt = .now
        persistAll()
        return stage
    }

    @discardableResult
    func markNurseryPropagationFailed(id: UUID, notes: String = "") -> Bool {
        guard let index = nurseryPropagationProjects.firstIndex(where: { $0.id == id }) else { return false }
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        nurseryPropagationProjects[index].stage = .failed
        nurseryPropagationProjects[index].events.append(
            NurseryPropagationEvent(
                kind: .failed,
                notes: trimmed.isEmpty ? "Marked failed by grower" : trimmed
            )
        )
        nurseryPropagationProjects[index].updatedAt = .now
        persistAll()
        return true
    }

    func deleteNurseryPropagationProject(id: UUID) {
        nurseryPropagationProjects.removeAll { $0.id == id }
        careTasks = careTasks.compactMap { task in
            var next = task
            next.nurseryPropagationProjectIDs.removeAll { $0 == id }
            let hasOtherTargets = !next.treeIDs.isEmpty
                || !next.yamadoriIDs.isEmpty
                || !next.seedBatchIDs.isEmpty
                || !next.nurseryPropagationProjectIDs.isEmpty
                || next.libraryInventoryKind != nil
            return hasOtherTargets ? next : nil
        }
        persistAll()
    }

    private func nextNurseryPropagationCode(kind: NurseryPropagationKind) -> String {
        let year = Calendar.current.component(.year, from: Date())
        let prefix = "\(kind.codePrefix)-\(year)-"
        let existing = nurseryPropagationProjects(kind: kind)
            .map(\.projectCode)
            .compactMap { code -> Int? in
                guard code.hasPrefix(prefix) else { return nil }
                return Int(code.dropFirst(prefix.count))
            }
        let next = (existing.max() ?? 0) + 1
        return "\(prefix)\(String(format: "%02d", next))"
    }

    // MARK: - Reference Data (Settings)

    func referenceRecords(in category: ReferenceDataCategory) -> [ReferenceDataRecord] {
        referenceCatalog.records(in: category)
    }

    @discardableResult
    func saveReferenceDraft(_ draft: ReferenceDataDraft, in category: ReferenceDataCategory) -> Bool {
        guard referenceCatalog.save(draft, in: category) else { return false }
        persistReferenceCatalog()
        return true
    }

    func setReferenceActive(id: UUID, in category: ReferenceDataCategory, isActive: Bool) {
        referenceCatalog.setActive(id, in: category, isActive: isActive)
        persistReferenceCatalog()
    }

    func deleteReferenceItem(id: UUID, in category: ReferenceDataCategory) {
        referenceCatalog.delete(id, in: category)
        persistReferenceCatalog()
    }

    func nextReferenceSortOrder(in category: ReferenceDataCategory) -> Int {
        (referenceCatalog.records(in: category).map(\.sortOrder).max() ?? -1) + 1
    }

    /// Active styles for pickers (Settings catalog, not PreviewData).
    var orderedStyles: [Style] {
        referenceCatalog.styles.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    var orderedSizeClasses: [SizeClass] {
        referenceCatalog.sizeClasses.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    var orderedTreeStages: [TreeStage] {
        referenceCatalog.treeStages.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    var orderedLightConditions: [LightCondition] {
        referenceCatalog.lightConditions.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    var orderedPotTypes: [PotType] {
        referenceCatalog.potTypes.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    var orderedAcquisitionMethods: [AcquisitionMethod] {
        referenceCatalog.acquisitionMethods.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    var orderedWorkTypes: [WorkType] {
        referenceCatalog.workTypes.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    var orderedFertilizerTypes: [FertilizerType] {
        referenceCatalog.fertilizerTypes.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    private func persistReferenceCatalog() {
        guard let store else { return }
        do {
            try store.saveReferenceCatalog(referenceCatalog)
            lastSaveError = nil
            noteLocalWrite()
        } catch {
            lastSaveError = "Bonsai World could not save Reference Data: \(error.localizedDescription)"
            print(lastSaveError ?? "")
        }
    }

    // MARK: - Pot Brands & Makers

    var orderedPotBrands: [PotBrand] {
        potBrands.sorted {
            if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
            return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    var activePotBrands: [PotBrand] {
        orderedPotBrands.filter(\.isActive)
    }

    func potBrand(id: UUID) -> PotBrand? {
        potBrands.first { $0.id == id }
    }

    func potMaker(id: UUID) -> PotMaker? {
        potMakers.first { $0.id == id }
    }

    /// Makers offered when assigning to a Pot: makers of the selected Brand, plus independents (Mac).
    func potMakersSelectable(forBrandID brandID: UUID?) -> [PotMaker] {
        let active = potMakers.filter(\.isActive)
        let independents = active.filter { $0.brandID == nil }
        let branded: [PotMaker]
        if let brandID {
            branded = active.filter { $0.brandID == brandID }
        } else {
            branded = []
        }
        return (branded + independents).sorted {
            if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
            return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    func potMakers(forBrandID brandID: UUID) -> [PotMaker] {
        potMakers
            .filter { $0.isActive && $0.brandID == brandID }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func independentPotMakers() -> [PotMaker] {
        potMakers
            .filter { $0.brandID == nil }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    @discardableResult
    func addPotBrand(name: String, kind: PotBrandKind = .brand, country: String = "", originText: String = "", notes: String = "") -> PotBrand? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let now = Date.now
        let brand = PotBrand(
            name: trimmed,
            kind: kind,
            country: country.trimmingCharacters(in: .whitespacesAndNewlines),
            originText: originText.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            sortOrder: (potBrands.map(\.sortOrder).max() ?? 0) + 1,
            createdDate: now,
            modifiedDate: now
        )
        potBrands.append(brand)
        persistPotBrands()
        return brand
    }

    func updatePotBrand(_ brand: PotBrand) {
        guard let index = potBrands.firstIndex(where: { $0.id == brand.id }) else { return }
        var next = brand
        next.modifiedDate = .now
        potBrands[index] = next
        persistPotBrands()
    }

    func deletePotBrand(id: UUID) {
        guard !pots.contains(where: { $0.brandID == id }) else { return }
        guard !potMakers.contains(where: { $0.brandID == id }) else { return }
        potBrands.removeAll { $0.id == id }
        persistPotBrands()
    }

    @discardableResult
    func addPotMaker(
        name: String,
        brandID: UUID? = nil,
        makerType: PotMakerType = .unknown,
        generation: String = "",
        notes: String = ""
    ) -> PotMaker? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let now = Date.now
        let maker = PotMaker(
            name: trimmed,
            brandID: brandID,
            makerType: makerType,
            generation: generation.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            sortOrder: (potMakers.map(\.sortOrder).max() ?? 0) + 1,
            createdDate: now,
            modifiedDate: now
        )
        potMakers.append(maker)
        persistPotBrands()
        return maker
    }

    func updatePotMaker(_ maker: PotMaker) {
        guard let index = potMakers.firstIndex(where: { $0.id == maker.id }) else { return }
        var next = maker
        next.modifiedDate = .now
        potMakers[index] = next
        persistPotBrands()
    }

    func deletePotMaker(id: UUID) {
        guard !pots.contains(where: { $0.makerID == id }) else { return }
        potMakers.removeAll { $0.id == id }
        persistPotBrands()
    }

    private func persistPotBrands() {
        guard let store else { return }
        do {
            try store.savePotBrandsAndMakers(
                brands: potBrands,
                makers: potMakers,
                seedVersion: potBrandsSeedVersion ?? PotBrandPreviewData.seedVersion
            )
            lastSaveError = nil
            noteLocalWrite()
        } catch {
            reportSaveFailure(error)
        }
    }

    func updatePot(
        id: UUID,
        name: String,
        material: String,
        shape: String,
        condition: String,
        notes: String,
        status: PotStatus
    ) {
        guard let index = pots.firstIndex(where: { $0.id == id }) else { return }
        pots[index].name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        pots[index].material = material.trimmingCharacters(in: .whitespacesAndNewlines)
        pots[index].shape = shape.trimmingCharacters(in: .whitespacesAndNewlines)
        pots[index].condition = condition.trimmingCharacters(in: .whitespacesAndNewlines)
        pots[index].notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        // Lifecycle transitions that unassign are handled by assign/unassign helpers.
        if status != .inUse || pots[index].linkedTreeID != nil {
            pots[index].status = status
        }
        pots[index].modifiedDate = .now
        persistAll()
    }

    /// Assigns an Available inventory pot to a tree (Mac Assign Inventory Pot).
    @discardableResult
    func assignPot(_ potID: UUID, toTreeID treeID: UUID) -> Bool {
        guard let potIndex = pots.firstIndex(where: { $0.id == potID }) else { return false }
        guard let treeIndex = trees.firstIndex(where: { $0.id == treeID }) else { return false }
        var pot = pots[potIndex]
        guard pot.status == .available || (pot.status == .inUse && pot.linkedTreeID == treeID) else {
            return false
        }

        if let previousTreeID = pot.linkedTreeID, previousTreeID != treeID,
           let previousIndex = trees.firstIndex(where: { $0.id == previousTreeID }) {
            trees[previousIndex].currentPotID = nil
            trees[previousIndex].modifiedDate = .now
            pot.history.append(
                PotHistoryEntry(
                    kind: .unlinkedFromTree,
                    note: MobileTreePresentation.title(for: trees[previousIndex]),
                    relatedTreeID: previousTreeID
                )
            )
            pot.linkedTreeID = nil
            pot.status = .available
        }

        if let currentPotID = trees[treeIndex].currentPotID, currentPotID != potID {
            _ = unassignCurrentPot(fromTreeID: treeID)
            guard let refreshed = pots.firstIndex(where: { $0.id == potID }) else { return false }
            pot = pots[refreshed]
        }

        guard let index = pots.firstIndex(where: { $0.id == potID }) else { return false }
        pots[index].status = .inUse
        pots[index].linkedTreeID = treeID
        pots[index].history.append(
            PotHistoryEntry(
                kind: .linkedToTree,
                note: MobileTreePresentation.title(for: trees[treeIndex]),
                relatedTreeID: treeID
            )
        )
        pots[index].modifiedDate = .now
        trees[treeIndex].currentPotID = potID
        trees[treeIndex].modifiedDate = .now
        persistAll()
        return true
    }

    @discardableResult
    func unassignCurrentPot(fromTreeID treeID: UUID) -> Bool {
        guard let treeIndex = trees.firstIndex(where: { $0.id == treeID }) else { return false }
        var potIndex = pots.firstIndex(where: { $0.linkedTreeID == treeID })
        if potIndex == nil, let potID = trees[treeIndex].currentPotID {
            potIndex = pots.firstIndex(where: { $0.id == potID })
        }
        guard let potIndex else {
            trees[treeIndex].currentPotID = nil
            trees[treeIndex].modifiedDate = .now
            persistAll()
            return true
        }
        pots[potIndex].linkedTreeID = nil
        if pots[potIndex].status == .inUse {
            pots[potIndex].status = .available
        }
        pots[potIndex].history.append(
            PotHistoryEntry(kind: .unlinkedFromTree, relatedTreeID: treeID)
        )
        pots[potIndex].modifiedDate = .now
        trees[treeIndex].currentPotID = nil
        trees[treeIndex].modifiedDate = .now
        persistAll()
        return true
    }

    func deletePot(id: UUID) {
        guard let index = pots.firstIndex(where: { $0.id == id }) else { return }
        if let treeID = pots[index].linkedTreeID,
           let treeIndex = trees.firstIndex(where: { $0.id == treeID }),
           trees[treeIndex].currentPotID == id {
            trees[treeIndex].currentPotID = nil
            trees[treeIndex].modifiedDate = .now
        }
        pots.remove(at: index)
        persistAll()
    }

    /// Adds a JPEG original to a Seed Batch. New UUID.
    @discardableResult
    func addPhoto(
        toSeedBatch batchID: UUID,
        jpegData: Data,
        width: Int,
        height: Int,
        fileName: String
    ) -> ImageAsset? {
        guard let index = seedBatches.firstIndex(where: { $0.id == batchID }) else { return nil }
        guard !jpegData.isEmpty else { return nil }

        let id = UUID()
        let now = Date.now
        let becomesPrimary = seedBatches[index].primaryImageID == nil
        let asset = ImageAsset(
            id: id,
            fileName: fileName,
            relativePath: ImageAsset.originalsRelativePath(id: id, fileExtension: "jpg"),
            createdDate: now,
            modifiedDate: now,
            fileSize: Int64(jpegData.count),
            width: width,
            height: height,
            isPrimary: becomesPrimary,
            photoDate: now
        )
        imageAssets[id] = asset
        imageJPEGData[id] = jpegData
        if !seedBatches[index].imageIDs.contains(id) {
            seedBatches[index].imageIDs.append(id)
        }
        if becomesPrimary {
            seedBatches[index].primaryImageID = id
        }
        seedBatches[index].events.append(SeedBatchEvent(date: now, kind: .photoAdded, imageID: id))
        seedBatches[index].updatedAt = now
        persistPhoto(asset, jpegData: jpegData)
        return asset
    }

    func setPrimaryImage(seedBatchID: UUID, imageID: UUID) {
        guard let index = seedBatches.firstIndex(where: { $0.id == seedBatchID }) else { return }
        guard seedBatches[index].imageIDs.contains(imageID) else { return }
        seedBatches[index].primaryImageID = imageID
        seedBatches[index].updatedAt = .now
        for id in seedBatches[index].imageIDs {
            imageAssets[id]?.isPrimary = id == imageID
            imageAssets[id]?.modifiedDate = .now
        }
        persistAll()
    }

    func removePhoto(fromSeedBatch batchID: UUID, imageID: UUID) {
        guard let index = seedBatches.firstIndex(where: { $0.id == batchID }) else { return }
        guard seedBatches[index].imageIDs.contains(imageID) else { return }
        seedBatches[index].imageIDs.removeAll { $0 == imageID }
        if seedBatches[index].primaryImageID == imageID {
            seedBatches[index].primaryImageID = seedBatches[index].imageIDs.first
        }
        seedBatches[index].updatedAt = .now
        discardImageAsset(id: imageID)
        persistAll()
    }

    func deleteSeedBatch(id: UUID) {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return }
        let imageIDs = seedBatches[index].imageIDs
        seedBatches.remove(at: index)
        for imageID in imageIDs {
            discardImageAsset(id: imageID)
        }
        persistAll()
    }

    private func rememberJPEG(_ id: UUID, data: Data) {
        imageJPEGData[id] = data
        jpegOrder.removeAll { $0 == id }
        jpegOrder.append(id)
        while jpegOrder.count > jpegCacheLimit {
            imageJPEGData.removeValue(forKey: jpegOrder.removeFirst())
        }
    }

    private func promoteDownloadedImages() {
        guard let store, !pendingImagePaths.isEmpty else { return }
        let batch = Array(pendingImagePaths.prefix(24))
        let root = store.rootURL
        Task.detached(priority: .utility) { [weak self] in
            var ready: [String] = []
            for path in batch {
                let url = root.appendingPathComponent(path, isDirectory: false)
                if Self.fileLooksMaterialized(url) {
                    ready.append(path)
                }
            }
            guard !ready.isEmpty else { return }
            await MainActor.run {
                guard let self else { return }
                self.pendingImagePaths.subtract(ready)
                MobileImageThumbnail.clearCache()
                self.imageRevision += 1
            }
        }
    }

    /// Builds missing Thumbnails/Previews off the main actor (Mac package layout).
    private func startDerivativeBackfillIfNeeded() {
        guard !isDerivativeBackfillRunning, let store else { return }
        let assets = Array(imageAssets.values)
        guard !assets.isEmpty else { return }
        isDerivativeBackfillRunning = true
        let root = store.rootURL
        derivativeBackfillTask = Task.detached(priority: .utility) { [weak self] in
            defer {
                Task { @MainActor in self?.isDerivativeBackfillRunning = false }
            }
            var built = 0
            for asset in assets {
                if Task.isCancelled { return }
                let thumbRel = MobileImageDerivativeKind.thumbnail.relativePath(id: asset.id)
                let previewRel = MobileImageDerivativeKind.preview.relativePath(id: asset.id)
                let thumbURL = root.appendingPathComponent(thumbRel, isDirectory: false)
                let previewURL = root.appendingPathComponent(previewRel, isDirectory: false)
                let needsThumb = !Self.fileLooksMaterialized(thumbURL)
                let needsPreview = !Self.fileLooksMaterialized(previewURL)
                guard needsThumb || needsPreview else { continue }
                let originalURL = root.appendingPathComponent(asset.relativePath, isDirectory: false)
                guard Self.fileLooksMaterialized(originalURL),
                      let original = Self.readFileWithTimeout(originalURL, seconds: 1.5),
                      !original.isEmpty
                else { continue }
                try? FileManager.default.createDirectory(
                    at: thumbURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                try? FileManager.default.createDirectory(
                    at: previewURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                if needsThumb,
                   let jpeg = MobileImageDerivativeEncoder.jpegData(from: original, kind: .thumbnail) {
                    try? jpeg.write(to: thumbURL, options: .atomic)
                }
                if needsPreview,
                   let jpeg = MobileImageDerivativeEncoder.jpegData(from: original, kind: .preview) {
                    try? jpeg.write(to: previewURL, options: .atomic)
                }
                built += 1
                if built == 1 || built.isMultiple(of: 20) {
                    await MainActor.run {
                        MobileImageThumbnail.clearCache()
                        self?.imageRevision += 1
                    }
                }
            }
            guard built > 0 else { return }
            await MainActor.run {
                MobileImageThumbnail.clearCache()
                self?.imageRevision += 1
            }
        }
    }

    /// Fast existence + non-dataless check without DispatchGroup on the caller.
    private static func fileLooksMaterialized(_ url: URL) -> Bool {
        var attributeList = attrlist()
        attributeList.bitmapcount = u_short(ATTR_BIT_MAP_COUNT)
        attributeList.commonattr = attrgroup_t(ATTR_CMN_FLAGS)
        var buffer = (length: UInt32(0), flags: UInt32(0))
        let read = url.withUnsafeFileSystemRepresentation { pathPtr -> Int32 in
            guard let pathPtr else { return -1 }
            return getattrlist(pathPtr, &attributeList, &buffer, MemoryLayout.size(ofValue: buffer), 0)
        }
        guard read == 0 else { return false }
        return buffer.flags & UInt32(SF_DATALESS) == 0
    }

    private static func readFileWithTimeout(_ url: URL, seconds: TimeInterval) -> Data? {
        final class Box: @unchecked Sendable { var data: Data? }
        let box = Box()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .utility).async {
            defer { group.leave() }
            guard let handle = try? FileHandle(forReadingFrom: url) else { return }
            defer { try? handle.close() }
            box.data = try? handle.readToEnd()
        }
        guard group.wait(timeout: .now() + seconds) == .success else { return nil }
        return box.data
    }

    private func discardImageAsset(id: UUID) {
        let relativePath = imageAssets[id]?.relativePath
        imageAssets.removeValue(forKey: id)
        imageJPEGData.removeValue(forKey: id)
        jpegOrder.removeAll { $0 == id }
        if let relativePath, let store {
            try? store.deleteImageData(relativePath: relativePath)
        }
    }

    /// Removes all photos from Trees, Seed Batches, and Finds. Keeps other library data.
    func clearAllPhotos() {
        let ids = Set(imageAssets.keys).union(imageJPEGData.keys)
        for index in trees.indices {
            trees[index].imageIDs = []
            trees[index].primaryImageID = nil
            trees[index].modifiedDate = .now
        }
        for index in seedBatches.indices {
            seedBatches[index].imageIDs = []
            seedBatches[index].primaryImageID = nil
            seedBatches[index].updatedAt = .now
        }
        for index in yamadoriFinds.indices {
            yamadoriFinds[index].imageIDs = []
            yamadoriFinds[index].primaryImageID = nil
        }
        for id in ids {
            discardImageAsset(id: id)
        }
        persistAll()
    }

    private func nextSeedBatchCode(botanicalName: String, year: Int) -> String {
        let parts = botanicalName.split(separator: " ")
        let prefix: String = {
            if parts.count >= 2 {
                return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
            }
            return String(botanicalName.prefix(2)).uppercased()
        }()
        let existing = seedBatches.filter { $0.seedYear == year && $0.batchCode.hasPrefix("\(prefix)-\(year)-") }
        let next = existing.count + 1
        return "\(prefix)-\(year)-\(String(format: "%02d", next))"
    }

    // MARK: - Soil

    var orderedSoilMixes: [SoilMix] {
        soilMixes
            .filter(\.isActive)
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
    }

    func soilMix(id: UUID) -> SoilMix? {
        soilMixes.first { $0.id == id }
    }

    @discardableResult
    func addSoilMix(name: String, notes: String = "", parts: [SoilMixPart] = []) -> SoilMix? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let nextOrder = (soilMixes.map(\.sortOrder).max() ?? 0) + 1
        let mix = SoilMix(
            name: trimmed,
            mixDescription: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            parts: parts,
            sortOrder: nextOrder
        )
        soilMixes.append(mix)
        persistAll()
        return soilMixes.first { $0.id == mix.id }
    }

    func updateSoilMix(id: UUID, name: String, notes: String, parts: [SoilMixPart]) {
        guard let index = soilMixes.firstIndex(where: { $0.id == id }) else { return }
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        soilMixes[index].name = trimmed
        soilMixes[index].mixDescription = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        soilMixes[index].parts = parts
        persistAll()
    }

    /// Deletes a Soil Mix and clears `soilMixID` on Trees that referenced it.
    func deleteSoilMix(id: UUID) {
        guard soilMixes.contains(where: { $0.id == id }) else { return }
        soilMixes.removeAll { $0.id == id }
        for index in trees.indices where trees[index].soilMixID == id {
            trees[index].soilMixID = nil
            trees[index].modifiedDate = .now
        }
        for index in seedBatches.indices where seedBatches[index].soilMixID == id {
            seedBatches[index].soilMixID = nil
            seedBatches[index].updatedAt = .now
        }
        persistAll()
    }

    // MARK: - Inventory

    var orderedInventoryStock: [InventoryStockItem] {
        inventoryStock.sorted {
            if $0.kind.title != $1.kind.title {
                return $0.kind.title.localizedStandardCompare($1.kind.title) == .orderedAscending
            }
            return $0.name.localizedStandardCompare($1.name) == .orderedAscending
        }
    }

    /// Low stock: quantity ≤ 0, or below `minimumQuantity` when that floor is set.
    func isInventoryLowStock(_ item: InventoryStockItem) -> Bool {
        item.quantity <= 0 || item.isLowStock
    }

    var lowInventoryStock: [InventoryStockItem] {
        orderedInventoryStock.filter(isInventoryLowStock)
    }

    func inventoryItem(id: UUID) -> InventoryStockItem? {
        inventoryStock.first { $0.id == id }
    }

    /// Field New Inventory — Name + Kind + Quantity + Minimum.
    @discardableResult
    func addInventoryItem(
        name: String,
        kind: InventoryStockKind,
        quantity: Double,
        minimumQuantity: Double = 0
    ) -> InventoryStockItem? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        guard quantity >= 0, minimumQuantity >= 0 else { return nil }
        let now = Date.now
        let item = InventoryStockItem(
            kind: kind,
            name: trimmed,
            quantity: quantity,
            minimumQuantity: minimumQuantity,
            createdAt: now,
            updatedAt: now
        )
        inventoryStock.append(item)
        persistAll()
        return inventoryStock.first { $0.id == item.id }
    }

    func updateInventoryItem(
        id: UUID,
        name: String,
        kind: InventoryStockKind,
        quantity: Double,
        minimumQuantity: Double
    ) {
        guard let index = inventoryStock.firstIndex(where: { $0.id == id }) else { return }
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard quantity >= 0, minimumQuantity >= 0 else { return }
        inventoryStock[index].name = trimmed
        inventoryStock[index].kind = kind
        inventoryStock[index].quantity = quantity
        inventoryStock[index].minimumQuantity = minimumQuantity
        inventoryStock[index].updatedAt = .now
        persistAll()
    }

    /// Adjusts quantity by `delta`, floored at 0.
    func adjustInventoryQuantity(id: UUID, by delta: Double) {
        guard let index = inventoryStock.firstIndex(where: { $0.id == id }) else { return }
        inventoryStock[index].quantity = max(0, inventoryStock[index].quantity + delta)
        inventoryStock[index].updatedAt = .now
        persistAll()
    }

    func deleteInventoryItem(id: UUID) {
        guard inventoryStock.contains(where: { $0.id == id }) else { return }
        inventoryStock.removeAll { $0.id == id }
        persistAll()
    }

    private static func completesInstantly(workTypeID: UUID) -> Bool {
        workTypeID == CanonicalWorkTypeID.watering
    }

    private static func expiresIfMissed(workTypeID: UUID) -> Bool {
        workTypeID == CanonicalWorkTypeID.watering
    }

    private static func isOverdue(_ dueDate: Date, now: Date, calendar: Calendar) -> Bool {
        calendar.startOfDay(for: dueDate) < calendar.startOfDay(for: now)
    }

    private static func belongs(
        dueDate: Date,
        expiresIfMissed: Bool,
        to horizon: MobileTasksHorizon,
        now: Date,
        calendar: Calendar
    ) -> Bool {
        let overdue = isOverdue(dueDate, now: now, calendar: calendar)
        if horizon == .overdue {
            return overdue && !expiresIfMissed
        }
        if overdue {
            return false
        }
        if horizon == .nextYear {
            return calendar.component(.year, from: dueDate) > calendar.component(.year, from: now)
        }
        switch horizon {
        case .today:
            return calendar.isDateInToday(dueDate)
        case .thisWeek:
            return calendar.isDate(dueDate, equalTo: now, toGranularity: .weekOfYear)
        case .thisMonth:
            return calendar.isDate(dueDate, equalTo: now, toGranularity: .month)
        case .thisYear:
            return calendar.isDate(dueDate, equalTo: now, toGranularity: .year)
        case .overdue, .nextYear:
            return false
        }
    }

    /// True when any remaining tree already has this Bonsai Name.
    func isBonsaiNameInUse(_ name: String) -> Bool {
        let needle = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return false }
        return trees.contains {
            $0.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
                .caseInsensitiveCompare(needle) == .orderedSame
        }
    }

    /// Next official sequence for a species. Same rule as Mac: lowest unused number on remaining trees.
    func nextBonsaiNameSequence(for speciesID: UUID) -> Int {
        TreeNamingService.nextSequence(forSpecies: speciesID, existingTrees: trees)
    }

    /// Field New Tree. Bonsai Name is the Mac format, or a confirmed override.
    @discardableResult
    func createTree(
        botanicalName: String,
        nickname: String,
        bonsaiName: String,
        locationID: UUID,
        genusID: UUID? = nil,
        speciesID: UUID? = nil,
        cultivarID: UUID? = nil,
        styleID: UUID? = nil,
        sizeClassID: UUID? = nil,
        treeStageID: UUID? = nil,
        soilMixID: UUID? = nil,
        potTypeID: UUID? = nil,
        lightConditionID: UUID? = nil,
        homeLocationID: UUID? = nil,
        winterLocationID: UUID? = nil,
        placementStrategy: TreePlacementStrategy = .seasonal,
        seasonPlacement: TreeSeasonPlacement = .summer,
        propagation: TreePropagation? = nil,
        acquisitionDate: Date? = nil,
        acquisitionMethodID: UUID? = nil,
        acquisitionSourceName: String = "",
        purchasePrice: Decimal? = nil,
        acquisitionNotes: String = "",
        lastRepottedDate: Date? = nil,
        repottingIntervalYears: Int? = nil,
        heightMillimetres: Int? = nil,
        crownWidthMillimetres: Int? = nil,
        nebariWidthMillimetres: Int? = nil,
        trunkDiameterMillimetres: Int? = nil
    ) -> Tree? {
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty, !name.isEmpty else { return nil }
        guard genusID != nil, speciesID != nil else { return nil }
        guard !isBonsaiNameInUse(name) else { return nil }
        let homeID = homeLocationID ?? locationID
        guard location(id: homeID) != nil else { return nil }
        var tree = Tree(
            botanicalName: botanical,
            nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            bonsaiName: name,
            genusID: genusID,
            speciesID: speciesID,
            cultivarID: cultivarID,
            styleID: styleID,
            sizeClassID: sizeClassID,
            treeStageID: treeStageID,
            healthStatus: .stable,
            locationID: homeID,
            homeLocationID: homeID,
            winterLocationID: winterLocationID,
            soilMixID: soilMixID,
            potTypeID: potTypeID,
            lightConditionID: lightConditionID,
            heightMillimetres: heightMillimetres,
            crownWidthMillimetres: crownWidthMillimetres,
            nebariWidthMillimetres: nebariWidthMillimetres,
            trunkDiameterMillimetres: trunkDiameterMillimetres,
            propagation: propagation,
            acquisitionDate: acquisitionDate,
            acquisitionMethodID: acquisitionMethodID,
            acquisitionSourceName: acquisitionSourceName.trimmingCharacters(in: .whitespacesAndNewlines),
            purchasePrice: purchasePrice,
            acquisitionNotes: acquisitionNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            lastRepottedDate: lastRepottedDate,
            repottingIntervalYears: repottingIntervalYears,
            placementStrategy: placementStrategy,
            seasonPlacement: seasonPlacement
        )
        tree.syncStandingLocationFromPlacement()
        trees.append(tree)
        syncAutoRepottingSchedule(for: tree.id)
        persistAll()
        return trees.first { $0.id == tree.id }
    }

    /// Writes the first measurement session beside the tree, in Mac's history file.
    func appendInitialMeasurement(_ record: TreeMeasurementRecord) {
        try? store?.appendTreeMeasurement(record)
    }

    /// Appends a measurement session and updates denormalized Tree fields (Mac Enter measurements).
    func appendTreeMeasurement(
        treeID: UUID,
        measuredAt: Date,
        heightMillimetres: Int?,
        crownWidthMillimetres: Int?,
        nebariWidthMillimetres: Int?,
        trunkDiameterMillimetres: Int?
    ) {
        guard let index = trees.firstIndex(where: { $0.id == treeID }) else { return }
        let record = TreeMeasurementRecord(
            treeID: treeID,
            measuredAt: measuredAt,
            heightMillimetres: heightMillimetres,
            crownWidthMillimetres: crownWidthMillimetres,
            nebariWidthMillimetres: nebariWidthMillimetres,
            trunkDiameterMillimetres: trunkDiameterMillimetres
        )
        guard record.hasAnyValue else { return }
        if let heightMillimetres { trees[index].heightMillimetres = heightMillimetres }
        if let crownWidthMillimetres { trees[index].crownWidthMillimetres = crownWidthMillimetres }
        if let nebariWidthMillimetres { trees[index].nebariWidthMillimetres = nebariWidthMillimetres }
        if let trunkDiameterMillimetres { trees[index].trunkDiameterMillimetres = trunkDiameterMillimetres }
        trees[index].modifiedDate = .now
        try? store?.appendTreeMeasurement(record)
        persistAll()
    }

    /// Permanently removes a Tree, its photos, work, and tasks. Clears Collection membership and Find links.
    func deleteTree(id: UUID) {
        guard let index = trees.firstIndex(where: { $0.id == id }) else { return }
        let imageIDs = trees[index].imageIDs
        trees.remove(at: index)

        workRecords = workRecords.compactMap { record in
            var next = record
            next.treeIDs.removeAll { $0 == id }
            return next.treeIDs.isEmpty ? nil : next
        }
        careTasks = careTasks.compactMap { task in
            var next = task
            next.treeIDs.removeAll { $0 == id }
            let hasOtherTargets = !next.treeIDs.isEmpty
                || !next.yamadoriIDs.isEmpty
                || !next.seedBatchIDs.isEmpty
                || !next.nurseryPropagationProjectIDs.isEmpty
                || next.libraryInventoryKind != nil
            return hasOtherTargets ? next : nil
        }
        // Drop tree from schedule targets; remove schedule if no trees remain.
        careSchedules = careSchedules.compactMap { schedule in
            guard case .trees(let ids) = schedule.target, ids.contains(id) else { return schedule }
            var nextIDs = ids
            nextIDs.remove(id)
            guard !nextIDs.isEmpty else { return nil }
            var next = schedule
            next.target = .trees(nextIDs)
            next.modifiedDate = .now
            return next
        }
        for collectionIndex in collections.indices {
            collections[collectionIndex].treeIDs.removeAll { $0 == id }
        }
        for findIndex in yamadoriFinds.indices where yamadoriFinds[findIndex].linkedTreeID == id {
            yamadoriFinds[findIndex].linkedTreeID = nil
        }
        for imageID in imageIDs {
            discardImageAsset(id: imageID)
        }
        persistAll()
        refreshTodayTasksNotification()
    }

    /// Commits core editable fields; other overview fields stay as stored on the Tree.
    func updateTree(
        id: UUID,
        nickname: String,
        locationID: UUID,
        soilMixID: UUID?,
        notes: String,
        healthStatus: TreeHealthStatus,
        healthCause: String
    ) {
        guard let tree = tree(id: id) else { return }
        let membership = Set(
            collections
                .filter { $0.isManual && $0.treeIDs.contains(id) }
                .map(\.id)
        )
        updateTree(
            id: id,
            nickname: nickname,
            locationID: locationID,
            soilMixID: soilMixID,
            potTypeID: tree.potTypeID,
            lightConditionID: tree.lightConditionID,
            styleID: tree.styleID,
            sizeClassID: tree.sizeClassID,
            treeStageID: tree.treeStageID,
            propagation: tree.propagation,
            acquisitionDate: tree.acquisitionDate,
            acquisitionMethodID: tree.acquisitionMethodID,
            acquisitionSourceName: tree.acquisitionSourceName,
            purchasePrice: tree.purchasePrice,
            acquisitionNotes: tree.acquisitionNotes,
            lastRepottedDate: tree.lastRepottedDate,
            repottingIntervalYears: tree.repottingIntervalYears,
            notes: notes,
            healthStatus: healthStatus,
            healthCause: healthCause,
            manualCollectionIDs: membership
        )
    }

    /// Commits Overview editable fields (Mac Tree Detail Overview). Identity and photos unchanged.
    func updateTree(
        id: UUID,
        nickname: String,
        locationID: UUID,
        homeLocationID: UUID? = nil,
        winterLocationID: UUID? = nil,
        placementStrategy: TreePlacementStrategy? = nil,
        seasonPlacement: TreeSeasonPlacement? = nil,
        soilMixID: UUID?,
        potTypeID: UUID?,
        lightConditionID: UUID?,
        styleID: UUID?,
        sizeClassID: UUID?,
        treeStageID: UUID?,
        propagation: TreePropagation?,
        acquisitionDate: Date?,
        acquisitionMethodID: UUID?,
        acquisitionSourceName: String,
        purchasePrice: Decimal?,
        acquisitionNotes: String,
        lastRepottedDate: Date?,
        repottingIntervalYears: Int?,
        notes: String,
        healthStatus: TreeHealthStatus,
        healthCause: String,
        manualCollectionIDs: Set<UUID>
    ) {
        guard let index = trees.firstIndex(where: { $0.id == id }) else { return }
        trees[index].nickname = nickname
        trees[index].homeLocationID = homeLocationID ?? locationID
        trees[index].winterLocationID = winterLocationID
        if let placementStrategy {
            trees[index].placementStrategy = placementStrategy
        }
        if let seasonPlacement {
            trees[index].seasonPlacement = seasonPlacement
        }
        trees[index].syncStandingLocationFromPlacement()
        trees[index].soilMixID = soilMixID
        trees[index].potTypeID = potTypeID
        trees[index].lightConditionID = lightConditionID
        trees[index].styleID = styleID
        trees[index].sizeClassID = sizeClassID
        trees[index].treeStageID = treeStageID
        trees[index].propagation = propagation
        trees[index].acquisitionDate = acquisitionDate
        trees[index].acquisitionMethodID = acquisitionMethodID
        trees[index].acquisitionSourceName = acquisitionSourceName.trimmingCharacters(in: .whitespacesAndNewlines)
        trees[index].purchasePrice = purchasePrice
        trees[index].acquisitionNotes = acquisitionNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        trees[index].lastRepottedDate = lastRepottedDate
        trees[index].repottingIntervalYears = repottingIntervalYears.map { max(1, min(20, $0)) }
        trees[index].notes = notes
        trees[index].healthStatus = healthStatus
        trees[index].healthCause = healthCause.trimmingCharacters(in: .whitespacesAndNewlines)
        trees[index].modifiedDate = .now

        for collectionIndex in collections.indices where collections[collectionIndex].isManual {
            let collectionID = collections[collectionIndex].id
            let shouldBelong = manualCollectionIDs.contains(collectionID)
            let currentlyBelongs = collections[collectionIndex].treeIDs.contains(id)
            if shouldBelong, !currentlyBelongs {
                collections[collectionIndex].treeIDs.append(id)
            } else if !shouldBelong, currentlyBelongs {
                collections[collectionIndex].treeIDs.removeAll { $0 == id }
            }
        }

        syncAutoRepottingSchedule(for: id)
        persistAll()
    }

    /// Updates the full Shaping workbook for a tree (Mac Tree Detail → Shaping).
    func updateShaping(treeID: UUID, shaping: TreeShaping) {
        guard let index = trees.firstIndex(where: { $0.id == treeID }) else { return }
        trees[index].shaping = shaping
        trees[index].modifiedDate = .now
        persistAll()
    }

    /// Updates one Shaping area record.
    func updateShapingArea(treeID: UUID, area: ShapingAreaID, record: ShapingAreaRecord) {
        guard let index = trees.firstIndex(where: { $0.id == treeID }) else { return }
        var shaping = trees[index].shaping ?? .empty
        if !shaping.didMigrateVision {
            if let vision = trees[index].vision {
                shaping.migrateFromVision(vision)
            }
            shaping.didMigrateVision = true
        }
        shaping.setRecord(record, for: area)
        trees[index].shaping = shaping
        trees[index].modifiedDate = .now
        persistAll()
    }

    /// Ensures Vision→Shaping migration once, then returns current shaping.
    func shaping(for treeID: UUID) -> TreeShaping {
        guard let index = trees.firstIndex(where: { $0.id == treeID }) else { return .empty }
        var shaping = trees[index].shaping ?? .empty
        guard !shaping.didMigrateVision else { return shaping }
        if let vision = trees[index].vision {
            shaping.migrateFromVision(vision)
        }
        shaping.didMigrateVision = true
        trees[index].shaping = shaping
        trees[index].modifiedDate = .now
        persistAll()
        return shaping
    }

    // MARK: - Auto Repotting Schedule (Mac RepottingCareService)

    private static let autoRepottingTitle = "Repotting"
    private static let autoRepottingSeasonNote =
        "Repotting season is March–May. Next due is placed in that window."

    /// Create / update / remove the auto Schedule for one tree (Mac `syncSchedule(for:)`).
    func syncAutoRepottingSchedule(for treeID: UUID) {
        guard let tree = tree(id: treeID), tree.isInCare else {
            removeAutoRepottingSchedule(for: treeID)
            return
        }
        guard let interval = tree.repottingIntervalYears, interval >= 1,
              let lastRepotted = tree.lastRepottedDate
        else {
            removeAutoRepottingSchedule(for: treeID)
            return
        }

        let workTypeID = CanonicalWorkTypeID.repotting
        ensureBaselineRepottingWork(treeID: treeID, lastRepotted: lastRepotted, workTypeID: workTypeID)

        let recurrence = CareRecurrenceRule(unit: .year, interval: interval)
        if var existing = autoRepottingSchedule(for: treeID) {
            var changed = false
            if existing.recurrence.interval != interval || existing.recurrence.unit != .year {
                existing.recurrence = recurrence
                changed = true
            }
            if existing.workTypeID != workTypeID {
                existing.workTypeID = workTypeID
                changed = true
            }
            if existing.title != Self.autoRepottingTitle {
                existing.title = Self.autoRepottingTitle
                changed = true
            }
            if existing.notes != Self.autoRepottingSeasonNote {
                existing.notes = Self.autoRepottingSeasonNote
                changed = true
            }
            if !existing.isActive {
                existing.isActive = true
                changed = true
            }
            if existing.systemKind != .autoRepotting {
                existing.systemKind = .autoRepotting
                changed = true
            }
            if changed {
                existing.modifiedDate = .now
                if let index = careSchedules.firstIndex(where: { $0.id == existing.id }) {
                    careSchedules[index] = existing
                }
            }
            return
        }

        careSchedules.append(
            CareSchedule(
                title: Self.autoRepottingTitle,
                workTypeID: workTypeID,
                target: .trees(Set([treeID])),
                recurrence: recurrence,
                systemKind: .autoRepotting,
                notes: Self.autoRepottingSeasonNote
            )
        )
    }

    private func autoRepottingSchedule(for treeID: UUID) -> CareSchedule? {
        careSchedules.first { schedule in
            guard schedule.systemKind == .autoRepotting else { return false }
            if case .trees(let ids) = schedule.target {
                return ids.contains(treeID)
            }
            return false
        }
    }

    private func removeAutoRepottingSchedule(for treeID: UUID) {
        careSchedules.removeAll { schedule in
            guard schedule.systemKind == .autoRepotting else { return false }
            if case .trees(let ids) = schedule.target {
                return ids.contains(treeID)
            }
            return false
        }
    }

    private func ensureBaselineRepottingWork(treeID: UUID, lastRepotted: Date, workTypeID: UUID) {
        let calendar = Calendar.current
        if let existing = lastRepotDate(for: treeID) {
            if calendar.isDate(existing, inSameDayAs: lastRepotted) || existing > lastRepotted {
                return
            }
        }
        let record = WorkRecord(
            workTypeID: workTypeID,
            treeIDs: [treeID],
            performedAt: lastRepotted,
            notes: "Last repotted (recorded on tree)"
        )
        workRecords.insert(record, at: 0)
    }

    /// Seed batches that currently reference this Soil Mix.
    func seedBatches(usingSoilMix mixID: UUID) -> [SeedBatch] {
        orderedSeedBatches.filter { $0.soilMixID == mixID }
    }

    /// Copies this iPhone library into the shared iCloud package, then switches location preference.
    /// Caller must confirm replace when ``iCloudPackageHasTrees`` is true.
    @MainActor
    func moveLocalLibraryToICloud() async throws {
        guard let store, !store.isICloudDrive else { return }
        persistAll()
        guard let iCloud = await MobileLibraryStore.iCloudDrive() else {
            throw MobileLibraryMoveError.iCloudUnavailable
        }
        try FileManager.default.createDirectory(at: iCloud.rootURL, withIntermediateDirectories: true)
        try copyPackageContents(from: store.rootURL, to: iCloud.rootURL)
        let lease = iCloud.rootURL.appendingPathComponent(
            BonsaiWorldICloudLibrary.writerLeaseRelativePath,
            isDirectory: false
        )
        try? FileManager.default.removeItem(at: lease)
        MobileLibraryStore.locationPreference = .iCloud
        NotificationCenter.default.post(name: .bonsaiMobileLibraryLocationDidChange, object: nil)
    }

    /// Opens the shared Mac/iPhone iCloud library without uploading this phone’s local trees.
    /// Preference flips first so the session never stays on This iPhone demo after the tap.
    @MainActor
    func openSharedICloudLibrary(forceRedownloadTrees: Bool = true) async throws {
        // Flip preference before the ubiquity lookup so UI cannot keep showing local demo (3 trees).
        MobileLibraryStore.locationPreference = .iCloud
        UserDefaults.standard.removeObject(forKey: Self.lastAppliedWriterLeaseKey)
        lastAppliedWriterLeaseAt = nil
        lastCatalogDownloadAttemptAt = nil
        lastCatalogZipHealAttemptAt = nil
        catalogSyncBehindMessage = nil

        guard let iCloud = await MobileLibraryStore.iCloudDrive() else {
            // Preference is already iCloud — recreate session into waiting state, then surface the error.
            NotificationCenter.default.post(name: .bonsaiMobileLibraryLocationDidChange, object: nil)
            throw MobileLibraryMoveError.iCloudUnavailable
        }
        if forceRedownloadTrees {
            iCloud.requestFreshTreesDownload()
        }
        NotificationCenter.default.post(name: .bonsaiMobileLibraryLocationDidChange, object: nil)
    }

    /// Human-readable session state. No file contents or home-directory paths.
    var libraryStoreDiagnosticLine: String {
        guard let store else { return "No library store" }
        let preference: String
        switch MobileLibraryStore.locationPreference {
        case .iCloud: preference = "iCloud"
        case .local: preference = "This iPhone"
        case .undecided: preference = "not chosen"
        }
        let session = store.isICloudDrive ? "iCloud" : "This iPhone"
        let container = store.matchesExpectedICloudContainer ? "yes" : "no"
        let fileState: String
        switch store.treesFileState() {
        case .ready: fileState = "ready"
        case .missing: fileState = "missing"
        case .notReady: fileState = "not downloaded"
        }
        let source: String
        if Self.isDemoSampleCatalog(trees) {
            source = "demo"
        } else if trees.isEmpty {
            source = "none"
        } else if store.isICloudDrive {
            source = "iCloud"
        } else {
            source = "This iPhone"
        }
        var line =
            "Preference \(preference) · session \(session) · container \(container) · Trees.json \(fileState) · \(trees.count) loaded from \(source)"
        if let lease = store.loadWriterLeaseIfPresent(), let remote = lease.treeCount {
            line += " · Mac lease \(remote)/\(lease.myTreesCount ?? 0)"
        } else if let stamp = store.loadCatalogSyncStamp() {
            line += " · Mac stamp \(stamp.treeCount)/\(stamp.myTreesCount)"
        }
        if let catalogSyncBehindMessage {
            line += " — \(catalogSyncBehindMessage)"
        }
        return line
    }

    /// Whether the shared iCloud package already has trees (for replace confirmation).
    static func iCloudPackageHasTrees() async -> Bool {
        guard let iCloud = await MobileLibraryStore.iCloudDrive() else { return false }
        let url = iCloud.rootURL.appendingPathComponent(MobileLibraryPackageLayout.treesFileName)
        guard
            let rootObj = try? JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any],
            let trees = rootObj["trees"] as? [Any]
        else { return false }
        return !trees.isEmpty
    }

    /// Creates a dated store-method ZIP of the on-disk library package for sharing.
    func prepareLibraryExportPackage() throws -> URL {
        guard let store else {
            throw CocoaError(.fileNoSuchFile)
        }
        persistAll()
        let stamp = Date.now.formatted(.dateTime.year().month().day().hour().minute())
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: ", ", with: "_")
            .replacingOccurrences(of: " ", with: "_")
        let zipURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("Bonsai-World-iOS-\(stamp).zip", isDirectory: false)
        try MobileStoredZip.zipDirectory(store.rootURL, to: zipURL)
        return zipURL
    }

    /// Replaces the on-disk library from a ZIP archive or package folder, then reloads.
    func importLibraryPackage(from url: URL) throws {
        guard let store else {
            throw CocoaError(.fileNoSuchFile)
        }
        let fm = FileManager.default
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing { url.stopAccessingSecurityScopedResource() }
        }

        let staging = fm.temporaryDirectory
            .appendingPathComponent("bonsai-ios-import-\(UUID().uuidString)", isDirectory: true)
        defer { try? fm.removeItem(at: staging) }

        var isDirectory: ObjCBool = false
        guard fm.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            throw MobileStoredZipError.invalidArchive
        }

        if isDirectory.boolValue {
            try fm.copyItem(at: url, to: staging)
        } else if url.pathExtension.lowercased() == "zip" {
            try MobileStoredZip.unzip(url, to: staging)
        } else {
            throw MobileStoredZipError.invalidArchive
        }

        let packageRoot = try resolvePackageRoot(in: staging)
        let treesURL = packageRoot.appendingPathComponent(MobileLibraryPackageLayout.treesFileName)
        guard fm.fileExists(atPath: treesURL.path) else {
            throw MobileStoredZipError.missingTreesFile
        }

        try store.wipePackage()
        try copyPackageContents(from: packageRoot, to: store.rootURL)
        reloadFromDisk()
    }

    private func resolvePackageRoot(in staging: URL) throws -> URL {
        let fm = FileManager.default
        let direct = staging.appendingPathComponent(MobileLibraryPackageLayout.treesFileName)
        if fm.fileExists(atPath: direct.path) { return staging }
        let children = try fm.contentsOfDirectory(
            at: staging,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )
        for child in children {
            let trees = child.appendingPathComponent(MobileLibraryPackageLayout.treesFileName)
            if fm.fileExists(atPath: trees.path) { return child }
        }
        throw MobileStoredZipError.missingTreesFile
    }

    private func copyPackageContents(from sourceRoot: URL, to destinationRoot: URL) throws {
        let fm = FileManager.default
        try fm.createDirectory(at: destinationRoot, withIntermediateDirectories: true)
        let children = try fm.contentsOfDirectory(
            at: sourceRoot,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        for child in children {
            let dest = destinationRoot.appendingPathComponent(child.lastPathComponent)
            if fm.fileExists(atPath: dest.path) {
                try fm.removeItem(at: dest)
            }
            try fm.copyItem(at: child, to: dest)
        }
    }

    private func reloadFromDisk() {
        lastLoadError = nil
        lastSaveError = nil
        loadOrSeed()
        refreshTodayTasksNotification()
    }

    /// Single-writer warning when this library is on iCloud (A1 / S3).
    var foreignWriterWarningText: String? {
        store?.foreignWriterWarning()
    }

    /// Settings → Write anyway for one minute despite a foreign lease (S3).
    func allowLibraryWriteDespiteForeignLease() {
        store?.allowLibraryWriteDespiteForeignLease()
    }

    /// Updates Settings → User Profile name (Mac-compatible UserProfile.json).
    func setGrowerName(_ name: String) {
        growerName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        persistProfile()
    }

    /// Updates Settings → User Profile email.
    func setGrowerEmail(_ email: String) {
        growerEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        persistProfile()
    }

    /// Schedules or clears the daily 07:00 Today Tasks local notification.
    func refreshTodayTasksNotification() {
        MobileTodayTasksNotifier.sync(todayCount: pendingTasks(due: .today).count)
    }

    /// Wipes the **On This iPhone** library to an empty catalog. Never touches the shared iCloud library.
    func resetLibraryToEmpty() {
        MobileLibraryStore.locationPreference = .local
        let local: MobileLibraryStore
        if let store, !store.isICloudDrive {
            local = store
        } else {
            local = MobileLibraryStore.applicationSupport()
        }
        do {
            try local.wipePackage()
            try local.saveTrees([])
            try local.saveWork([])
            try local.saveCollections([])
            try local.saveTasks([])
            try local.saveSchedules([])
            lastLoadError = nil
            lastSaveError = nil
            NotificationCenter.default.post(name: .bonsaiMobileLibraryLocationDidChange, object: nil)
        } catch {
            lastLoadError = "Bonsai World could not reset the library: \(error.localizedDescription)"
            print(lastLoadError ?? "")
        }
    }

    /// Test helper — persist in-memory tree edits through the store.
    func replaceTree(_ tree: Tree) {
        guard let index = trees.firstIndex(where: { $0.id == tree.id }) else { return }
        trees[index] = tree
        persistAll()
    }

    /// Care page mutations (bags / checklists) — keeps `careTasks` file-private setter.
    func mutateCareTasks(_ body: (inout [CareTask]) -> Void) {
        body(&careTasks)
        persistAll()
        refreshTodayTasksNotification()
    }

    // MARK: - Persistence

    private func loadOrSeed() {
        guard let store else { return }
        do {
            let preferICloud = MobileLibraryStore.locationPreference == .iCloud || store.isICloudDrive
            if !store.isICloudDrive {
                try store.ensureFolderStructure()
            }
            switch store.treesFileState() {
            case .notReady:
                waitingForICloudLibrary = trees.isEmpty
                iCloudCatalogReadyToWrite = false
                store.requestFreshTreesDownload()
                startTreesCatalogLocatorIfNeeded()
                return
            case .missing where preferICloud:
                // Never seed demo into an iCloud session — wait for Mac’s Trees.json.
                waitingForICloudLibrary = trees.isEmpty
                iCloudCatalogReadyToWrite = false
                store.requestFreshTreesDownload()
                startTreesCatalogLocatorIfNeeded()
                return
            case .missing, .ready:
                waitingForICloudLibrary = false
            }
            if let loadedTrees = try store.loadTrees() {
                trees = Self.treesByRemovingUnspecifiedCultivarBonsaiNames(loadedTrees)
                if rejectDemoCatalogPresentedAsICloud(store: store) {
                    return
                }
                if store.isICloudDrive {
                    try store.ensureFolderStructure()
                }
                // Keep a valid local catalog on screen. Heal from ZIP when it is newer; never blank the UI.
                if store.isICloudDrive, isLocalCatalogBehindSyncStamp(store: store) {
                    let before = trees.count
                    if applyTreesCatalogZipHeal(store: store) {
                        print("Bonsai World: ZIP heal after load — \(before) → \(trees.count) trees")
                    } else {
                        catalogSyncBehindMessage =
                            "Catalog not updated — phone \(trees.count) trees, Mac expects \(store.expectedRemoteTreeCount() ?? 0). Waiting for TreesCatalog.zip."
                        print(catalogSyncBehindMessage ?? "")
                        store.requestFreshTreesDownload()
                    }
                }
                // Never write a rename pass into iCloud during open. persistAll runs after eligibility.
                if !store.isICloudDrive, trees != loadedTrees {
                    do {
                        try store.saveTrees(trees)
                    } catch {
                        lastLoadError = "Bonsai World could not save renamed trees: \(error.localizedDescription)"
                        print(lastLoadError ?? "")
                    }
                }
                do {
                    workRecords = try store.loadWork() ?? []
                } catch MobileLibraryStoreError.notLocal {
                    requestICloudDownload()
                } catch {
                    workRecords = []
                    lastLoadError = "Bonsai World could not load Work: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    let catalog = try store.loadImageCatalog() ?? []
                    imageAssets = Dictionary(uniqueKeysWithValues: catalog.map { ($0.id, $0) })
                } catch MobileLibraryStoreError.notLocal {
                    requestICloudDownload()
                } catch {
                    imageAssets = [:]
                    lastLoadError = "Bonsai World could not load Photos: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                imageJPEGData = [:]
                jpegOrder = []
                do {
                    collections = try store.loadCollections() ?? []
                    ensureSystemSmartCollections()
                    lastLoadError = nil
                } catch MobileLibraryStoreError.notLocal {
                    requestICloudDownload()
                } catch {
                    collections = []
                    lastLoadError = "Bonsai World could not load Collections: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loadedLocations = try store.loadLocations() {
                        locations = loadedLocations
                    } else if store.isICloudDrive {
                        locations = []
                    } else {
                        locations = CanonicalLocationID.seedLocations
                        saveSeedFileIfLocal(store: store, name: "Locations") {
                            try store.saveLocations(locations)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    locations = []
                    requestICloudDownload()
                } catch {
                    locations = []
                    lastLoadError = "Bonsai World could not load Locations: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loadedGardens = try store.loadGardens() {
                        gardens = loadedGardens
                        ensureOneDefaultGarden()
                    } else if store.isICloudDrive {
                        gardens = []
                    } else {
                        gardens = Garden.seedCatalog
                        saveSeedFileIfLocal(store: store, name: "Gardens") {
                            try store.saveGardens(gardens)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    gardens = []
                    requestICloudDownload()
                } catch {
                    gardens = []
                    lastLoadError = "Bonsai World could not load Gardens: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loadedTasks = try store.loadTasks() {
                        careTasks = loadedTasks
                    } else if store.isICloudDrive {
                        careTasks = []
                    } else {
                        careTasks = Self.sampleTasks(for: trees)
                        saveSeedFileIfLocal(store: store, name: "Tasks") {
                            try store.saveTasks(careTasks)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    careTasks = []
                    requestICloudDownload()
                } catch {
                    careTasks = []
                    lastLoadError = "Bonsai World could not load Tasks: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    careSchedules = try store.loadSchedules() ?? []
                } catch MobileLibraryStoreError.notLocal {
                    requestICloudDownload()
                } catch {
                    careSchedules = []
                    lastLoadError = "Bonsai World could not load Schedules: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadYamadori() {
                        yamadoriTrips = loaded.trips
                        yamadoriFinds = loaded.finds
                    } else if store.isICloudDrive {
                        yamadoriTrips = []
                        yamadoriFinds = []
                    } else {
                        yamadoriTrips = []
                        yamadoriFinds = []
                        saveSeedFileIfLocal(store: store, name: "Yamadori") {
                            try store.saveYamadori(trips: yamadoriTrips, finds: yamadoriFinds)
                        }
                    }
                } catch {
                    yamadoriTrips = []
                    yamadoriFinds = []
                    lastLoadError = "Bonsai World could not load Yamadori: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadSeedBatches() {
                        seedBatches = loaded
                    } else if store.isICloudDrive {
                        seedBatches = []
                        requestICloudDownload()
                    } else {
                        seedBatches = []
                        saveSeedFileIfLocal(store: store, name: "Seed Batches") {
                            try store.saveSeedBatches(seedBatches)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    seedBatches = []
                    requestICloudDownload()
                } catch {
                    seedBatches = []
                    lastLoadError = "Bonsai World could not load Seed Batches: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadSoilMixes(), !loaded.isEmpty {
                        soilMixes = loaded
                    } else if store.isICloudDrive {
                        soilMixes = []
                    } else {
                        soilMixes = SoilMixCatalogSeed.all
                        saveSeedFileIfLocal(store: store, name: "Soil Mixes") {
                            try store.saveSoilMixes(soilMixes)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    soilMixes = []
                    requestICloudDownload()
                } catch {
                    soilMixes = store.isICloudDrive ? [] : SoilMixCatalogSeed.all
                    lastLoadError = "Bonsai World could not load Soil Mixes: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadReferenceCatalog() {
                        referenceCatalog = loaded
                    } else if store.isICloudDrive {
                        referenceCatalog = .seededFromPreview()
                    } else {
                        referenceCatalog = .seededFromPreview()
                        saveSeedFileIfLocal(store: store, name: "Reference Data") {
                            try store.saveReferenceCatalog(referenceCatalog)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    referenceCatalog = .seededFromPreview()
                    requestICloudDownload()
                } catch {
                    referenceCatalog = .seededFromPreview()
                    lastLoadError = "Bonsai World could not load Reference Data: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadInventoryStock() {
                        inventoryStock = loaded
                    } else if store.isICloudDrive {
                        inventoryStock = []
                    } else {
                        inventoryStock = []
                        saveSeedFileIfLocal(store: store, name: "Inventory") {
                            try store.saveInventoryStock(inventoryStock)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    inventoryStock = []
                    requestICloudDownload()
                } catch {
                    inventoryStock = []
                    lastLoadError = "Bonsai World could not load Inventory: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadPots() {
                        pots = loaded
                    } else if store.isICloudDrive {
                        pots = []
                    } else {
                        pots = []
                        saveSeedFileIfLocal(store: store, name: "Pots") {
                            try store.savePots(pots)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    pots = []
                    requestICloudDownload()
                } catch {
                    pots = []
                    lastLoadError = "Bonsai World could not load Pots: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadNurseryPropagationProjects() {
                        nurseryPropagationProjects = loaded
                    } else if store.isICloudDrive {
                        nurseryPropagationProjects = []
                    } else {
                        nurseryPropagationProjects = []
                        saveSeedFileIfLocal(store: store, name: "Nursery Propagation") {
                            try store.saveNurseryPropagationProjects(nurseryPropagationProjects)
                        }
                    }
                } catch MobileLibraryStoreError.notLocal {
                    nurseryPropagationProjects = []
                    requestICloudDownload()
                } catch {
                    nurseryPropagationProjects = []
                    lastLoadError = "Bonsai World could not load Nursery Propagation: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                loadOrSeedPotBrands(store: store)
                do {
                    if let profile = try store.loadUserProfile() {
                        growerName = profile.name
                        growerEmail = profile.email
                    }
                } catch {
                    // Keep in-memory profile if file is corrupt.
                }
                syncSpeciesCare()
                refreshTodayTasksNotification()
            } else if preferICloud {
                // Missing Trees.json on iCloud — wait. Never seed trees into the shared library.
                waitingForICloudLibrary = trees.isEmpty
                iCloudCatalogReadyToWrite = false
                store.requestFreshTreesDownload()
                print("Bonsai World: iCloud Trees.json missing — waiting (will not seed)")
                return
            } else {
                trees = []
                workRecords = []
                collections = []
                locations = CanonicalLocationID.seedLocations
                gardens = Garden.seedCatalog
                careTasks = []
                careSchedules = []
                yamadoriTrips = []
                yamadoriFinds = []
                seedBatches = []
                soilMixes = []
                inventoryStock = []
                pots = []
                nurseryPropagationProjects = []
                potBrands = PotBrandPreviewData.all
                potMakers = PotBrandPreviewData.makers
                potBrandsSeedVersion = PotBrandPreviewData.seedVersion
                imageAssets = [:]
                imageJPEGData = [:]
                ensureSystemSmartCollections()
                persistAll()
                syncSpeciesCare()
                refreshTodayTasksNotification()
            }
        } catch MobileLibraryStoreError.notLocal {
            waitingForICloudLibrary = trees.isEmpty
            iCloudCatalogReadyToWrite = false
            store.requestFreshTreesDownload()
            return
        } catch {
            let message = "Bonsai World could not load the local library: \(error.localizedDescription)"
            lastLoadError = message
            print(message)
            trees = []
            workRecords = []
            collections = []
            locations = []
            gardens = []
            careTasks = []
            careSchedules = []
            yamadoriTrips = []
            yamadoriFinds = []
            seedBatches = []
            soilMixes = []
            inventoryStock = []
            pots = []
            nurseryPropagationProjects = []
            potBrands = []
            potMakers = []
            imageAssets = [:]
            imageJPEGData = [:]
        }
        loadedContentStamp = libraryContentStamp()
        updateICloudWriteEligibility(store: store)
        // Only mark Mac lease applied when local count is not behind stamp/lease.
        if !waitingForICloudLibrary, !isLocalCatalogBehindSyncStamp(store: store) {
            if let lease = store.loadWriterLeaseIfPresent() {
                rememberAppliedWriterLease(lease.updatedAt)
            }
            print("Bonsai World: loaded \(trees.count) trees (myTrees \(myTrees.count), iCloud=\(store.isICloudDrive))")
        } else if store.isICloudDrive, isLocalCatalogBehindSyncStamp(store: store) {
            print(
                "Bonsai World: load incomplete — phone \(trees.count) trees, Mac expects \(store.expectedRemoteTreeCount() ?? 0)"
            )
        }
        if !waitingForICloudLibrary, !imageAssets.isEmpty {
            startDerivativeBackfillIfNeeded()
        }
    }

    /// Loads Pot Brands & Makers; seeds curated catalog when missing or outdated (Mac migration rules).
    /// iCloud: never write during open — missing files stay empty until they download.
    private func loadOrSeedPotBrands(store: MobileLibraryStore) {
        do {
            if let loaded = try store.loadPotBrandsAndMakers() {
                let existingVersion = loaded.seedVersion ?? 0
                let target = PotBrandPreviewData.seedVersion
                if existingVersion >= target || store.isICloudDrive {
                    potBrands = loaded.brands
                    potMakers = loaded.makers
                    potBrandsSeedVersion = loaded.seedVersion
                    return
                }
                let userBrands = loaded.brands.filter { !$0.isSystemSeed }
                let userMakers = loaded.makers.filter { !$0.isSystemSeed }
                var mergedBrands = PotBrandPreviewData.all
                var mergedMakers = PotBrandPreviewData.makers
                let seedBrandIDs = Set(mergedBrands.map(\.id))
                let seedMakerIDs = Set(mergedMakers.map(\.id))
                for brand in userBrands where !seedBrandIDs.contains(brand.id) {
                    mergedBrands.append(brand)
                }
                for maker in userMakers where !seedMakerIDs.contains(maker.id) {
                    if let brandID = maker.brandID {
                        if mergedBrands.contains(where: { $0.id == brandID }) {
                            mergedMakers.append(maker)
                        }
                    } else {
                        mergedMakers.append(maker)
                    }
                }
                potBrands = mergedBrands
                potMakers = mergedMakers
                potBrandsSeedVersion = target
                try store.savePotBrandsAndMakers(
                    brands: potBrands,
                    makers: potMakers,
                    seedVersion: target
                )
            } else if store.isICloudDrive {
                potBrands = []
                potMakers = []
                potBrandsSeedVersion = nil
            } else {
                potBrands = PotBrandPreviewData.all
                potMakers = PotBrandPreviewData.makers
                potBrandsSeedVersion = PotBrandPreviewData.seedVersion
                try store.savePotBrandsAndMakers(
                    brands: potBrands,
                    makers: potMakers,
                    seedVersion: potBrandsSeedVersion
                )
            }
        } catch MobileLibraryStoreError.notLocal {
            potBrands = []
            potMakers = []
            potBrandsSeedVersion = nil
            requestICloudDownload()
        } catch {
            potBrands = store.isICloudDrive ? [] : PotBrandPreviewData.all
            potMakers = store.isICloudDrive ? [] : PotBrandPreviewData.makers
            potBrandsSeedVersion = store.isICloudDrive ? nil : PotBrandPreviewData.seedVersion
            lastLoadError = "Bonsai World could not load Pot Brands & Makers: \(error.localizedDescription)"
            print(lastLoadError ?? "")
        }
    }

    /// Re-reads the library when Mac (or iCloud) has written newer files.
    func refreshFromDiskIfChanged() {
        pullSharedLibraryFromCloud(forceReload: false)
    }

    /// Foreground / stalled-iCloud entry — ask bird for Trees.json and reload when the catalog stamp moves.
    func pullSharedLibraryFromCloud(forceReload: Bool = true) {
        guard let store else { return }

        // Preference says iCloud but this session still has the local package — cannot see Mac.
        if MobileLibraryStore.locationPreference == .iCloud, !store.isICloudDrive {
            if Self.isDemoSampleCatalog(trees) {
                trees = []
            }
            waitingForICloudLibrary = trees.isEmpty
            catalogSyncBehindMessage = "Preference is iCloud but this session is still On This iPhone"
            print("Bonsai World: preference is iCloud but store is local — skipping local poll (\(trees.count) trees)")
            return
        }

        if waitingForICloudLibrary {
            loadOrSeed()
            if waitingForICloudLibrary {
                startTreesCatalogLocatorIfNeeded()
                requestICloudDownload()
                store.requestFreshTreesDownload()
                return
            }
            treesCatalogLocator?.stop()
            rescheduleLibraryRefresh()
            updateCatalogSyncBehindState(store: store)
        }
        promoteDownloadedImages()
        if let until = suppressRefreshUntil, Date() < until {
            loadedContentStamp = libraryContentStamp()
            return
        }

        requestICloudDownload()
        CloudDownload.forceRequest(store.url(for: MobileLibraryPackageLayout.catalogSyncStampFileName))
        CloudDownload.forceRequest(store.url(for: MobileLibraryPackageLayout.treesCatalogZipFileName))

        let behindStamp = isLocalCatalogBehindSyncStamp(store: store)

        if store.isICloudDrive, behindStamp {
            if applyTreesCatalogZipHeal(store: store) {
                updateCatalogSyncBehindState(store: store)
                updateICloudWriteEligibility(store: store)
            } else {
                requestCatalogDownloadThrottled(store: store)
                updateCatalogSyncBehindState(store: store)
            }
        }

        if store.isICloudDrive {
            reconcileForeignWriterLease(store: store)
        }
        let stamp = libraryContentStamp()
        guard let stamp else { return }
        if forceReload || stamp != loadedContentStamp {
            reloadFromDisk()
            print("Bonsai World: library reload — \(trees.count) trees (myTrees \(myTrees.count))")
        }
        updateCatalogSyncBehindState(store: store)
    }

    private func isLocalCatalogBehindSyncStamp(store: MobileLibraryStore) -> Bool {
        if let remote = store.loadCatalogSyncStamp(),
           remote.isLocalCatalogBehind(localTreeCount: trees.count) {
            return true
        }
        if let lease = store.loadWriterLeaseIfPresent(),
           lease.isLocalCatalogBehind(localTreeCount: trees.count) {
            return true
        }
        return false
    }

    /// Applies `Database/TreesCatalog.zip` when it carries a catalog that matches Mac stamp/lease.
    @discardableResult
    private func applyTreesCatalogZipHeal(store: MobileLibraryStore) -> Bool {
        let now = Date()
        if let last = lastCatalogZipHealAttemptAt, now.timeIntervalSince(last) < 4 {
            CloudDownload.forceRequest(store.url(for: MobileLibraryPackageLayout.treesCatalogZipFileName))
            return false
        }
        lastCatalogZipHealAttemptAt = now
        let expected = store.expectedRemoteTreeCount() ?? (trees.count + 3)
        do {
            guard let zipTreesJSON = try store.loadTreesJSONFromCatalogZip() else {
                CloudDownload.forceRequest(store.url(for: MobileLibraryPackageLayout.treesCatalogZipFileName))
                return false
            }
            let healed = try store.replaceTreesJSONFromCatalogHeal(
                zipTreesJSON,
                minimumTreeCount: expected,
                currentLocalCount: trees.count
            )
            trees = Self.treesByRemovingUnspecifiedCultivarBonsaiNames(healed)
            waitingForICloudLibrary = false
            loadedContentStamp = libraryContentStamp()
            if let lease = store.loadWriterLeaseIfPresent() {
                rememberAppliedWriterLease(lease.updatedAt)
            }
            catalogSyncBehindMessage = nil
            updateICloudWriteEligibility(store: store)
            print("Bonsai World: applied TreesCatalog.zip — \(trees.count) trees (expect ≥ \(expected))")
            return !isLocalCatalogBehindSyncStamp(store: store)
        } catch MobileLibraryStoreError.notLocal {
            CloudDownload.forceRequest(store.url(for: MobileLibraryPackageLayout.treesCatalogZipFileName))
            return false
        } catch {
            print("Bonsai World: TreesCatalog.zip heal failed — \(error.localizedDescription)")
            CloudDownload.forceRequest(store.url(for: MobileLibraryPackageLayout.treesCatalogZipFileName))
            return false
        }
    }

    private func updateCatalogSyncBehindState(store: MobileLibraryStore) {
        guard store.isICloudDrive else { return }
        if let remote = store.loadCatalogSyncStamp(),
           remote.isLocalCatalogBehind(localTreeCount: trees.count) {
            catalogSyncBehindMessage =
                "Catalog not updated — phone \(trees.count) trees, Mac stamp \(remote.treeCount) (\(remote.deviceName)). Healing via TreesCatalog.zip…"
            return
        }
        if let lease = store.loadWriterLeaseIfPresent(),
           lease.isLocalCatalogBehind(localTreeCount: trees.count) {
            catalogSyncBehindMessage =
                "Catalog not updated — phone \(trees.count) trees, Mac lease \(lease.treeCount ?? 0) (\(lease.deviceName)). Healing via TreesCatalog.zip…"
            return
        }
        catalogSyncBehindMessage = nil
    }

    /// When Mac touched the lease, request a download of Trees.json without evicting the local catalog.
    @discardableResult
    private func reconcileForeignWriterLease(store: MobileLibraryStore) -> Bool {
        guard let lease = store.loadWriterLeaseIfPresent() else { return false }
        let localName = UIDevice.current.name
        guard lease.deviceName != localName else { return false }
        let previous = lastAppliedWriterLeaseAt ?? .distantPast
        guard lease.updatedAt > previous else { return false }
        print("Bonsai World: Mac lease newer (\(lease.deviceName) @ \(lease.updatedAt)) — requesting Trees.json from iCloud (keeping \(trees.count) trees on screen).")
        requestCatalogDownloadThrottled(store: store)
        return true
    }

    private func requestCatalogDownloadThrottled(store: MobileLibraryStore) {
        let now = Date()
        if let last = lastCatalogDownloadAttemptAt, now.timeIntervalSince(last) < 12 {
            CloudDownload.forceRequest(store.url(for: MobileLibraryPackageLayout.treesCatalogZipFileName))
            return
        }
        lastCatalogDownloadAttemptAt = now
        store.requestFreshTreesDownload()
    }

    private func updateICloudWriteEligibility(store: MobileLibraryStore) {
        guard store.isICloudDrive else {
            iCloudCatalogReadyToWrite = true
            return
        }
        iCloudCatalogReadyToWrite =
            store.treesFileState() == .ready
            && !trees.isEmpty
            && !isLocalCatalogBehindSyncStamp(store: store)
    }

    private func saveSeedFileIfLocal(
        store: MobileLibraryStore,
        name: String,
        _ body: () throws -> Void
    ) {
        guard !store.isICloudDrive else { return }
        do {
            try body()
        } catch {
            lastLoadError = "Bonsai World could not save \(name): \(error.localizedDescription)"
            print(lastLoadError ?? "")
        }
    }

    private static func storedLastAppliedWriterLeaseAt() -> Date? {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: lastAppliedWriterLeaseKey) != nil else { return nil }
        return Date(timeIntervalSinceReferenceDate: defaults.double(forKey: lastAppliedWriterLeaseKey))
    }

    private func rememberAppliedWriterLease(_ date: Date) {
        let previous = lastAppliedWriterLeaseAt ?? .distantPast
        guard date > previous else { return }
        lastAppliedWriterLeaseAt = date
        UserDefaults.standard.set(date.timeIntervalSinceReferenceDate, forKey: Self.lastAppliedWriterLeaseKey)
    }

    private func startLibraryRefresh() {
        guard store != nil else { return }
        // 3s while waiting for iCloud Trees.json; otherwise 12s to cut getattrlist / bird spam.
        let interval: TimeInterval = waitingForICloudLibrary ? 3 : 12
        let timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.refreshFromDiskIfChanged()
        }
        RunLoop.main.add(timer, forMode: .common)
        refreshTimer = timer
    }

    private func rescheduleLibraryRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
        startLibraryRefresh()
    }

    var isUsingICloudDrive: Bool {
        store?.isICloudDrive == true
    }

    /// Standardized iCloud package path for this session. Nil when the store is local.
    var iCloudLibraryRootPath: String? {
        guard let store, store.isICloudDrive else { return nil }
        return store.rootURL.standardizedFileURL.path
    }

    private func startTreesCatalogLocatorIfNeeded() {
        guard store?.isICloudDrive == true, waitingForICloudLibrary else { return }
        if treesCatalogLocator == nil {
            let locator = ICloudTreesCatalogLocator()
            locator.onFoundTreesFile = { [weak self] url in
                DispatchQueue.main.async {
                    self?.handleDiscoveredTreesFile(url)
                }
            }
            treesCatalogLocator = locator
        }
        DispatchQueue.main.async { [weak self] in
            self?.treesCatalogLocator?.start()
        }
        Task.detached(priority: .utility) {
            _ = await BonsaiWorldICloudLibrary.resolveLibraryRootURL(timeout: 60)
        }
    }

    private func handleDiscoveredTreesFile(_ treesURL: URL) {
        guard let root = BonsaiWorldICloudLibrary.libraryRoot(containingTreesFile: treesURL) else { return }
        BonsaiWorldICloudLibrary.rememberLibraryRootURL(root)
        CloudDownload.requestLibraryMaterialize(libraryRoot: root)
        guard let store else { return }
        if store.rootURL.standardizedFileURL.path != root.standardizedFileURL.path {
            print("Bonsai World: metadata query root differs from session — reopening iCloud store")
            NotificationCenter.default.post(name: .bonsaiMobileLibraryLocationDidChange, object: nil)
            return
        }
        store.requestFreshTreesDownload()
        loadOrSeed()
        if !waitingForICloudLibrary {
            treesCatalogLocator?.stop()
        }
    }

    private func requestICloudDownload() {
        guard let store, store.isICloudDrive else { return }
        // Must not call startDownloadingUbiquitousItem on the main timer — Simulator XPC hangs the UI.
        CloudDownload.requestLibraryMaterialize(libraryRoot: store.rootURL)
        CloudDownload.requestFolders(
            under: store.rootURL,
            relativeFolders: [
                "Database",
                "Images",
                MobileLibraryPackageLayout.imagesOriginals,
                MobileLibraryPackageLayout.imagesThumbnails,
                MobileLibraryPackageLayout.imagesPreviews
            ]
        )
    }

    /// mtime + fileSize (+ lease) so a replaced Trees.json is detected even when bird is slow to bump dates alone.
    private func libraryContentStamp() -> String? {
        guard let store else { return nil }
        let names = [
            MobileLibraryPackageLayout.treesFileName,
            MobileLibraryPackageLayout.catalogSyncStampFileName,
            MobileLibraryPackageLayout.treesCatalogZipFileName,
            BonsaiWorldICloudLibrary.writerLeaseRelativePath,
            MobileLibraryPackageLayout.workFileName,
            MobileLibraryPackageLayout.collectionsFileName,
            MobileLibraryPackageLayout.locationsFileName,
            MobileLibraryPackageLayout.gardensFileName,
            MobileLibraryPackageLayout.tasksFileName,
            MobileLibraryPackageLayout.schedulesFileName,
            MobileLibraryPackageLayout.yamadoriFileName,
            MobileLibraryPackageLayout.seedBatchesFileName,
            MobileLibraryPackageLayout.soilMixesFileName,
            MobileLibraryPackageLayout.inventoryStockFileName,
            MobileLibraryPackageLayout.potsFileName,
            MobileLibraryPackageLayout.nurseryPropagationProjectsFileName,
            MobileLibraryPackageLayout.potBrandsFileName,
            MobileLibraryPackageLayout.imagesCatalogFileName,
            MobileLibraryPackageLayout.userProfileFileName,
            MobileLibraryPackageLayout.treeMeasurementHistoryFileName
        ]
        var parts: [String] = []
        for name in names {
            let url = store.url(for: name)
            let values = try? url.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey])
            let mtime = values?.contentModificationDate.map { String($0.timeIntervalSinceReferenceDate) } ?? "-"
            let size = values?.fileSize.map(String.init) ?? "-"
            parts.append("\(name):\(mtime):\(size)")
        }
        return parts.joined(separator: "|")
    }

    private func noteLocalWrite() {
        suppressRefreshUntil = Date().addingTimeInterval(2)
        loadedContentStamp = libraryContentStamp()
    }

    /// Ensures system Smart Collection placeholders exist (same catalog as Mac).
    /// Does not evaluate filter rules. Preserves any existing treeIDs on match.
    private func ensureSystemSmartCollections() {
        let existingByID = Dictionary(uniqueKeysWithValues: collections.map { ($0.id, $0) })
        var changed = false

        for placeholder in SystemSmartCollections.makeCollections() {
            if var existing = existingByID[placeholder.id] {
                let needsUpgrade =
                    existing.type != .smart
                    || existing.name != placeholder.name
                    || existing.smartDefinition == nil
                guard needsUpgrade else { continue }
                existing.type = .smart
                existing.name = placeholder.name
                existing.description = placeholder.description
                existing.icon = placeholder.icon
                existing.color = placeholder.color
                if existing.smartDefinition == nil {
                    existing.smartDefinition = SmartCollectionDefinition()
                }
                if let index = collections.firstIndex(where: { $0.id == existing.id }) {
                    collections[index] = existing
                }
                changed = true
            } else {
                collections.append(placeholder)
                changed = true
            }
        }

        if changed, store != nil {
            do {
                try store?.saveCollections(collections)
                lastSaveError = nil
            } catch {
                reportSaveFailure(error)
            }
        }
    }

    private func persistPhoto(_ asset: ImageAsset, jpegData: Data) {
        guard let store else { return }
        do {
            try store.saveImageData(jpegData, relativePath: asset.relativePath)
            if let thumb = MobileImageDerivativeEncoder.jpegData(from: jpegData, kind: .thumbnail) {
                try? store.saveImageData(
                    thumb,
                    relativePath: MobileImageDerivativeKind.thumbnail.relativePath(id: asset.id)
                )
            }
            if let preview = MobileImageDerivativeEncoder.jpegData(from: jpegData, kind: .preview) {
                try? store.saveImageData(
                    preview,
                    relativePath: MobileImageDerivativeKind.preview.relativePath(id: asset.id)
                )
            }
            lastSaveError = nil
        } catch {
            reportSaveFailure(error)
            return
        }
        persistAll()
    }

    private func persistCatalogAndTrees() {
        persistAll()
    }

    private func persistAll() {
        guard let store else { return }
        if store.isICloudDrive, Self.isDemoSampleCatalog(trees) {
            lastSaveError = "Demo catalog was not saved to iCloud."
            print(lastSaveError ?? "")
            return
        }
        if store.isICloudDrive, !iCloudCatalogReadyToWrite {
            lastSaveError = "Bonsai World is still opening the shared iCloud library. Changes were not saved."
            print(lastSaveError ?? "")
            return
        }
        do {
            try store.saveTrees(trees)
            try persistIfResident(store, MobileLibraryPackageLayout.workFileName) {
                try store.saveWork(workRecords)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.collectionsFileName) {
                try store.saveCollections(collections)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.locationsFileName) {
                try store.saveLocations(locations)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.gardensFileName) {
                try store.saveGardens(gardens)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.tasksFileName) {
                try store.saveTasks(careTasks)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.schedulesFileName) {
                try store.saveSchedules(careSchedules)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.yamadoriFileName) {
                try store.saveYamadori(trips: yamadoriTrips, finds: yamadoriFinds)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.seedBatchesFileName) {
                try store.saveSeedBatches(seedBatches)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.soilMixesFileName) {
                try store.saveSoilMixes(soilMixes)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.referenceCatalogFileName) {
                try store.saveReferenceCatalog(referenceCatalog)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.inventoryStockFileName) {
                try store.saveInventoryStock(inventoryStock)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.potsFileName) {
                try store.savePots(pots)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.nurseryPropagationProjectsFileName) {
                try store.saveNurseryPropagationProjects(nurseryPropagationProjects)
            }
            try persistIfResident(store, MobileLibraryPackageLayout.potBrandsFileName) {
                try store.savePotBrandsAndMakers(
                    brands: potBrands,
                    makers: potMakers,
                    seedVersion: potBrandsSeedVersion ?? PotBrandPreviewData.seedVersion
                )
            }
            try persistIfResident(store, MobileLibraryPackageLayout.imagesCatalogFileName) {
                try store.saveImageCatalog(Array(imageAssets.values))
            }
            try persistIfResident(store, MobileLibraryPackageLayout.userProfileFileName) {
                try store.saveUserProfile(MobileUserProfileFile(name: growerName, email: growerEmail))
            }
            lastSaveError = nil
            noteLocalWrite()
        } catch {
            reportSaveFailure(error)
        }
    }

    private func persistIfResident(
        _ store: MobileLibraryStore,
        _ relativePath: String,
        _ body: () throws -> Void
    ) throws {
        if store.isICloudDrive {
            switch store.packageFileState(relativePath: relativePath) {
            case .ready:
                break
            case .missing, .notReady:
                return
            }
        }
        try body()
    }

    private func persistProfile() {
        guard let store else { return }
        if store.isICloudDrive, !iCloudCatalogReadyToWrite {
            lastSaveError = "Bonsai World is still opening the shared iCloud library. Changes were not saved."
            print(lastSaveError ?? "")
            return
        }
        do {
            try persistIfResident(store, MobileLibraryPackageLayout.userProfileFileName) {
                try store.saveUserProfile(MobileUserProfileFile(name: growerName, email: growerEmail))
            }
            lastSaveError = nil
        } catch {
            reportSaveFailure(error)
        }
    }

    private func reportSaveFailure(_ error: Error) {
        let message = "Bonsai World could not save the local library: \(error.localizedDescription)"
        lastSaveError = message
        print(message)
    }

    // MARK: - Sample data

    private static let mapleID = UUID(uuidString: "B2000000-0000-4000-8000-000000000001")!
    private static let juniperID = UUID(uuidString: "B2000000-0000-4000-8000-000000000002")!
    private static let pineID = UUID(uuidString: "B2000000-0000-4000-8000-000000000003")!

    static let sampleTreeIDs: Set<UUID> = [mapleID, juniperID, pineID]

    /// True only for the built-in 3-tree demo set (fixed IDs). A grower’s 3-tree library is not this.
    static func isDemoSampleCatalog(_ trees: [Tree]) -> Bool {
        Set(trees.map(\.id)) == sampleTreeIDs
    }

    /// iCloud selection must not present demo trees as the shared Mac catalog.
    @discardableResult
    private func rejectDemoCatalogPresentedAsICloud(store: MobileLibraryStore) -> Bool {
        let preferICloud = MobileLibraryStore.locationPreference == .iCloud || store.isICloudDrive
        guard preferICloud, Self.isDemoSampleCatalog(trees) else { return false }
        print("Bonsai World: iCloud session loaded demo sample catalog — not presenting as shared library")
        trees = []
        waitingForICloudLibrary = true
        iCloudCatalogReadyToWrite = false
        catalogSyncBehindMessage =
            "iCloud session still has demo data — waiting for Mac library"
        lastLoadError = catalogSyncBehindMessage
        if store.isICloudDrive {
            store.evictLocalDemoTreesFileIfPresent()
            store.requestFreshTreesDownload()
            startTreesCatalogLocatorIfNeeded()
        }
        return true
    }

    static let sampleTrees: [Tree] = [
        Tree(
            id: mapleID,
            botanicalName: "Acer palmatum",
            nickname: "Terrace Maple",
            bonsaiName: "ACE-PAL-2020-001",
            healthStatus: .thriving,
            locationID: CanonicalLocationID.altan,
            notes: "Demo tree — refinement stage. Water when the surface starts to dry."
        ),
        Tree(
            id: juniperID,
            botanicalName: "Juniperus chinensis",
            nickname: "Garden Juniper",
            bonsaiName: "JUN-CHI-2018-014",
            healthStatus: .stable,
            locationID: CanonicalLocationID.altan,
            notes: "Demo tree — structural wiring planned for autumn."
        ),
        Tree(
            id: pineID,
            botanicalName: "Pinus sylvestris",
            nickname: "",
            bonsaiName: "PIN-SYL-2015-003",
            healthStatus: .needsAttention,
            locationID: CanonicalLocationID.altan,
            notes: "Demo tree — candle work next spring."
        )
    ]

    static func sampleWork(for trees: [Tree]) -> [WorkRecord] {
        guard let maple = trees.first(where: { $0.id == mapleID }),
              let juniper = trees.first(where: { $0.id == juniperID })
        else { return [] }

        let day: TimeInterval = 24 * 60 * 60
        return [
            WorkRecord(
                workTypeID: CanonicalWorkTypeID.watering,
                treeIDs: [maple.id],
                performedAt: Date().addingTimeInterval(-1 * day),
                notes: "Morning watering."
            ),
            WorkRecord(
                workTypeID: CanonicalWorkTypeID.branchPruning,
                treeIDs: [maple.id],
                performedAt: Date().addingTimeInterval(-12 * day),
                notes: "Light tip prune."
            ),
            WorkRecord(
                workTypeID: CanonicalWorkTypeID.fertilizing,
                treeIDs: [juniper.id],
                performedAt: Date().addingTimeInterval(-5 * day),
                notes: "Organic pellets."
            )
        ]
    }

    /// Demo field Tasks — Overdue + Today so Complete is usable before New Task.
    static func sampleTasks(for trees: [Tree]) -> [CareTask] {
        guard let maple = trees.first(where: { $0.id == mapleID }),
              let juniper = trees.first(where: { $0.id == juniperID }),
              let pine = trees.first(where: { $0.id == pineID })
        else { return [] }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let overdue = calendar.date(byAdding: .day, value: -2, to: today) ?? today.addingTimeInterval(-2 * 24 * 60 * 60)

        return [
            CareTask(
                title: "Water Terrace Maple",
                workTypeID: CanonicalWorkTypeID.watering,
                treeIDs: [maple.id],
                dueDate: today
            ),
            CareTask(
                title: "Fertilize Garden Juniper",
                workTypeID: CanonicalWorkTypeID.fertilizing,
                treeIDs: [juniper.id],
                dueDate: overdue
            ),
            CareTask(
                title: "Check Scots Pine",
                workTypeID: CanonicalWorkTypeID.repotting,
                treeIDs: [pine.id],
                dueDate: today,
                notes: "Assess root health before spring."
            )
        ]
    }
    /// Legacy `GEN-SPE-XXX-YYYY-NNN` → `GEN-SPE-YYYY-NNN`.
    private static func treesByRemovingUnspecifiedCultivarBonsaiNames(_ trees: [Tree]) -> [Tree] {
        trees.map { tree in
            guard let rewritten = TreeNamingService.bonsaiNameByRemovingUnspecifiedCultivar(tree.bonsaiName)
            else { return tree }
            var copy = tree
            copy.bonsaiName = rewritten
            return copy
        }
    }
}

enum MobileTreePresentation {
    static func title(for tree: Tree) -> String {
        let nick = trimmed(tree.nickname)
        if !nick.isEmpty { return nick }
        let botanical = trimmed(tree.botanicalName)
        if !botanical.isEmpty { return botanical }
        let code = trimmed(tree.bonsaiName)
        return code.isEmpty ? "Untitled Tree" : code
    }

    static func botanicalLine(for tree: Tree) -> String {
        trimmed(tree.botanicalName)
    }

    static func bonsaiNameLine(for tree: Tree) -> String {
        trimmed(tree.bonsaiName)
    }

    static func subtitle(for tree: Tree) -> String {
        let botanical = botanicalLine(for: tree)
        if title(for: tree) != botanical, !botanical.isEmpty {
            return botanical
        }
        return bonsaiNameLine(for: tree)
    }

    private static func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
