//
//  ExperienceCapability.swift
//  Bonsai World
//
//  Named capabilities we can enable per Experience Edition later.
//  Complete enables full progressive disclosure (expert tier). Essentials /
//  Practice reuse existing Gallery / Crop / Image rules. Sidebar module
//  hiding is not applied until we choose cuts.
//

import Foundation

/// Feature switches for editions. Add cases as we decide Essentials / Practice cuts.
enum ExperienceCapability: String, CaseIterable, Identifiable, Hashable, Sendable {
    case galleryFeaturedBadge
    case galleryAdvancedBrowseFilters
    case cropAspectRatioPresets
    case cropMultiplePresentationSurfaces
    case cropAISuggestionsPlaceholder
    case imageWorkspaceFeaturedStatus
    case imageWorkspaceCompareTool
    case imageWorkspaceAIPlaceholder

    var id: String { rawValue }

    /// Whether this capability is on for the given edition.
    func isEnabled(in edition: ExperienceEdition) -> Bool {
        let gallery = edition.disclosureTier
        let crop = CropWorkspaceExperienceLevel.mapped(from: gallery)
        let image = ImageWorkspaceExperienceLevel.mapped(from: gallery)
        switch self {
        case .galleryFeaturedBadge:
            return gallery.showsFeaturedBadge
        case .galleryAdvancedBrowseFilters:
            return gallery != .novice
        case .cropAspectRatioPresets:
            return crop.showsAspectRatios
        case .cropMultiplePresentationSurfaces:
            return crop.showsMultiplePresentationCrops
        case .cropAISuggestionsPlaceholder:
            return crop.showsAICropPlaceholder
        case .imageWorkspaceFeaturedStatus:
            return image.showsFeaturedStatus
        case .imageWorkspaceCompareTool:
            return image.showsCompareTool
        case .imageWorkspaceAIPlaceholder:
            return image.showsAIPlaceholder
        }
    }

    static func isEnabled(_ capability: ExperienceCapability) -> Bool {
        capability.isEnabled(in: ExperienceEditionStore.current)
    }
}

extension CropWorkspaceExperienceLevel {
    static func mapped(from tier: GalleryExperienceLevel) -> CropWorkspaceExperienceLevel {
        switch tier {
        case .novice: .novice
        case .experienced: .experienced
        case .expert: .expert
        }
    }
}

extension ImageWorkspaceExperienceLevel {
    static func mapped(from tier: GalleryExperienceLevel) -> ImageWorkspaceExperienceLevel {
        switch tier {
        case .novice: .novice
        case .experienced: .experienced
        case .expert: .expert
        }
    }
}
