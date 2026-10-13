//
//  DemoLibrary.swift
//  Bonsai World
//
//  Mobile facade over the canonical Tree / WorkRecord / ImageAsset models.
//  Persists through MobileLibraryStore (iOS Application Support). Session-only
//  when constructed with `preview` for SwiftUI canvases.
//

import Foundation
import Observation

@Observable
final class DemoLibrary: @unchecked Sendable {
    private let store: MobileLibraryStore?

    private(set) var trees: [Tree]
    private(set) var workRecords: [WorkRecord]
    private(set) var collections: [Collection]
    private(set) var locations: [Location]
    private(set) var gardens: [Garden]
    private(set) var careTasks: [CareTask]
    private(set) var yamadoriTrips: [Yamadori]
    private(set) var yamadoriFinds: [YamadoriFind]
    private(set) var seedBatches: [SeedBatch]
    private(set) var soilMixes: [SoilMix]
    private(set) var inventoryStock: [InventoryStockItem]
    /// Grower display name (Settings → User Profile). Same field as Mac User Profile.
    private(set) var growerName: String
    /// Canonical ImageAsset catalog.
    private(set) var imageAssets: [UUID: ImageAsset]
    /// Original JPEG bytes keyed by ImageAsset.id (memory cache of on-disk originals).
    private(set) var imageJPEGData: [UUID: Data]
    /// Set when load fails. Existing files are left untouched; demo is not reseeded.
    private(set) var lastLoadError: String?
    /// Set when a save fails. In-memory changes remain; files are not replaced with demo.
    private(set) var lastSaveError: String?

