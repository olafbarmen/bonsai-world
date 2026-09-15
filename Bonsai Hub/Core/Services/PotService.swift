//
//  PotService.swift
//  Bonsai World
//
//  Application-facing Pot API. Views talk only to PotService — never to
//  PotRepository or the pot catalog directly.
//
//  Owns the Pot ↔ Tree relationship: Tree stores only ``Tree/currentPotID``, and
//  this service is the sole place that keeps a Pot's ``Pot/linkedTreeID`` / status
//  and the Tree's ``Tree/currentPotID`` in sync, appending Pot History for every
//  lifecycle change (Purchased, Linked, Unlinked, Sold, Broken, Retired).
//
//  Dependency flow:
//    Views → PotService → PotRepository
//    PotService → TreeService (one-directional; TreeService knows nothing of Pot)
//

import Foundation
import Observation

/// Coordinates Pot access for Features. Backed by any `PotRepository`.
@Observable
@MainActor
final class PotService {
    private let repository: any PotRepository
    private let treeService: TreeService

    /// Observable snapshot of all pots. Refreshed after every mutating call.
    private(set) var pots: [Pot]

    init(repository: any PotRepository, treeService: TreeService) {
        self.repository = repository
        self.treeService = treeService
        self.pots = repository.getAllPots()
    }

    private func reload() {
        pots = repository.getAllPots()
    }

    // MARK: - Reads

    func getAllPots() -> [Pot] {
        pots
    }

    func getPot(id: UUID) -> Pot? {
        pots.first { $0.id == id }
    }

    /// Pots normally offered when assigning to a Tree (Status == Available).
    var availablePots: [Pot] {
        pots.filter { $0.status == .available }
    }

    /// Pots for a given lifecycle status, sorted by name.
    func pots(status: PotStatus) -> [Pot] {
        pots.filter { $0.status == status }
    }

    func pot(linkedToTreeID treeID: UUID) -> Pot? {
        pots.first { $0.linkedTreeID == treeID }
    }

    /// True when any Pot still references this Brand — Settings should offer
    /// Archive instead of Delete in that case.
    func isBrandInUse(_ brandID: UUID) -> Bool {
        pots.contains { $0.brandID == brandID }
    }

    /// True when any Pot still references this Maker — Settings should offer
    /// Archive instead of Delete in that case.
    func isMakerInUse(_ makerID: UUID) -> Bool {
        pots.contains { $0.makerID == makerID }
    }

    // MARK: - Create

    @discardableResult
    func createPot(fromDraft draft: NewPotDraft) throws -> Pot {
        let now = Date.now
        var history: [PotHistoryEntry] = [PotHistoryEntry(kind: .created, date: now)]
        if let purchaseDate = draft.purchaseDate {
            history.append(PotHistoryEntry(kind: .purchased, date: purchaseDate, note: draft.purchaseSellerName))
        }

        let pot = Pot(
            name: draft.name.trimmingCharacters(in: .whitespacesAndNewlines),
            potTypeID: draft.potTypeID,
            brandID: draft.brandID,
            makerID: draft.makerID,
            material: draft.material.trimmingCharacters(in: .whitespacesAndNewlines),
            glaze: draft.glaze.trimmingCharacters(in: .whitespacesAndNewlines),
            shape: draft.shape.trimmingCharacters(in: .whitespacesAndNewlines),
            lengthMillimetres: draft.lengthMillimetres,
            widthMillimetres: draft.widthMillimetres,
            heightMillimetres: draft.heightMillimetres,
            diameterMillimetres: draft.diameterMillimetres,
            condition: draft.condition.trimmingCharacters(in: .whitespacesAndNewlines),
            purchaseDate: draft.purchaseDate,
            purchasePrice: draft.purchasePrice,
            purchaseSellerName: draft.purchaseSellerName.trimmingCharacters(in: .whitespacesAndNewlines),
            purchaseNotes: draft.purchaseNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            history: history,
            createdDate: now,
            modifiedDate: now
        )
        return try createPot(pot)
    }

    @discardableResult
    func createPot(_ pot: Pot) throws -> Pot {
        let created = try repository.createPot(pot)
        reload()
        return created
    }

    // MARK: - Update

    /// Replaces an existing pot. Rejects any attempt to change Pot ID.
    @discardableResult
    func updatePot(_ pot: Pot) throws -> Pot {
        guard let existing = repository.getPot(id: pot.id) else {
            throw PotRepositoryError.notFound(pot.id)
        }
        guard pot.id == existing.id else {
            throw PotServiceError.potIdentityLocked
        }
        var updated = pot
        updated.modifiedDate = .now
        let saved = try repository.updatePot(updated)
        reload()
        return saved
    }

