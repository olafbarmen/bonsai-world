//
//  NurseryPropagationProject.swift
//  Bonsai World
//
//  Nursery → Cuttings / Air Layers / Field Tree — one project record per unit.
//  Grafting remains a stored kind for existing data, but is not a Nursery destination
//  (record grafting as Work on a Tree instead).
//

import Foundation

enum NurseryPropagationKind: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case cutting
    case airLayer
    case grafting
    /// Tree planted in the ground to grow, then collected. Formerly stored as `development`.
    case fieldTree

    var id: Self { self }

    /// Kinds shown in Nursery navigation and create flows.
    static var nurserySelectable: [NurseryPropagationKind] {
        [.cutting, .airLayer]
    }

    /// Whether this kind has a Nursery sidebar workspace.
    var isNurseryDestination: Bool {
        switch self {
        case .cutting, .airLayer: true
        case .grafting, .fieldTree: false
        }
    }

    var title: String {
        switch self {
        case .cutting: "Cuttings"
        case .airLayer: "Air Layers"
        case .grafting: "Grafting"
        case .fieldTree: "Field Tree"
        }
    }

    var singularTitle: String {
        switch self {
        case .cutting: "Cutting"
        case .airLayer: "Air Layer"
        case .grafting: "Graft"
        case .fieldTree: "Field Tree"
        }
    }

    var projectNoun: String {
        "\(singularTitle) Project"
    }

    var route: AppRoute {
        switch self {
        case .cutting: .nurseryCuttings
        case .airLayer: .nurseryAirLayers
        case .grafting: .nurseryGrafting
        case .fieldTree: .nurseryFieldTree
        }
    }

    var codePrefix: String {
        switch self {
        case .cutting: "CUT"
        case .airLayer: "AL"
        case .grafting: "GR"
        case .fieldTree: "FT"
        }
    }

    var acquisitionMethodName: String {
        switch self {
        case .cutting: "Cutting"
        case .airLayer: "Air Layer"
        case .grafting: "Grafting"
        case .fieldTree: "Field Tree"
        }
    }

    var systemImage: String {
        switch self {
        case .cutting: "scissors"
        case .airLayer: "arrow.triangle.branch"
        case .grafting: "arrow.triangle.merge"
        case .fieldTree: "tree"
        }
    }

    /// Honest product line — Cuttings and Air Layers carry their own technique fields.
    static let sharedTrackerHonestyLine =
        "Cuttings and Air Layers share the Propagation workspace, but each kind has its own technique fields, stages, and project codes."

    /// Primary lifecycle path (excludes failed / archived).
    var mainPath: [NurseryPropagationStage] {
        switch self {
        case .cutting:
            // Started is stored as `planned` — UI title is "Started".
            [.planned, .rooting, .rooted, .potted, .completed]
        case .airLayer:
            // Started is stored as `planned`; Checking is stored as `active`.
            [.planned, .active, .separated, .potted, .completed]
        case .grafting:
            [.planned, .healing, .established, .developing, .completed]
        case .fieldTree:
            [.planned, .trunkBuilding, .ramification, .refining, .completed]
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if raw == "development" {
            self = .fieldTree
            return
        }
        guard let value = Self(rawValue: raw) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown NurseryPropagationKind: \(raw)"
            )
        }
        self = value
    }
}

enum NurseryPropagationStage: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case planned
    case rooting
    case rooted
    case potted
    case active
    case separated
    case healing
    case established
    case developing
    case trunkBuilding
    case ramification
    case refining
    case completed
    case failed
    case archived

    var id: Self { self }

    var title: String {
        switch self {
        case .planned: "Planned"
        case .rooting: "Rooting"
        case .rooted: "Rooted"
        case .potted: "Potted"
        case .active: "Active"
        case .separated: "Separated"
        case .healing: "Healing"
        case .established: "Established"
        case .developing: "Developing"
        case .trunkBuilding: "Trunk Building"
        case .ramification: "Ramification"
        case .refining: "Refining"
        case .completed: "Completed"
        case .failed: "Failed"
        case .archived: "Archived"
        }
    }

    /// Grower-facing title (Cuttings/Air Layers: Planned → Started; Air Layers: Active → Checking).
    func title(for kind: NurseryPropagationKind) -> String {
        switch (kind, self) {
        case (.cutting, .planned), (.airLayer, .planned):
            return "Started"
        case (.airLayer, .active):
            return "Checking"
        default:
            return title
        }
    }

    var isActive: Bool {
        switch self {
        case .completed, .failed, .archived: false
        default: true
        }
    }

    /// Stages where Transfer / Create / Generate Tree is allowed.
    var canCreateTree: Bool {
        switch self {
        case .rooted, .potted, .separated, .established, .developing: true
        case .trunkBuilding, .ramification, .refining: true
        default: false
        }
    }

    /// Primary advance button label toward this stage.
    func advanceActionTitle(for kind: NurseryPropagationKind) -> String {
        switch (kind, self) {
        case (.cutting, .rooting): "Mark as rooting"
        case (.cutting, .rooted): "Mark rooted"
        case (.cutting, .potted): "Mark potted"
        case (.airLayer, .active): "Mark checking"
        case (.airLayer, .separated): "Mark separated"
        case (.airLayer, .potted): "Mark potted"
        default: "Advance to \(title(for: kind))"
        }
    }
}

