//
//  ImageWorkspaceExperienceLevel.swift
//  Bonsai World
//
//  Progressive disclosure for Image Workspace metadata and tools (Blueprint §5.5, §6).
//

import Foundation

/// Grower-facing Image Workspace capability tiers.
enum ImageWorkspaceExperienceLevel: Sendable {
    case novice
    case experienced
    case expert

    /// Mirrors Gallery until Workspace Profile UI ships.
    static var current: ImageWorkspaceExperienceLevel {
        switch GalleryExperienceLevel.current {
        case .novice: .novice
        case .experienced: .experienced
        case .expert: .expert
        }
    }

    var showsFeaturedStatus: Bool {
        switch self {
        case .novice: false
        case .experienced, .expert: true
        }
    }

    var showsCollections: Bool {
        switch self {
        case .novice: false
        case .experienced, .expert: true
        }
    }

    var showsNotes: Bool {
        switch self {
        case .novice: false
        case .experienced, .expert: true
        }
    }

    var showsExpertMetadata: Bool {
        self == .expert
    }

    var showsAIPlaceholder: Bool {
        self == .expert
    }

    var showsCompareTool: Bool {
        self == .expert
    }
}
