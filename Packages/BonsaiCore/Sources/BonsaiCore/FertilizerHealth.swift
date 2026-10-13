//
//  FertilizerHealth.swift
//  Bonsai World
//
//  Explicit feeding condition stored on Tree. Nil = unknown — never assumed healthy.
//

import Foundation

enum FertilizerHealth: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case healthy
    case recovering
    case weak
    case stressed
    case sick

    var id: Self { self }

    var title: String {
        switch self {
        case .healthy: "Healthy"
        case .recovering: "Recovering"
        case .weak: "Weak"
        case .stressed: "Stressed"
        case .sick: "Sick"
        }
    }

    var isRestricted: Bool {
        switch self {
        case .weak, .stressed, .sick: true
        default: false
        }
    }

    /// Recovery programme instead of the selected stage.
    var requiresConservativeProgramme: Bool {
        self == .recovering || isRestricted
    }
}
