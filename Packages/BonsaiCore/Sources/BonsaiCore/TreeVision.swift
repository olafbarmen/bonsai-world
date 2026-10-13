//
//  TreeVision.swift
//  Bonsai World
//
//  Long-term artistic intention for one Tree (Shaping → Vision).
//  Not Design, Work, Tasks, or care.
//

import Foundation

/// Per-tree goal. Stored on ``Tree``; never global.
struct TreeVision: Codable, Hashable, Sendable {
    var statement: String
    /// Legacy field — migrated to ``Tree/styleID``. Not written on save.
    var targetStyleID: UUID?
    var trunkCharacteristic: VisionCharacteristicSlot
    var branchCharacteristic: VisionCharacteristicSlot
    var apexCharacteristic: VisionCharacteristicSlot
    var nebariCharacteristic: VisionCharacteristicSlot
    /// Extra grower-defined notes beyond Trunk / Branch / Apex / Nebari.
    var additionalCharacteristics: [VisionCharacteristic]
    /// Deprecated — migrated to slots or ``additionalCharacteristics``; cleared on save.
    var characteristics: [VisionCharacteristic]
    /// Legacy fixed fields — migrated into slots on load; cleared on save.
    var trunkMovement: String
    var taper: String
    var branchStructure: String
    var apex: String
    var overallSilhouette: String
    var nebari: String
    var developmentDirection: String
    var notes: String
    /// Library image IDs. Never tree gallery / Primary photos.
    var referenceImageIDs: [UUID]

    static let empty = TreeVision()

    init(
        statement: String = "",
        targetStyleID: UUID? = nil,
        trunkCharacteristic: VisionCharacteristicSlot = VisionCharacteristicSlot(),
        branchCharacteristic: VisionCharacteristicSlot = VisionCharacteristicSlot(),
        apexCharacteristic: VisionCharacteristicSlot = VisionCharacteristicSlot(),
        nebariCharacteristic: VisionCharacteristicSlot = VisionCharacteristicSlot(),
        additionalCharacteristics: [VisionCharacteristic] = [],
        characteristics: [VisionCharacteristic] = [],
        trunkMovement: String = "",
        taper: String = "",
        branchStructure: String = "",
        apex: String = "",
        overallSilhouette: String = "",
        nebari: String = "",
        developmentDirection: String = "",
        notes: String = "",
        referenceImageIDs: [UUID] = []
    ) {
        self.statement = statement
        self.targetStyleID = targetStyleID
        self.trunkCharacteristic = trunkCharacteristic
        self.branchCharacteristic = branchCharacteristic
        self.apexCharacteristic = apexCharacteristic
        self.nebariCharacteristic = nebariCharacteristic
        self.additionalCharacteristics = additionalCharacteristics
        self.characteristics = characteristics
        self.trunkMovement = trunkMovement
        self.taper = taper
        self.branchStructure = branchStructure
        self.apex = apex
        self.overallSilhouette = overallSilhouette
        self.nebari = nebari
        self.developmentDirection = developmentDirection
        self.notes = notes
        self.referenceImageIDs = referenceImageIDs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statement = try container.decodeIfPresent(String.self, forKey: .statement) ?? ""
        targetStyleID = try container.decodeIfPresent(UUID.self, forKey: .targetStyleID)
        trunkCharacteristic = try container.decodeIfPresent(VisionCharacteristicSlot.self, forKey: .trunkCharacteristic)
            ?? VisionCharacteristicSlot()
        branchCharacteristic = try container.decodeIfPresent(VisionCharacteristicSlot.self, forKey: .branchCharacteristic)
            ?? VisionCharacteristicSlot()
        apexCharacteristic = try container.decodeIfPresent(VisionCharacteristicSlot.self, forKey: .apexCharacteristic)
            ?? VisionCharacteristicSlot()
        nebariCharacteristic = try container.decodeIfPresent(VisionCharacteristicSlot.self, forKey: .nebariCharacteristic)
            ?? VisionCharacteristicSlot()
        additionalCharacteristics = try container.decodeIfPresent([VisionCharacteristic].self, forKey: .additionalCharacteristics) ?? []
        characteristics = try container.decodeIfPresent([VisionCharacteristic].self, forKey: .characteristics) ?? []
        trunkMovement = try container.decodeIfPresent(String.self, forKey: .trunkMovement) ?? ""
        taper = try container.decodeIfPresent(String.self, forKey: .taper) ?? ""
        branchStructure = try container.decodeIfPresent(String.self, forKey: .branchStructure) ?? ""
        apex = try container.decodeIfPresent(String.self, forKey: .apex) ?? ""
        overallSilhouette = try container.decodeIfPresent(String.self, forKey: .overallSilhouette) ?? ""
        nebari = try container.decodeIfPresent(String.self, forKey: .nebari) ?? ""
        developmentDirection = try container.decodeIfPresent(String.self, forKey: .developmentDirection) ?? ""
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        referenceImageIDs = try container.decodeIfPresent([UUID].self, forKey: .referenceImageIDs) ?? []
        migrateLegacyCharacteristicsIfNeeded()
    }

    func slot(for fixed: VisionFixedCharacteristic) -> VisionCharacteristicSlot {
        switch fixed {
        case .trunk: trunkCharacteristic
        case .branch: branchCharacteristic
        case .apex: apexCharacteristic
        case .nebari: nebariCharacteristic
        }
    }

    mutating func setSlot(_ fixed: VisionFixedCharacteristic, to slot: VisionCharacteristicSlot) {
        switch fixed {
        case .trunk: trunkCharacteristic = slot
        case .branch: branchCharacteristic = slot
        case .apex: apexCharacteristic = slot
        case .nebari: nebariCharacteristic = slot
        }
    }

    /// Imports legacy storage into fixed slots and ``additionalCharacteristics``.
    mutating func migrateLegacyCharacteristicsIfNeeded() {
        migrateLegacyString(into: .trunk, value: trunkMovement)
        migrateLegacyString(into: .branch, value: branchStructure)
        migrateLegacyString(into: .apex, value: apex)
        migrateLegacyString(into: .nebari, value: nebari)

        if !taper.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            appendAdditional(kind: .develop, text: taper)
            taper = ""
        }
        if !overallSilhouette.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            appendAdditional(kind: .develop, text: overallSilhouette)
            overallSilhouette = ""
        }

        if !characteristics.isEmpty {
            additionalCharacteristics.append(contentsOf: characteristics)
            characteristics = []
        }

        trunkMovement = ""
        branchStructure = ""
        apex = ""
        nebari = ""
    }

    /// Clears deprecated fields before persistence. Characteristics belong in Shaping areas.
    mutating func prepareForSave() {
        targetStyleID = nil
        characteristics = []
        trunkCharacteristic = VisionCharacteristicSlot()
        branchCharacteristic = VisionCharacteristicSlot()
        apexCharacteristic = VisionCharacteristicSlot()
        nebariCharacteristic = VisionCharacteristicSlot()
        additionalCharacteristics = []
        trunkMovement = ""
        taper = ""
        branchStructure = ""
        apex = ""
        overallSilhouette = ""
        nebari = ""
        developmentDirection = ""
        notes = ""
    }

    private mutating func migrateLegacyString(into fixed: VisionFixedCharacteristic, value: String) {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var slot = slot(for: fixed)
        guard slot.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        slot.text = trimmed
        slot.kind = .develop
        setSlot(fixed, to: slot)
    }

    private mutating func appendAdditional(kind: VisionCharacteristicKind, text: String) {
        additionalCharacteristics.append(VisionCharacteristic(kind: kind, text: text))
    }
}