enum NurseryPropagationEventKind: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case created
    case stageChanged
    case noteAdded
    case quantityUpdated
    case treeCreated
    case failed
    case archived
    case wrappingChecked

    var id: Self { self }

    var title: String {
        switch self {
        case .created: "Project created"
        case .stageChanged: "Stage changed"
        case .noteAdded: "Note added"
        case .quantityUpdated: "Quantity updated"
        case .treeCreated: "Tree created"
        case .failed: "Marked failed"
        case .archived: "Archived"
        case .wrappingChecked: "Wrapping checked"
        }
    }
}

/// Wood maturity for Cuttings — material stage of the cutting wood.
enum NurseryCuttingWoodMaturity: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case softwood
    case semiHardwood
    case hardwood

    var id: Self { self }

    var title: String {
        switch self {
        case .softwood: "Softwood"
        case .semiHardwood: "Semi-hardwood"
        case .hardwood: "Hardwood"
        }
    }
}

/// How the cutting base is taken from the mother plant.
enum NurseryCuttingBaseTechnique: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case straight
    case heel
    case mallet

    var id: Self { self }

    var title: String {
        switch self {
        case .straight: "Straight"
        case .heel: "Heel"
        case .mallet: "Mallet"
        }
    }
}

/// Structural form of the cutting (nodes / leaf material).
enum NurseryCuttingStructure: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case singleNode
    case multiNode
    case leafBud
    case leaf

    var id: Self { self }

    var title: String {
        switch self {
        case .singleNode: "Single-node"
        case .multiNode: "Multi-node"
        case .leafBud: "Leaf-bud"
        case .leaf: "Leaf"
        }
    }
}

/// Legacy Cut style — retained only for decoding older library JSON.
enum NurseryCuttingCutStyle: String, Codable, Hashable, Sendable {
    case wholeCutting
    case midBranch
}

/// Legacy Cutting type — retained only for decoding older library JSON.
enum NurseryCuttingWoodType: String, Codable, Hashable, Sendable {
    case hardwood
    case overWinter
}

/// Completed vs failed projects for a kind (optionally filtered by species).
struct NurseryPropagationSuccessRate: Hashable, Sendable {
    var completedCount: Int
    var failedCount: Int

    var decidedCount: Int { completedCount + failedCount }

    /// Nil when nothing has finished or failed yet.
    var percent: Double? {
        guard decidedCount > 0 else { return nil }
        return Double(completedCount) / Double(decidedCount)
    }

    var displayLabel: String {
        guard let percent else { return "No completed or failed projects yet" }
        let pct = Int((percent * 100).rounded())
        return "\(pct)% (\(completedCount) completed · \(failedCount) failed)"
    }
}

struct NurseryPropagationEvent: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var date: Date
    var kind: NurseryPropagationEventKind
    var quantity: Int?
    var notes: String
    /// Air Layer wrap-check snapshot (optional; older events nil).
    var airLayerRootDevelopment: NurseryAirLayerRootDevelopment?
    var airLayerMoisture: NurseryAirLayerMoisture?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        kind: NurseryPropagationEventKind,
        quantity: Int? = nil,
        notes: String = "",
        airLayerRootDevelopment: NurseryAirLayerRootDevelopment? = nil,
        airLayerMoisture: NurseryAirLayerMoisture? = nil
    ) {
        self.id = id
        self.date = date
        self.kind = kind
        self.quantity = quantity
        self.notes = notes
        self.airLayerRootDevelopment = airLayerRootDevelopment
        self.airLayerMoisture = airLayerMoisture
    }
}