    /// Commits a Pot Detail Edit Mode draft. Status, Current Use, and History are
    /// never taken from this draft — those change only through the lifecycle methods
    /// below so Tree ↔ Pot sync and history stay correct.
    func applyDetailDraft(id: UUID, draft: PotDetailDraft) throws {
        guard var pot = getPot(id: id) else {
            throw PotRepositoryError.notFound(id)
        }
        pot.name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.potTypeID = draft.potTypeID
        pot.brandID = draft.brandID
        pot.makerID = draft.makerID
        pot.generationPeriod = draft.generationPeriod.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.madeYear = draft.madeYear
        pot.estimatedFromYear = draft.estimatedFromYear
        pot.estimatedToYear = draft.estimatedToYear
        pot.datingConfidence = draft.datingConfidence
        pot.datingNotes = draft.datingNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.material = draft.material.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.glaze = draft.glaze.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.shape = draft.shape.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.lengthMillimetres = draft.lengthMillimetres
        pot.widthMillimetres = draft.widthMillimetres
        pot.heightMillimetres = draft.heightMillimetres
        pot.diameterMillimetres = draft.diameterMillimetres
        pot.condition = draft.condition.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.purchaseDate = draft.purchaseDate
        pot.purchasePrice = draft.purchasePrice
        pot.purchaseSellerName = draft.purchaseSellerName.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.purchaseNotes = draft.purchaseNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.notes = draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.primaryImageID = draft.primaryImageID
        pot.imageIDs = draft.imageIDs
        pot.stampImageIDs = draft.stampImageIDs
        try updatePot(pot)
    }

    /// Removes the pot with the given id. Reserved for mistaken / duplicate records
    /// — never for Sold, Broken, or Retired pots (use the lifecycle methods instead).
    /// Unlinks from any Tree first (with history) so the Tree never points at a missing Pot.
    func deletePot(id: UUID) throws {
        if let pot = getPot(id: id), let treeID = pot.linkedTreeID {
            try unassignCurrentPot(fromTreeID: treeID)
        } else if let tree = treeService.trees.first(where: { $0.currentPotID == id }) {
            // Repair path: Tree still points here but Pot.linkedTreeID was already clear.
            treeService.setCurrentPotID(nil, forTreeID: tree.id)
        }
        try repository.deletePot(id: id)
        reload()
    }

    // MARK: - Tree relationship

