//
//  Tree.swift
//  Bonsai World
//
//  Central domain entity for an individual bonsai.
//  Shape only — no UI, platform, persistence, or business logic.
//
//  Identity: bonsaiName (system) + botanicalName (botanical) + optional nickname.
//  Ownership lifecycle: Acquisition → active care → Disposal (end of ownership).
//  Delete remains reserved for test / incorrect / duplicate records — not disposal.
//

import Foundation

/// An individual bonsai in the grower’s World.
struct Tree: Identifiable, Codable, Hashable, Sendable {

    // MARK: - Identity

    var id: UUID
    /// Generated / authored botanical label (e.g. Acer palmatum 'Deshojo').
    var botanicalName: String
    /// Optional personal name (e.g. "Grandpa", "Terrace Juniper"). Empty when unset.
    var nickname: String
    /// Permanent registry code (GEN-SPE-CUL-YYYY-NNN). Set at creation; empty when unset.
    var bonsaiName: String

    // MARK: - Botanical (Reference Data)

    var genusID: UUID?
    var speciesID: UUID?
    var cultivarID: UUID?

    // MARK: - Classification (Reference Data)

    var styleID: UUID?
    var sizeClassID: UUID?
    /// Reference Data — Tree Stage (authoritative development position).
    var treeStageID: UUID?
    /// Grower-facing health assessment (not botanical identity).
    var healthStatus: TreeHealthStatus

    // MARK: - Fertilization plan inputs
    // Tree Stage drives fertilization mode. Condition is explicit — never assumed healthy.

    /// Explicit condition for feeding. Nil = unknown — never assumed healthy.
    var fertilizerHealth: FertilizerHealth?
    /// Optional kind when species mapping is missing or pine flush must be chosen.
    var fertilizerKindOverride: FertilizerKind?

    // MARK: - Growing

    /// Reference Data — Growing → Locations. Required.
    /// Map position is derived from this Location — Trees never store coordinates.
    var locationID: UUID
    /// Reference Data — Soil Mix (composition lives on the mix, not the tree).
    var soilMixID: UUID?
    /// Tree Pot Description — generic container type (Reference Data Pot Type).
    /// Always available as fallback when no Inventory Pot is assigned.
    /// Not cleared when an Inventory Pot is linked; Inventory Pot wins for display only.
    var potTypeID: UUID?
    var lightConditionID: UUID?

    // MARK: - Measurements

    /// Latest Tree dimensions (mm) — denormalized from Measurement History.
    /// Display via ``MeasurementService`` / ``MeasurementDimension/height``.
    var heightMillimetres: Int?
    var crownWidthMillimetres: Int?
    var nebariWidthMillimetres: Int?
    var trunkDiameterMillimetres: Int?

    // MARK: - Pot (Tree Pot Description + optional Inventory Pot)

    /// Optional dimensions for Tree Pot Description (mm). Independent of Inventory Pot.
    var potLengthMillimetres: Int?
    var potWidthMillimetres: Int?
    var potHeightMillimetres: Int?
    var potDiameterMillimetres: Int?

    /// Optional Inventory Pot currently in use. Owned/synced by PotService — never edit
    /// directly. When set, Inventory Pot details override Tree Pot Description for
    /// display; ``potTypeID`` and description dimensions remain stored as fallback.
    var currentPotID: UUID?

    /// Origin Yamadori record when this Tree was created via collection or Transfer.
    /// Never equals the Yamadori display code — links by UUID only.
    var sourceYamadoriID: UUID?
    /// Origin Seed Batch when this Tree was created from Seed Work.
    var sourceSeedBatchID: UUID?
    /// When true, this Tree appears in Nursery → Yamadori Trees until moved to My Trees.
    var yamadoriNursery: Bool

    // MARK: - Acquisition (start of ownership)

    var acquisitionDate: Date?
    /// Reference Data — Acquisition Method.
    var acquisitionMethodID: UUID?
    /// Free-text source whose UI label depends on the selected method.
    var acquisitionSourceName: String
    /// Purchase / acquisition cost. Economy prep — no calculations here.
    var purchasePrice: Decimal?
    var acquisitionNotes: String

    // MARK: - Disposal (end of ownership — tree normally remains in the database)

    var disposalDate: Date?
    /// Reference Data — Disposal Method.
    var disposalMethodID: UUID?
    /// Free-text party / detail whose UI label depends on the selected method.
    var disposalPartyName: String
    /// Sale / disposal proceeds. Economy prep — no calculations here.
    var disposalPrice: Decimal?
    var disposalNotes: String

