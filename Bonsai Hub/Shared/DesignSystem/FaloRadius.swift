//
//  FaloRadius.swift
//  Bonsai World
//
//  Shared corner-radius scale for Falo Worlds.
//

import CoreGraphics

/// Consistent corner radii. Prefer these over magic numbers.
enum FaloRadius {
    static let small: CGFloat = 6
    static let medium: CGFloat = 10
    static let large: CGFloat = 12
    /// Primary media / hero surfaces (Photos-like inspector).
    static let hero: CGFloat = 16
}
