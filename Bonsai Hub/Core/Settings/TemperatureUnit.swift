//
//  TemperatureUnit.swift
//  Bonsai World
//
//  Regional temperature display preference. Weather not implemented yet.
//

import Foundation

enum TemperatureUnit: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case celsius
    case fahrenheit

    var id: String { rawValue }

    var menuTitle: String {
        switch self {
        case .celsius: "Celsius (°C)"
        case .fahrenheit: "Fahrenheit (°F)"
        }
    }
}
