//
//  SocialShareLevel.swift
//  Bonsai World
//
//  Per-tree Social sharing — local library prep for later network sharing.
//

import Foundation

/// How much of a Tree is marked for Social when the grower has Social enabled.
enum SocialShareLevel: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case off
    case mainPhoto
    case basics
    case fullProfile

    var id: Self { self }

    var title: String {
        switch self {
        case .off: "Off"
        case .mainPhoto: "Main Photo"
        case .basics: "Basics"
        case .fullProfile: "Full Profile"
        }
    }

    var detail: String {
        switch self {
        case .off:
            "Not shared on Social."
        case .mainPhoto:
            "Main photo only."
        case .basics:
            "Main photo, bonsai name, species, and tree stage."
        case .fullProfile:
            "Photo, identity, stage, health, measurements, notes, and known history."
        }
    }

    var isShared: Bool { self != .off }
}
