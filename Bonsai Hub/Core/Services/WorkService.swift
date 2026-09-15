//
//  WorkService.swift
//  Bonsai World
//
//  Workshop domain (working name) — technical surface: Work module / WorkService.
//  Application-facing API for planned and recorded practical care.
//  Work Types come from Reference Data. Trees display history; they never own registration.
//
//  Domain terminology: ``WorkingDomainID/workshop`` / ``WorkingDomainCatalog``.
//  Work records persist through an injected WorkRepository — an in-memory session
//  store before a Library exists, Database/Work.json once one is open (mirrors
//  Garden/Location; see ``attachLibraryWorkRepository(_:)``). Platform-agnostic by
//  design: a future Mobile Companion (field registration) or Windows client reads
//  and writes through the same WorkRepository contract against the shared Library.
//
//  Prepared for: wiring, pruning, repotting, fertilizing, watering, winter work,
//  batch operations, templates — not fully implemented yet.
//

import Foundation
import Observation

/// Errors surfaced to callers registering or editing Work.
enum WorkServiceError: Error, LocalizedError, Sendable {
    case noTrees
    case unknownWorkType

    var errorDescription: String? {
        switch self {
        case .noTrees:
            return "Select at least one tree for this work."
        case .unknownWorkType:
            return "Choose a Work Type before saving."
        }
    }
}

@Observable
@MainActor
final class WorkService {
    /// Working domain this service belongs to (terminology — not a storage key).
    static let workingDomain: WorkingDomainID = .workshop

    private let referenceData: ReferenceDataService
    private var workRepository: WorkRepository

    /// Work history — loaded from the injected repository, empty session by default.
    private(set) var records: [WorkRecord] = []
    private(set) var revision: Int = 0

    init(referenceData: ReferenceDataService, workRepository: WorkRepository? = nil) {
        self.referenceData = referenceData
        self.workRepository = workRepository ?? PreviewWorkRepository()
        records = self.workRepository.getAllWork()
    }

    /// Switches Work persistence to a Library-backed repository once one becomes
    /// available (mirrors `UserProfileStore.attachLibraryGardenRepository(_:)`).
    /// Work has no legacy data to migrate, so this simply adopts whatever the
    /// repository already holds (empty on first library, populated on reopen).
    func attachLibraryWorkRepository(_ repository: WorkRepository) {
        workRepository = repository
        records = repository.getAllWork()
        revision += 1
    }

    // MARK: - Work Types (Reference Data)

    /// Active Work Types for pickers and the Work module browser.
    var workTypes: [WorkType] {
        referenceData.workTypes
    }

    func workType(id: UUID) -> WorkType? {
        referenceData.workType(id: id)
    }

    func workTypes(in category: WorkTypeCategory) -> [WorkType] {
        workTypes.filter { $0.category == category }
    }

    // MARK: - Work History (reads)

    func history(for treeID: UUID) -> [WorkRecord] {
        _ = revision
        return records
            .filter { $0.treeIDs.contains(treeID) }
            .sorted { $0.performedAt > $1.performedAt }
    }

    /// Most recent completed Repotting work for a Tree (Work Type name contains "repot").
    /// Excludes future-dated scheduled rows. Nil when no completed repot is recorded.
    func lastCompletedRepottingDate(for treeID: UUID) -> Date? {
        _ = revision
        let now = Date.now
        return records
            .filter { record in
                record.treeIDs.contains(treeID)
                    && record.performedAt <= now
                    && isRepotting(workTypeID: record.workTypeID)
            }
            .map(\.performedAt)
            .max()
    }

    /// Completed Repotting Work records, newest first.
    func recentRepottingRecords(limit: Int = 25) -> [WorkRecord] {
        _ = revision
        let now = Date.now
        return Array(
            records
                .filter { $0.performedAt <= now && isRepotting(workTypeID: $0.workTypeID) }
                .sorted { $0.performedAt > $1.performedAt }
                .prefix(limit)
        )
    }

    /// Preferred Work Type for Register Watering (`expiresIfMissed` or name contains “water”).
    func preferredWateringWorkTypeID() -> UUID? {
        if let flagged = workTypes.first(where: { $0.behaviour.expiresIfMissed }) {
            return flagged.id
        }
        return workTypes.first { $0.name.localizedCaseInsensitiveContains("water") }?.id
    }

