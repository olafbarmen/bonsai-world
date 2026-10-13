//
//  TreeDetailDraft.swift
//  Bonsai World
//
//  In-session draft for Tree Detail Edit Mode (Auto Save).
//  Permanent identity is never part of the draft.
//

import Foundation

/// Editable Tree Detail fields. Changes persist via Auto Save while editing.
struct TreeDetailDraft: Equatable, Sendable {
    var nickname: String
    var styleID: UUID?
    var sizeClassID: UUID?
    var treeStageID: UUID?
    var healthStatus: TreeHealthStatus
    var lastRepottedDate: Date?
    var repottingIntervalYears: Int?
    var placementStrategy: TreePlacementStrategy
    var seasonPlacement: TreeSeasonPlacement
    var winterCareCompletedSteps: [WinterCareStep]
    var springCareCompletedSteps: [SpringCareStep]
    var fertilizerHealth: FertilizerHealth?
    var fertilizerKindOverride: FertilizerKind?
    var locationID: UUID?
    var lightConditionID: UUID?
    var soilMixID: UUID?
    var potTypeID: UUID?

    var heightMillimetres: Int?
    var crownWidthMillimetres: Int?
    var nebariWidthMillimetres: Int?
    var trunkDiameterMillimetres: Int?
    var potLengthMillimetres: Int?
    var potWidthMillimetres: Int?
    var potHeightMillimetres: Int?
    var potDiameterMillimetres: Int?

    var acquisitionDate: Date?
    var acquisitionMethodID: UUID?
    var acquisitionSourceName: String
    var purchasePrice: Decimal?
    var acquisitionNotes: String

    var disposalDate: Date?
    var disposalMethodID: UUID?
    var disposalPartyName: String
    var disposalPrice: Decimal?
    var disposalNotes: String

    var notes: String
    var knownHistory: String
    var carePolicyCollectionID: UUID?
    var wateringModeOverride: WateringMode?
    var autoTimesPerDayOverride: Int?
    var primaryImageID: UUID?
    /// Gallery order while editing (applied on Auto Save).
    var imageIDs: [UUID]
    /// Pending Photo Name edits (id → name). Applied to the catalog on Auto Save.
    var photoNames: [UUID: String]
    /// Pending Capture Date edits (id → date). Applied to the catalog on Auto Save.
    var photoCaptureDates: [UUID: Date]
    /// Photos imported since last persist (cleared after Auto Save).
    var pendingAddedImageIDs: [UUID]
    /// Photos removed since last persist (deleted from disk on Auto Save).
    var pendingDeletedImageIDs: [UUID]
    /// Collection membership while editing (applied on Auto Save).
    var collectionIDs: Set<UUID>

    /// Membership is resolved from Collections — pass IDs from ``TreeService/collections(for:)``.
    static func capture(from tree: Tree, collectionIDs: Set<UUID>) -> TreeDetailDraft {
        TreeDetailDraft(
            nickname: tree.nickname,
            styleID: tree.styleID,
            sizeClassID: tree.sizeClassID,
            treeStageID: tree.treeStageID,
            healthStatus: tree.healthStatus,
            lastRepottedDate: tree.lastRepottedDate,
            repottingIntervalYears: tree.repottingIntervalYears,
            placementStrategy: tree.placementStrategy,
            seasonPlacement: tree.seasonPlacement,
            winterCareCompletedSteps: tree.winterCareCompletedSteps,
            springCareCompletedSteps: tree.springCareCompletedSteps,
            fertilizerHealth: tree.fertilizerHealth,
            fertilizerKindOverride: tree.fertilizerKindOverride,
            locationID: tree.locationID,
            lightConditionID: tree.lightConditionID,
            soilMixID: tree.soilMixID,
            potTypeID: tree.potTypeID,
            heightMillimetres: tree.heightMillimetres,
            crownWidthMillimetres: tree.crownWidthMillimetres,
            nebariWidthMillimetres: tree.nebariWidthMillimetres,
            trunkDiameterMillimetres: tree.trunkDiameterMillimetres,
            potLengthMillimetres: tree.potLengthMillimetres,
            potWidthMillimetres: tree.potWidthMillimetres,
            potHeightMillimetres: tree.potHeightMillimetres,
            potDiameterMillimetres: tree.potDiameterMillimetres,
            acquisitionDate: tree.acquisitionDate,
            acquisitionMethodID: tree.acquisitionMethodID,
            acquisitionSourceName: tree.acquisitionSourceName,
            purchasePrice: tree.purchasePrice,
            acquisitionNotes: tree.acquisitionNotes,
            disposalDate: tree.disposalDate,
            disposalMethodID: tree.disposalMethodID,
            disposalPartyName: tree.disposalPartyName,
            disposalPrice: tree.disposalPrice,
            disposalNotes: tree.disposalNotes,
            notes: tree.notes,
            knownHistory: tree.knownHistory,
            carePolicyCollectionID: tree.carePolicyCollectionID,
            wateringModeOverride: tree.wateringModeOverride,
            autoTimesPerDayOverride: tree.autoTimesPerDayOverride,
            primaryImageID: tree.primaryImageID,
            imageIDs: tree.imageIDs,
            photoNames: [:],
            photoCaptureDates: [:],
            pendingAddedImageIDs: [],
            pendingDeletedImageIDs: [],
            collectionIDs: collectionIDs
        )
    }

    /// Whether photo-related fields differ from the saved tree (ignoring pending name map emptiness).
    func hasPhotoChanges(comparedTo tree: Tree) -> Bool {
        primaryImageID != tree.primaryImageID
            || imageIDs != tree.imageIDs
            || !photoNames.isEmpty
            || !photoCaptureDates.isEmpty
            || !pendingAddedImageIDs.isEmpty
            || !pendingDeletedImageIDs.isEmpty
    }
}
