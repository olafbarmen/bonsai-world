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
    var treeStatusID: UUID?
    /// Grower-facing health assessment (not botanical identity).
    var healthStatus: TreeHealthStatus

    // MARK: - Growing

    /// Reference Data — Growing → Locations. Required.
    /// Map position is derived from this Location — Trees never store coordinates.
    var locationID: UUID
    /// Reference Data — Soil Mix (composition lives on the mix, not the tree).
    var soilMixID: UUID?
    var potTypeID: UUID?
    var lightConditionID: UUID?

    // MARK: - Measurements

    /// Latest Tree dimensions (mm) — denormalized from Measurement History.
    /// Display via ``MeasurementService`` / ``MeasurementDimension/height``.
    var heightMillimetres: Int?
    var crownWidthMillimetres: Int?
    var nebariWidthMillimetres: Int?
    var trunkDiameterMillimetres: Int?

    // MARK: - Pot (current size on this Tree — not Measurement History)

    /// Current pot footprint / profile (mm). Editable in Edit Mode; future Pot entity candidate.
    var potLengthMillimetres: Int?
    var potWidthMillimetres: Int?
    var potHeightMillimetres: Int?
    var potDiameterMillimetres: Int?

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
        treeStatusID: UUID? = nil,
        healthStatus: TreeHealthStatus = .stable,
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
        self.treeStatusID = treeStatusID
        self.healthStatus = healthStatus
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
        self.primaryImageID = primaryImageID
        self.imageIDs = imageIDs
        self.projectIDs = projectIDs
        self.journalEntryIDs = journalEntryIDs
        self.taskIDs = taskIDs
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }

    /// True when any disposal field indicates ownership has ended.
    var hasDisposalRecord: Bool {
        disposalDate != nil
            || disposalMethodID != nil
            || !disposalPartyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || disposalPrice != nil
            || !disposalNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
