//
//  GalleryExperienceLevel.swift
//  Bonsai World
//
//  Experience Level behaviour for Gallery (Blueprint §5.5, §6).
//  Driven by Settings → Experience Edition via ``ExperienceEditionStore``.
//

import Foundation

/// Grower-facing Gallery capability tiers — one schema, progressive disclosure.
enum GalleryExperienceLevel: String, CaseIterable, Sendable {
    case novice
    case experienced
    case expert

    /// Follows the active Experience Edition (defaults to Complete → expert).
    static var current: GalleryExperienceLevel {
        ExperienceEditionStore.current.disclosureTier
    }

    /// Whether Featured badges appear on tiles (Experienced+ when Featured workflow ships).
    var showsFeaturedBadge: Bool {
        switch self {
        case .novice: false
        case .experienced, .expert: true
        }
    }
}
