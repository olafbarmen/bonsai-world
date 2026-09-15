//
//  WorkRecord.swift
//  BonsaiCore
//
//  Shared work-history entry. Shape aligns with Mac `WorkRecord`
//  (workTypeID + treeIDs + performedAt + notes) for future sync.
//

import Foundation

public struct WorkRecord: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    /// Reference Data — Work Type (UUID). Demo uses fixed catalog IDs.
    public var workTypeID: UUID
    public var treeIDs: [UUID]
    public var performedAt: Date
    public var notes: String
    public var createdDate: Date
    public var modifiedDate: Date

    public init(
        id: UUID = UUID(),
        workTypeID: UUID,
        treeIDs: [UUID],
        performedAt: Date = .now,
        notes: String = "",
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.workTypeID = workTypeID
        self.treeIDs = treeIDs
        self.performedAt = performedAt
        self.notes = notes
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}

/// Demo / mobile catalog entry until Reference Data is shared.
public struct WorkTypeInfo: Identifiable, Hashable, Sendable {
    public var id: UUID
    public var name: String

    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

public enum DemoWorkTypes {
    public static let watering = WorkTypeInfo(
        id: UUID(uuidString: "A1000000-0000-4000-8000-000000000001")!,
        name: "Watering"
    )
    public static let pruning = WorkTypeInfo(
        id: UUID(uuidString: "A1000000-0000-4000-8000-000000000002")!,
        name: "Pruning"
    )
    public static let wiring = WorkTypeInfo(
        id: UUID(uuidString: "A1000000-0000-4000-8000-000000000003")!,
        name: "Wiring"
    )
    public static let fertilizing = WorkTypeInfo(
        id: UUID(uuidString: "A1000000-0000-4000-8000-000000000004")!,
        name: "Fertilizing"
    )
    public static let repotting = WorkTypeInfo(
        id: UUID(uuidString: "A1000000-0000-4000-8000-000000000005")!,
        name: "Repotting"
    )

    public static let all: [WorkTypeInfo] = [
        watering, pruning, wiring, fertilizing, repotting
    ]

    public static func name(for id: UUID) -> String {
        all.first { $0.id == id }?.name ?? "Work"
    }
}
