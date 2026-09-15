//
//  VisionCharacteristic.swift
//  Bonsai World
//
//  One grower-defined note under Shaping → Vision → Key Characteristics.
//

import Foundation

struct VisionCharacteristic: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var kind: VisionCharacteristicKind
    var text: String

    init(
        id: UUID = UUID(),
        kind: VisionCharacteristicKind = .develop,
        text: String = ""
    ) {
        self.id = id
        self.kind = kind
        self.text = text
    }
}
