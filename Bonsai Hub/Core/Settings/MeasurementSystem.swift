//
//  MeasurementSystem.swift
//  Bonsai World
//
//  Global measurement preference (display only).
//  All linear values are stored in millimetres — never dual-unit persistence.
//

import Foundation

/// Regional measurement preference for Falo Worlds.
enum MeasurementSystem: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case metric
    case imperial

    var id: String { rawValue }

    var menuTitle: String {
        switch self {
        case .metric: "Metric (SI)"
        case .imperial: "Imperial (US)"
        }
    }
}
