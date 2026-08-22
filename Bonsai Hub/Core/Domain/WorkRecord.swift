//
//  WorkRecord.swift
//  Bonsai World
//
//  Workshop domain — generated work history entry.
//  Created by the Work / Workshop module (future workflows).
//  Trees display these records; they never own the registration UI.
//  Prepared for batch ops, inventory, economy, calendar, and templates.
//

import Foundation

/// A completed (or scheduled) work event referencing a ``WorkType``.
struct WorkRecord: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    /// Reference Data — Work Type.
    var workTypeID: UUID
    /// One or more trees. Multi-tree support is prepared for batch operations.
    var treeIDs: [UUID]
    var performedAt: Date
    var notes: String

    // MARK: - Future linkage (unused until workflows land)

    var soilMixID: UUID?
    var potTypeID: UUID?
    var fertilizerTypeID: UUID?
    var productIDs: [UUID]
    var wireID: UUID?
    /// Optional link to a future template.
    var templateID: UUID?
    /// Optional calendar / schedule identity.
    var scheduleID: UUID?

    var createdDate: Date
    var modifiedDate: Date

    init(
        id: UUID = UUID(),
        workTypeID: UUID,
        treeIDs: [UUID],
        performedAt: Date = .now,
        notes: String = "",
        soilMixID: UUID? = nil,
        potTypeID: UUID? = nil,
        fertilizerTypeID: UUID? = nil,
        productIDs: [UUID] = [],
        wireID: UUID? = nil,
        templateID: UUID? = nil,
        scheduleID: UUID? = nil,
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.workTypeID = workTypeID
        self.treeIDs = treeIDs
        self.performedAt = performedAt
        self.notes = notes
        self.soilMixID = soilMixID
        self.potTypeID = potTypeID
        self.fertilizerTypeID = fertilizerTypeID
        self.productIDs = productIDs
        self.wireID = wireID
        self.templateID = templateID
        self.scheduleID = scheduleID
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}