    /// Assigns `potID` to `treeID`. Unassigns any pot already on that Tree, and
    /// clears the Tree side for any other Tree the pot itself was linked to.
    /// Requires the pot to be Available (or already linked only to this same Tree).
    func assignPot(_ potID: UUID, toTreeID treeID: UUID) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }

        // Defensive: if this pot still points at another Tree, clear that side first
        // so one Pot cannot remain current on two Trees.
        if let previousTreeID = pot.linkedTreeID, previousTreeID != treeID {
            try clearTreeCurrentPotIfMatching(treeID: previousTreeID, potID: potID)
            pot.linkedTreeID = nil
            if pot.status == .inUse {
                pot.status = .available
            }
            pot.history.append(
                PotHistoryEntry(
                    kind: .unlinkedFromTree,
                    note: treeService.getTree(id: previousTreeID)?.bonsaiName ?? "",
                    relatedTreeID: previousTreeID
                )
            )
            try updatePot(pot)
            pot = getPot(id: potID) ?? pot
        }

        guard pot.status == .available || (pot.status == .inUse && pot.linkedTreeID == treeID) else {
            throw PotServiceError.potNotAvailable
        }
        if pot.linkedTreeID == treeID, treeService.getTree(id: treeID)?.currentPotID == potID {
            return
        }

        // Free whatever pot the tree currently has, if different.
        if let currentPot = potLinkedOrReferenced(byTreeID: treeID), currentPot.id != potID {
            try unassignCurrentPot(fromTreeID: treeID)
            pot = getPot(id: potID) ?? pot
        }

        pot.status = .inUse
        pot.linkedTreeID = treeID
        pot.history.append(
            PotHistoryEntry(
                kind: .linkedToTree,
                note: treeService.getTree(id: treeID)?.bonsaiName ?? "",
                relatedTreeID: treeID
            )
        )
        try updatePot(pot)

        treeService.setCurrentPotID(potID, forTreeID: treeID)
    }

    /// Unassigns whichever pot is linked to `treeID`, returning it to Available.
    /// Also repairs a Tree that still has ``Tree/currentPotID`` when the Pot side
    /// was cleared inconsistently. A no-op when neither side references a pot.
    func unassignCurrentPot(fromTreeID treeID: UUID) throws {
        var pot = pot(linkedToTreeID: treeID)
        if pot == nil, let potID = treeService.getTree(id: treeID)?.currentPotID {
            pot = getPot(id: potID)
        }
        guard var pot else {
            treeService.setCurrentPotID(nil, forTreeID: treeID)
            return
        }

        pot.linkedTreeID = nil
        if pot.status == .inUse {
            pot.status = .available
        }
        pot.history.append(
            PotHistoryEntry(kind: .unlinkedFromTree, relatedTreeID: treeID)
        )
        try updatePot(pot)

        treeService.setCurrentPotID(nil, forTreeID: treeID)
    }

    /// Pot currently associated with a Tree via ``Pot/linkedTreeID``, or via the
    /// Tree's ``Tree/currentPotID`` when repairing a one-sided link.
    private func potLinkedOrReferenced(byTreeID treeID: UUID) -> Pot? {
        if let pot = pot(linkedToTreeID: treeID) { return pot }
        if let potID = treeService.getTree(id: treeID)?.currentPotID {
            return getPot(id: potID)
        }
        return nil
    }

    private func clearTreeCurrentPotIfMatching(treeID: UUID, potID: UUID) {
        guard treeService.getTree(id: treeID)?.currentPotID == potID else { return }
        treeService.setCurrentPotID(nil, forTreeID: treeID)
    }

    // MARK: - Lifecycle

    /// Marks a pot Sold. Unassigns it from any Tree first — a sold pot cannot stay In Use.
    func markSold(potID: UUID, date: Date, price: Decimal?, buyerName: String, notes: String) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }
        if let treeID = pot.linkedTreeID {
            try unassignCurrentPot(fromTreeID: treeID)
            pot = getPot(id: potID) ?? pot
        }
        pot.status = .sold
        pot.saleDate = date
        pot.salePrice = price
        pot.saleBuyerName = buyerName.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.saleNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.history.append(PotHistoryEntry(kind: .sold, date: date, note: buyerName))
        try updatePot(pot)
    }

    /// Marks a pot Broken. Unassigns it from any Tree first.
    func markBroken(potID: UUID, date: Date, reason: String, notes: String) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }
        if let treeID = pot.linkedTreeID {
            try unassignCurrentPot(fromTreeID: treeID)
            pot = getPot(id: potID) ?? pot
        }
        pot.status = .broken
        pot.brokenDate = date
        pot.brokenReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.brokenNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.history.append(PotHistoryEntry(kind: .broken, date: date, note: reason))
        try updatePot(pot)
    }

    /// Marks a pot Retired (no longer in active use, but not sold or broken).
    /// Unassigns it from any Tree first.
    func markRetired(potID: UUID, date: Date, notes: String) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }
        if let treeID = pot.linkedTreeID {
            try unassignCurrentPot(fromTreeID: treeID)
            pot = getPot(id: potID) ?? pot
        }
        pot.status = .retired
        pot.retiredDate = date
        pot.retiredNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        pot.history.append(PotHistoryEntry(kind: .retired, date: date, note: notes))
        try updatePot(pot)
    }

    /// Reverses a mistaken Sold / Broken / Retired status back to Available.
    /// Also clears any lingering Tree link so Available never means “still in use”.
    func returnToAvailable(potID: UUID) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }
        if let treeID = pot.linkedTreeID {
            try unassignCurrentPot(fromTreeID: treeID)
            pot = getPot(id: potID) ?? pot
        } else if let tree = treeService.trees.first(where: { $0.currentPotID == potID }) {
            treeService.setCurrentPotID(nil, forTreeID: tree.id)
        }

        // Unassign already returns In Use → Available with unlink history.
        if pot.status == .available {
            return
        }

        pot.status = .available
        pot.linkedTreeID = nil
        pot.history.append(PotHistoryEntry(kind: .returnedToAvailable))
        try updatePot(pot)
    }

    // MARK: - Images

    func setPrimaryImage(potID: UUID, imageID: UUID) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }
        pot.primaryImageID = imageID
        if !pot.imageIDs.contains(imageID) {
            pot.imageIDs.insert(imageID, at: 0)
        }
        try updatePot(pot)
    }

    /// Removes a photo from the pot gallery (does not delete catalog bytes).
    func removeImage(potID: UUID, imageID: UUID) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }
        pot.imageIDs.removeAll { $0 == imageID }
        if pot.primaryImageID == imageID {
            pot.primaryImageID = pot.imageIDs.first
        }
        try updatePot(pot)
    }

    /// Adds a photo of the actual stamp on this pot (separate from Brand/Maker
    /// Stamp References).
    func addStampImage(potID: UUID, imageID: UUID) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }
        guard !pot.stampImageIDs.contains(imageID) else { return }
        pot.stampImageIDs.append(imageID)
        try updatePot(pot)
    }

    func removeStampImage(potID: UUID, imageID: UUID) throws {
        guard var pot = getPot(id: potID) else {
            throw PotRepositoryError.notFound(potID)
        }
        pot.stampImageIDs.removeAll { $0 == imageID }
        try updatePot(pot)
    }
}

extension PotService {
    /// Preview bootstrap.
    static func preview(pots: [Pot] = [], treeService: TreeService) -> PotService {
        PotService(repository: PreviewPotRepository(pots: pots), treeService: treeService)
    }
}
