//
//  YamadoriService.swift
//  Bonsai World
//
//  Application-facing Yamadori API. Views talk only to YamadoriService.
//  Yamadori = trip; Find = specimen. Mark Collected creates a Yamadori Tree;
//  Move to My Trees graduates it to the main tree list.
//
//  Dependency flow:
//    Views → YamadoriService → YamadoriRepository
//    YamadoriService → TreeService (one-directional; TreeService knows nothing of Yamadori)
//

import Foundation
import Observation

@Observable
@MainActor
final class YamadoriService {
    private let repository: any YamadoriRepository
    private let treeService: TreeService

    private(set) var records: [Yamadori]
    private(set) var finds: [YamadoriFind]

    init(repository: any YamadoriRepository, treeService: TreeService) {
        self.repository = repository
        self.treeService = treeService
        self.records = repository.getAllYamadori()
        self.finds = repository.getAllFinds()
    }

    private func reload() {
        records = repository.getAllYamadori()
        finds = repository.getAllFinds()
    }

    // MARK: - Trip reads

    func getAllYamadori() -> [Yamadori] { records }

    func getYamadori(id: UUID) -> Yamadori? {
        records.first { $0.id == id }
    }

    // MARK: - Find reads

    func getAllFinds() -> [YamadoriFind] { finds }

    func getFind(id: UUID) -> YamadoriFind? {
        finds.first { $0.id == id }
    }

    func finds(forYamadoriID yamadoriID: UUID) -> [YamadoriFind] {
        finds.filter { $0.yamadoriID == yamadoriID }
    }

    func find(linkedToTreeID treeID: UUID) -> YamadoriFind? {
        finds.first { $0.linkedTreeID == treeID }
    }

    /// Prefer Find lookup; kept for call sites that still say “yamadori linked to tree”.
    func yamadori(linkedToTreeID treeID: UUID) -> YamadoriFind? {
        find(linkedToTreeID: treeID)
    }

    // MARK: - Create trip

