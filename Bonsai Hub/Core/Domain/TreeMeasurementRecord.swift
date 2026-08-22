//
//  TreeMeasurementRecord.swift
//  Bonsai World
//
//  One dated Tree measurement session (Height / Crown / Nebari / Trunk).
//  Append-only history — never overwrite prior records.
//  Pot dimensions are NOT part of this history — they live on Tree (and a future Pot entity).
//

import Foundation

/// A single Tree measurement session at a point in time.
struct TreeMeasurementRecord: Identifiable, Codable, Hashable, Sendable {
    /// Record schema version — bump when adding breaking field semantics.
    static let currentSchemaVersion = 1

    var id: UUID
    var treeID: UUID
    /// When the measurements were taken (user-facing Measurement Date).
    var measuredAt: Date

    // MARK: - Tree (millimetres)

    var heightMillimetres: Int?
    var crownWidthMillimetres: Int?
    var nebariWidthMillimetres: Int?
    var trunkDiameterMillimetres: Int?

    // MARK: - Legacy pot fields (decode only)

    /// Historical pot values from older records. Not written by new measurement sessions.
    /// Kept for backward-compatible catalog decoding until a Pot entity exists.
    var potLengthMillimetres: Int?
    var potWidthMillimetres: Int?
    var potHeightMillimetres: Int?
    var potDiameterMillimetres: Int?

    /// Optional session notes.
    var notes: String

    /// When this record was created in the library (system).
    var createdDate: Date
    /// Schema version of this record (forward-compatible decoding).
    var schemaVersion: Int

    init(
        id: UUID = UUID(),
        treeID: UUID,
        measuredAt: Date = .now,
        heightMillimetres: Int? = nil,
        crownWidthMillimetres: Int? = nil,
        nebariWidthMillimetres: Int? = nil,
        trunkDiameterMillimetres: Int? = nil,
        notes: String = "",
        createdDate: Date = .now,
        schemaVersion: Int = TreeMeasurementRecord.currentSchemaVersion
    ) {
        self.id = id
        self.treeID = treeID
        self.measuredAt = measuredAt
        self.heightMillimetres = heightMillimetres
        self.crownWidthMillimetres = crownWidthMillimetres
        self.nebariWidthMillimetres = nebariWidthMillimetres
        self.trunkDiameterMillimetres = trunkDiameterMillimetres
        // New sessions never attach pot data to measurement history.
        self.potLengthMillimetres = nil
        self.potWidthMillimetres = nil
        self.potHeightMillimetres = nil
        self.potDiameterMillimetres = nil
        self.notes = notes
        self.createdDate = createdDate
        self.schemaVersion = schemaVersion
    }

    /// Snapshot of Tree dimensions only (migration / pre-fill). Ignores pot fields.
    static func fromLatestFields(on tree: Tree, measuredAt: Date = .now) -> TreeMeasurementRecord {
        TreeMeasurementRecord(
            treeID: tree.id,
            measuredAt: measuredAt,
            heightMillimetres: tree.heightMillimetres,
            crownWidthMillimetres: tree.crownWidthMillimetres,
            nebariWidthMillimetres: tree.nebariWidthMillimetres,
            trunkDiameterMillimetres: tree.trunkDiameterMillimetres,
            notes: ""
        )
    }

    /// True when at least one Tree dimension or note is set.
    var hasAnyValue: Bool {
        heightMillimetres != nil
            || crownWidthMillimetres != nil
            || nebariWidthMillimetres != nil
            || trunkDiameterMillimetres != nil
            || !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    enum CodingKeys: String, CodingKey {
        case id, treeID, measuredAt
        case heightMillimetres, crownWidthMillimetres, nebariWidthMillimetres, trunkDiameterMillimetres
        case potLengthMillimetres, potWidthMillimetres, potHeightMillimetres, potDiameterMillimetres
        case notes, createdDate, schemaVersion
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        treeID = try container.decode(UUID.self, forKey: .treeID)
        measuredAt = try container.decode(Date.self, forKey: .measuredAt)
        heightMillimetres = try container.decodeIfPresent(Int.self, forKey: .heightMillimetres)
        crownWidthMillimetres = try container.decodeIfPresent(Int.self, forKey: .crownWidthMillimetres)
        nebariWidthMillimetres = try container.decodeIfPresent(Int.self, forKey: .nebariWidthMillimetres)
        trunkDiameterMillimetres = try container.decodeIfPresent(Int.self, forKey: .trunkDiameterMillimetres)
        potLengthMillimetres = try container.decodeIfPresent(Int.self, forKey: .potLengthMillimetres)
        potWidthMillimetres = try container.decodeIfPresent(Int.self, forKey: .potWidthMillimetres)
        potHeightMillimetres = try container.decodeIfPresent(Int.self, forKey: .potHeightMillimetres)
        potDiameterMillimetres = try container.decodeIfPresent(Int.self, forKey: .potDiameterMillimetres)
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        createdDate = try container.decodeIfPresent(Date.self, forKey: .createdDate) ?? measuredAt
        schemaVersion = try container.decodeIfPresent(Int.self, forKey: .schemaVersion)
            ?? TreeMeasurementRecord.currentSchemaVersion
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(treeID, forKey: .treeID)
        try container.encode(measuredAt, forKey: .measuredAt)
        try container.encodeIfPresent(heightMillimetres, forKey: .heightMillimetres)
        try container.encodeIfPresent(crownWidthMillimetres, forKey: .crownWidthMillimetres)
        try container.encodeIfPresent(nebariWidthMillimetres, forKey: .nebariWidthMillimetres)
        try container.encodeIfPresent(trunkDiameterMillimetres, forKey: .trunkDiameterMillimetres)
        // Do not encode empty legacy pot fields on new writes.
        try container.encodeIfPresent(potLengthMillimetres, forKey: .potLengthMillimetres)
        try container.encodeIfPresent(potWidthMillimetres, forKey: .potWidthMillimetres)
        try container.encodeIfPresent(potHeightMillimetres, forKey: .potHeightMillimetres)
        try container.encodeIfPresent(potDiameterMillimetres, forKey: .potDiameterMillimetres)
        try container.encode(notes, forKey: .notes)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(schemaVersion, forKey: .schemaVersion)
    }
}

/// On-disk package for all trees’ measurement history.
struct TreeMeasurementHistoryFile: Codable, Hashable, Sendable {
    /// All records (append-only). Grouped / sorted in the store.
    var records: [TreeMeasurementRecord]

    init(records: [TreeMeasurementRecord] = []) {
        self.records = records
    }
}
