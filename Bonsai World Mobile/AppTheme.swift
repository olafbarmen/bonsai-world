//
//  AppTheme.swift
//  Bonsai World
//
//  Same cases as Mac `AppTheme` so `BonsaiWorldColors` compiles on iOS.
//  Mobile V1 stays on Light; Mac remains the source of Appearance settings.
//

import Foundation

enum AppTheme: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case light
    case dark

    var id: String { rawValue }

    var menuTitle: String {
        switch self {
        case .light: "Light"
        case .dark: "Dark"
        }
    }
}
