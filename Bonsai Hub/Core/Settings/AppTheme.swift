//
//  AppTheme.swift
//  Bonsai World
//
//  Settings → Appearance → Theme. Light keeps the approved palette;
//  Dark is hybrid (dark green sidebar, slightly darker canvas, light cards).
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