struct NurseryPropagationProject: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var kind: NurseryPropagationKind
    var projectCode: String
    var genusID: UUID?
    var speciesID: UUID?
    var cultivarID: UUID?
    var botanicalName: String
    var commonName: String
    var parentTreeID: UUID?
    var quantity: Int
    var stage: NurseryPropagationStage
    /// When the tree was planted in the ground (Field Tree). Optional for other kinds.
    var plantedAt: Date?
    var locationID: UUID?
    var notes: String
    var createdTreeIDs: [UUID]
    var events: [NurseryPropagationEvent]
    var imageIDs: [UUID]
    /// Pending Check task while an Air Layer is in Checking (optional; older records nil).
    var nextCheckTaskID: UUID?

    // MARK: Cuttings technique

    /// When the cutting was taken.
    var cuttingTakenAt: Date?
    var cuttingRootMedium: String
    var cuttingSoilMix: String
    /// Free-text length (e.g. "8 cm").
    var cuttingLength: String
    var cuttingLeafCount: Int?
    var cuttingWoodMaturity: NurseryCuttingWoodMaturity?
    var cuttingWoodMaturityOverride: String
    var cuttingBaseTechnique: NurseryCuttingBaseTechnique?
    var cuttingBaseTechniqueOverride: String
    var cuttingStructure: NurseryCuttingStructure?
    var cuttingStructureOverride: String

    // MARK: Air Layer technique

    var airLayerMethod: NurseryAirLayerMethod?
    var airLayerMethodOverride: String
    var airLayerRingWidthMM: Double?
    var airLayerLayerDiameterMM: Double?
    var airLayerLocation: NurseryAirLayerLocation?
    var airLayerLocationOverride: String
    var airLayerRootingAid: NurseryAirLayerRootingAid?
    var airLayerRootingAidOverride: String
    var airLayerHormoneProduct: String
    var airLayerHormoneConcentration: String
    var airLayerMediumPreset: NurseryAirLayerMediumPreset?
    var airLayerMediumCustom: String
    var airLayerWrapSystem: NurseryAirLayerWrapSystem?
    var airLayerWrapSystemOverride: String
    var airLayerPurpose: NurseryAirLayerPurpose?
    var airLayerPurposeOverride: String
    var airLayerRootDevelopment: NurseryAirLayerRootDevelopment?
    /// When the air layer was started.
    var airLayerStartedAt: Date?
    /// Whether winter care needs special attention (nil = unset).
    var airLayerWinterCare: Bool?
    var airLayerWinterCareNotes: String
    var airLayerSeparated: Bool
    var airLayerSeparationDate: Date?
    var airLayerSeparationNotes: String

    var createdAt: Date
    var updatedAt: Date

    var isActive: Bool { stage.isActive }

    var orderedEvents: [NurseryPropagationEvent] {
        events.sorted { $0.date > $1.date }
    }

    var cuttingWoodMaturityDisplay: String {
        let override = cuttingWoodMaturityOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        if !override.isEmpty { return override }
        return cuttingWoodMaturity?.title ?? ""
    }

    var cuttingBaseTechniqueDisplay: String {
        let override = cuttingBaseTechniqueOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        if !override.isEmpty { return override }
        return cuttingBaseTechnique?.title ?? ""
    }

    var cuttingStructureDisplay: String {
        let override = cuttingStructureOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        if !override.isEmpty { return override }
        return cuttingStructure?.title ?? ""
    }

    /// Compact classification line, e.g. "Semi-hardwood · Heel · Multi-node".
    var cuttingClassificationDisplay: String {
        [cuttingWoodMaturityDisplay, cuttingBaseTechniqueDisplay, cuttingStructureDisplay]
            .filter { !$0.isEmpty }
            .joined(separator: " · ")
    }

    var airLayerMethodDisplay: String {
        let override = airLayerMethodOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        if !override.isEmpty { return override }
        return airLayerMethod?.title ?? ""
    }

    var airLayerLocationDisplay: String {
        let override = airLayerLocationOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        if !override.isEmpty { return override }
        return airLayerLocation?.title ?? ""
    }

    var airLayerRootingAidDisplay: String {
        let override = airLayerRootingAidOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        if !override.isEmpty { return override }
        return airLayerRootingAid?.title ?? ""
    }

    var airLayerMediumDisplay: String {
        let custom = airLayerMediumCustom.trimmingCharacters(in: .whitespacesAndNewlines)
        if airLayerMediumPreset == .custom || (airLayerMediumPreset == nil && !custom.isEmpty) {
            return custom.isEmpty ? (airLayerMediumPreset?.title ?? "") : custom
        }
        if !custom.isEmpty, airLayerMediumPreset != nil {
            return "\(airLayerMediumPreset!.title) — \(custom)"
        }
        return airLayerMediumPreset?.title ?? custom
    }

    var airLayerWrapSystemDisplay: String {
        let override = airLayerWrapSystemOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        if !override.isEmpty { return override }
        return airLayerWrapSystem?.title ?? ""
    }

    var airLayerPurposeDisplay: String {
        let override = airLayerPurposeOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        if !override.isEmpty { return override }
        return airLayerPurpose?.title ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id, kind, projectCode, genusID, speciesID, cultivarID
        case botanicalName, commonName, parentTreeID, quantity, stage
        case plantedAt, locationID, notes, createdTreeIDs, events, imageIDs
        case nextCheckTaskID
        case cuttingTakenAt, cuttingRootMedium, cuttingSoilMix, cuttingLength
        case cuttingLeafCount
        case cuttingWoodMaturity, cuttingWoodMaturityOverride
        case cuttingBaseTechnique, cuttingBaseTechniqueOverride
        case cuttingStructure, cuttingStructureOverride
        /// Legacy key (decode only — merged into notes).
        case cuttingSeasonTip
        /// Legacy keys (decode only).
        case cuttingCutStyle, cuttingCutStyleOverride
        case cuttingWoodType, cuttingWoodTypeOverride
        case airLayerMethod, airLayerMethodOverride
        case airLayerRingWidthMM, airLayerLayerDiameterMM
        case airLayerLocation, airLayerLocationOverride
        case airLayerRootingAid, airLayerRootingAidOverride
        case airLayerHormoneProduct, airLayerHormoneConcentration
        case airLayerMediumPreset, airLayerMediumCustom
        case airLayerWrapSystem, airLayerWrapSystemOverride
        case airLayerPurpose, airLayerPurposeOverride
        case airLayerRootDevelopment, airLayerStartedAt
        case airLayerWinterCare, airLayerWinterCareNotes
        case airLayerSeparated, airLayerSeparationDate, airLayerSeparationNotes
        /// Legacy air-layer keys (decode only).
        case airLayerWrap, airLayerHormone, airLayerMedium
        case airLayerWinterWatering, airLayerWinterWateringNotes
        case createdAt, updatedAt
    }

    init(
        id: UUID = UUID(),
        kind: NurseryPropagationKind,
        projectCode: String,
        genusID: UUID? = nil,
        speciesID: UUID? = nil,
        cultivarID: UUID? = nil,
        botanicalName: String,
        commonName: String = "",
        parentTreeID: UUID? = nil,
        quantity: Int = 1,
        stage: NurseryPropagationStage = .planned,
        plantedAt: Date? = nil,
        locationID: UUID? = nil,
        notes: String = "",
        createdTreeIDs: [UUID] = [],
        events: [NurseryPropagationEvent] = [],
        imageIDs: [UUID] = [],
        nextCheckTaskID: UUID? = nil,
        cuttingTakenAt: Date? = nil,
        cuttingRootMedium: String = "",
        cuttingSoilMix: String = "",
        cuttingLength: String = "",
        cuttingLeafCount: Int? = nil,
        cuttingWoodMaturity: NurseryCuttingWoodMaturity? = nil,
        cuttingWoodMaturityOverride: String = "",
        cuttingBaseTechnique: NurseryCuttingBaseTechnique? = nil,
        cuttingBaseTechniqueOverride: String = "",
        cuttingStructure: NurseryCuttingStructure? = nil,
        cuttingStructureOverride: String = "",
        airLayerMethod: NurseryAirLayerMethod? = nil,
        airLayerMethodOverride: String = "",
        airLayerRingWidthMM: Double? = nil,
        airLayerLayerDiameterMM: Double? = nil,
        airLayerLocation: NurseryAirLayerLocation? = nil,
        airLayerLocationOverride: String = "",
        airLayerRootingAid: NurseryAirLayerRootingAid? = nil,
        airLayerRootingAidOverride: String = "",
        airLayerHormoneProduct: String = "",
        airLayerHormoneConcentration: String = "",
        airLayerMediumPreset: NurseryAirLayerMediumPreset? = nil,
        airLayerMediumCustom: String = "",
        airLayerWrapSystem: NurseryAirLayerWrapSystem? = nil,
        airLayerWrapSystemOverride: String = "",
        airLayerPurpose: NurseryAirLayerPurpose? = nil,
        airLayerPurposeOverride: String = "",
        airLayerRootDevelopment: NurseryAirLayerRootDevelopment? = nil,
        airLayerStartedAt: Date? = nil,
        airLayerWinterCare: Bool? = nil,
        airLayerWinterCareNotes: String = "",
        airLayerSeparated: Bool = false,
        airLayerSeparationDate: Date? = nil,
        airLayerSeparationNotes: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.kind = kind
        self.projectCode = projectCode
        self.genusID = genusID
        self.speciesID = speciesID
        self.cultivarID = cultivarID
        self.botanicalName = botanicalName
        self.commonName = commonName
        self.parentTreeID = parentTreeID
        self.quantity = quantity
        self.stage = stage
        self.plantedAt = plantedAt
        self.locationID = locationID
        self.notes = notes
        self.createdTreeIDs = createdTreeIDs
        self.events = events
        self.imageIDs = imageIDs
        self.nextCheckTaskID = nextCheckTaskID
        self.cuttingTakenAt = cuttingTakenAt
        self.cuttingRootMedium = cuttingRootMedium
        self.cuttingSoilMix = cuttingSoilMix
        self.cuttingLength = cuttingLength
        self.cuttingLeafCount = cuttingLeafCount
        self.cuttingWoodMaturity = cuttingWoodMaturity
        self.cuttingWoodMaturityOverride = cuttingWoodMaturityOverride
        self.cuttingBaseTechnique = cuttingBaseTechnique
        self.cuttingBaseTechniqueOverride = cuttingBaseTechniqueOverride
        self.cuttingStructure = cuttingStructure
        self.cuttingStructureOverride = cuttingStructureOverride
        self.airLayerMethod = airLayerMethod
        self.airLayerMethodOverride = airLayerMethodOverride
        self.airLayerRingWidthMM = airLayerRingWidthMM
        self.airLayerLayerDiameterMM = airLayerLayerDiameterMM
        self.airLayerLocation = airLayerLocation
        self.airLayerLocationOverride = airLayerLocationOverride
        self.airLayerRootingAid = airLayerRootingAid
        self.airLayerRootingAidOverride = airLayerRootingAidOverride
        self.airLayerHormoneProduct = airLayerHormoneProduct
        self.airLayerHormoneConcentration = airLayerHormoneConcentration
        self.airLayerMediumPreset = airLayerMediumPreset
        self.airLayerMediumCustom = airLayerMediumCustom
        self.airLayerWrapSystem = airLayerWrapSystem
        self.airLayerWrapSystemOverride = airLayerWrapSystemOverride
        self.airLayerPurpose = airLayerPurpose
        self.airLayerPurposeOverride = airLayerPurposeOverride
        self.airLayerRootDevelopment = airLayerRootDevelopment
        self.airLayerStartedAt = airLayerStartedAt
        self.airLayerWinterCare = airLayerWinterCare
        self.airLayerWinterCareNotes = airLayerWinterCareNotes
        self.airLayerSeparated = airLayerSeparated
        self.airLayerSeparationDate = airLayerSeparationDate
        self.airLayerSeparationNotes = airLayerSeparationNotes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        kind = try c.decode(NurseryPropagationKind.self, forKey: .kind)
        projectCode = try c.decode(String.self, forKey: .projectCode)
        genusID = try c.decodeIfPresent(UUID.self, forKey: .genusID)
        speciesID = try c.decodeIfPresent(UUID.self, forKey: .speciesID)
        cultivarID = try c.decodeIfPresent(UUID.self, forKey: .cultivarID)
        botanicalName = try c.decode(String.self, forKey: .botanicalName)
        commonName = try c.decodeIfPresent(String.self, forKey: .commonName) ?? ""
        parentTreeID = try c.decodeIfPresent(UUID.self, forKey: .parentTreeID)
        quantity = try c.decode(Int.self, forKey: .quantity)
        stage = try c.decode(NurseryPropagationStage.self, forKey: .stage)
        plantedAt = try c.decodeIfPresent(Date.self, forKey: .plantedAt)
        locationID = try c.decodeIfPresent(UUID.self, forKey: .locationID)
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        createdTreeIDs = try c.decodeIfPresent([UUID].self, forKey: .createdTreeIDs) ?? []
        events = try c.decodeIfPresent([NurseryPropagationEvent].self, forKey: .events) ?? []
        imageIDs = try c.decodeIfPresent([UUID].self, forKey: .imageIDs) ?? []
        nextCheckTaskID = try c.decodeIfPresent(UUID.self, forKey: .nextCheckTaskID)
        cuttingTakenAt = try c.decodeIfPresent(Date.self, forKey: .cuttingTakenAt)
        cuttingRootMedium = try c.decodeIfPresent(String.self, forKey: .cuttingRootMedium) ?? ""
        cuttingSoilMix = try c.decodeIfPresent(String.self, forKey: .cuttingSoilMix) ?? ""
        cuttingLength = try c.decodeIfPresent(String.self, forKey: .cuttingLength) ?? ""
        cuttingLeafCount = try c.decodeIfPresent(Int.self, forKey: .cuttingLeafCount)

        cuttingWoodMaturity = try c.decodeIfPresent(NurseryCuttingWoodMaturity.self, forKey: .cuttingWoodMaturity)
        cuttingWoodMaturityOverride = try c.decodeIfPresent(String.self, forKey: .cuttingWoodMaturityOverride) ?? ""
        cuttingBaseTechnique = try c.decodeIfPresent(NurseryCuttingBaseTechnique.self, forKey: .cuttingBaseTechnique)
        cuttingBaseTechniqueOverride = try c.decodeIfPresent(String.self, forKey: .cuttingBaseTechniqueOverride) ?? ""
        cuttingStructure = try c.decodeIfPresent(NurseryCuttingStructure.self, forKey: .cuttingStructure)
        cuttingStructureOverride = try c.decodeIfPresent(String.self, forKey: .cuttingStructureOverride) ?? ""

        // Migrate brief legacy cut-style / wood-type fields when new keys are absent.
        if cuttingWoodMaturity == nil {
            if let legacyWood = try c.decodeIfPresent(NurseryCuttingWoodType.self, forKey: .cuttingWoodType) {
                switch legacyWood {
                case .hardwood:
                    cuttingWoodMaturity = .hardwood
                case .overWinter:
                    cuttingWoodMaturity = .hardwood
                    if cuttingWoodMaturityOverride.isEmpty {
                        cuttingWoodMaturityOverride = "Over winter"
                    }
                    if !notes.localizedCaseInsensitiveContains("over winter") {
                        notes = notes.isEmpty
                            ? "Often needs to stand over winter."
                            : notes + "\nOften needs to stand over winter."
                    }
                }
            }
            let legacyWoodOverride = try c.decodeIfPresent(String.self, forKey: .cuttingWoodTypeOverride) ?? ""
            if cuttingWoodMaturityOverride.isEmpty, !legacyWoodOverride.isEmpty {
                cuttingWoodMaturityOverride = legacyWoodOverride
            }
        }
        if cuttingBaseTechnique == nil {
            if let legacyStyle = try c.decodeIfPresent(NurseryCuttingCutStyle.self, forKey: .cuttingCutStyle) {
                switch legacyStyle {
                case .wholeCutting:
                    cuttingBaseTechnique = .straight
                case .midBranch:
                    cuttingBaseTechniqueOverride = cuttingBaseTechniqueOverride.isEmpty
                        ? "Mid-branch" : cuttingBaseTechniqueOverride
                }
            }
            let legacyStyleOverride = try c.decodeIfPresent(String.self, forKey: .cuttingCutStyleOverride) ?? ""
            if cuttingBaseTechniqueOverride.isEmpty, !legacyStyleOverride.isEmpty {
                cuttingBaseTechniqueOverride = legacyStyleOverride
            }
        }

        // Legacy Season tip → Notes.
        let legacySeasonTip = try c.decodeIfPresent(String.self, forKey: .cuttingSeasonTip)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !legacySeasonTip.isEmpty, !notes.contains(legacySeasonTip) {
            notes = notes.isEmpty ? legacySeasonTip : notes + "\n" + legacySeasonTip
        }

        airLayerMethod = try c.decodeIfPresent(NurseryAirLayerMethod.self, forKey: .airLayerMethod)
        airLayerMethodOverride = try c.decodeIfPresent(String.self, forKey: .airLayerMethodOverride) ?? ""
        airLayerRingWidthMM = try c.decodeIfPresent(Double.self, forKey: .airLayerRingWidthMM)
        airLayerLayerDiameterMM = try c.decodeIfPresent(Double.self, forKey: .airLayerLayerDiameterMM)
        airLayerLocation = try c.decodeIfPresent(NurseryAirLayerLocation.self, forKey: .airLayerLocation)
        airLayerLocationOverride = try c.decodeIfPresent(String.self, forKey: .airLayerLocationOverride) ?? ""
        airLayerRootingAid = try c.decodeIfPresent(NurseryAirLayerRootingAid.self, forKey: .airLayerRootingAid)
        airLayerRootingAidOverride = try c.decodeIfPresent(String.self, forKey: .airLayerRootingAidOverride) ?? ""
        airLayerHormoneProduct = try c.decodeIfPresent(String.self, forKey: .airLayerHormoneProduct) ?? ""
        airLayerHormoneConcentration = try c.decodeIfPresent(String.self, forKey: .airLayerHormoneConcentration) ?? ""
        airLayerMediumPreset = try c.decodeIfPresent(NurseryAirLayerMediumPreset.self, forKey: .airLayerMediumPreset)
        airLayerMediumCustom = try c.decodeIfPresent(String.self, forKey: .airLayerMediumCustom) ?? ""
        airLayerWrapSystem = try c.decodeIfPresent(NurseryAirLayerWrapSystem.self, forKey: .airLayerWrapSystem)
        airLayerWrapSystemOverride = try c.decodeIfPresent(String.self, forKey: .airLayerWrapSystemOverride) ?? ""
        airLayerPurpose = try c.decodeIfPresent(NurseryAirLayerPurpose.self, forKey: .airLayerPurpose)
        airLayerPurposeOverride = try c.decodeIfPresent(String.self, forKey: .airLayerPurposeOverride) ?? ""
        airLayerRootDevelopment = try c.decodeIfPresent(
            NurseryAirLayerRootDevelopment.self,
            forKey: .airLayerRootDevelopment
        )
        airLayerStartedAt = try c.decodeIfPresent(Date.self, forKey: .airLayerStartedAt)
        airLayerWinterCare = try c.decodeIfPresent(Bool.self, forKey: .airLayerWinterCare)
        airLayerWinterCareNotes = try c.decodeIfPresent(String.self, forKey: .airLayerWinterCareNotes) ?? ""
        airLayerSeparated = try c.decodeIfPresent(Bool.self, forKey: .airLayerSeparated) ?? false
        airLayerSeparationDate = try c.decodeIfPresent(Date.self, forKey: .airLayerSeparationDate)
        airLayerSeparationNotes = try c.decodeIfPresent(String.self, forKey: .airLayerSeparationNotes) ?? ""

        // Legacy free-text wrap / hormone / medium / winter watering.
        let legacyWrap = try c.decodeIfPresent(String.self, forKey: .airLayerWrap)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if airLayerWrapSystem == nil, airLayerWrapSystemOverride.isEmpty, !legacyWrap.isEmpty {
            airLayerWrapSystemOverride = legacyWrap
        }
        let legacyHormone = try c.decodeIfPresent(String.self, forKey: .airLayerHormone)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if airLayerHormoneProduct.isEmpty, !legacyHormone.isEmpty {
            airLayerHormoneProduct = legacyHormone
            if airLayerRootingAid == nil { airLayerRootingAid = .rootingHormone }
        }
        let legacyMedium = try c.decodeIfPresent(String.self, forKey: .airLayerMedium)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if airLayerMediumCustom.isEmpty, !legacyMedium.isEmpty {
            airLayerMediumCustom = legacyMedium
            if airLayerMediumPreset == nil { airLayerMediumPreset = .custom }
        }
        if airLayerWinterCare == nil {
            airLayerWinterCare = try c.decodeIfPresent(Bool.self, forKey: .airLayerWinterWatering)
        }
        let legacyWinterNotes = try c.decodeIfPresent(String.self, forKey: .airLayerWinterWateringNotes)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if airLayerWinterCareNotes.isEmpty, !legacyWinterNotes.isEmpty {
            airLayerWinterCareNotes = legacyWinterNotes
        }

        createdAt = try c.decode(Date.self, forKey: .createdAt)
        updatedAt = try c.decode(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(kind, forKey: .kind)
        try c.encode(projectCode, forKey: .projectCode)
        try c.encodeIfPresent(genusID, forKey: .genusID)
        try c.encodeIfPresent(speciesID, forKey: .speciesID)
        try c.encodeIfPresent(cultivarID, forKey: .cultivarID)
        try c.encode(botanicalName, forKey: .botanicalName)
        try c.encode(commonName, forKey: .commonName)
        try c.encodeIfPresent(parentTreeID, forKey: .parentTreeID)
        try c.encode(quantity, forKey: .quantity)
        try c.encode(stage, forKey: .stage)
        try c.encodeIfPresent(plantedAt, forKey: .plantedAt)
        try c.encodeIfPresent(locationID, forKey: .locationID)
        try c.encode(notes, forKey: .notes)
        try c.encode(createdTreeIDs, forKey: .createdTreeIDs)
        try c.encode(events, forKey: .events)
        try c.encode(imageIDs, forKey: .imageIDs)
        try c.encodeIfPresent(nextCheckTaskID, forKey: .nextCheckTaskID)
        try c.encodeIfPresent(cuttingTakenAt, forKey: .cuttingTakenAt)
        try c.encode(cuttingRootMedium, forKey: .cuttingRootMedium)
        try c.encode(cuttingSoilMix, forKey: .cuttingSoilMix)
        try c.encode(cuttingLength, forKey: .cuttingLength)
        try c.encodeIfPresent(cuttingLeafCount, forKey: .cuttingLeafCount)
        try c.encodeIfPresent(cuttingWoodMaturity, forKey: .cuttingWoodMaturity)
        try c.encode(cuttingWoodMaturityOverride, forKey: .cuttingWoodMaturityOverride)
        try c.encodeIfPresent(cuttingBaseTechnique, forKey: .cuttingBaseTechnique)
        try c.encode(cuttingBaseTechniqueOverride, forKey: .cuttingBaseTechniqueOverride)
        try c.encodeIfPresent(cuttingStructure, forKey: .cuttingStructure)
        try c.encode(cuttingStructureOverride, forKey: .cuttingStructureOverride)
        try c.encodeIfPresent(airLayerMethod, forKey: .airLayerMethod)
        try c.encode(airLayerMethodOverride, forKey: .airLayerMethodOverride)
        try c.encodeIfPresent(airLayerRingWidthMM, forKey: .airLayerRingWidthMM)
        try c.encodeIfPresent(airLayerLayerDiameterMM, forKey: .airLayerLayerDiameterMM)
        try c.encodeIfPresent(airLayerLocation, forKey: .airLayerLocation)
        try c.encode(airLayerLocationOverride, forKey: .airLayerLocationOverride)
        try c.encodeIfPresent(airLayerRootingAid, forKey: .airLayerRootingAid)
        try c.encode(airLayerRootingAidOverride, forKey: .airLayerRootingAidOverride)
        try c.encode(airLayerHormoneProduct, forKey: .airLayerHormoneProduct)
        try c.encode(airLayerHormoneConcentration, forKey: .airLayerHormoneConcentration)
        try c.encodeIfPresent(airLayerMediumPreset, forKey: .airLayerMediumPreset)
        try c.encode(airLayerMediumCustom, forKey: .airLayerMediumCustom)
        try c.encodeIfPresent(airLayerWrapSystem, forKey: .airLayerWrapSystem)
        try c.encode(airLayerWrapSystemOverride, forKey: .airLayerWrapSystemOverride)
        try c.encodeIfPresent(airLayerPurpose, forKey: .airLayerPurpose)
        try c.encode(airLayerPurposeOverride, forKey: .airLayerPurposeOverride)
        try c.encodeIfPresent(airLayerRootDevelopment, forKey: .airLayerRootDevelopment)
        try c.encodeIfPresent(airLayerStartedAt, forKey: .airLayerStartedAt)
        try c.encodeIfPresent(airLayerWinterCare, forKey: .airLayerWinterCare)
        try c.encode(airLayerWinterCareNotes, forKey: .airLayerWinterCareNotes)
        try c.encode(airLayerSeparated, forKey: .airLayerSeparated)
        try c.encodeIfPresent(airLayerSeparationDate, forKey: .airLayerSeparationDate)
        try c.encode(airLayerSeparationNotes, forKey: .airLayerSeparationNotes)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(updatedAt, forKey: .updatedAt)
    }
}

