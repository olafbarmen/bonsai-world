//
//  PotDetailDraft.swift
//  Bonsai World
//
//  In-session draft for Pot Detail Edit Mode. Commits via PotService.applyDetailDraft.
//  Status / Current Use / History are not part of this draft — those change only
//  through PotService lifecycle actions (assign, mark sold, mark broken, mark retired)
//  so history and Tree ↔ Pot sync stay correct.
//

import Foundation

struct PotDetailDraft: Hashable, Sendable {
    var name: String
    var potTypeID: UUID?
    var brandID: UUID?
    var makerID: UUID?
    var generationPeriod: String

    var madeYear: Int?
    var estimatedFromYear: Int?
    var estimatedToYear: Int?
    var datingConfidence: PotDatingConfidence
    var datingNotes: String

    var material: String
    var glaze: String
    var shape: String
    var lengthMillimetres: Int?
    var widthMillimetres: Int?
    var heightMillimetres: Int?
    var diameterMillimetres: Int?
    var condition: String

    var purchaseDate: Date?
    var purchasePrice: Decimal?
    var purchaseSellerName: String
    var purchaseNotes: String

    var notes: String

    var primaryImageID: UUID?
    var imageIDs: [UUID]
    var stampImageIDs: [UUID]

    static func from(_ pot: Pot) -> PotDetailDraft {
        PotDetailDraft(
            name: pot.name,
            potTypeID: pot.potTypeID,
            brandID: pot.brandID,
            makerID: pot.makerID,
            generationPeriod: pot.generationPeriod,
            madeYear: pot.madeYear,
            estimatedFromYear: pot.estimatedFromYear,
            estimatedToYear: pot.estimatedToYear,
            datingConfidence: pot.datingConfidence,
            datingNotes: pot.datingNotes,
            material: pot.material,
            glaze: pot.glaze,
            shape: pot.shape,
            lengthMillimetres: pot.lengthMillimetres,
            widthMillimetres: pot.widthMillimetres,
            heightMillimetres: pot.heightMillimetres,
            diameterMillimetres: pot.diameterMillimetres,
            condition: pot.condition,
            purchaseDate: pot.purchaseDate,
            purchasePrice: pot.purchasePrice,
            purchaseSellerName: pot.purchaseSellerName,
            purchaseNotes: pot.purchaseNotes,
            notes: pot.notes,
            primaryImageID: pot.primaryImageID,
            imageIDs: pot.imageIDs,
            stampImageIDs: pot.stampImageIDs
        )
    }
}
