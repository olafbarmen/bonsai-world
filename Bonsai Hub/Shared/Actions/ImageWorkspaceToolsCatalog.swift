//
//  ImageWorkspaceToolsCatalog.swift
//  Bonsai World
//
//  Image Tools for Image Workspace sidebar (Context Tools §7.2).
//  Only real, wired actions — no Coming Soon stubs for missing workflows.
//

import Foundation

enum ImageWorkspaceToolsCatalog {
    static let importID = "imageTools.import"
    static let cropID = "imageTools.crop"
    static let rotateID = "imageTools.rotate"
    static let setPrimaryID = "imageTools.setPrimary"
    static let deleteID = "imageTools.delete"

    /// Tools that have a real implementation path today.
    /// `canSetPrimary` when the open image is already linked to a Tree.
    static func actions(
        for level: ImageWorkspaceExperienceLevel,
        canSetPrimary: Bool
    ) -> [ActionDefinition] {
        var actions: [ActionDefinition] = [
            ActionDefinition(
                id: importID,
                title: "Import",
                systemImage: "square.and.arrow.down",
                availability: .available,
                help: "Import a photo from Finder into the library"
            ),
            ActionDefinition(
                id: cropID,
                title: "Crop",
                systemImage: "crop",
                availability: .available,
                help: "Open Crop Workspace — presentation metadata only"
            ),
            ActionDefinition(
                id: rotateID,
                title: "Rotate",
                systemImage: "rotate.right",
                availability: .available,
                help: "Rotate the presentation 90° clockwise. Original is never modified"
            ),
            ActionDefinition(
                id: setPrimaryID,
                title: "Set Primary",
                systemImage: "star",
                availability: canSetPrimary
                    ? .available
                    : .disabled(reason: "This image is not attached to a Tree"),
                help: "Set as the Tree’s primary photo"
            ),
            ActionDefinition(
                id: deleteID,
                title: "Delete",
                systemImage: "trash",
                availability: .available,
                help: "Remove this image from the library"
            )
        ]

        // Featured / Compare / Attach are omitted until a real workflow exists.
        _ = level
        return actions
    }
}
