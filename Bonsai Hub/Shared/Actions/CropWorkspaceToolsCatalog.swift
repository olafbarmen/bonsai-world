//
//  CropWorkspaceToolsCatalog.swift
//  Bonsai World
//
//  Context Tools for the Crop Workspace sidebar.
//

import Foundation

enum CropWorkspaceToolsCatalog {
    static let saveCropID = "cropTools.saveCrop"
    static let resetCropID = "cropTools.resetCrop"
    static let rotateID = "cropTools.rotate"
    static let mirrorID = "cropTools.mirror"
    static let compareOriginalID = "cropTools.compareOriginal"
    static let cancelID = "cropTools.cancel"

    static func actions(for level: CropWorkspaceExperienceLevel) -> [ActionDefinition] {
        var actions: [ActionDefinition] = [
            ActionDefinition(
                id: saveCropID,
                title: "Save Crop",
                systemImage: "checkmark.circle",
                availability: .available,
                help: "Save presentation crop metadata — Original is never modified"
            )
        ]

        if level.showsResetTool {
            actions.append(
                ActionDefinition(
                    id: resetCropID,
                    title: "Reset to Original",
                    systemImage: "arrow.counterclockwise",
                    availability: .available,
                    help: "Revert crop, rotation, and mirror to the full Original frame"
                )
            )
        }

        actions.append(
            ActionDefinition(
                id: rotateID,
                title: "Rotate",
                systemImage: "rotate.right",
                availability: .available,
                help: "Rotate the presentation 90° clockwise. Original is never modified"
            )
        )
        actions.append(
            ActionDefinition(
                id: mirrorID,
                title: "Mirror",
                systemImage: "arrow.left.and.right.righttriangle.left.righttriangle.right",
                availability: .available,
                help: "Mirror the presentation horizontally. Original is never modified"
            )
        )
        actions.append(
            ActionDefinition(
                id: compareOriginalID,
                title: "Compare Original",
                systemImage: "square.split.2x1",
                availability: .available,
                help: "Show the untouched Original beside the crop"
            )
        )
        actions.append(
            ActionDefinition(
                id: cancelID,
                title: "Cancel",
                systemImage: "xmark.circle",
                availability: .available,
                help: "Discard unsaved changes and close"
            )
        )

        return actions
    }
}
