//
//  CropAspectRatioMode.swift
//  Bonsai World
//
//  Predefined crop aspect ratios for non-destructive presentation metadata.
//

import CoreGraphics
import Foundation

/// Aspect ratio preset for the Crop Workspace.
enum CropAspectRatioMode: String, Codable, CaseIterable, Hashable, Sendable {
    case original
    case square
    case landscape
    case portrait
    case treePortrait
    case custom

    var title: String {
        switch self {
        case .original: "Original"
        case .square: "Square"
        case .landscape: "Landscape"
        case .portrait: "Portrait"
        case .treePortrait: "Tree Portrait"
        case .custom: "Custom"
        }
    }

    /// Fixed width:height ratio; `nil` means free-form (Original / Custom).
    var fixedAspectRatio: CGFloat? {
        switch self {
        case .original, .custom: nil
        case .square: 1
        case .landscape: 4.0 / 3.0
        case .portrait: 3.0 / 4.0
        case .treePortrait: 2.0 / 3.0
        }
    }

    /// Whether this mode is selectable today (Tree Portrait reserved for future).
    var isSelectable: Bool {
        self != .treePortrait
    }

    /// Options shown in the aspect ratio picker for the current experience level.
    static func menuOptions(for level: CropWorkspaceExperienceLevel) -> [CropAspectRatioMode] {
        switch level {
        case .novice:
            return [.original]
        case .experienced:
            return [.original, .square, .landscape, .portrait, .custom]
        case .expert:
            return allCases.filter(\.isSelectable)
        }
    }
}
