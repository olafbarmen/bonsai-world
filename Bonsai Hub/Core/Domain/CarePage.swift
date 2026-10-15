//
//  CarePage.swift
//  Bonsai World
//
//  On-page Care destinations (BV1) — sidebar shows one Care row.
//

import Foundation

enum CarePage: String, CaseIterable, Identifiable, Sendable {
    case watering
    case fertilizing
    case placement
    case winter
    case spring
    case repotting
    case health
    case seasonal

    var id: Self { self }

    var title: String {
        switch self {
        case .watering: "Watering"
        case .fertilizing: "Fertilizing"
        case .placement: "Placement"
        case .winter: "Winter Care"
        case .spring: "Spring Care"
        case .repotting: "Repotting"
        case .health: "Health"
        case .seasonal: "Seasonal Care"
        }
    }

    /// Segmented control on the Care page (others use More…).
    static let primaryPickerCases: [CarePage] = [
        .watering, .fertilizing, .placement, .winter, .spring
    ]

    var isPrimaryPickerCase: Bool { Self.primaryPickerCases.contains(self) }

    var route: AppRoute {
        switch self {
        case .watering: .careWatering
        case .fertilizing: .careFertilizing
        case .placement: .carePlacement
        case .winter: .careWinter
        case .spring: .careSpring
        case .repotting: .careRepotting
        case .health: .careTreeHealth
        case .seasonal: .careSeasonal
        }
    }

    init?(route: AppRoute) {
        switch route {
        case .careWatering: self = .watering
        case .careFertilizing: self = .fertilizing
        case .carePlacement: self = .placement
        case .careWinter: self = .winter
        case .careSpring: self = .spring
        case .careRepotting: self = .repotting
        case .careTreeHealth: self = .health
        case .careSeasonal: self = .seasonal
        case .careToday: return nil
        default: return nil
        }
    }
}