    // MARK: - Notes

    var notes: String
    /// Short summary of what is known about this tree before it entered the grower’s care.
    var knownHistory: String

    // MARK: - Social

    /// Per-tree Social share level. Effective only when App Settings → Social is on.
    var socialShareLevel: SocialShareLevel

    // MARK: - Repotting plan (grower-set interval)

    /// Last known repot date (may be recorded before the tree entered this garden).
    var lastRepottedDate: Date?
    /// How often this tree should be repotted, in years. Nil = no automatic schedule.
    var repottingIntervalYears: Int?

    /// When set, this tree is on the fertilizer-bags program. Date of last place/replace.
    var lastFertilizerBagReplacedAt: Date?

    // MARK: - Placement strategy & season (Winter / Spring Care)

    /// Always outdoors vs seasonal in/out — distinct from Location (where it stands now).
    var placementStrategy: TreePlacementStrategy
    /// Summer vs winter mode for seasonal trees.
    var seasonPlacement: TreeSeasonPlacement
    /// Completed Winter Care checklist steps for the current prep pass.
    var winterCareCompletedSteps: [WinterCareStep]
    /// Completed Spring Care checklist steps for the current return pass.
    var springCareCompletedSteps: [SpringCareStep]

    // MARK: - Watering policy

    /// The one Care-policy Collection this tree inherits watering from (optional).
    var carePolicyCollectionID: UUID?
    /// When set, overrides Collection watering mode.
    var wateringModeOverride: WateringMode?
    /// When mode override is ``WateringMode/auto``, times per day (1…3).
    var autoTimesPerDayOverride: Int?

    /// Shaping → Vision. Nil on trees that have never opened Vision.
    var vision: TreeVision?

    /// Shaping → practical development workbook (observations, plans, history).
    var shaping: TreeShaping?

    // MARK: - Images (identifiers only — never absolute paths)

    var primaryImageID: UUID?
    /// Gallery order. May include `primaryImageID`.
    var imageIDs: [UUID]

    // MARK: - Relationships (identifiers only — behaviour reserved)

    /// Collection membership is owned by ``Collection/treeIDs`` — not stored on Tree (see Product Blueprint §4.4).
    /// Future Projects module.
    var projectIDs: [UUID]
    /// Future Journal module.
    var journalEntryIDs: [UUID]
    /// Future Tasks module.
    var taskIDs: [UUID]

    // MARK: - Metadata

    var createdDate: Date
    var modifiedDate: Date

    // MARK: - Init

