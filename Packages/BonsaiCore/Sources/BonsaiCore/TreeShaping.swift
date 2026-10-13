//
//  TreeShaping.swift
//  Bonsai World
//
//  Practical development workbook for one Tree (Tree Detail → Shaping).
//

import Foundation

struct TreeShaping: Codable, Hashable, Sendable {
    /// Keyed by ``ShapingAreaID/rawValue``.
    var areas: [String: ShapingAreaRecord]
    /// True after legacy Vision fields have been migrated into ``areas``.
    var didMigrateVision: Bool

    static let empty = TreeShaping()

    init(areas: [String: ShapingAreaRecord] = [:], didMigrateVision: Bool = false) {
        self.areas = areas
        self.didMigrateVision = didMigrateVision
    }

    func record(for area: ShapingAreaID) -> ShapingAreaRecord {
        areas[area.rawValue] ?? .empty
    }

    mutating func setRecord(_ record: ShapingAreaRecord, for area: ShapingAreaID) {
        areas[area.rawValue] = record
    }

    /// Migrates legacy Vision content into Shaping areas without deleting source text.
    mutating func migrateFromVision(_ vision: TreeVision) {
        var migrated = vision
        migrated.migrateLegacyCharacteristicsIfNeeded()

        importSlot(migrated.trunkCharacteristic, into: .trunk)
        importSlot(migrated.branchCharacteristic, into: .primaryBranches)
        importSlot(migrated.apexCharacteristic, into: .apex)
        importSlot(migrated.nebariCharacteristic, into: .nebari)

        for characteristic in migrated.additionalCharacteristics {
            importText(
                characteristic.text,
                intent: characteristic.kind,
                into: .branchDevelopment,
                migratedLabel: "Additional characteristic"
            )
        }

        importText(migrated.developmentDirection, into: .overallSilhouette, field: .developmentPlan, migratedLabel: "Development Direction")
        importText(migrated.notes, into: .branchDevelopment, field: .observation, migratedLabel: "Vision Notes")

        if !migrated.trunkMovement.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            importText(migrated.trunkMovement, into: .trunkMovement, migratedLabel: "Trunk Movement")
        }
        if !migrated.taper.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            importText(migrated.taper, into: .taper, migratedLabel: "Taper")
        }
        if !migrated.branchStructure.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            importText(migrated.branchStructure, into: .primaryBranches, migratedLabel: "Branch Structure")
        }
        if !migrated.overallSilhouette.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            importText(migrated.overallSilhouette, into: .overallSilhouette, migratedLabel: "Overall Silhouette")
        }
        if !migrated.nebari.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            importText(migrated.nebari, into: .nebari, migratedLabel: "Nebari")
        }

        didMigrateVision = true
    }

    private enum ImportField {
        case observation
        case developmentPlan
    }

    private mutating func importSlot(_ slot: VisionCharacteristicSlot, into area: ShapingAreaID) {
        importText(slot.text, intent: slot.kind, into: area, migratedLabel: area.title)
    }

    private mutating func importText(
        _ text: String,
        intent: VisionCharacteristicKind? = nil,
        into area: ShapingAreaID,
        field: ImportField? = nil,
        migratedLabel: String
    ) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        var record = record(for: area)

        if let field {
            switch field {
            case .observation where record.observation.isEmpty:
                record.observation = trimmed
                setRecord(record, for: area)
                return
            case .developmentPlan where record.developmentPlan.isEmpty:
                record.developmentPlan = trimmed
                setRecord(record, for: area)
                return
            default:
                break
            }
        }

        if record.observation.isEmpty {
            record.observation = trimmed
            if let intent, record.status == .planned, intent == .develop {
                record.status = .inProgress
            }
            setRecord(record, for: area)
            return
        }

        if record.developmentPlan.isEmpty {
            record.developmentPlan = trimmed
            setRecord(record, for: area)
            return
        }

        let prefix = intent.map { "[\($0.title)] " } ?? ""
        record.history.append(
            ShapingHistoryEntry(
                date: .now,
                description: "\(prefix)\(trimmed)",
                intent: intent
            )
        )
        setRecord(record, for: area)
    }
}
