//
//  WorkService.swift
//  Bonsai World
//
//  Workshop domain (working name) — technical surface: Work module / WorkService.
//  Application-facing API for planned and recorded practical care.
//  Work Types come from Reference Data. Trees display history; they never own registration.
//
//  Domain terminology: ``WorkingDomainID/workshop`` / ``WorkingDomainCatalog``.
//  Prepared for: wiring, pruning, repotting, fertilizing, watering, winter work,
//  batch operations, templates — not fully implemented yet.
//

import Foundation
import Observation

@Observable
@MainActor
final class WorkService {
    /// Working domain this service belongs to (terminology — not a storage key).
    static let workingDomain: WorkingDomainID = .workshop

    private let referenceData: ReferenceDataService

    /// Session work history. Empty until Workshop workflows land.
    private(set) var records: [WorkRecord] = []

    init(referenceData: ReferenceDataService) {
        self.referenceData = referenceData
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

    // MARK: - Work History (Trees consume; Workshop / Work module will write)

    func history(for treeID: UUID) -> [WorkRecord] {
        records
            .filter { $0.treeIDs.contains(treeID) }
            .sorted { $0.performedAt > $1.performedAt }
    }

    func recentRecords(limit: Int = 50) -> [WorkRecord] {
        Array(records.sorted { $0.performedAt > $1.performedAt }.prefix(limit))
    }

    /// Most recent completed work touching any of the given Trees (Location Inspector).
    func lastWork(involving treeIDs: [UUID]) -> WorkRecord? {
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
}
