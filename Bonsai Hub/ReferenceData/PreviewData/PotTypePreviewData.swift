//
//  PotTypePreviewData.swift
//  Bonsai World
//
//  Lists worksheet → section "Pots".
//

import Foundation

enum PotTypePreviewData {
    static let all: [PotType] = ReferencePreviewSeed.names(list: 7, [
        "Treningspotte",
        "Plastpotte",
        "Keramikk",
        "Tokoname",
        "Hjemmelaget",
        "Ingen potte",
    ]).map { PotType(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
