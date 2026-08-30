//
//  GalleryExperienceLevel.swift
//  Bonsai World
//
//  Experience Level behaviour for Gallery (Blueprint §5.5, §6).
//  Wired to Settings → Experience Level when that ships; safe Novice default today.
//

import Foundation

/// Grower-facing Gallery capability tiers — one schema, progressive disclosure.
enum GalleryExperienceLevel: String, CaseIterable, Sendable {
    case novice
    case experienced
    case expert

    /// Default until Workspace Profile UI ships (Constitution §17 — safe by default).
    static let current: GalleryExperienceLevel = .novice

    /// Whether Featured badges appear on tiles (Experienced+ when Featured workflow ships).
    var showsFeaturedBadge: Bool {
        switch self {
        case .novice: false
        case .experienced, .expert: true
        }
    }
}
