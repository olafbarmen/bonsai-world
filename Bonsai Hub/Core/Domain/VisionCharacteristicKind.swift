//
//  VisionCharacteristicKind.swift
//  Bonsai World
//
//  Preserve / Develop / Change — one note per characteristic on Tree Vision.
//

import Foundation

enum VisionCharacteristicKind: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case preserve
    case develop
    case changeAvoid

    var id: Self { self }

    var title: String {
        switch self {
        case .preserve: "Preserve"
        case .develop: "Develop"
        case .changeAvoid: "Change / Avoid"
        }
    }
}
