//
//  PotTypePreviewData.swift
//  Bonsai World
//
//  Lists worksheet → section "Pots".
//
//  Names below are the English canonical Pot Type list. List index (not name) drives
//  each id via `ReferencePreviewSeed`, so this rename does not change or orphan any
//  `Tree.potTypeID` already stored on existing trees. Three entries (Wooden Growing Box /
//  Wooden Box / Wooden Training Box) preserve wood-box distinctions the prior Norwegian
//  list carried that the canonical list collapses to one term — kept distinct rather than
//  merged so no existing pot-type reference is silently orphaned.
//

import Foundation

enum PotTypePreviewData {
    static let all: [PotType] = ReferencePreviewSeed.names(list: 7, [
        "Cascade Pot",
        "Concrete Pot",
        "Deep Oval Pot",
        "Deep Rectangular Pot",
        "Deep Round Pot",
        "Glazed Ceramic Square Pot",
        "Glazed Ceramic Oval Pot",
        "Glazed Ceramic Rectangular Pot",
        "Glazed Ceramic Round Pot",
        "Glazed Ceramic Shallow Oval Pot",
        "Glazed Ceramic Shallow Rectangular Pot",
        "Glazed Ceramic Shallow Round Pot",
        "Handmade Pot",
        "In Ground",
        "Ceramic Pot",
        "Air Pot",
        "Mica Pot",
        "Plastic Growing Box",
        "Wooden Growing Box",
        "Plastic Pot",
        "Semi-Cascade Pot",
        "Signed Pot",
        "Forest Pot / Slab",
        "Stone Slab",
        "Tokoname Square Pot",
        "Tokoname Oval Pot",
        "Tokoname Rectangular Pot",
        "Tokoname Round Pot",
        "Wooden Box",
        "Wooden Training Box",
        "Training Pot",
        "Unglazed Ceramic Square Pot",
        "Unglazed Ceramic Oval Pot",
        "Unglazed Ceramic Rectangular Pot",
        "Unglazed Ceramic Round Pot",
        "Unglazed Ceramic Shallow Oval Pot",
        "Unglazed Ceramic Shallow Rectangular Pot",
        "Unglazed Ceramic Shallow Round Pot",
        "Yixing Square Pot",
        "Yixing Oval Pot",
        "Yixing Rectangular Pot",
        "Yixing Round Pot",
        "Tub",
        "Air Box",
    ]).map { PotType(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