struct NurseryPropagationCreateDraft: Hashable, Sendable {
    var kind: NurseryPropagationKind
    var genusID: UUID?
    var speciesID: UUID?
    var cultivarID: UUID?
    var botanicalName: String
    var commonName: String
    var parentTreeID: UUID?
    var quantity: Int
    var plantedAt: Date?
    var locationID: UUID?
    var notes: String

    var cuttingTakenAt: Date?
    var cuttingRootMedium: String
    var cuttingSoilMix: String
    var cuttingLength: String
    var cuttingLeafCount: Int?
    var cuttingWoodMaturity: NurseryCuttingWoodMaturity?
    var cuttingWoodMaturityOverride: String
    var cuttingBaseTechnique: NurseryCuttingBaseTechnique?
    var cuttingBaseTechniqueOverride: String
    var cuttingStructure: NurseryCuttingStructure?
    var cuttingStructureOverride: String

    var airLayerMethod: NurseryAirLayerMethod?
    var airLayerMethodOverride: String
    var airLayerRingWidthMM: Double?
    var airLayerLayerDiameterMM: Double?
    var airLayerLocation: NurseryAirLayerLocation?
    var airLayerLocationOverride: String
    var airLayerRootingAid: NurseryAirLayerRootingAid?
    var airLayerRootingAidOverride: String
    var airLayerHormoneProduct: String
    var airLayerHormoneConcentration: String
    var airLayerMediumPreset: NurseryAirLayerMediumPreset?
    var airLayerMediumCustom: String
    var airLayerWrapSystem: NurseryAirLayerWrapSystem?
    var airLayerWrapSystemOverride: String
    var airLayerPurpose: NurseryAirLayerPurpose?
    var airLayerPurposeOverride: String
    var airLayerRootDevelopment: NurseryAirLayerRootDevelopment?
    var airLayerStartedAt: Date?
    var airLayerWinterCare: Bool?
    var airLayerWinterCareNotes: String
    var airLayerSeparated: Bool
    var airLayerSeparationDate: Date?
    var airLayerSeparationNotes: String

