//
//  BonsaiWorldColors.swift
//  Bonsai World
//
//  Approved visual identity for Bonsai World.
//  Light: warm cream surfaces. Dark: hybrid — forest-green sidebar + light cards,
//  slightly deeper canvas (Settings → Appearance → Theme).
//

import SwiftUI

enum BonsaiWorldColors {
    /// Active theme — kept in sync by ``AppSettings`` (main actor).
    private(set) static var theme: AppTheme = .light

    static func apply(_ theme: AppTheme) {
        self.theme = theme
    }

    // MARK: - Surfaces

    static var canvas: Color {
        switch theme {
        case .light: Color(hex: 0xF7F4EF)
        case .dark: Color(hex: 0xE6E1D8)
        }
    }

    static var sidebar: Color {
        switch theme {
        case .light: Color(hex: 0xE8E2DA)
        case .dark: Color(hex: 0x1B2B1E)
        }
    }

    /// Cards stay light in both themes (hybrid Dark).
    static let surface = Color(hex: 0xFBFAF7)
    static let raisedSurface = Color(hex: 0xFFFEFC)

    // MARK: - Text (main content — dark on light cards)

    static let textPrimary = Color(hex: 0x1C1B19)
    static let textSecondary = Color(hex: 0x6B6560)
    static let textTertiary = Color(hex: 0x8A847C)

    // MARK: - Sidebar text (theme-aware)

    static var sidebarTextPrimary: Color {
        switch theme {
        case .light: textPrimary
        case .dark: Color(hex: 0xF4F1EA)
        }
    }

    static var sidebarTextSecondary: Color {
        switch theme {
        case .light: textSecondary
        case .dark: Color(hex: 0xF4F1EA).opacity(0.72)
        }
    }

    static var sidebarAccent: Color {
        switch theme {
        case .light: accent
        case .dark: Color(hex: 0xD5E3D6)
        }
    }

    // MARK: - Accent (content)

    /// Muted sage — selection, focus, small icons, emphasis. Never a wash.
    static let accent = Color(hex: 0x3F5A4C)

    /// Named accent treatment (~12%). Prefer this over ad-hoc accent opacity.
    static var accentSubtle: Color { accent.opacity(0.12) }

    // MARK: - Navigation chrome

    /// Selected sidebar / menu row — muted sage, not system blue.
    static var sidebarSelection: Color {
        switch theme {
        case .light: accent.opacity(0.18)
        case .dark: Color.white.opacity(0.14)
        }
    }

    /// Hovered sidebar / menu row — quieter than selection.
    static var sidebarHover: Color {
        switch theme {
        case .light: accent.opacity(0.08)
        case .dark: Color.white.opacity(0.08)
        }
    }

    /// Keyboard focus ring for navigation — visible, not blue.
    static var navigationFocusRing: Color {
        switch theme {
        case .light: accent.opacity(0.42)
        case .dark: Color.white.opacity(0.35)
        }
    }

    // MARK: - Borders

    static var border: Color { textPrimary.opacity(0.08) }
    static var borderSubtle: Color { textPrimary.opacity(0.05) }

    // MARK: - Semantic status

    static let statusInformation = Color(hex: 0x4A6A8A)
    static let statusPositive = Color(hex: 0x3D6B52)
    static let statusAttention = Color(hex: 0xC47E3B)
    static let statusWarning = Color(hex: 0xB65C2A)
    static let statusCritical = Color(hex: 0xA63D3D)

    /// Quiet fill behind status text/icons — not a large colored panel.
    static func statusTintFill(_ status: Color) -> Color { status.opacity(0.14) }

    /// Quiet stroke for status chrome (e.g. badge outline).
    static func statusTintStroke(_ status: Color) -> Color { status.opacity(0.28) }
}

// MARK: - Hex helper

private extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}