    /// App launch — load preferred package (local or iCloud), or seed demo once when Trees.json is missing.
    convenience init() {
        self.init(store: .resolvedPreferred())
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
        self.yamadoriTrips = []
        self.yamadoriFinds = []
        self.seedBatches = []
        self.soilMixes = []
        self.inventoryStock = []
        self.growerName = ""
        self.imageAssets = [:]
        self.imageJPEGData = [:]
        loadOrSeed()
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
        self.yamadoriTrips = []
        self.yamadoriFinds = []
        self.seedBatches = []
        self.soilMixes = []
        self.inventoryStock = []
        self.growerName = "Olaf"
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
        country: String = ""
    ) -> Garden? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return nil }
        let garden = Garden(
            name: trimmedName,
            address: address.trimmingCharacters(in: .whitespacesAndNewlines),
            postalCode: postalCode.trimmingCharacters(in: .whitespacesAndNewlines),
            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
            country: country.trimmingCharacters(in: .whitespacesAndNewlines),
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

    /// Updates Garden Name, Default, and address fields. Preserves map coordinates.
    func updateGarden(
        id: UUID,
        name: String,
        isDefault: Bool,
        address: String = "",
        postalCode: String = "",
        city: String = "",
        country: String = ""
    ) {
        guard let index = gardens.firstIndex(where: { $0.id == id }) else { return }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        gardens[index].name = trimmedName
        gardens[index].address = address.trimmingCharacters(in: .whitespacesAndNewlines)
        gardens[index].postalCode = postalCode.trimmingCharacters(in: .whitespacesAndNewlines)
        gardens[index].city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        gardens[index].country = country.trimmingCharacters(in: .whitespacesAndNewlines)
        if isDefault {
            applyDefaultGarden(id: id)
        } else {
            gardens[index].isDefault = false
            ensureOneDefaultGarden()
        }
        persistAll()
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

    /// Updates Name, Description, Notes, Garden, Location Type, and map pin. Preserves sort and active.
    func updateLocation(
        id: UUID,
        name: String,
        description: String,
        notes: String,
        gardenID: UUID,
        locationTypeID: UUID,
        geographicPosition: GeographicPosition? = nil
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
        persistAll()
    }

    /// Deletes a Location. Trees stay in the library; locationID is unchanged.
    func deleteLocation(id: UUID) {
        guard locations.contains(where: { $0.id == id }) else { return }
        locations.removeAll { $0.id == id }
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

    func jpegData(for imageID: UUID?) -> Data? {
        guard let imageID else { return nil }
        return imageJPEGData[imageID]
    }

    func asset(id: UUID) -> ImageAsset? {
        imageAssets[id]
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

    /// Field Tasks horizons — one-off CareTasks only (no Schedules in this slice).
    enum MobileTasksHorizon: Hashable, Sendable {
        case overdue
        case today
    }

    /// One actionable row: a pending CareTask for one Tree.
    struct MobileTaskItem: Identifiable, Hashable, Sendable {
        var id: String
        var task: CareTask
        var treeID: UUID
        var isInstant: Bool
    }

    func task(id: UUID) -> CareTask? {
        careTasks.first { $0.id == id }
    }

    /// Creates a one-off CareTask for a single Tree. Title falls back to Work Type name.
    @discardableResult
    func addTask(
        title: String,
        workTypeID: UUID,
        treeID: UUID,
        dueDate: Date,
        notes: String = ""
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
            dueDate: dueDate,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        careTasks.append(task)
        persistAll()
        refreshTodayTasksNotification()
        return careTasks.first { $0.id == task.id }
    }

    /// Pending tree-scoped Tasks for Overdue or Today. Missed watering is dropped.
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
                        task: task,
                        treeID: treeID,
                        isInstant: instant
                    )
                )
            }
        }
        return items.sorted {
            if $0.task.dueDate != $1.task.dueDate {
                return $0.task.dueDate < $1.task.dueDate
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

    private func taskSortTitle(_ item: MobileTaskItem) -> String {
        let trimmed = item.task.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        return CanonicalWorkTypeID.name(for: item.task.workTypeID)
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

    /// Creates a trip and its first Find (status Scout). Returns both IDs.
    @discardableResult
    func addYamadori(displayName: String, notes: String = "") -> (trip: Yamadori, find: YamadoriFind)? {
        let name = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return nil }
        let now = Date.now
        let trip = Yamadori(
            displayName: name,
            tripDate: now,
            createdDate: now,
            modifiedDate: now,
            notes: ""
        )
        let code = YamadoriIDService.nextCode(existing: yamadoriFinds)
        let find = YamadoriFind(
            yamadoriID: trip.id,
            yamadoriCode: code,
            displayName: name,
            status: .scout,
            createdDate: now,
            modifiedDate: now,
            discoveryDate: now,
            history: [YamadoriHistoryEntry(kind: .created, date: now)],
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        yamadoriTrips.append(trip)
        yamadoriFinds.append(find)
        persistAll()
        return (trip, find)
    }

    func updateYamadoriFind(
        id: UUID,
        displayName: String,
        status: YamadoriStatus,
        notes: String,
        latitude: Double?,
        longitude: Double?,
        speciesEstimate: String? = nil
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
        if let speciesEstimate {
            let estimate = speciesEstimate.trimmingCharacters(in: .whitespacesAndNewlines)
            find.speciesEstimate = estimate.isEmpty ? nil : estimate
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

    func updateYamadoriTrip(
        id: UUID,
        displayName: String,
        tripDate: Date?,
        latitude: Double? = nil,
        longitude: Double? = nil,
        updateCoordinates: Bool = false
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
        yamadoriTrips[index].modifiedDate = .now
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

    /// Creates a Planned seed batch. Name maps to botanicalName; species text only (A1).
    @discardableResult
    func addSeedBatch(name: String, species: String) -> SeedBatch? {
        let botanical = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let speciesText = species.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return nil }
        let year = Calendar.current.component(.year, from: .now)
        let code = nextSeedBatchCode(botanicalName: botanical, year: year)
        let now = Date.now
        let batch = SeedBatch(
            batchCode: code,
            speciesID: UUID(),
            botanicalName: botanical,
            commonName: speciesText,
            seedYear: year,
            initialSeedCount: 0,
            stage: .planned,
            events: [SeedBatchEvent(date: now, kind: .created)],
            createdAt: now,
            updatedAt: now
        )
        seedBatches.append(batch)
        persistAll()
        return seedBatches.first { $0.id == batch.id }
    }

    func updateSeedBatch(
        id: UUID,
        name: String,
        species: String,
        stage: SeedBatchStage,
        notes: String,
        soilMixID: UUID?
    ) {
        guard let index = seedBatches.firstIndex(where: { $0.id == id }) else { return }
        let botanical = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return }
        seedBatches[index].botanicalName = botanical
        seedBatches[index].commonName = species.trimmingCharacters(in: .whitespacesAndNewlines)
        seedBatches[index].stage = stage
        seedBatches[index].notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        seedBatches[index].soilMixID = soilMixID
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

    private func discardImageAsset(id: UUID) {
        let relativePath = imageAssets[id]?.relativePath
        imageAssets.removeValue(forKey: id)
        imageJPEGData.removeValue(forKey: id)
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
        let dueDay = calendar.startOfDay(for: dueDate)
        let today = calendar.startOfDay(for: now)
        switch horizon {
        case .overdue:
            return dueDay < today && !expiresIfMissed
        case .today:
            return dueDay == today
        }
    }

    /// Field New Tree — botanical + optional nickname + location. Auto bonsai name.
    @discardableResult
    func createTree(botanicalName: String, nickname: String, locationID: UUID) -> Tree? {
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return nil }
        guard location(id: locationID) != nil else { return nil }
        let nick = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let tree = Tree(
            botanicalName: botanical,
            nickname: nick,
            bonsaiName: nextBonsaiName(botanicalName: botanical),
            healthStatus: .stable,
            locationID: locationID
        )
        trees.append(tree)
        persistAll()
        return trees.first { $0.id == tree.id }
    }

    /// Preview of the auto bonsai name that `createTree` would assign (does not mutate).
    func previewNextBonsaiName(botanicalName: String) -> String? {
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else { return nil }
        return nextBonsaiName(botanicalName: botanical)
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

    private func nextBonsaiName(botanicalName: String) -> String {
        let year = Calendar.current.component(.year, from: .now)
        let parts = botanicalName.split(separator: " ")
        let prefix: String = {
            if parts.count >= 2 {
                let genus = String(parts[0].prefix(3)).uppercased()
                let species = String(parts[1].prefix(3)).uppercased()
                return "\(genus)-\(species)"
            }
            return String(botanicalName.prefix(3)).uppercased()
        }()
        let marker = "\(prefix)-\(year)-"
        let existing = trees.filter { $0.bonsaiName.uppercased().hasPrefix(marker) }
        let next = existing.count + 1
        return "\(marker)\(String(format: "%03d", next))"
    }

    /// Commits editable Tree Profile fields. Identity, photos, and work are unchanged.
    func updateTree(
        id: UUID,
        nickname: String,
        locationID: UUID,
        soilMixID: UUID?,
        notes: String,
        healthStatus: TreeHealthStatus
    ) {
        guard let index = trees.firstIndex(where: { $0.id == id }) else { return }
        trees[index].nickname = nickname
        trees[index].locationID = locationID
        trees[index].soilMixID = soilMixID
        trees[index].notes = notes
        trees[index].healthStatus = healthStatus
        trees[index].modifiedDate = .now
        persistAll()
    }

    /// Seed batches that currently reference this Soil Mix.
    func seedBatches(usingSoilMix mixID: UUID) -> [SeedBatch] {
        orderedSeedBatches.filter { $0.soilMixID == mixID }
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
        trees = []
        workRecords = []
        collections = []
        locations = []
        gardens = []
        careTasks = []
        yamadoriTrips = []
        yamadoriFinds = []
        seedBatches = []
        soilMixes = []
        inventoryStock = []
        imageAssets = [:]
        imageJPEGData = [:]
        loadOrSeed()
        refreshTodayTasksNotification()
    }

    /// Single-writer warning when this library is on iCloud (A1).
    var foreignWriterWarningText: String? {
        store?.foreignWriterWarning()
    }

    /// Updates Settings → User Profile name (Mac-compatible UserProfile.json).
    func setGrowerName(_ name: String) {
        growerName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        persistProfile()
    }

    /// Schedules or clears the daily 07:00 Today Tasks local notification.
    func refreshTodayTasksNotification() {
        MobileTodayTasksNotifier.sync(todayCount: pendingTasks(due: .today).count)
    }

    /// Wipes the on-disk iOS library and reseeds demo data (B1).
    func resetLibraryToDemo() {
        guard let store else { return }
        do {
            try store.wipePackage()
            lastLoadError = nil
            lastSaveError = nil
            trees = Self.sampleTrees
            workRecords = Self.sampleWork(for: trees)
            collections = []
            locations = CanonicalLocationID.seedLocations
            gardens = Garden.seedCatalog
            careTasks = Self.sampleTasks(for: trees)
            yamadoriTrips = []
            yamadoriFinds = []
            seedBatches = []
            soilMixes = []
            inventoryStock = []
            imageAssets = [:]
            imageJPEGData = [:]
            // Keep growerName across demo reset.
            persistAll()
            refreshTodayTasksNotification()
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

    // MARK: - Persistence

    private func loadOrSeed() {
        guard let store else { return }
        do {
            try store.ensureFolderStructure()
            if let loadedTrees = try store.loadTrees() {
                trees = loadedTrees
                workRecords = try store.loadWork() ?? []
                let catalog = try store.loadImageCatalog() ?? []
                imageAssets = Dictionary(uniqueKeysWithValues: catalog.map { ($0.id, $0) })
                var pixels: [UUID: Data] = [:]
                for asset in catalog {
                    if let data = try store.loadImageData(relativePath: asset.relativePath), !data.isEmpty {
                        pixels[asset.id] = data
                    }
                }
                imageJPEGData = pixels
                do {
                    collections = try store.loadCollections() ?? []
                    ensureSystemSmartCollections()
                    lastLoadError = nil
                } catch {
                    collections = []
                    lastLoadError = "Bonsai World could not load Collections: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loadedLocations = try store.loadLocations() {
                        locations = loadedLocations
                    } else {
                        locations = CanonicalLocationID.seedLocations
                        do {
                            try store.saveLocations(locations)
                        } catch {
                            lastLoadError = "Bonsai World could not save Locations: \(error.localizedDescription)"
                            print(lastLoadError ?? "")
                        }
                    }
                } catch {
                    locations = []
                    lastLoadError = "Bonsai World could not load Locations: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loadedGardens = try store.loadGardens() {
                        gardens = loadedGardens
                        ensureOneDefaultGarden()
                    } else {
                        gardens = Garden.seedCatalog
                        do {
                            try store.saveGardens(gardens)
                        } catch {
                            lastLoadError = "Bonsai World could not save Gardens: \(error.localizedDescription)"
                            print(lastLoadError ?? "")
                        }
                    }
                } catch {
                    gardens = []
                    lastLoadError = "Bonsai World could not load Gardens: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loadedTasks = try store.loadTasks() {
                        careTasks = loadedTasks
                    } else {
                        careTasks = Self.sampleTasks(for: trees)
                        do {
                            try store.saveTasks(careTasks)
                        } catch {
                            lastLoadError = "Bonsai World could not save Tasks: \(error.localizedDescription)"
                            print(lastLoadError ?? "")
                        }
                    }
                } catch {
                    careTasks = []
                    lastLoadError = "Bonsai World could not load Tasks: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadYamadori() {
                        yamadoriTrips = loaded.trips
                        yamadoriFinds = loaded.finds
                    } else {
                        yamadoriTrips = []
                        yamadoriFinds = []
                        do {
                            try store.saveYamadori(trips: yamadoriTrips, finds: yamadoriFinds)
                        } catch {
                            lastLoadError = "Bonsai World could not save Yamadori: \(error.localizedDescription)"
                            print(lastLoadError ?? "")
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
                    } else {
                        seedBatches = []
                        do {
                            try store.saveSeedBatches(seedBatches)
                        } catch {
                            lastLoadError = "Bonsai World could not save Seed Batches: \(error.localizedDescription)"
                            print(lastLoadError ?? "")
                        }
                    }
                } catch {
                    seedBatches = []
                    lastLoadError = "Bonsai World could not load Seed Batches: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadSoilMixes() {
                        soilMixes = loaded
                    } else {
                        soilMixes = []
                        do {
                            try store.saveSoilMixes(soilMixes)
                        } catch {
                            lastLoadError = "Bonsai World could not save Soil Mixes: \(error.localizedDescription)"
                            print(lastLoadError ?? "")
                        }
                    }
                } catch {
                    soilMixes = []
                    lastLoadError = "Bonsai World could not load Soil Mixes: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let loaded = try store.loadInventoryStock() {
                        inventoryStock = loaded
                    } else {
                        inventoryStock = []
                        do {
                            try store.saveInventoryStock(inventoryStock)
                        } catch {
                            lastLoadError = "Bonsai World could not save Inventory: \(error.localizedDescription)"
                            print(lastLoadError ?? "")
                        }
                    }
                } catch {
                    inventoryStock = []
                    lastLoadError = "Bonsai World could not load Inventory: \(error.localizedDescription)"
                    print(lastLoadError ?? "")
                }
                do {
                    if let profile = try store.loadUserProfile() {
                        growerName = profile.name
                    } else {
                        growerName = growerName
                    }
                } catch {
                    // Keep in-memory name if profile file is corrupt.
                }
                refreshTodayTasksNotification()
            } else {
                trees = Self.sampleTrees
                workRecords = Self.sampleWork(for: trees)
                collections = []
                locations = CanonicalLocationID.seedLocations
                gardens = Garden.seedCatalog
                careTasks = Self.sampleTasks(for: trees)
                yamadoriTrips = []
                yamadoriFinds = []
                seedBatches = []
                soilMixes = []
                inventoryStock = []
                imageAssets = [:]
                imageJPEGData = [:]
                ensureSystemSmartCollections()
                persistAll()
                refreshTodayTasksNotification()
            }
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
            yamadoriTrips = []
            yamadoriFinds = []
            seedBatches = []
            soilMixes = []
            inventoryStock = []
            imageAssets = [:]
            imageJPEGData = [:]
        }
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
        do {
            try store.saveTrees(trees)
            try store.saveWork(workRecords)
            try store.saveCollections(collections)
            try store.saveLocations(locations)
            try store.saveGardens(gardens)
            try store.saveTasks(careTasks)
            try store.saveYamadori(trips: yamadoriTrips, finds: yamadoriFinds)
            try store.saveSeedBatches(seedBatches)
            try store.saveSoilMixes(soilMixes)
            try store.saveInventoryStock(inventoryStock)
            try store.saveImageCatalog(Array(imageAssets.values))
            try store.saveUserProfile(MobileUserProfileFile(name: growerName, email: ""))
            lastSaveError = nil
        } catch {
            reportSaveFailure(error)
        }
    }

    private func persistProfile() {
        guard let store else { return }
        do {
            try store.saveUserProfile(MobileUserProfileFile(name: growerName, email: ""))
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
