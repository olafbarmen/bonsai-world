//
//  TreeService.swift
//  Bonsai World
//
//  Application-facing Tree API. Views talk only to TreeService — never to
//  TreeRepository, CollectionRepository, or PreviewData.
//
//  Dependency flow:
//    Views → TreeService → TreeRepository / CollectionRepository
//
//  Botanical identity (Genus / Species / Cultivar / Botanical Name / Bonsai Name) and Tree ID
//  are immutable after create in the editor. Catalog repair may realign genus / species /
//  cultivar IDs to the stored Botanical Name when Lists order changes.
//
//  Collection membership is owned by Collection records (``Collection/treeIDs``) — not Tree.
//  Collection CRUD still lives here; ``CollectionServiceError`` already has its own file.
//  Full CollectionService extraction is planned after Mac test backup/commit.
//

import Foundation
import Observation

/// Coordinates Tree access for Features. Backed by any `TreeRepository` and `CollectionRepository`.
@Observable
@MainActor
final class TreeService {
    private let repository: any TreeRepository
    private let collectionRepository: any CollectionRepository
    private let photoIndex: TreePhotoIndexStore?
    private let bonsaiNameSequences: BonsaiNameSequenceStore?

    /// Observable snapshot of all trees. Refreshed after every mutating call.
    private(set) var trees: [Tree]

    /// Observable snapshot of all collections. Refreshed after collection mutations.
    private(set) var collections: [Collection]

    init(
        repository: any TreeRepository,
        collectionRepository: any CollectionRepository,
        photoIndex: TreePhotoIndexStore? = nil,
        bonsaiNameSequences: BonsaiNameSequenceStore? = nil
    ) {
        self.repository = repository
        self.collectionRepository = collectionRepository
        self.photoIndex = photoIndex
        self.bonsaiNameSequences = bonsaiNameSequences
        var loaded = repository.getAllTrees()
        // Tree is SSOT for photos. Index may fill empty trees once (legacy), then
        // is rebuilt as a derived mirror and locked — never overwrites Trees again.
        if let photoIndex {
            let migratedIDs = Set(photoIndex.migrateMissingPhotosIfNeeded(into: &loaded))
            if !migratedIDs.isEmpty {
                for tree in loaded where migratedIDs.contains(tree.id) {
                    _ = try? repository.updateTree(tree)
                }
                loaded = repository.getAllTrees()
            }
            photoIndex.rebuildFromTreesAsSourceOfTruth(loaded)
        }
        self.trees = loaded
        self.collections = collectionRepository.getAllCollections()
        ensureSystemSmartCollections()
        bonsaiNameSequences?.reconcile(with: self.trees)
    }

    /// Aligns genus / species / cultivar IDs with Botanical Name.
    /// Botanical Name and Bonsai Name stay unchanged. Safe to call on every library open.
    func repairBotanicalIdentity(genera: [Genus], species: [Species], cultivars: [Cultivar]) {
        let catalog = TreeBotanicalIdentityRepair.Catalog(
            genera: genera,
            species: species,
            cultivars: cultivars
        )
        let repaired = trees.compactMap { TreeBotanicalIdentityRepair.repaired($0, catalog: catalog) }
        guard !repaired.isEmpty else { return }

        do {
            try repository.repairBotanicalIdentities(repaired)
        } catch {
            return
        }

        trees = repository.getAllTrees()
        bonsaiNameSequences?.reconcile(with: trees)
    }

    // MARK: - Reads

    func getAllTrees() -> [Tree] {
        trees
    }

    func getTree(id: UUID) -> Tree? {
        trees.first { $0.id == id } ?? repository.getTree(id: id)
    }

    func trees(at locationID: UUID) -> [Tree] {
        trees.filter { $0.locationID == locationID }
    }

    /// Trees of a given Genus — used to resolve dynamic Task/Schedule targets
    /// (e.g. "water every Acer the same way").
    func trees(genusID: UUID) -> [Tree] {
        trees.filter { $0.genusID == genusID }
    }

    /// Trees still in the grower’s care (no disposal method).
    var treesInCare: [Tree] {
        trees.filter(\.isInCare)
    }

    /// Trees whose ownership has ended (disposal method set).
    var treesFormer: [Tree] {
        trees.filter { !$0.isInCare }
    }

    /// Trees that belong to a Collection.
    /// Lifecycle Smart Collections resolve from disposal outcome.
    /// Needs Water / Today's Work / Needs Repotting resolve from ``liveMembers``.
    /// Needs Photos is In Care trees without a photo (same as Dashboard Library).
    /// Other Smart Collections still use the stored ID list until their rules ship.
    func trees(
        inCollection collectionID: UUID,
        disposalMethods: [DisposalMethod] = [],
        liveMembers: SmartCollectionLiveMembers = SmartCollectionLiveMembers()
    ) -> [Tree] {
        if SystemSmartCollections.isNeedsWater(collectionID) {
            return trees.filter { liveMembers.needsWater.contains($0.id) }
        }
        if SystemSmartCollections.isTodaysWork(collectionID) {
            return trees.filter { liveMembers.todaysWork.contains($0.id) }
        }
        if SystemSmartCollections.isNeedsRepotting(collectionID) {
            return trees.filter { liveMembers.needsRepotting.contains($0.id) }
        }
        if SystemSmartCollections.isNeedsPhotos(collectionID) {
            return treesInCare.filter(\.lacksPhoto)
        }
        if let outcome = SystemSmartCollections.lifecycleOutcome(for: collectionID) {
            let methodIDs = Set(disposalMethods.filter { $0.outcome == outcome }.map(\.id))
            return trees.filter { tree in
                guard let id = tree.disposalMethodID else { return false }
                return methodIDs.contains(id)
            }
        }
        guard let collection = collection(id: collectionID) else { return [] }
        let memberIDs = Set(collection.treeIDs)
        return trees.filter { memberIDs.contains($0.id) }
    }

