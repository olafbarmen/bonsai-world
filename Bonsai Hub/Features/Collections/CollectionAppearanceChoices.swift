//
//  CollectionAppearanceChoices.swift
//  Bonsai World
//
//  Shared icon and accent options for New Collection and Edit Collection.
//

import SwiftUI

enum CollectionAppearanceChoices {
    static let icons: [String] = [
        "square.stack.3d.up",
        "leaf.fill",
        "star.fill",
        "rosette",
        "heart.fill",
        "tag.fill",
        "bookmark.fill",
        "flame.fill"
    ]

    static let colors: [(label: String, hex: String)] = [
        ("Maple", "#8B3A3A"),
        ("Gold", "#C4A35A"),
        ("Forest", "#3D6B5A"),
        ("Slate", "#5A6570"),
        ("Clay", "#A66A4E")
    ]

    static func colorLabel(for hex: String?) -> String {
        guard let hex else { return FaloDisplayValue.empty }
        return colors.first { $0.hex.caseInsensitiveCompare(hex) == .orderedSame }?.label
            ?? hex
    }
}

extension Color {
    /// Minimal hex parser for optional collection accent previews (`#RRGGBB`).
    init?(collectionHex hex: String) {
        var value = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if value.hasPrefix("#") { value.removeFirst() }
        guard value.count == 6, let int = UInt64(value, radix: 16) else { return nil }
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