    /// Creates a trip from the New Yamadori form. Finds are added later via Add Find (CB1).
    @discardableResult
    func createYamadori(fromDraft draft: NewYamadoriDraft) throws -> Yamadori {
        let now = Date.now
        let name = draft.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trip = Yamadori(
            displayName: name,
            tripDate: draft.discoveryDate ?? now,
            createdDate: now,
            modifiedDate: now,
            latitude: draft.latitude,
            longitude: draft.longitude,
            locationDescription: draft.locationDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            countryRegion: draft.countryRegion.trimmingCharacters(in: .whitespacesAndNewlines),
            permissionNotes: draft.permissionNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            siteKey: draft.siteKey.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        return try createYamadori(trip)
    }

    @discardableResult
    func createYamadori(_ yamadori: Yamadori) throws -> Yamadori {
        let created = try repository.createYamadori(yamadori)
        reload()
        return created
    }

    @discardableResult
    func createFind(onYamadoriID yamadoriID: UUID, displayName: String = "") throws -> YamadoriFind {
        guard getYamadori(id: yamadoriID) != nil else {
            throw YamadoriRepositoryError.notFound(yamadoriID)
        }
        let now = Date.now
        let code = YamadoriIDService.nextCode(existing: finds)
        let find = YamadoriFind(
            yamadoriID: yamadoriID,
            yamadoriCode: code,
            displayName: displayName.trimmingCharacters(in: .whitespacesAndNewlines),
            status: .scout,
            createdDate: now,
            modifiedDate: now,
            discoveryDate: now,
            history: [YamadoriHistoryEntry(kind: .created, date: now)]
        )
        return try createFind(find)
    }

    @discardableResult
    func createFind(_ find: YamadoriFind) throws -> YamadoriFind {
        let created = try repository.createFind(find)
        reload()
        return created
    }

    // MARK: - Update trip

    @discardableResult
    func updateYamadori(_ yamadori: Yamadori) throws -> Yamadori {
        guard repository.getYamadori(id: yamadori.id) != nil else {
            throw YamadoriRepositoryError.notFound(yamadori.id)
        }
        var updated = yamadori
        updated.modifiedDate = .now
        let saved = try repository.updateYamadori(updated)
        reload()
        return saved
    }

    func applyTripDraft(id: UUID, draft: YamadoriTripDetailDraft) throws {
        guard var trip = getYamadori(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        trip.displayName = draft.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.tripDate = draft.tripDate
        trip.latitude = draft.latitude
        trip.longitude = draft.longitude
        trip.locationDescription = draft.locationDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.countryRegion = draft.countryRegion.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.landOwnershipNotes = draft.landOwnershipNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.permissionNotes = draft.permissionNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.siteKey = draft.siteKey.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.plannedCollectionDate = draft.plannedCollectionDate
        trip.collectionWindowNotes = draft.collectionWindowNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.preparationNotes = draft.preparationNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.equipmentNotes = draft.equipmentNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.collectionPlanNotes = draft.collectionPlanNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        trip.notes = draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        try updateYamadori(trip)
    }

    func deleteYamadori(id: UUID) throws {
        try repository.deleteYamadori(id: id)
        reload()
    }

    // MARK: - Update Find

    @discardableResult
    func updateFind(_ find: YamadoriFind) throws -> YamadoriFind {
        guard let existing = repository.getFind(id: find.id) else {
            throw YamadoriRepositoryError.notFound(find.id)
        }
        guard find.yamadoriCode == existing.yamadoriCode else {
            throw YamadoriServiceError.codeIdentityLocked
        }
        var updated = find
        updated.modifiedDate = .now
        let saved = try repository.updateFind(updated)
        reload()
        return saved
    }

    /// Clears Find → Tree links when the Tree is deleted. Find history is kept.
    func clearLinkedTreeReference(treeID: UUID) {
        let linked = finds.filter { $0.linkedTreeID == treeID }
        for find in linked {
            var updated = find
            updated.linkedTreeID = nil
            try? updateFind(updated)
        }
    }

    func applyFindDraft(id: UUID, draft: YamadoriFindDetailDraft) throws {
        guard var find = getFind(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        find.displayName = draft.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        find.genusID = draft.genusID
        find.speciesID = draft.speciesID
        find.cultivarID = draft.cultivarID
        find.discoveryDate = draft.discoveryDate
        find.latitude = draft.latitude
        find.longitude = draft.longitude
        find.evaluationTrunk = draft.evaluationTrunk.trimmingCharacters(in: .whitespacesAndNewlines)
        find.evaluationNebari = draft.evaluationNebari.trimmingCharacters(in: .whitespacesAndNewlines)
        find.evaluationMovement = draft.evaluationMovement.trimmingCharacters(in: .whitespacesAndNewlines)
        find.evaluationTaper = draft.evaluationTaper.trimmingCharacters(in: .whitespacesAndNewlines)
        find.evaluationBranches = draft.evaluationBranches.trimmingCharacters(in: .whitespacesAndNewlines)
        find.evaluationHealth = draft.evaluationHealth.trimmingCharacters(in: .whitespacesAndNewlines)
        find.evaluationAccessibility = draft.evaluationAccessibility.trimmingCharacters(in: .whitespacesAndNewlines)
        find.evaluationDifficulty = draft.evaluationDifficulty.trimmingCharacters(in: .whitespacesAndNewlines)
        find.evaluationOverall = draft.evaluationOverall.trimmingCharacters(in: .whitespacesAndNewlines)
        find.collectionDate = draft.collectionDate
        find.collectionObservations = draft.collectionObservations.trimmingCharacters(in: .whitespacesAndNewlines)
        find.rootNotes = draft.rootNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        find.transportNotes = draft.transportNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        find.initialPlacement = draft.initialPlacement.trimmingCharacters(in: .whitespacesAndNewlines)
        find.initialRecoveryNotes = draft.initialRecoveryNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        find.recoveryStartDate = draft.recoveryStartDate
        find.recoveryLocationNotes = draft.recoveryLocationNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        find.recoveryCareNotes = draft.recoveryCareNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        find.establishmentAssessment = draft.establishmentAssessment.trimmingCharacters(in: .whitespacesAndNewlines)
        find.establishedDate = draft.establishedDate
        find.notes = draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        try updateFind(find)
    }

    /// Alias for Find draft apply (former single-record detail).
    func applyDetailDraft(id: UUID, draft: YamadoriFindDetailDraft) throws {
        try applyFindDraft(id: id, draft: draft)
    }

    func deleteFind(id: UUID) throws {
        try repository.deleteFind(id: id)
        reload()
    }

    // MARK: - Status (Find)

    /// Legacy: Uncollected → Planned. Happy path is Mark Collected from Uncollected.
    @discardableResult
    func advanceStatus(id: UUID) throws -> YamadoriFind {
        guard let find = getFind(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        guard find.status == .scout else {
            throw YamadoriServiceError.invalidStatusTransition(from: find.status, to: .planned)
        }
        return try setStatus(id: id, to: .planned)
    }

    @discardableResult
    func setStatus(id: UUID, to status: YamadoriStatus, note: String = "") throws -> YamadoriFind {
        guard var find = getFind(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        guard Self.canTransition(from: find.status, to: status) else {
            throw YamadoriServiceError.invalidStatusTransition(from: find.status, to: status)
        }
        let now = Date.now
        let previous = find.status
        find.status = status

        switch status {
        case .collected:
            if find.collectionDate == nil { find.collectionDate = now }
            find.history.append(YamadoriHistoryEntry(kind: .collected, date: now, note: note))
        case .recovery:
            if find.recoveryStartDate == nil { find.recoveryStartDate = now }
            find.history.append(YamadoriHistoryEntry(kind: .recoveryStarted, date: now, note: note))
        case .established:
            if find.establishedDate == nil { find.establishedDate = now }
            find.history.append(YamadoriHistoryEntry(kind: .established, date: now, note: note))
        case .abandoned:
            find.history.append(YamadoriHistoryEntry(kind: .abandoned, date: now, note: note))
        case .archived:
            find.history.append(YamadoriHistoryEntry(kind: .archived, date: now, note: note))
        case .transferred:
            find.history.append(YamadoriHistoryEntry(kind: .transferred, date: now, note: note))
        default:
            find.history.append(
                YamadoriHistoryEntry(
                    kind: .statusChanged,
                    date: now,
                    note: note.isEmpty ? "\(previous.title) → \(status.title)" : note
                )
            )
        }

        return try updateFind(find)
    }

    @discardableResult
    func markCollected(
        id: UUID,
        draft: YamadoriCollectDraft,
        acquisitionMethodID: UUID,
        treeStageID: UUID,
        genusName: String,
        speciesName: String,
        cultivarName: String?,
        validLocationIDs: Set<UUID>,
        date: Date = .now
    ) throws -> (find: YamadoriFind, tree: Tree) {
        guard var find = getFind(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        if find.status == .transferred {
            throw YamadoriServiceError.alreadyTransferred
        }
        if let treeID = find.linkedTreeID, let existing = treeService.getTree(id: treeID) {
            return (find, existing)
        }
        guard find.status.isUncollected else {
            throw YamadoriServiceError.invalidStatusTransition(from: find.status, to: .collected)
        }
        guard let genusID = find.genusID, let speciesID = find.speciesID else {
            throw YamadoriServiceError.genusAndSpeciesRequired
        }
        guard let locationID = draft.locationID else {
            throw YamadoriServiceError.locationRequired
        }
        guard validLocationIDs.contains(locationID) else {
            throw YamadoriServiceError.locationNotFound
        }

        let trip = getYamadori(id: find.yamadoriID)
        let botanicalName = TreeNamingService.makeBotanicalName(
            genus: genusName,
            species: speciesName,
            cultivar: cultivarName
        )
        var originNotes = "Collected as \(find.yamadoriCode)"
        let trimmedNotes = draft.collectionNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedNotes.isEmpty {
            originNotes += " — \(trimmedNotes)"
        }
        if let site = trip?.locationDescription, !site.isEmpty {
            originNotes += "\nWild site: \(site)"
        }

        let imageIDs = draft.copyImages ? find.imageIDs : []
        let primaryImageID = draft.copyImages ? find.primaryImageID : nil

        let tree = Tree(
            botanicalName: botanicalName,
            bonsaiName: find.yamadoriCode,
            genusID: genusID,
            speciesID: speciesID,
            cultivarID: find.cultivarID,
            treeStageID: treeStageID,
            locationID: locationID,
            sourceYamadoriID: find.id,
            yamadoriNursery: true,
            propagation: .yamadori,
            acquisitionDate: date,
            acquisitionMethodID: acquisitionMethodID,
            acquisitionNotes: originNotes,
            notes: find.notes,
            primaryImageID: primaryImageID,
            imageIDs: imageIDs
        )
        let created = try treeService.createTree(tree)

        find.status = .collected
        find.collectionDate = date
        find.linkedTreeID = created.id
        find.history.append(
            YamadoriHistoryEntry(
                kind: .collected,
                date: date,
                note: created.bonsaiName
            )
        )
        let updated = try updateFind(find)
        return (updated, created)
    }

    /// Backward-compatible Mark Collected without Tree creation inputs — requires linked Tree already.
    @discardableResult
    func markCollected(id: UUID, date: Date = .now, note: String = "") throws -> YamadoriFind {
        guard var find = getFind(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        if find.linkedTreeID != nil {
            if find.status != .collected {
                find.status = .collected
                find.collectionDate = date
                return try updateFind(find)
            }
            return find
        }
        throw YamadoriServiceError.locationRequired
    }

    static func canTransition(from: YamadoriStatus, to: YamadoriStatus) -> Bool {
        if from == to { return false }
        switch (from, to) {
        case (.scout, .collected), (.scout, .planned), (.scout, .abandoned):
            return true
        case (.planned, .collected), (.planned, .scout), (.planned, .abandoned):
            return true
        case (.collected, .recovery), (.collected, .abandoned):
            return true
        case (.recovery, .established), (.recovery, .abandoned):
            return true
        case (.established, .transferred), (.established, .abandoned):
            return true
        case (.abandoned, .archived):
            return true
        default:
            return false
        }
    }

    // MARK: - Observations & checklists

    @discardableResult
    func addObservation(id: UUID, text: String, category: String = "", date: Date = .now) throws -> YamadoriFind {
        guard var find = getFind(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return find }
        let observation = YamadoriObservation(date: date, text: trimmed, category: category)
        find.observations.append(observation)
        find.history.append(
            YamadoriHistoryEntry(kind: .observationAdded, date: date, note: String(trimmed.prefix(80)))
        )
        return try updateFind(find)
    }

    @discardableResult
    func setChecklistItem(id: UUID, itemID: UUID, isComplete: Bool, kit: Bool) throws -> Yamadori {
        guard var trip = getYamadori(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        if kit {
            if let index = trip.collectionKitChecklist.firstIndex(where: { $0.id == itemID }) {
                trip.collectionKitChecklist[index].isComplete = isComplete
            }
        } else if let index = trip.preCollectionChecklist.firstIndex(where: { $0.id == itemID }) {
            trip.preCollectionChecklist[index].isComplete = isComplete
        }
        return try updateYamadori(trip)
    }

    // MARK: - Images (Find)

    func setPrimaryImage(findID: UUID, imageID: UUID) throws {
        guard var find = getFind(id: findID) else {
            throw YamadoriRepositoryError.notFound(findID)
        }
        find.primaryImageID = imageID
        if !find.imageIDs.contains(imageID) {
            find.imageIDs.insert(imageID, at: 0)
        }
        try updateFind(find)
    }

    func addImage(findID: UUID, imageID: UUID) throws {
        guard var find = getFind(id: findID) else {
            throw YamadoriRepositoryError.notFound(findID)
        }
        guard !find.imageIDs.contains(imageID) else { return }
        find.imageIDs.append(imageID)
        if find.primaryImageID == nil {
            find.primaryImageID = imageID
        }
        try updateFind(find)
    }

    func removeImage(findID: UUID, imageID: UUID) throws {
        guard var find = getFind(id: findID) else {
            throw YamadoriRepositoryError.notFound(findID)
        }
        find.imageIDs.removeAll { $0 == imageID }
        if find.primaryImageID == imageID {
            find.primaryImageID = find.imageIDs.first
        }
        try updateFind(find)
    }

    /// Backward-compatible aliases — IDs refer to Finds.
    func setPrimaryImage(yamadoriID: UUID, imageID: UUID) throws {
        try setPrimaryImage(findID: yamadoriID, imageID: imageID)
    }

    func addImage(yamadoriID: UUID, imageID: UUID) throws {
        try addImage(findID: yamadoriID, imageID: imageID)
    }

    func removeImage(yamadoriID: UUID, imageID: UUID) throws {
        try removeImage(findID: yamadoriID, imageID: imageID)
    }

    // MARK: - Move to My Trees (Find → graduate existing Tree)

    /// Graduates the Yamadori Tree linked to this Find. Assigns a new Bonsai Name.
    @discardableResult
    func transferToTree(
        id: UUID,
        draft: YamadoriTransferDraft,
        acquisitionMethodID: UUID,
        treeStageID: UUID,
        genusName: String,
        speciesName: String,
        cultivarName: String?,
        validLocationIDs: Set<UUID>
    ) throws -> Tree {
        guard var find = getFind(id: id) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        guard find.status != .transferred else {
            throw YamadoriServiceError.alreadyTransferred
        }
        guard find.status.canTransferToTree else {
            throw YamadoriServiceError.notEstablishedForTransfer
        }
        guard let genusID = find.genusID, let speciesID = find.speciesID else {
            throw YamadoriServiceError.genusAndSpeciesRequired
        }

        if let treeID = find.linkedTreeID, var tree = treeService.getTree(id: treeID) {
            return try graduateLinkedTree(
                find: &find,
                tree: &tree,
                draft: draft,
                acquisitionMethodID: acquisitionMethodID,
                treeStageID: treeStageID,
                genusName: genusName,
                speciesName: speciesName,
                cultivarName: cultivarName,
                validLocationIDs: validLocationIDs
            )
        }

        guard let locationID = draft.locationID else {
            throw YamadoriServiceError.locationRequired
        }
        guard validLocationIDs.contains(locationID) else {
            throw YamadoriServiceError.locationNotFound
        }

        let trip = getYamadori(id: find.yamadoriID)
        let acquisitionDate = draft.acquisitionDate
            ?? find.collectionDate
            ?? Date.now
        let year = Calendar.current.component(.year, from: acquisitionDate)
        let sequence = treeService.nextBonsaiNameSequence(for: speciesID)
        let bonsaiName = TreeNamingService.makeBonsaiName(
            genusName: genusName,
            speciesName: speciesName,
            cultivarName: cultivarName,
            acquisitionYear: year,
            sequence: sequence
        )
        guard !bonsaiName.isEmpty else {
            throw YamadoriServiceError.bonsaiNameRequired
        }

        let botanicalName = TreeNamingService.makeBotanicalName(
            genus: genusName,
            species: speciesName,
            cultivar: cultivarName
        )

        var originNotes = "Transferred from \(find.yamadoriCode)"
        let trimmedTransfer = draft.transferNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTransfer.isEmpty {
            originNotes += " — \(trimmedTransfer)"
        }
        if let site = trip?.locationDescription, !site.isEmpty {
            originNotes += "\nWild site: \(site)"
        }

        let imageIDs = draft.copyImages ? find.imageIDs : []
        let primaryImageID = draft.copyImages ? find.primaryImageID : nil

        let tree = Tree(
            botanicalName: botanicalName,
            nickname: draft.nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            bonsaiName: bonsaiName,
            genusID: genusID,
            speciesID: speciesID,
            cultivarID: find.cultivarID,
            treeStageID: treeStageID,
            locationID: locationID,
            sourceYamadoriID: find.id,
            propagation: .yamadori,
            acquisitionDate: acquisitionDate,
            acquisitionMethodID: acquisitionMethodID,
            acquisitionNotes: originNotes,
            notes: find.notes,
            primaryImageID: primaryImageID,
            imageIDs: imageIDs
        )

        let created = try treeService.createTree(tree)

        let now = Date.now
        find.status = .transferred
        find.transferDate = now
        find.linkedTreeID = created.id
        find.transferNotes = trimmedTransfer
        find.history.append(
            YamadoriHistoryEntry(
                kind: .transferred,
                date: now,
                note: created.bonsaiName
            )
        )
        _ = try updateFind(find)
        return created
    }

    private func graduateLinkedTree(
        find: inout YamadoriFind,
        tree: inout Tree,
        draft: YamadoriTransferDraft,
        acquisitionMethodID: UUID,
        treeStageID: UUID,
        genusName: String,
        speciesName: String,
        cultivarName: String?,
        validLocationIDs: Set<UUID>
    ) throws -> Tree {
        guard let speciesID = find.speciesID else {
            throw YamadoriServiceError.genusAndSpeciesRequired
        }
        if let locationID = draft.locationID {
            guard validLocationIDs.contains(locationID) else {
                throw YamadoriServiceError.locationNotFound
            }
            tree.locationID = locationID
        }

        let acquisitionDate = draft.acquisitionDate
            ?? find.collectionDate
            ?? tree.acquisitionDate
            ?? Date.now
        let year = Calendar.current.component(.year, from: acquisitionDate)
        let sequence = treeService.nextBonsaiNameSequence(for: speciesID)
        let bonsaiName = TreeNamingService.makeBonsaiName(
            genusName: genusName,
            speciesName: speciesName,
            cultivarName: cultivarName,
            acquisitionYear: year,
            sequence: sequence
        )
        guard !bonsaiName.isEmpty else {
            throw YamadoriServiceError.bonsaiNameRequired
        }

        tree.bonsaiName = bonsaiName
        tree.nickname = draft.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        tree.treeStageID = treeStageID
        tree.acquisitionMethodID = acquisitionMethodID
        tree.acquisitionDate = acquisitionDate
        tree.yamadoriNursery = false

        let trimmedTransfer = draft.transferNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTransfer.isEmpty {
            let prefix = tree.acquisitionNotes.isEmpty ? "" : "\n"
            tree.acquisitionNotes += "\(prefix)Moved to My Trees — \(trimmedTransfer)"
        }

        if draft.copyImages {
            for imageID in find.imageIDs where !tree.imageIDs.contains(imageID) {
                tree.imageIDs.append(imageID)
            }
            if tree.primaryImageID == nil {
                tree.primaryImageID = find.primaryImageID ?? find.imageIDs.first
            }
        }

        let updated = try treeService.graduateYamadoriTree(tree)

        let now = Date.now
        find.status = .transferred
        find.transferDate = now
        find.transferNotes = trimmedTransfer
        find.history.append(
            YamadoriHistoryEntry(
                kind: .transferred,
                date: now,
                note: updated.bonsaiName
            )
        )
        _ = try updateFind(find)
        return updated
    }
}

extension YamadoriService {
    static func preview(
        trips: [Yamadori] = [],
        finds: [YamadoriFind] = [],
        treeService: TreeService
    ) -> YamadoriService {
        YamadoriService(
            repository: PreviewYamadoriRepository(trips: trips, finds: finds),
            treeService: treeService
        )
    }
}