    init(
        kind: NurseryPropagationKind,
        genusID: UUID? = nil,
        speciesID: UUID? = nil,
        cultivarID: UUID? = nil,
        botanicalName: String,
        commonName: String = "",
        parentTreeID: UUID? = nil,
        quantity: Int = 1,
        plantedAt: Date? = nil,
        locationID: UUID? = nil,
        notes: String = "",
        cuttingTakenAt: Date? = nil,
        cuttingRootMedium: String = "",
        cuttingSoilMix: String = "",
        cuttingLength: String = "",
        cuttingLeafCount: Int? = nil,
        cuttingWoodMaturity: NurseryCuttingWoodMaturity? = nil,
        cuttingWoodMaturityOverride: String = "",
        cuttingBaseTechnique: NurseryCuttingBaseTechnique? = nil,
        cuttingBaseTechniqueOverride: String = "",
        cuttingStructure: NurseryCuttingStructure? = nil,
        cuttingStructureOverride: String = "",
        airLayerMethod: NurseryAirLayerMethod? = .completeRing,
        airLayerMethodOverride: String = "",
        airLayerRingWidthMM: Double? = nil,
        airLayerLayerDiameterMM: Double? = nil,
        airLayerLocation: NurseryAirLayerLocation? = nil,
        airLayerLocationOverride: String = "",
        airLayerRootingAid: NurseryAirLayerRootingAid? = .none,
        airLayerRootingAidOverride: String = "",
        airLayerHormoneProduct: String = "",
        airLayerHormoneConcentration: String = "",
        airLayerMediumPreset: NurseryAirLayerMediumPreset? = .longFiberSphagnum,
        airLayerMediumCustom: String = "",
        airLayerWrapSystem: NurseryAirLayerWrapSystem? = nil,
        airLayerWrapSystemOverride: String = "",
        airLayerPurpose: NurseryAirLayerPurpose? = nil,
        airLayerPurposeOverride: String = "",
        airLayerRootDevelopment: NurseryAirLayerRootDevelopment? = .noRoots,
        airLayerStartedAt: Date? = nil,
        airLayerWinterCare: Bool? = nil,
        airLayerWinterCareNotes: String = "",
        airLayerSeparated: Bool = false,
        airLayerSeparationDate: Date? = nil,
        airLayerSeparationNotes: String = ""
    ) {
        self.kind = kind
        self.genusID = genusID
        self.speciesID = speciesID
        self.cultivarID = cultivarID
        self.botanicalName = botanicalName
        self.commonName = commonName
        self.parentTreeID = parentTreeID
        self.quantity = quantity
        self.plantedAt = plantedAt
        self.locationID = locationID
        self.notes = notes
        self.cuttingTakenAt = cuttingTakenAt
        self.cuttingRootMedium = cuttingRootMedium
        self.cuttingSoilMix = cuttingSoilMix
        self.cuttingLength = cuttingLength
        self.cuttingLeafCount = cuttingLeafCount
        self.cuttingWoodMaturity = cuttingWoodMaturity
        self.cuttingWoodMaturityOverride = cuttingWoodMaturityOverride
        self.cuttingBaseTechnique = cuttingBaseTechnique
        self.cuttingBaseTechniqueOverride = cuttingBaseTechniqueOverride
        self.cuttingStructure = cuttingStructure
        self.cuttingStructureOverride = cuttingStructureOverride
        self.airLayerMethod = airLayerMethod
        self.airLayerMethodOverride = airLayerMethodOverride
        self.airLayerRingWidthMM = airLayerRingWidthMM
        self.airLayerLayerDiameterMM = airLayerLayerDiameterMM
        self.airLayerLocation = airLayerLocation
        self.airLayerLocationOverride = airLayerLocationOverride
        self.airLayerRootingAid = airLayerRootingAid
        self.airLayerRootingAidOverride = airLayerRootingAidOverride
        self.airLayerHormoneProduct = airLayerHormoneProduct
        self.airLayerHormoneConcentration = airLayerHormoneConcentration
        self.airLayerMediumPreset = airLayerMediumPreset
        self.airLayerMediumCustom = airLayerMediumCustom
        self.airLayerWrapSystem = airLayerWrapSystem
        self.airLayerWrapSystemOverride = airLayerWrapSystemOverride
        self.airLayerPurpose = airLayerPurpose
        self.airLayerPurposeOverride = airLayerPurposeOverride
        self.airLayerRootDevelopment = airLayerRootDevelopment
        self.airLayerStartedAt = airLayerStartedAt
        self.airLayerWinterCare = airLayerWinterCare
        self.airLayerWinterCareNotes = airLayerWinterCareNotes
        self.airLayerSeparated = airLayerSeparated
        self.airLayerSeparationDate = airLayerSeparationDate
        self.airLayerSeparationNotes = airLayerSeparationNotes
    }
}