    /// Whether this Work Type is treated as watering / expires-if-missed care.
    func isWatering(workTypeID: UUID) -> Bool {
        guard let type = workType(id: workTypeID) else { return false }
        return type.behaviour.expiresIfMissed
            || type.name.localizedCaseInsensitiveContains("water")
    }

    /// Most recent completed watering Work for a Tree.
    func lastCompletedWateringDate(for treeID: UUID) -> Date? {
        _ = revision
        let now = Date.now
        return records
            .filter { record in
                record.treeIDs.contains(treeID)
                    && record.performedAt <= now
                    && isWatering(workTypeID: record.workTypeID)
            }
            .map(\.performedAt)
            .max()
    }

    /// Completed watering Work records, newest first.
    func recentWateringRecords(limit: Int = 40) -> [WorkRecord] {
        _ = revision
        let now = Date.now
        return Array(
            records
                .filter { $0.performedAt <= now && isWatering(workTypeID: $0.workTypeID) }
                .sorted { $0.performedAt > $1.performedAt }
                .prefix(limit)
        )
    }

    /// Preferred Work Type for Register Repotting (name contains "repot").
    func preferredRepottingWorkTypeID() -> UUID? {
        workTypes.first { isRepotting(workTypeID: $0.id) }?.id
    }

    /// Same Work Type heuristic as Tasks → Needs Repotting.
    func isRepotting(workTypeID: UUID) -> Bool {
        let name = workType(id: workTypeID)?.name ?? ""
        return name.localizedCaseInsensitiveContains("repot")
    }

    /// Preferred Work Type for Fertilizing (`requiresFertilizer` or name contains “fertiliz”).
    func preferredFertilizingWorkTypeID() -> UUID? {
        if let flagged = workTypes.first(where: { $0.behaviour.requiresFertilizer }) {
            return flagged.id
        }
        return workTypes.first { isFertilizing(workTypeID: $0.id) }?.id
    }

    func isFertilizing(workTypeID: UUID) -> Bool {
        guard let type = workType(id: workTypeID) else { return false }
        return type.behaviour.requiresFertilizer
            || type.name.localizedCaseInsensitiveContains("fertiliz")
    }

    func lastCompletedFertilizingDate(for treeID: UUID) -> Date? {
        _ = revision
        let now = Date.now
        return records
            .filter { record in
                record.treeIDs.contains(treeID)
                    && record.performedAt <= now
                    && isFertilizing(workTypeID: record.workTypeID)
            }
            .map(\.performedAt)
            .max()
    }

    func recentFertilizingRecords(limit: Int = 25) -> [WorkRecord] {
        _ = revision
        let now = Date.now
        return Array(
            records
                .filter { $0.performedAt <= now && isFertilizing(workTypeID: $0.workTypeID) }
                .sorted { $0.performedAt > $1.performedAt }
                .prefix(limit)
        )
    }

    /// Preferred Work Type in a Reference Data category (first match by sort order / name).
    func preferredWorkTypeID(in category: WorkTypeCategory) -> UUID? {
        workTypes(in: category).first?.id
    }

    func isWorkType(_ workTypeID: UUID, in category: WorkTypeCategory) -> Bool {
        workType(id: workTypeID)?.category == category
    }

    func recentRecords(in category: WorkTypeCategory, limit: Int = 25) -> [WorkRecord] {
        _ = revision
        let now = Date.now
        return Array(
            records
                .filter { $0.performedAt <= now && isWorkType($0.workTypeID, in: category) }
                .sorted { $0.performedAt > $1.performedAt }
                .prefix(limit)
        )
    }

    /// Recent Work whose Work Type name matches Winter / Frost (Care → Winter Care).
    func recentWinterCareRecords(limit: Int = 25) -> [WorkRecord] {
        _ = revision
        let now = Date.now
        return Array(
            records
                .filter { record in
                    record.performedAt <= now
                        && TaskService.matchesWinterCareWorkTypeName(workType(id: record.workTypeID)?.name ?? "")
                }
                .sorted { $0.performedAt > $1.performedAt }
                .prefix(limit)
        )
    }

    /// Preferred Winter Care Work Type (Preparation → Wash → Storage → Frost → any Winter/Frost name).
    func preferredWinterCareWorkTypeID() -> UUID? {
        let preferredNames = [
            "Winter Preparation",
            "Winter Wash",
            "Move to Winter Storage",
            "Frost Protection"
        ]
        for name in preferredNames {
            if let id = referenceData.workTypes.first(where: { $0.name == name })?.id {
                return id
            }
        }
        return referenceData.workTypes.first {
            TaskService.matchesWinterCareWorkTypeName($0.name)
        }?.id
    }