    init(
        id: UUID = UUID(),
        botanicalName: String = "",
        nickname: String = "",
        bonsaiName: String = "",
        genusID: UUID? = nil,
        speciesID: UUID? = nil,
        cultivarID: UUID? = nil,
        styleID: UUID? = nil,
        sizeClassID: UUID? = nil,
        treeStageID: UUID? = nil,
        healthStatus: TreeHealthStatus = .stable,
        fertilizerHealth: FertilizerHealth? = nil,
        fertilizerKindOverride: FertilizerKind? = nil,
        locationID: UUID,
        soilMixID: UUID? = nil,
        potTypeID: UUID? = nil,
        lightConditionID: UUID? = nil,
        heightMillimetres: Int? = nil,
        crownWidthMillimetres: Int? = nil,
        nebariWidthMillimetres: Int? = nil,
        trunkDiameterMillimetres: Int? = nil,
        potLengthMillimetres: Int? = nil,
        potWidthMillimetres: Int? = nil,
        potHeightMillimetres: Int? = nil,
        potDiameterMillimetres: Int? = nil,
        currentPotID: UUID? = nil,
        sourceYamadoriID: UUID? = nil,
        sourceSeedBatchID: UUID? = nil,
        yamadoriNursery: Bool = false,
        acquisitionDate: Date? = nil,
        acquisitionMethodID: UUID? = nil,
        acquisitionSourceName: String = "",
        purchasePrice: Decimal? = nil,
        acquisitionNotes: String = "",
        disposalDate: Date? = nil,
        disposalMethodID: UUID? = nil,
        disposalPartyName: String = "",
        disposalPrice: Decimal? = nil,
        disposalNotes: String = "",
        notes: String = "",
        knownHistory: String = "",
        socialShareLevel: SocialShareLevel = .off,
        lastRepottedDate: Date? = nil,
        repottingIntervalYears: Int? = nil,
        lastFertilizerBagReplacedAt: Date? = nil,
        placementStrategy: TreePlacementStrategy = .seasonal,
        seasonPlacement: TreeSeasonPlacement = .summer,
        winterCareCompletedSteps: [WinterCareStep] = [],
        springCareCompletedSteps: [SpringCareStep] = [],
        carePolicyCollectionID: UUID? = nil,
        wateringModeOverride: WateringMode? = nil,
        autoTimesPerDayOverride: Int? = nil,
        vision: TreeVision? = nil,
        shaping: TreeShaping? = nil,
        primaryImageID: UUID? = nil,
        imageIDs: [UUID] = [],
        projectIDs: [UUID] = [],
        journalEntryIDs: [UUID] = [],
        taskIDs: [UUID] = [],
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.botanicalName = botanicalName
        self.nickname = nickname
        self.bonsaiName = bonsaiName
        self.genusID = genusID
        self.speciesID = speciesID
        self.cultivarID = cultivarID
        self.styleID = styleID
        self.sizeClassID = sizeClassID
        self.treeStageID = treeStageID
        self.healthStatus = healthStatus
        self.fertilizerHealth = fertilizerHealth
        self.fertilizerKindOverride = fertilizerKindOverride
        self.locationID = locationID
        self.soilMixID = soilMixID
        self.potTypeID = potTypeID
        self.lightConditionID = lightConditionID
        self.heightMillimetres = heightMillimetres
        self.crownWidthMillimetres = crownWidthMillimetres
        self.nebariWidthMillimetres = nebariWidthMillimetres
        self.trunkDiameterMillimetres = trunkDiameterMillimetres
        self.potLengthMillimetres = potLengthMillimetres
        self.potWidthMillimetres = potWidthMillimetres
        self.potHeightMillimetres = potHeightMillimetres
        self.potDiameterMillimetres = potDiameterMillimetres
        self.currentPotID = currentPotID
        self.sourceYamadoriID = sourceYamadoriID
        self.sourceSeedBatchID = sourceSeedBatchID
        self.yamadoriNursery = yamadoriNursery
        self.acquisitionDate = acquisitionDate
        self.acquisitionMethodID = acquisitionMethodID
        self.acquisitionSourceName = acquisitionSourceName
        self.purchasePrice = purchasePrice
        self.acquisitionNotes = acquisitionNotes
        self.disposalDate = disposalDate
        self.disposalMethodID = disposalMethodID
        self.disposalPartyName = disposalPartyName
        self.disposalPrice = disposalPrice
        self.disposalNotes = disposalNotes
        self.notes = notes
        self.knownHistory = knownHistory
        self.socialShareLevel = socialShareLevel
        self.lastRepottedDate = lastRepottedDate
        self.repottingIntervalYears = repottingIntervalYears.map { max(1, min(20, $0)) }
        self.lastFertilizerBagReplacedAt = lastFertilizerBagReplacedAt
        self.placementStrategy = placementStrategy
        self.seasonPlacement = seasonPlacement
        self.winterCareCompletedSteps = winterCareCompletedSteps
        self.springCareCompletedSteps = springCareCompletedSteps
        self.carePolicyCollectionID = carePolicyCollectionID
        self.wateringModeOverride = wateringModeOverride
        self.autoTimesPerDayOverride = autoTimesPerDayOverride.map(WateringMode.clampedTimes)
        self.vision = vision
        self.shaping = shaping
        self.primaryImageID = primaryImageID
        self.imageIDs = imageIDs
        self.projectIDs = projectIDs
        self.journalEntryIDs = journalEntryIDs
        self.taskIDs = taskIDs
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }

    /// Photo for tree lists: primary, otherwise the first gallery image.
    var listImageID: UUID? { primaryImageID ?? imageIDs.first }

    /// No primary and no gallery images — single source of truth for Library /
    /// Needs Photos / Trees ``withoutPhoto`` (reference/shaping images stay off this list).
    var lacksPhoto: Bool { primaryImageID == nil && imageIDs.isEmpty }

    /// Inverse of ``lacksPhoto``.
    var hasPhoto: Bool { !lacksPhoto }

    /// In the grower’s care — no disposal method recorded (Blueprint §4.5 Active).
    var isInCare: Bool { disposalMethodID == nil }

