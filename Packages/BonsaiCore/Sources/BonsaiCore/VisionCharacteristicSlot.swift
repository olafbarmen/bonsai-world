//
//  VisionCharacteristicSlot.swift
//  Bonsai World
//
//  Preserve / Develop / Change note for one Key Characteristics slot.
//

import Foundation

struct VisionCharacteristicSlot: Codable, Hashable, Sendable {
    var kind: VisionCharacteristicKind
    var text: String

    init(kind: VisionCharacteristicKind = .develop, text: String = "") {
        self.kind = kind
        self.text = text
    }
}

enum VisionFixedCharacteristic: String, CaseIterable, Identifiable, Sendable {
    case trunk
    case branch
    case apex
    case nebari

    var id: Self { self }

    var title: String {
        switch self {
        case .trunk: "Trunk"
        case .branch: "Branch"
        case .apex: "Apex"
        case .nebari: "Nebari"
        }
    }
}