    /// Preferred Placement-related Seasonal Work Type (Return / Shade / Move / Heat).
    func preferredPlacementWorkTypeID() -> UUID? {
        let preferredNames = [
            "Return Outdoors",
            "Shade Installation",
            "Shade Removal",
            "Move to Winter Storage",
            "Heat Protection"
        ]
        for name in preferredNames {
            if let id = referenceData.workTypes.first(where: { $0.name == name })?.id {
                return id
            }
        }
        return preferredWorkTypeID(in: .seasonal)
    }

    func lastCompletedDate(for treeID: UUID, in category: WorkTypeCategory) -> Date? {
        _ = revision
        let now = Date.now
        return records
            .filter { record in
                record.treeIDs.contains(treeID)
                    && record.performedAt <= now
                    && isWorkType(record.workTypeID, in: category)
            }
            .map(\.performedAt)
            .max()
    }

    func recentRecords(limit: Int = 50) -> [WorkRecord] {
        _ = revision
        return Array(records.sorted { $0.performedAt > $1.performedAt }.prefix(limit))
    }

    /// Most recent completed work touching any of the given Trees (Location Inspector).
    func lastWork(involving treeIDs: [UUID]) -> WorkRecord? {
        _ = revision
        guard !treeIDs.isEmpty else { return nil }
        let idSet = Set(treeIDs)
        return records
            .filter { record in record.treeIDs.contains(where: idSet.contains) }
            .sorted { $0.performedAt > $1.performedAt }
            .first
    }

    /// Next scheduled work for Trees at a Location.
    /// Reserved until scheduling workflows write ``WorkRecord/scheduleID``.
    func nextScheduledWork(involving treeIDs: [UUID]) -> WorkRecord? {
        _ = revision
        guard !treeIDs.isEmpty else { return nil }
        let idSet = Set(treeIDs)
        let now = Date.now
        return records
            .filter { record in
                record.scheduleID != nil
                    && record.performedAt > now
                    && record.treeIDs.contains(where: idSet.contains)
            }
            .sorted { $0.performedAt < $1.performedAt }
            .first
    }

    // MARK: - Work History (writes)

    /// Registers a completed (or scheduled) Work entry against one or more Trees.
    /// This is the single write path — Context Tools → Add Work, and later the
    /// Work module / Mobile Companion, all call through here.
    @discardableResult
    func registerWork(
        workTypeID: UUID,
        treeIDs: [UUID],
        performedAt: Date = .now,
        notes: String = "",
        fertilizerTypeID: UUID? = nil,
        scheduleID: UUID? = nil,
        shapingAreaID: String? = nil,
        shapingHistoryEntryID: UUID? = nil
    ) throws -> WorkRecord {
        guard !treeIDs.isEmpty else { throw WorkServiceError.noTrees }
        guard referenceData.workType(id: workTypeID) != nil else { throw WorkServiceError.unknownWorkType }

        let record = WorkRecord(
            workTypeID: workTypeID,
            treeIDs: treeIDs,
            performedAt: performedAt,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            fertilizerTypeID: fertilizerTypeID,
            scheduleID: scheduleID,
            shapingAreaID: shapingAreaID,
            shapingHistoryEntryID: shapingHistoryEntryID
        )

        try workRepository.createWork(record)
        records.append(record)
        revision += 1
        return record
    }

    @discardableResult
    func importWorkRecord(_ record: WorkRecord) throws -> WorkRecord {
        guard !record.treeIDs.isEmpty else { throw WorkServiceError.noTrees }
        guard referenceData.workType(id: record.workTypeID) != nil else { throw WorkServiceError.unknownWorkType }

        try workRepository.createWork(record)
        records.append(record)
        revision += 1
        return record
    }

    @discardableResult
    func updateWork(_ record: WorkRecord) throws -> WorkRecord {
        var updated = record
        updated.modifiedDate = .now
        try workRepository.updateWork(updated)
        if let index = records.firstIndex(where: { $0.id == updated.id }) {
            records[index] = updated
        }
        revision += 1
        return updated
    }

    func deleteWork(id: UUID) throws {
        try workRepository.deleteWork(id: id)
        records.removeAll { $0.id == id }
        revision += 1
    }
}