    /// True when any disposal field indicates ownership has ended.
    var hasDisposalRecord: Bool {
        disposalDate != nil
            || disposalMethodID != nil
            || !disposalPartyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || disposalPrice != nil
            || !disposalNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Codable (Tree Stage migration)

extension Tree {
    private enum CodingKeys: String, CodingKey {
        case id, botanicalName, nickname, bonsaiName
        case genusID, speciesID, cultivarID, styleID, sizeClassID
        case treeStageID
        case treeStatusID
        case healthStatus
        case fertilizerHealth, fertilizerKindOverride
        case fertilizerStage, fertilizerGrowth
        case locationID, soilMixID, potTypeID, lightConditionID
        case heightMillimetres, crownWidthMillimetres, nebariWidthMillimetres, trunkDiameterMillimetres
        case potLengthMillimetres, potWidthMillimetres, potHeightMillimetres, potDiameterMillimetres
        case currentPotID, sourceYamadoriID, sourceSeedBatchID, yamadoriNursery
        case acquisitionDate, acquisitionMethodID, acquisitionSourceName, purchasePrice, acquisitionNotes
        case disposalDate, disposalMethodID, disposalPartyName, disposalPrice, disposalNotes
        case notes, knownHistory, socialShareLevel
        case lastRepottedDate, repottingIntervalYears, lastFertilizerBagReplacedAt
        case placementStrategy, seasonPlacement, winterCareCompletedSteps, springCareCompletedSteps
        case seasonalStorage // legacy single-field migration
        case carePolicyCollectionID, wateringModeOverride, autoTimesPerDayOverride
        case vision, shaping
        case primaryImageID, imageIDs, projectIDs, journalEntryIDs, taskIDs
        case createdDate, modifiedDate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        botanicalName = try c.decode(String.self, forKey: .botanicalName)
        nickname = try c.decodeIfPresent(String.self, forKey: .nickname) ?? ""
        bonsaiName = try c.decodeIfPresent(String.self, forKey: .bonsaiName) ?? ""
        genusID = try c.decodeIfPresent(UUID.self, forKey: .genusID)
        speciesID = try c.decodeIfPresent(UUID.self, forKey: .speciesID)
        cultivarID = try c.decodeIfPresent(UUID.self, forKey: .cultivarID)
        styleID = try c.decodeIfPresent(UUID.self, forKey: .styleID)
        sizeClassID = try c.decodeIfPresent(UUID.self, forKey: .sizeClassID)
        treeStageID = try c.decodeIfPresent(UUID.self, forKey: .treeStageID)
            ?? c.decodeIfPresent(UUID.self, forKey: .treeStatusID)
        healthStatus = try c.decodeIfPresent(TreeHealthStatus.self, forKey: .healthStatus) ?? .stable
        fertilizerHealth = try c.decodeIfPresent(FertilizerHealth.self, forKey: .fertilizerHealth)
        fertilizerKindOverride = try c.decodeIfPresent(FertilizerKind.self, forKey: .fertilizerKindOverride)
        locationID = try c.decode(UUID.self, forKey: .locationID)
        soilMixID = try c.decodeIfPresent(UUID.self, forKey: .soilMixID)
        potTypeID = try c.decodeIfPresent(UUID.self, forKey: .potTypeID)
        lightConditionID = try c.decodeIfPresent(UUID.self, forKey: .lightConditionID)
        heightMillimetres = try c.decodeIfPresent(Int.self, forKey: .heightMillimetres)
        crownWidthMillimetres = try c.decodeIfPresent(Int.self, forKey: .crownWidthMillimetres)
        nebariWidthMillimetres = try c.decodeIfPresent(Int.self, forKey: .nebariWidthMillimetres)
        trunkDiameterMillimetres = try c.decodeIfPresent(Int.self, forKey: .trunkDiameterMillimetres)
        potLengthMillimetres = try c.decodeIfPresent(Int.self, forKey: .potLengthMillimetres)
        potWidthMillimetres = try c.decodeIfPresent(Int.self, forKey: .potWidthMillimetres)
        potHeightMillimetres = try c.decodeIfPresent(Int.self, forKey: .potHeightMillimetres)
        potDiameterMillimetres = try c.decodeIfPresent(Int.self, forKey: .potDiameterMillimetres)
        currentPotID = try c.decodeIfPresent(UUID.self, forKey: .currentPotID)
        sourceYamadoriID = try c.decodeIfPresent(UUID.self, forKey: .sourceYamadoriID)
        sourceSeedBatchID = try c.decodeIfPresent(UUID.self, forKey: .sourceSeedBatchID)
        yamadoriNursery = try c.decodeIfPresent(Bool.self, forKey: .yamadoriNursery) ?? false
        acquisitionDate = try c.decodeIfPresent(Date.self, forKey: .acquisitionDate)
        acquisitionMethodID = try c.decodeIfPresent(UUID.self, forKey: .acquisitionMethodID)
        acquisitionSourceName = try c.decodeIfPresent(String.self, forKey: .acquisitionSourceName) ?? ""
        purchasePrice = try c.decodeIfPresent(Decimal.self, forKey: .purchasePrice)
        acquisitionNotes = try c.decodeIfPresent(String.self, forKey: .acquisitionNotes) ?? ""
        disposalDate = try c.decodeIfPresent(Date.self, forKey: .disposalDate)
        disposalMethodID = try c.decodeIfPresent(UUID.self, forKey: .disposalMethodID)
        disposalPartyName = try c.decodeIfPresent(String.self, forKey: .disposalPartyName) ?? ""
        disposalPrice = try c.decodeIfPresent(Decimal.self, forKey: .disposalPrice)
        disposalNotes = try c.decodeIfPresent(String.self, forKey: .disposalNotes) ?? ""
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        knownHistory = try c.decodeIfPresent(String.self, forKey: .knownHistory) ?? ""
        socialShareLevel = try c.decodeIfPresent(SocialShareLevel.self, forKey: .socialShareLevel) ?? .off
        lastRepottedDate = try c.decodeIfPresent(Date.self, forKey: .lastRepottedDate)
        if let years = try c.decodeIfPresent(Int.self, forKey: .repottingIntervalYears) {
            repottingIntervalYears = max(1, min(20, years))
        } else {
            repottingIntervalYears = nil
        }
        lastFertilizerBagReplacedAt = try c.decodeIfPresent(Date.self, forKey: .lastFertilizerBagReplacedAt)
        if let strategy = try c.decodeIfPresent(TreePlacementStrategy.self, forKey: .placementStrategy),
           let season = try c.decodeIfPresent(TreeSeasonPlacement.self, forKey: .seasonPlacement) {
            placementStrategy = strategy
            seasonPlacement = season
        } else if let legacy = try c.decodeIfPresent(String.self, forKey: .seasonalStorage) {
            switch legacy {
            case "alwaysOutdoors":
                placementStrategy = .alwaysOutdoors
                seasonPlacement = .summer
            case "winterStorage":
                placementStrategy = .seasonal
                seasonPlacement = .winter
            default:
                placementStrategy = .seasonal
                seasonPlacement = .summer
            }
        } else {
            placementStrategy = .seasonal
            seasonPlacement = .summer
        }
        winterCareCompletedSteps = try c.decodeIfPresent([WinterCareStep].self, forKey: .winterCareCompletedSteps) ?? []
        springCareCompletedSteps = try c.decodeIfPresent([SpringCareStep].self, forKey: .springCareCompletedSteps) ?? []
        carePolicyCollectionID = try c.decodeIfPresent(UUID.self, forKey: .carePolicyCollectionID)
        wateringModeOverride = try c.decodeIfPresent(WateringMode.self, forKey: .wateringModeOverride)
        autoTimesPerDayOverride = try c.decodeIfPresent(Int.self, forKey: .autoTimesPerDayOverride)
            .map(WateringMode.clampedTimes)
        vision = try c.decodeIfPresent(TreeVision.self, forKey: .vision)
        shaping = try c.decodeIfPresent(TreeShaping.self, forKey: .shaping)
        primaryImageID = try c.decodeIfPresent(UUID.self, forKey: .primaryImageID)
        imageIDs = try c.decodeIfPresent([UUID].self, forKey: .imageIDs) ?? []
        projectIDs = try c.decodeIfPresent([UUID].self, forKey: .projectIDs) ?? []
        journalEntryIDs = try c.decodeIfPresent([UUID].self, forKey: .journalEntryIDs) ?? []
        taskIDs = try c.decodeIfPresent([UUID].self, forKey: .taskIDs) ?? []
        createdDate = try c.decodeIfPresent(Date.self, forKey: .createdDate) ?? .now
        modifiedDate = try c.decodeIfPresent(Date.self, forKey: .modifiedDate) ?? .now
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(botanicalName, forKey: .botanicalName)
        try c.encode(nickname, forKey: .nickname)
        try c.encode(bonsaiName, forKey: .bonsaiName)
        try c.encodeIfPresent(genusID, forKey: .genusID)
        try c.encodeIfPresent(speciesID, forKey: .speciesID)
        try c.encodeIfPresent(cultivarID, forKey: .cultivarID)
        try c.encodeIfPresent(styleID, forKey: .styleID)
        try c.encodeIfPresent(sizeClassID, forKey: .sizeClassID)
        try c.encodeIfPresent(treeStageID, forKey: .treeStageID)
        try c.encode(healthStatus, forKey: .healthStatus)
        try c.encodeIfPresent(fertilizerHealth, forKey: .fertilizerHealth)
        try c.encodeIfPresent(fertilizerKindOverride, forKey: .fertilizerKindOverride)
        try c.encode(locationID, forKey: .locationID)
        try c.encodeIfPresent(soilMixID, forKey: .soilMixID)
        try c.encodeIfPresent(potTypeID, forKey: .potTypeID)
        try c.encodeIfPresent(lightConditionID, forKey: .lightConditionID)
        try c.encodeIfPresent(heightMillimetres, forKey: .heightMillimetres)
        try c.encodeIfPresent(crownWidthMillimetres, forKey: .crownWidthMillimetres)
        try c.encodeIfPresent(nebariWidthMillimetres, forKey: .nebariWidthMillimetres)
        try c.encodeIfPresent(trunkDiameterMillimetres, forKey: .trunkDiameterMillimetres)
        try c.encodeIfPresent(potLengthMillimetres, forKey: .potLengthMillimetres)
        try c.encodeIfPresent(potWidthMillimetres, forKey: .potWidthMillimetres)
        try c.encodeIfPresent(potHeightMillimetres, forKey: .potHeightMillimetres)
        try c.encodeIfPresent(potDiameterMillimetres, forKey: .potDiameterMillimetres)
        try c.encodeIfPresent(currentPotID, forKey: .currentPotID)
        try c.encodeIfPresent(sourceYamadoriID, forKey: .sourceYamadoriID)
        try c.encodeIfPresent(sourceSeedBatchID, forKey: .sourceSeedBatchID)
        try c.encode(yamadoriNursery, forKey: .yamadoriNursery)
        try c.encodeIfPresent(acquisitionDate, forKey: .acquisitionDate)
        try c.encodeIfPresent(acquisitionMethodID, forKey: .acquisitionMethodID)
        try c.encode(acquisitionSourceName, forKey: .acquisitionSourceName)
        try c.encodeIfPresent(purchasePrice, forKey: .purchasePrice)
        try c.encode(acquisitionNotes, forKey: .acquisitionNotes)
        try c.encodeIfPresent(disposalDate, forKey: .disposalDate)
        try c.encodeIfPresent(disposalMethodID, forKey: .disposalMethodID)
        try c.encode(disposalPartyName, forKey: .disposalPartyName)
        try c.encodeIfPresent(disposalPrice, forKey: .disposalPrice)
        try c.encode(disposalNotes, forKey: .disposalNotes)
        try c.encode(notes, forKey: .notes)
        try c.encode(knownHistory, forKey: .knownHistory)
        try c.encode(socialShareLevel, forKey: .socialShareLevel)
        try c.encodeIfPresent(lastRepottedDate, forKey: .lastRepottedDate)
        try c.encodeIfPresent(repottingIntervalYears, forKey: .repottingIntervalYears)
        try c.encodeIfPresent(lastFertilizerBagReplacedAt, forKey: .lastFertilizerBagReplacedAt)
        try c.encode(placementStrategy, forKey: .placementStrategy)
        try c.encode(seasonPlacement, forKey: .seasonPlacement)
        try c.encode(winterCareCompletedSteps, forKey: .winterCareCompletedSteps)
        try c.encode(springCareCompletedSteps, forKey: .springCareCompletedSteps)
        try c.encodeIfPresent(carePolicyCollectionID, forKey: .carePolicyCollectionID)
        try c.encodeIfPresent(wateringModeOverride, forKey: .wateringModeOverride)
        try c.encodeIfPresent(autoTimesPerDayOverride, forKey: .autoTimesPerDayOverride)
        try c.encodeIfPresent(vision, forKey: .vision)
        try c.encodeIfPresent(shaping, forKey: .shaping)
        try c.encodeIfPresent(primaryImageID, forKey: .primaryImageID)
        try c.encode(imageIDs, forKey: .imageIDs)
        try c.encode(projectIDs, forKey: .projectIDs)
        try c.encode(journalEntryIDs, forKey: .journalEntryIDs)
        try c.encode(taskIDs, forKey: .taskIDs)
        try c.encode(createdDate, forKey: .createdDate)
        try c.encode(modifiedDate, forKey: .modifiedDate)
    }
}
