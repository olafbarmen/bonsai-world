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
    /// This is the single write path — Tree Detail's Add Activity, and later the
    /// Work module / Mobile Companion, all call through here.
    @discardableResult
    func registerWork(
        workTypeID: UUID,
        treeIDs: [UUID],
        performedAt: Date = .now,
        notes: String = "",
        fertilizerTypeID: UUID? = nil,
        scheduleID: UUID? = nil
    ) throws -> WorkRecord {
        guard !treeIDs.isEmpty else { throw WorkServiceError.noTrees }
        guard referenceData.workType(id: workTypeID) != nil else { throw WorkServiceError.unknownWorkType }

        let record = WorkRecord(
            workTypeID: workTypeID,
            treeIDs: treeIDs,
            performedAt: performedAt,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            fertilizerTypeID: fertilizerTypeID,
            scheduleID: scheduleID
        )

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