    /// Member count for a Collection (same resolution as ``trees(inCollection:disposalMethods:liveMembers:)``).
    func treeCount(
        inCollection collectionID: UUID,
        disposalMethods: [DisposalMethod] = [],
        liveMembers: SmartCollectionLiveMembers = SmartCollectionLiveMembers()
    ) -> Int {
        trees(
            inCollection: collectionID,
            disposalMethods: disposalMethods,
            liveMembers: liveMembers
        ).count
    }

    /// Smart Collections in permanent navigation order (Favorite Trees, Today's Work, …).
    /// Lifecycle outcomes (Died, Sold, …) are ``formerTreeCollections``, not this list.
    var smartCollections: [Collection] {
        collections
            .filter { collection in
                collection.isSmart
                    && SystemSmartCollections.lifecycleOutcome(for: collection.id) == nil
            }
            .sorted { lhs, rhs in
                let left = SystemSmartCollections.sortIndex(for: lhs.id) ?? Int.max
                let right = SystemSmartCollections.sortIndex(for: rhs.id) ?? Int.max
                if left != right { return left < right }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    /// Died, Sold, Gifted, Donated, Exchanged, Lost — same names as on the Trees list.
    var formerTreeCollections: [Collection] {
        collections
            .filter { collection in
                collection.isSmart
                    && SystemSmartCollections.lifecycleOutcome(for: collection.id) != nil
            }
            .sorted { lhs, rhs in
                let left = SystemSmartCollections.sortIndex(for: lhs.id) ?? Int.max
                let right = SystemSmartCollections.sortIndex(for: rhs.id) ?? Int.max
                if left != right { return left < right }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    /// User-created Manual Collections (My Collections).
    var manualCollections: [Collection] {
        collections
            .filter(\.isManual)
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    /// Default Collection when entering the module or restoring selection.
    /// Prefers last opened; otherwise the first My Collection; then Smart; then Former Trees.
    func defaultCollectionID(lastOpened: UUID?) -> UUID? {
        if let lastOpened, collection(id: lastOpened) != nil {
            return lastOpened
        }
        if let firstManual = manualCollections.first {
            return firstManual.id
        }
        if let firstSmart = smartCollections.first {
            return firstSmart.id
        }
        return formerTreeCollections.first?.id
    }

    /// Reloads trees from the repository.
    func reload() {
        trees = repository.getAllTrees()
    }

    /// True when any remaining tree (In Care or Former) already has this Bonsai Name.
    func isBonsaiNameInUse(_ name: String, excluding treeID: UUID? = nil) -> Bool {
        let needle = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return false }
        return trees.contains { tree in
            if let treeID, tree.id == treeID { return false }
            return tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
                .caseInsensitiveCompare(needle) == .orderedSame
        }
    }

    /// Next Bonsai Name sequence for a species (does not consume sequence).
    func nextBonsaiNameSequence(for speciesID: UUID) -> Int {
        if let bonsaiNameSequences {
            return bonsaiNameSequences.nextSequence(forSpecies: speciesID, existingTrees: trees)
        }
        return TreeNamingService.nextSequence(
            forSpecies: speciesID,
            existingTrees: trees
        )
    }

    // MARK: - Collection support (membership owned by Collection records)

    func collection(id: UUID) -> Collection? {
        collections.first { $0.id == id } ?? collectionRepository.getCollection(id: id)
    }

    /// Collections that include the given tree — resolved from ``Collection/treeIDs``.
    func collections(for treeID: UUID) -> [Collection] {
        collections.filter { $0.treeIDs.contains(treeID) }
    }

    func isMember(treeID: UUID, collectionID: UUID) -> Bool {
        collection(id: collectionID)?.treeIDs.contains(treeID) == true
    }

    func toggleMembership(treeID: UUID, collectionID: UUID) {
        if isMember(treeID: treeID, collectionID: collectionID) {
            try? removeTree(treeID, from: collectionID)
        } else {
            try? addTree(treeID, to: collectionID)
        }
    }

    /// Adds trees to a collection by ID only. Skips existing members.
    /// Throws ``CollectionServiceError/carePolicyConflict`` when a tree already
    /// belongs to a different Care-policy Collection.
    func addTreesToCollection(treeIDs: [UUID], collectionID: UUID) throws {
        let unique = Array(Set(treeIDs))
        for treeID in unique where !isMember(treeID: treeID, collectionID: collectionID) {
            try addTree(treeID, to: collectionID)
        }
    }

    /// Removes a tree from one Collection only. Does not delete the Tree.
    func removeTreeFromCollection(treeID: UUID, collectionID: UUID) {
        try? removeTree(treeID, from: collectionID)
    }

    /// Sets which Collections include this tree. Collection records are the source of truth.
    /// Only Manual Collections (My Collections) — Smart Collections keep their own membership.
    func setCollectionMembership(treeID: UUID, collectionIDs: Set<UUID>) throws {
        let current = Set(collections(for: treeID).filter(\.isManual).map(\.id))
        let target = Set(collectionIDs.filter { collection(id: $0)?.isManual == true })

        for collectionID in current.subtracting(target) {
            try removeTree(treeID, from: collectionID)
        }
        for collectionID in target.subtracting(current) {
            try addTree(treeID, to: collectionID)
        }
    }

    func isFavoriteTree(_ treeID: UUID) -> Bool {
        isMember(treeID: treeID, collectionID: SystemSmartCollections.StableID.favoriteTrees)
    }

    func setFavoriteTree(_ treeID: UUID, isFavorite: Bool) {
        let collectionID = SystemSmartCollections.StableID.favoriteTrees
        if isFavorite {
            try? addTreesToCollection(treeIDs: [treeID], collectionID: collectionID)
        } else {
            removeTreeFromCollection(treeID: treeID, collectionID: collectionID)
        }
    }

    /// Sets or clears which Pot a Tree is currently using. Only ``PotService`` should
    /// call this — it owns keeping the matching ``Pot/linkedTreeID`` and status in sync.
    /// A no-op when `treeID` is unknown (the Tree may have been deleted).
    func setCurrentPotID(_ potID: UUID?, forTreeID treeID: UUID) {
        guard var tree = getTree(id: treeID) else { return }
        guard tree.currentPotID != potID else { return }
        tree.currentPotID = potID
        _ = try? updateTree(tree)
    }

    /// Creates an empty Collection (membership starts empty).
    @discardableResult
    func addCollection(
        name: String,
        description: String = "",
        color: String? = nil,
        icon: String? = nil
    ) -> Collection {
        let collection = Collection(
            name: name,
            description: description,
            type: .manual,
            color: color,
            icon: icon,
            treeIDs: []
        )
        _ = try? collectionRepository.createCollection(collection)
        refreshCollections()
        return collection
    }

    /// Updates Collection metadata only. Preserves type, membership, and smart definition.
    @discardableResult
    func updateCollectionMetadata(
        id: UUID,
        name: String,
        description: String,
        color: String?,
        icon: String?
    ) throws -> Collection {
        guard var collection = collectionRepository.getCollection(id: id) else {
            throw CollectionRepositoryError.notFound(id)
        }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw CollectionServiceError.nameRequired
        }
        collection.name = trimmedName
        collection.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        collection.color = color
        collection.icon = icon
        let updated = try collectionRepository.updateCollection(collection)
        refreshCollections()
        return updated
    }

    /// Deletes a Manual Collection. Trees stay in the library; care-policy links are cleared.
    func deleteCollection(id: UUID) throws {
        guard let collection = collectionRepository.getCollection(id: id) else {
            throw CollectionRepositoryError.notFound(id)
        }
        guard collection.isManual else {
            throw CollectionServiceError.systemCollectionLocked
        }
        clearCarePolicyCollection(id)
        try collectionRepository.deleteCollection(id: id)
        refreshCollections()
    }

    /// Applies a Detail metadata draft. Membership is not part of the draft.
    func applyCollectionDetailDraft(id: UUID, draft: CollectionDetailDraft) throws {
        guard var collection = collectionRepository.getCollection(id: id) else {
            throw CollectionRepositoryError.notFound(id)
        }
        let trimmedName = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw CollectionServiceError.nameRequired
        }

        let wasCarePolicy = collection.isCarePolicyCollection
        let willBeCarePolicy = collection.isManual && draft.isCarePolicyCollection

        if willBeCarePolicy {
            for treeID in collection.treeIDs {
                try ensureCarePolicyAssignable(treeID: treeID, collectionID: id)
            }
        }

        collection.name = trimmedName
        collection.description = draft.description.trimmingCharacters(in: .whitespacesAndNewlines)
        collection.color = draft.color
        collection.icon = draft.icon
        collection.isCarePolicyCollection = willBeCarePolicy
        collection.wateringMode = draft.wateringMode
        collection.autoTimesPerDay = TreeWateringPolicyResolver.clampedTimes(draft.autoTimesPerDay)
        collection.heatWatchEnabled = draft.heatWatchEnabled

        let updated = try collectionRepository.updateCollection(collection)
        refreshCollections()

        if updated.isCarePolicyCollection {
            try assignCarePolicyToMembers(collectionID: updated.id)
        } else if wasCarePolicy {
            clearCarePolicyCollection(updated.id)
        }
    }

    /// Effective watering policy for a tree (override → Care-policy Collection → Silent default).
    func effectiveWateringPolicy(for treeID: UUID) -> EffectiveWateringPolicy {
        guard let tree = getTree(id: treeID) else { return .default }
        return TreeWateringPolicyResolver.effective(for: tree) { collection(id: $0) }
    }

    func carePolicyCollections() -> [Collection] {
        collections.filter { $0.isManual && $0.isCarePolicyCollection }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    // MARK: - Writes

    /// Validates and constructs a new Tree from an Add Tree draft, then persists it.
    ///
    /// This is the **single** place the Add Tree business rules live — genus,
    /// species, and location are required; location must exist in Reference Data.
    /// Every platform's Add Tree UI calls this method rather than re-implementing
    /// validation and field mapping itself.
    /// `validLocationIDs` is supplied by the caller (Reference Data owns the catalog;
    /// TreeService does not depend on ReferenceDataService to avoid a circular dependency).
    @discardableResult
    func createTree(
        fromDraft draft: NewTreeDraft,
        validLocationIDs: Set<UUID>,
        joiningCollectionIDs: Set<UUID> = []
    ) throws -> Tree {
        guard draft.genusID != nil, draft.speciesID != nil else {
            throw TreeServiceError.genusAndSpeciesRequired
        }
        guard let locationID = draft.locationID else {
            throw TreeServiceError.locationRequired
        }
        guard validLocationIDs.contains(locationID) else {
            throw TreeServiceError.locationNotFound
        }

        let now = Date.now
        let tree = Tree(
            botanicalName: draft.botanicalName,
            nickname: draft.nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            bonsaiName: draft.bonsaiName,
            genusID: draft.genusID,
            speciesID: draft.speciesID,
            cultivarID: draft.cultivarID,
            styleID: draft.styleID,
            sizeClassID: draft.sizeClassID,
            treeStageID: draft.treeStageID,
            locationID: locationID,
            soilMixID: draft.soilMixID,
            potTypeID: draft.potTypeID,
            lightConditionID: draft.lightConditionID,
            acquisitionDate: draft.acquisitionDate,
            acquisitionMethodID: draft.acquisitionMethodID,
            acquisitionSourceName: draft.acquisitionSourceName.trimmingCharacters(in: .whitespacesAndNewlines),
            purchasePrice: draft.purchasePrice,
            acquisitionNotes: draft.acquisitionNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            lastRepottedDate: draft.lastRepottedDate,
            repottingIntervalYears: draft.repottingIntervalYears,
            createdDate: now,
            modifiedDate: now
        )

        return try createTree(tree, joiningCollectionIDs: joiningCollectionIDs)
    }

    @discardableResult
    func createTree(_ tree: Tree, joiningCollectionIDs: Set<UUID> = []) throws -> Tree {
        guard tree.genusID != nil, tree.speciesID != nil else {
            throw TreeServiceError.genusAndSpeciesRequired
        }
        let trimmedName = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw TreeServiceError.bonsaiNameRequired
        }
        if isBonsaiNameInUse(trimmedName, excluding: tree.id) {
            throw TreeServiceError.bonsaiNameAlreadyUsed
        }

        var tree = tree
        tree.bonsaiName = trimmedName

        let created = try repository.createTree(tree)
        photoIndex?.saveBinding(
            treeID: created.id,
            primaryImageID: created.primaryImageID,
            imageIDs: created.imageIDs
        )
        bonsaiNameSequences?.noteTree(created)
        if !joiningCollectionIDs.isEmpty {
            try setCollectionMembership(treeID: created.id, collectionIDs: joiningCollectionIDs)
        }
        reload()
        refreshCollections()
        return created
    }

    /// Updates a tree. Rejects any attempt to change Tree ID or permanent identity.
    @discardableResult
    func updateTree(_ tree: Tree) throws -> Tree {
        guard let existing = repository.getTree(id: tree.id) else {
            throw TreeRepositoryError.notFound(tree.id)
        }

        if tree.id != existing.id {
            throw TreeServiceError.treeIdentityLocked
        }

        if Self.permanentIdentityChanged(from: existing, to: tree) {
            throw TreeServiceError.botanicalIdentityLocked
        }

        var updated = tree
        updated.id = existing.id
        // Permanent identity — never taken from the incoming value.
        updated.genusID = existing.genusID
        updated.speciesID = existing.speciesID
        updated.cultivarID = existing.cultivarID
        updated.botanicalName = existing.botanicalName
        updated.bonsaiName = existing.bonsaiName
        updated.modifiedDate = .now

        let saved = try repository.updateTree(updated)
        photoIndex?.saveBinding(
            treeID: saved.id,
            primaryImageID: saved.primaryImageID,
            imageIDs: saved.imageIDs
        )
        reload()
        return saved
    }

    /// Graduates a Yamadori nursery tree to My Trees — the one allowed Bonsai Name change after create.
    @discardableResult
    func graduateYamadoriTree(_ tree: Tree) throws -> Tree {
        guard let existing = repository.getTree(id: tree.id) else {
            throw TreeRepositoryError.notFound(tree.id)
        }
        guard existing.yamadoriNursery else {
            throw TreeServiceError.botanicalIdentityLocked
        }

        let trimmedName = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw TreeServiceError.bonsaiNameRequired
        }
        if isBonsaiNameInUse(trimmedName, excluding: tree.id) {
            throw TreeServiceError.bonsaiNameAlreadyUsed
        }

        var updated = tree
        updated.id = existing.id
        updated.genusID = existing.genusID
        updated.speciesID = existing.speciesID
        updated.cultivarID = existing.cultivarID
        updated.botanicalName = existing.botanicalName
        updated.bonsaiName = trimmedName
        updated.yamadoriNursery = false
        updated.modifiedDate = .now

        let saved = try repository.updateTree(updated)
        photoIndex?.saveBinding(
            treeID: saved.id,
            primaryImageID: saved.primaryImageID,
            imageIDs: saved.imageIDs
        )
        bonsaiNameSequences?.noteTree(saved)
        reload()
        return saved
    }

    /// Copies botanics, placement, pot, and acquisition onto a new Tree.
    /// New id and Bonsai Name (next sequence). Photos, measurements, notes, and disposal are not copied.
    @discardableResult
    func duplicateTree(
        id: UUID,
        genusName: String,
        speciesName: String,
        cultivarName: String?
    ) throws -> Tree {
        guard let source = getTree(id: id) else {
            throw TreeRepositoryError.notFound(id)
        }

        let year: Int = {
            if let date = source.acquisitionDate {
                return TreeNamingService.acquisitionYear(from: date)
            }
            return TreeNamingService.acquisitionYear(from: .now)
        }()
        let sequence: Int = {
            guard let speciesID = source.speciesID else { return 1 }
            return nextBonsaiNameSequence(for: speciesID)
        }()
        let bonsaiName = TreeNamingService.makeGeneratedBonsaiName(
            genusName: genusName,
            speciesName: speciesName,
            cultivarName: cultivarName,
            botanicalName: source.botanicalName,
            existingBonsaiName: source.bonsaiName,
            acquisitionYear: year,
            sequence: sequence
        )
        guard !bonsaiName.isEmpty else {
            throw TreeServiceError.bonsaiNameRequired
        }

        let now = Date.now
        let copy = Tree(
            botanicalName: source.botanicalName,
            bonsaiName: bonsaiName,
            genusID: source.genusID,
            speciesID: source.speciesID,
            cultivarID: source.cultivarID,
            styleID: source.styleID,
            sizeClassID: source.sizeClassID,
            treeStageID: source.treeStageID,
            healthStatus: source.healthStatus,
            fertilizerHealth: source.fertilizerHealth,
            fertilizerKindOverride: source.fertilizerKindOverride,
            locationID: source.locationID,
            soilMixID: source.soilMixID,
            potTypeID: source.potTypeID,
            lightConditionID: source.lightConditionID,
            potLengthMillimetres: source.potLengthMillimetres,
            potWidthMillimetres: source.potWidthMillimetres,
            potHeightMillimetres: source.potHeightMillimetres,
            potDiameterMillimetres: source.potDiameterMillimetres,
            acquisitionDate: source.acquisitionDate,
            acquisitionMethodID: source.acquisitionMethodID,
            acquisitionSourceName: source.acquisitionSourceName,
            purchasePrice: source.purchasePrice,
            acquisitionNotes: source.acquisitionNotes,
            lastRepottedDate: source.lastRepottedDate,
            repottingIntervalYears: source.repottingIntervalYears,
            createdDate: now,
            modifiedDate: now
        )

        let collectionIDs = Set(collections(for: id).filter(\.isManual).map(\.id))
        return try createTree(copy, joiningCollectionIDs: collectionIDs)
    }

    /// Clears disposal so the tree is In Care again. History (work, photos, notes) stays.
    @discardableResult
    func returnToCare(id: UUID) throws -> Tree {
        guard var tree = getTree(id: id) else {
            throw TreeRepositoryError.notFound(id)
        }
        tree.disposalDate = nil
        tree.disposalMethodID = nil
        tree.disposalPartyName = ""
        tree.disposalPrice = nil
        tree.disposalNotes = ""
        return try updateTree(tree)
    }

    /// Removes the Tree, cleans manual Collection membership, and drops the
    /// photo-index binding. Does not delete gallery image assets, Work history,
    /// Pots, or Tasks — callers orchestrate those unlink / preserve steps.
    func deleteTree(id: UUID) throws {
        try repository.deleteTree(id: id)
        removeTreeFromAllCollections(treeID: id)
        photoIndex?.removeBinding(treeID: id)
        reload()
        refreshCollections()
        bonsaiNameSequences?.reconcile(with: trees)
    }

    // MARK: - Convenience (session UI)

    func setNickname(id: UUID, to nickname: String) throws {
        guard var tree = getTree(id: id) else {
            throw TreeRepositoryError.notFound(id)
        }
        tree.nickname = nickname
        try updateTree(tree)
    }

    func updateVision(treeID: UUID, vision: TreeVision) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        var visionToSave = vision
        if let legacyTargetStyleID = visionToSave.targetStyleID {
            if tree.styleID == nil {
                tree.styleID = legacyTargetStyleID
            }
            visionToSave.targetStyleID = nil
        }
        tree.vision = visionToSave
        try updateTree(tree)
    }

