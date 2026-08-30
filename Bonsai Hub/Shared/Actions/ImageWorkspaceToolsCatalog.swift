//
//  ImageWorkspaceToolsCatalog.swift
//  Bonsai World
//
//  Image Tools for Image Workspace sidebar (Context Tools §7.2).
//  Crop is reserved — non-destructive presentation metadata only (Blueprint §5.5.1).
//

import Foundation

enum ImageWorkspaceToolsCatalog {
    static let importID = "imageTools.import"
    static let attachToTreeID = "imageTools.attachToTree"
    static let cropID = "imageTools.crop"
    static let rotateID = "imageTools.rotate"
    static let setPrimaryID = "imageTools.setPrimary"
    static let setFeaturedID = "imageTools.setFeatured"
    static let compareID = "imageTools.compare"
    static let deleteID = "imageTools.delete"

    static func actions(for level: ImageWorkspaceExperienceLevel) -> [ActionDefinition] {
        var actions: [ActionDefinition] = [
            placeholder(
                id: importID,
                title: "Import",
                systemImage: "square.and.arrow.down",
                help: "Import photos into the library"
            ),
            placeholder(
                id: attachToTreeID,
                title: "Attach to Tree",
                systemImage: "leaf",
                help: "Link this image to a Tree"
            ),
            placeholder(
                id: cropID,
                title: "Crop",
                systemImage: "crop",
                help: "Open Crop Workspace — presentation metadata only"
            ).asAvailable(),
            placeholder(
                id: rotateID,
                title: "Rotate",
                systemImage: "rotate.right",
                help: "Rotate this image"
            ),
            placeholder(
                id: setPrimaryID,
                title: "Set Primary",
                systemImage: "star",
                help: "Set as the Tree’s primary photo"
            )
        ]

        if level.showsFeaturedStatus {
            actions.append(
                placeholder(
                    id: setFeaturedID,
                    title: "Set Featured",
                    systemImage: "sparkles",
                    help: "Mark as a featured library image"
                )
            )
        }

        if level.showsCompareTool {
            actions.append(
                placeholder(
                    id: compareID,
                    title: "Compare",
                    systemImage: "square.split.2x1",
                    help: "Compare with another image"
                )
            )
        }

        actions.append(
            placeholder(
                id: deleteID,
                title: "Delete",
                systemImage: "trash",
                help: "Remove this image from the library"
            )
        )

        return actions
    }

    private static func placeholder(
        id: String,
        title: String,
        systemImage: String,
        help: String
    ) -> ActionDefinition {
        ActionDefinition(
            id: id,
            title: title,
            systemImage: systemImage,
            availability: .comingSoon,
            help: help
        )
    }
}

private extension ActionDefinition {
    func asAvailable() -> ActionDefinition {
        ActionDefinition(
            id: id,
            title: title,
            systemImage: systemImage,
            availability: .available,
            help: help
        )
    }
}
