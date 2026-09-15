//
//  DemoLibrary.swift
//  BonsaiCore
//
//  In-memory demo library for Bonsai World Mobile v1.
//  No disk, no iCloud — session-only sample data.
//

import Foundation
import Observation

@Observable
public final class DemoLibrary: @unchecked Sendable {
    public private(set) var trees: [Tree]
    public private(set) var workRecords: [WorkRecord]

    public init(trees: [Tree] = DemoLibrary.sampleTrees, workRecords: [WorkRecord] = []) {
        self.trees = trees
        if workRecords.isEmpty {
            self.workRecords = DemoLibrary.sampleWork(for: trees)
        } else {
            self.workRecords = workRecords
        }
    }

    public func tree(id: UUID) -> Tree? {
        trees.first { $0.id == id }
    }

    public func work(for treeID: UUID) -> [WorkRecord] {
        workRecords
            .filter { $0.treeIDs.contains(treeID) }
            .sorted { $0.performedAt > $1.performedAt }
    }

    public func addWork(
        treeID: UUID,
        workTypeID: UUID,
        performedAt: Date = .now,
        notes: String = ""
    ) {
        let record = WorkRecord(
            workTypeID: workTypeID,
            treeIDs: [treeID],
            performedAt: performedAt,
            notes: notes
        )
        workRecords.insert(record, at: 0)
        if let index = trees.firstIndex(where: { $0.id == treeID }) {
            trees[index].modifiedDate = .now
        }
    }

    // MARK: - Sample data

    private static let mapleID = UUID(uuidString: "B2000000-0000-4000-8000-000000000001")!
    private static let juniperID = UUID(uuidString: "B2000000-0000-4000-8000-000000000002")!
    private static let pineID = UUID(uuidString: "B2000000-0000-4000-8000-000000000003")!

    public static let sampleTrees: [Tree] = [
        Tree(
            id: mapleID,
            botanicalName: "Acer palmatum",
            nickname: "Terrace Maple",
            bonsaiName: "ACE-PAL-2020-001",
            notes: "Demo tree — refinement stage. Water when the surface starts to dry.",
            healthStatus: .thriving
        ),
        Tree(
            id: juniperID,
            botanicalName: "Juniperus chinensis",
            nickname: "Garden Juniper",
            bonsaiName: "JUN-CHI-2018-014",
            notes: "Demo tree — structural wiring planned for autumn.",
            healthStatus: .stable
        ),
        Tree(
            id: pineID,
            botanicalName: "Pinus sylvestris",
            nickname: "",
            bonsaiName: "PIN-SYL-2015-003",
            notes: "Demo tree — candle work next spring.",
            healthStatus: .needsAttention
        )
    ]

    private static func sampleWork(for trees: [Tree]) -> [WorkRecord] {
        guard let maple = trees.first(where: { $0.id == mapleID }),
              let juniper = trees.first(where: { $0.id == juniperID })
        else { return [] }

        let day: TimeInterval = 24 * 60 * 60
        return [
            WorkRecord(
                workTypeID: DemoWorkTypes.watering.id,
                treeIDs: [maple.id],
                performedAt: Date().addingTimeInterval(-1 * day),
                notes: "Morning watering."
            ),
            WorkRecord(
                workTypeID: DemoWorkTypes.pruning.id,
                treeIDs: [maple.id],
                performedAt: Date().addingTimeInterval(-12 * day),
                notes: "Light tip prune."
            ),
            WorkRecord(
                workTypeID: DemoWorkTypes.fertilizing.id,
                treeIDs: [juniper.id],
                performedAt: Date().addingTimeInterval(-5 * day),
                notes: "Organic pellets."
            )
        ]
    }
}