    // MARK: - Shaping

    /// Ensures legacy Vision characteristics are migrated into Shaping areas once.
    @discardableResult
    func ensureShapingMigrated(treeID: UUID) throws -> TreeShaping {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        var shaping = tree.shaping ?? TreeShaping.empty
        guard !shaping.didMigrateVision else {
            return shaping
        }
        if let vision = tree.vision {
            var migratedVision = vision
            migratedVision.migrateLegacyCharacteristicsIfNeeded()
            let hasShapingContentToMigrate =
                !migratedVision.trunkCharacteristic.text.isEmpty
                || !migratedVision.branchCharacteristic.text.isEmpty
                || !migratedVision.apexCharacteristic.text.isEmpty
                || !migratedVision.nebariCharacteristic.text.isEmpty
                || !migratedVision.additionalCharacteristics.isEmpty
                || !migratedVision.developmentDirection.isEmpty
                || !migratedVision.notes.isEmpty
                || !migratedVision.trunkMovement.isEmpty
                || !migratedVision.taper.isEmpty
                || !migratedVision.branchStructure.isEmpty
                || !migratedVision.overallSilhouette.isEmpty
                || !migratedVision.nebari.isEmpty
                || !migratedVision.characteristics.isEmpty

            if hasShapingContentToMigrate {
                shaping.migrateFromVision(migratedVision)
            }
            var slimVision = migratedVision
            slimVision.prepareForSave()
            tree.vision = slimVision
        }
        shaping.didMigrateVision = true
        tree.shaping = shaping
        try updateTree(tree)
        return shaping
    }

