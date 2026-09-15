//
//  ExperienceEdition.swift
//  Bonsai World
//
//  Need-based product editions (Essentials → Practice → Complete).
//  One Library / one schema — editions control presentation only (Constitution §17).
//

import Foundation

/// Grower-facing edition. Maps to progressive-disclosure tiers used by Gallery / Crop / Image Workspace.
enum ExperienceEdition: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case essentials
    case practice
    case complete

    var id: String { rawValue }

    /// Settings / shell label.
    var menuTitle: String {
        switch self {
        case .essentials: "Essentials"
        case .practice: "Practice"
        case .complete: "Complete"
        }
    }

    var help: String {
        switch self {
        case .essentials:
            "Daily care focus. Fewer tools visible as we tune this edition."
        case .practice:
            "Growing craft — more tools as we open Practice capabilities."
        case .complete:
            "Full Bonsai World — every shipped capability available."
        }
    }

    /// Internal disclosure tier for surfaces that already gate by Novice / Experienced / Expert.
    var disclosureTier: GalleryExperienceLevel {
        switch self {
        case .essentials: .novice
        case .practice: .experienced
        case .complete: .expert
        }
    }
}

/// Process-wide edition mirror so Gallery / Crop can read without `@Environment`.
/// Kept in sync by ``AppSettings`` (same pattern as ``BonsaiWorldColors/apply``).
enum ExperienceEditionStore {
    private(set) static var current: ExperienceEdition = .complete

    static func apply(_ edition: ExperienceEdition) {
        current = edition
    }
}
