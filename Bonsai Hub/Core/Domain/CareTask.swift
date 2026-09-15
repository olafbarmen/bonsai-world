//
//  CareTask.swift
//  Bonsai World
//
//  Tasks domain — planned/scheduled care, distinct from WorkRecord (history of
//  care already performed). See Product Blueprint §5.9 "Tasks vs. Work".
//
//  Named `CareTask`, not `Task`, to avoid clashing with Swift's concurrency `Task`.
//

import Foundation

enum CareTaskStatus: String, Codable, Hashable, Sendable, CaseIterable {
    case pending
    case completed
    case cancelled
}

/// Library-level inventory work — no Tree / Yamadori / Seed Batch target.
enum CareTaskLibraryInventoryKind: String, Codable, Hashable, Sendable {
    case soilStocktake
}

/// A planned care activity for one or more Trees, tied to a Work Type so its
/// completion behaviour (instant vs. full Add Work form) is known in advance.
struct CareTask: Identifiable, Hashable, Sendable {
    var id: UUID
    var title: String
    /// Reference Data — Work Type. Drives completion behaviour
    /// (``WorkTypeBehaviourFlags/tasksCompleteInstantly``).
    var workTypeID: UUID
    /// One or more trees this task applies to.
    var treeIDs: [UUID]
    /// Optional Yamadori links — same Task system, no second task store (Blueprint §5.10).
    var yamadoriIDs: [UUID]
    /// Optional Seed Batch links — same Task system (Nursery → Seeds → Seed Work).
    var seedBatchIDs: [UUID]
    /// Optional Nursery Propagation / Field Tree project links — same Task system.
    var nurseryPropagationProjectIDs: [UUID]
    /// Optional library inventory scope (e.g. Soil stocktake) — same Task system.
    var libraryInventoryKind: CareTaskLibraryInventoryKind?
    var dueDate: Date
    var notes: String
    var status: CareTaskStatus
    var completedAt: Date?
    /// Optional link to a Shaping area on one of ``treeIDs`` (raw ``ShapingAreaID`` value).
    var shapingAreaID: String?
    /// The WorkRecord created when this task was completed, once known.
    var resultingWorkRecordID: UUID?

    var createdDate: Date
    var modifiedDate: Date

    init(
        id: UUID = UUID(),
        title: String,
        workTypeID: UUID,
        treeIDs: [UUID] = [],
        yamadoriIDs: [UUID] = [],
        seedBatchIDs: [UUID] = [],
        nurseryPropagationProjectIDs: [UUID] = [],
        libraryInventoryKind: CareTaskLibraryInventoryKind? = nil,
        dueDate: Date,
        notes: String = "",
        status: CareTaskStatus = .pending,
        completedAt: Date? = nil,
        shapingAreaID: String? = nil,
        resultingWorkRecordID: UUID? = nil,
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.title = title
        self.workTypeID = workTypeID
        self.treeIDs = treeIDs
        self.yamadoriIDs = yamadoriIDs
        self.seedBatchIDs = seedBatchIDs
        self.nurseryPropagationProjectIDs = nurseryPropagationProjectIDs
        self.libraryInventoryKind = libraryInventoryKind
        self.dueDate = dueDate
        self.notes = notes
        self.status = status
        self.completedAt = completedAt
        self.shapingAreaID = shapingAreaID
        self.resultingWorkRecordID = resultingWorkRecordID
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}

extension CareTask: Codable {
    enum CodingKeys: String, CodingKey {
        case id, title, workTypeID, treeIDs, yamadoriIDs, seedBatchIDs, nurseryPropagationProjectIDs, libraryInventoryKind
        case dueDate, notes, status
        case completedAt, shapingAreaID, resultingWorkRecordID, createdDate, modifiedDate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        workTypeID = try c.decode(UUID.self, forKey: .workTypeID)
        treeIDs = try c.decodeIfPresent([UUID].self, forKey: .treeIDs) ?? []
        yamadoriIDs = try c.decodeIfPresent([UUID].self, forKey: .yamadoriIDs) ?? []
        seedBatchIDs = try c.decodeIfPresent([UUID].self, forKey: .seedBatchIDs) ?? []
        nurseryPropagationProjectIDs = try c.decodeIfPresent([UUID].self, forKey: .nurseryPropagationProjectIDs) ?? []
        libraryInventoryKind = try c.decodeIfPresent(CareTaskLibraryInventoryKind.self, forKey: .libraryInventoryKind)
        dueDate = try c.decode(Date.self, forKey: .dueDate)
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        status = try c.decode(CareTaskStatus.self, forKey: .status)
        completedAt = try c.decodeIfPresent(Date.self, forKey: .completedAt)
        shapingAreaID = try c.decodeIfPresent(String.self, forKey: .shapingAreaID)
        resultingWorkRecordID = try c.decodeIfPresent(UUID.self, forKey: .resultingWorkRecordID)
        createdDate = try c.decode(Date.self, forKey: .createdDate)
        modifiedDate = try c.decode(Date.self, forKey: .modifiedDate)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(workTypeID, forKey: .workTypeID)
        try c.encode(treeIDs, forKey: .treeIDs)
        try c.encode(yamadoriIDs, forKey: .yamadoriIDs)
        try c.encode(seedBatchIDs, forKey: .seedBatchIDs)
        try c.encode(nurseryPropagationProjectIDs, forKey: .nurseryPropagationProjectIDs)
        try c.encodeIfPresent(libraryInventoryKind, forKey: .libraryInventoryKind)
        try c.encode(dueDate, forKey: .dueDate)
        try c.encode(notes, forKey: .notes)
        try c.encode(status, forKey: .status)
        try c.encodeIfPresent(completedAt, forKey: .completedAt)
        try c.encodeIfPresent(shapingAreaID, forKey: .shapingAreaID)
        try c.encodeIfPresent(resultingWorkRecordID, forKey: .resultingWorkRecordID)
        try c.encode(createdDate, forKey: .createdDate)
        try c.encode(modifiedDate, forKey: .modifiedDate)
    }
}
