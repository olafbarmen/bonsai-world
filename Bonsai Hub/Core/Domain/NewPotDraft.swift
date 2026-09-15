//
//  NewPotDraft.swift
//  Bonsai World
//
//  In-session gathering of New Pot sheet fields before PotService validates and
//  constructs a Pot. Mirrors NewTreeDraft.
//

import Foundation

struct NewPotDraft: Hashable, Sendable {
    var name: String = ""
    var potTypeID: UUID?
    var brandID: UUID?
    var makerID: UUID?

    var material: String = ""
    var glaze: String = ""
    var shape: String = ""
    var lengthMillimetres: Int?
    var widthMillimetres: Int?
    var heightMillimetres: Int?
    var diameterMillimetres: Int?
    var condition: String = ""

    var purchaseDate: Date?
    var purchasePrice: Decimal?
    var purchaseSellerName: String = ""
    var purchaseNotes: String = ""

    var notes: String = ""
}