    func shaping(for treeID: UUID) -> TreeShaping {
        (try? ensureShapingMigrated(treeID: treeID)) ?? .empty
    }

    func updateShaping(treeID: UUID, shaping: TreeShaping) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        tree.shaping = shaping
        try updateTree(tree)
    }

    func updateShapingArea(treeID: UUID, area: ShapingAreaID, record: ShapingAreaRecord) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        var shaping = tree.shaping ?? TreeShaping.empty
        shaping.setRecord(record, for: area)
        tree.shaping = shaping
        try updateTree(tree)
    }

    @discardableResult
    func appendShapingHistory(
        treeID: UUID,
        area: ShapingAreaID,
        entry: ShapingHistoryEntry
    ) throws -> ShapingHistoryEntry {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        var shaping = tree.shaping ?? TreeShaping.empty
        var record = shaping.record(for: area)
        record.history.append(entry)
        shaping.setRecord(record, for: area)
        tree.shaping = shaping
        try updateTree(tree)
        return entry
    }

    func linkShapingHistoryWorkRecord(
        treeID: UUID,
        area: ShapingAreaID,
        historyEntryID: UUID,
        workRecordID: UUID
    ) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        var shaping = tree.shaping ?? TreeShaping.empty
        var record = shaping.record(for: area)
        guard let index = record.history.firstIndex(where: { $0.id == historyEntryID }) else { return }
        record.history[index].linkedWorkRecordID = workRecordID
        shaping.setRecord(record, for: area)
        tree.shaping = shaping
        try updateTree(tree)
    }

    /// Image IDs used as Vision or Shaping reference images — never tree gallery / Primary.
    func referenceImageIDs(for tree: Tree) -> Set<UUID> {
        var ids = Set(tree.vision?.referenceImageIDs ?? [])
        if let shaping = tree.shaping {
            for record in shaping.areas.values {
                ids.formUnion(record.referenceImageIDs)
            }
        }
        return ids
    }

    func referenceImageIDs() -> Set<UUID> {
        Set(trees.flatMap { Array(referenceImageIDs(for: $0)) })
    }

    func isReferenceImage(_ imageID: UUID) -> Bool {
        referenceImageIDs().contains(imageID)
    }

    func setPrimaryImage(treeID: UUID, imageID: UUID) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        guard !isReferenceImage(imageID) else { return }
        tree.primaryImageID = imageID
        if !tree.imageIDs.contains(imageID) {
            tree.imageIDs.insert(imageID, at: 0)
        }
        try updateTree(tree)
    }

    /// Removes a photo from the tree gallery (does not delete catalog bytes).
    func removeImage(treeID: UUID, imageID: UUID) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        tree.imageIDs.removeAll { $0 == imageID }
        if tree.primaryImageID == imageID {
            tree.primaryImageID = tree.imageIDs.first
        }
        try updateTree(tree)
    }

    /// Replaces gallery order (e.g. after Capture Date sort).
    func setImageIDs(treeID: UUID, imageIDs: [UUID]) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        tree.imageIDs = imageIDs
        if let primary = tree.primaryImageID, !imageIDs.contains(primary) {
            tree.primaryImageID = imageIDs.first
        }
        try updateTree(tree)
    }

    /// Updates denormalized “latest” Tree measurement fields from a history record.
    /// Does not touch pot dimensions — those live on the Tree (future Pot entity) only.
    func applyLatestMeasurement(treeID: UUID, from record: TreeMeasurementRecord) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        tree.heightMillimetres = record.heightMillimetres
        tree.crownWidthMillimetres = record.crownWidthMillimetres
        tree.nebariWidthMillimetres = record.nebariWidthMillimetres
        tree.trunkDiameterMillimetres = record.trunkDiameterMillimetres
        try updateTree(tree)
    }

    /// Seeds empty measurement history from Tree fields, then aligns Tree dims
    /// to the latest history record. History is SSOT for Height / Crown / Nebari / Trunk.
    func reconcileMeasurementDimensions(using history: TreeMeasurementHistoryStore) {
        var anyChanged = false
        for tree in trees {
            _ = history.ensureMigrated(from: tree)
            guard let latest = history.latest(for: tree.id) else { continue }
            let matches =
                tree.heightMillimetres == latest.heightMillimetres
                && tree.crownWidthMillimetres == latest.crownWidthMillimetres
                && tree.nebariWidthMillimetres == latest.nebariWidthMillimetres
                && tree.trunkDiameterMillimetres == latest.trunkDiameterMillimetres
            guard !matches else { continue }
            var updated = tree
            updated.heightMillimetres = latest.heightMillimetres
            updated.crownWidthMillimetres = latest.crownWidthMillimetres
            updated.nebariWidthMillimetres = latest.nebariWidthMillimetres
            updated.trunkDiameterMillimetres = latest.trunkDiameterMillimetres
            updated.modifiedDate = .now
            _ = try? repository.updateTree(updated)
            photoIndex?.saveBinding(
                treeID: updated.id,
                primaryImageID: updated.primaryImageID,
                imageIDs: updated.imageIDs
            )
            anyChanged = true
        }
        if anyChanged {
            reload()
        }
    }

    func setNotes(id: UUID, notes: String) throws {
        guard var tree = getTree(id: id) else {
            throw TreeRepositoryError.notFound(id)
        }
        tree.notes = notes
        try updateTree(tree)
    }

    func setHealthStatus(id: UUID, healthStatus: TreeHealthStatus) throws {
        guard var tree = getTree(id: id) else {
            throw TreeRepositoryError.notFound(id)
        }
        tree.healthStatus = healthStatus
        try updateTree(tree)
    }

    /// Permanent identity is immutable after create. Always rejects changes.
    func updateBotanical(
        id: UUID,
        genusID: UUID?,
        speciesID: UUID?,
        cultivarID: UUID?,
        botanicalName: String
    ) throws {
        guard let existing = getTree(id: id) else {
            throw TreeRepositoryError.notFound(id)
        }
        let attempted = Tree(
            id: existing.id,
            botanicalName: botanicalName,
            nickname: existing.nickname,
            bonsaiName: existing.bonsaiName,
            genusID: genusID,
            speciesID: speciesID,
            cultivarID: cultivarID,
            styleID: existing.styleID,
            sizeClassID: existing.sizeClassID,
            treeStageID: existing.treeStageID,
            healthStatus: existing.healthStatus,
            locationID: existing.locationID,
            soilMixID: existing.soilMixID,
            potTypeID: existing.potTypeID,
            lightConditionID: existing.lightConditionID,
            heightMillimetres: existing.heightMillimetres,
            crownWidthMillimetres: existing.crownWidthMillimetres,
            nebariWidthMillimetres: existing.nebariWidthMillimetres,
            trunkDiameterMillimetres: existing.trunkDiameterMillimetres,
            potLengthMillimetres: existing.potLengthMillimetres,
            potWidthMillimetres: existing.potWidthMillimetres,
            potHeightMillimetres: existing.potHeightMillimetres,
            potDiameterMillimetres: existing.potDiameterMillimetres,
            acquisitionDate: existing.acquisitionDate,
            acquisitionMethodID: existing.acquisitionMethodID,
            acquisitionSourceName: existing.acquisitionSourceName,
            purchasePrice: existing.purchasePrice,
            acquisitionNotes: existing.acquisitionNotes,
            disposalDate: existing.disposalDate,
            disposalMethodID: existing.disposalMethodID,
            disposalPartyName: existing.disposalPartyName,
            disposalPrice: existing.disposalPrice,
            disposalNotes: existing.disposalNotes,
            notes: existing.notes,
            knownHistory: existing.knownHistory,
            vision: existing.vision,
            primaryImageID: existing.primaryImageID,
            imageIDs: existing.imageIDs,
            projectIDs: existing.projectIDs,
            journalEntryIDs: existing.journalEntryIDs,
            taskIDs: existing.taskIDs,
            createdDate: existing.createdDate,
            modifiedDate: existing.modifiedDate
        )
        if Self.permanentIdentityChanged(from: existing, to: attempted) {
            throw TreeServiceError.botanicalIdentityLocked
        }
        // No-op when values match existing identity.
    }

    /// Commits an Edit Mode draft. Permanent identity and Tree ID are never taken from the draft.
    func applyDetailDraft(id: UUID, draft: TreeDetailDraft) throws {
        guard var tree = getTree(id: id) else {
            throw TreeRepositoryError.notFound(id)
        }

        tree.nickname = draft.nickname
        tree.styleID = draft.styleID
        tree.sizeClassID = draft.sizeClassID
        tree.treeStageID = draft.treeStageID
        tree.healthStatus = draft.healthStatus
        tree.lastRepottedDate = draft.lastRepottedDate
        tree.repottingIntervalYears = draft.repottingIntervalYears.map { max(1, min(20, $0)) }
        tree.placementStrategy = draft.placementStrategy
        tree.seasonPlacement = draft.seasonPlacement
        tree.winterCareCompletedSteps = draft.winterCareCompletedSteps
        tree.springCareCompletedSteps = draft.springCareCompletedSteps
        tree.fertilizerHealth = draft.fertilizerHealth
        tree.fertilizerKindOverride = draft.fertilizerKindOverride
        if let locationID = draft.locationID {
            tree.locationID = locationID
        }
        tree.lightConditionID = draft.lightConditionID
        tree.soilMixID = draft.soilMixID
        tree.potTypeID = draft.potTypeID
        // Height / Crown / Nebari / Trunk are measurement history events only.
        // Edit Tree must not write them from the draft — use Add Measurement →
        // ``applyLatestMeasurement``.
        tree.potLengthMillimetres = draft.potLengthMillimetres
        tree.potWidthMillimetres = draft.potWidthMillimetres
        tree.potHeightMillimetres = draft.potHeightMillimetres
        tree.potDiameterMillimetres = draft.potDiameterMillimetres

        tree.acquisitionDate = draft.acquisitionDate
        tree.acquisitionMethodID = draft.acquisitionMethodID
        tree.acquisitionSourceName = draft.acquisitionSourceName
        tree.purchasePrice = draft.purchasePrice
        tree.acquisitionNotes = draft.acquisitionNotes

        tree.disposalDate = draft.disposalDate
        tree.disposalMethodID = draft.disposalMethodID
        tree.disposalPartyName = draft.disposalPartyName
        tree.disposalPrice = draft.disposalPrice
        tree.disposalNotes = draft.disposalNotes

        tree.notes = draft.notes
        tree.knownHistory = draft.knownHistory
        tree.carePolicyCollectionID = draft.carePolicyCollectionID
        tree.wateringModeOverride = draft.wateringModeOverride
        tree.autoTimesPerDayOverride = draft.autoTimesPerDayOverride.map(TreeWateringPolicyResolver.clampedTimes)

        let referenceIDs = referenceImageIDs(for: tree)
        var gallery = draft.imageIDs.filter { !referenceIDs.contains($0) }
        var primaryImageID = draft.primaryImageID
        if let primary = primaryImageID, referenceIDs.contains(primary) {
            primaryImageID = nil
        }
        tree.primaryImageID = primaryImageID

        // Prefer explicit gallery order from the draft; ensure primary is included.
        if let primaryImageID, !gallery.contains(primaryImageID) {
            gallery.insert(primaryImageID, at: 0)
        }
        tree.imageIDs = gallery

        try updateTree(tree)
        try setCollectionMembership(treeID: id, collectionIDs: draft.collectionIDs)
    }

    // MARK: - Collection membership (private)

    /// Ensures system Smart Collection placeholders exist and stay typed as Smart.
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
                _ = try? collectionRepository.updateCollection(existing)
                changed = true
            } else {
                _ = try? collectionRepository.createCollection(placeholder)
                changed = true
            }
        }

        if changed {
            refreshCollections()
        }
    }

    private func refreshCollections() {
        collections = collectionRepository.getAllCollections()
    }

    private func addTree(_ treeID: UUID, to collectionID: UUID) throws {
        guard var collection = collectionRepository.getCollection(id: collectionID) else {
            throw CollectionRepositoryError.notFound(collectionID)
        }
        guard getTree(id: treeID) != nil else {
            throw TreeRepositoryError.notFound(treeID)
        }
        guard !collection.treeIDs.contains(treeID) else { return }

        if collection.isCarePolicyCollection {
            try ensureCarePolicyAssignable(treeID: treeID, collectionID: collectionID)
        }

        collection.treeIDs.append(treeID)
        _ = try collectionRepository.updateCollection(collection)
        refreshCollections()

        if collection.isCarePolicyCollection {
            try setCarePolicyCollectionID(treeID: treeID, collectionID: collectionID)
        }
    }

    private func removeTree(_ treeID: UUID, from collectionID: UUID) throws {
        guard var collection = collectionRepository.getCollection(id: collectionID) else {
            throw CollectionRepositoryError.notFound(collectionID)
        }
        guard collection.treeIDs.contains(treeID) else { return }
        collection.treeIDs.removeAll { $0 == treeID }
        _ = try collectionRepository.updateCollection(collection)
        refreshCollections()

        if let tree = getTree(id: treeID), tree.carePolicyCollectionID == collectionID {
            try setCarePolicyCollectionID(treeID: treeID, collectionID: nil)
        }
    }

    private func ensureCarePolicyAssignable(treeID: UUID, collectionID: UUID) throws {
        guard let tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        guard let existingID = tree.carePolicyCollectionID, existingID != collectionID else { return }
        guard let existing = collection(id: existingID), existing.isCarePolicyCollection else { return }
        guard existing.treeIDs.contains(treeID) else { return }
        throw CollectionServiceError.carePolicyConflict(
            treeTitle: TreePresentation.title(for: tree),
            existingCollectionName: existing.name
        )
    }

    private func assignCarePolicyToMembers(collectionID: UUID) throws {
        guard let collection = collection(id: collectionID), collection.isCarePolicyCollection else { return }
        for treeID in collection.treeIDs {
            try ensureCarePolicyAssignable(treeID: treeID, collectionID: collectionID)
            try setCarePolicyCollectionID(treeID: treeID, collectionID: collectionID)
        }
    }

    private func clearCarePolicyCollection(_ collectionID: UUID) {
        for tree in trees where tree.carePolicyCollectionID == collectionID {
            try? setCarePolicyCollectionID(treeID: tree.id, collectionID: nil)
        }
    }

    private func setCarePolicyCollectionID(treeID: UUID, collectionID: UUID?) throws {
        guard var tree = getTree(id: treeID) else {
            throw TreeRepositoryError.notFound(treeID)
        }
        guard tree.carePolicyCollectionID != collectionID else { return }
        tree.carePolicyCollectionID = collectionID
        tree.modifiedDate = .now
        _ = try repository.updateTree(tree)
        reload()
    }

    private func removeTreeFromAllCollections(treeID: UUID) {
        for collection in collections where collection.treeIDs.contains(treeID) {
            var updated = collection
            updated.treeIDs.removeAll { $0 == treeID }
            _ = try? collectionRepository.updateCollection(updated)
        }
        refreshCollections()
    }

    // MARK: - Permanent identity lock

    /// True when any immutable identity field would change.
    /// Locked after create: Bonsai Name, Botanical Name, Genus, Species, Cultivar.
    static func permanentIdentityChanged(from existing: Tree, to updated: Tree) -> Bool {
        existing.genusID != updated.genusID
            || existing.speciesID != updated.speciesID
            || existing.cultivarID != updated.cultivarID
            || existing.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
                != updated.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
            || existing.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
                != updated.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Compatibility alias for ``permanentIdentityChanged(from:to:)``.
    static func botanicalIdentityChanged(from existing: Tree, to updated: Tree) -> Bool {
        permanentIdentityChanged(from: existing, to: updated)
    }
}

extension TreeService {
    /// Preview bootstrap — pairs preview tree and collection repositories over one catalog.
    static func preview(previewData: PreviewData) -> TreeService {
        TreeService(
            repository: PreviewTreeRepository(previewData: previewData),
            collectionRepository: PreviewCollectionRepository(previewData: previewData)
        )
    }
}
