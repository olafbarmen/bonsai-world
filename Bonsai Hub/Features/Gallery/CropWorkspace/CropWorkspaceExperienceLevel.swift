//
//  CropWorkspaceExperienceLevel.swift
//  Bonsai World
//
//  Progressive disclosure for Crop Workspace tools and panels.
//

import Foundation

enum CropWorkspaceExperienceLevel: Sendable {
    case novice
    case experienced
    case expert

    static var current: CropWorkspaceExperienceLevel {
        switch GalleryExperienceLevel.current {
        case .novice: .novice
        case .experienced: .experienced
        case .expert: .expert
        }
    }

    var showsAspectRatios: Bool {
        switch self {
        case .novice: false
        case .experienced, .expert: true
        }
    }

    var showsResetTool: Bool {
        true
    }

    var showsMultiplePresentationCrops: Bool {
        self == .expert
    }

    var showsAICropPlaceholder: Bool {
        self == .expert
    }
}
