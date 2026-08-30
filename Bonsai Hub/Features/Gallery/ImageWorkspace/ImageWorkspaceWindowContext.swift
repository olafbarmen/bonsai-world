//
//  ImageWorkspaceWindowContext.swift
//  Bonsai World
//
//  Value type for opening an Image Workspace window (Blueprint §5.5).
//  One context = one focused image; opening the same imageID focuses that window.
//

import Foundation

/// Opens a full Bonsai World window focused on Media → one Image Workspace.
struct ImageWorkspaceWindowContext: Identifiable, Codable, Hashable, Sendable {
    /// Window identity equals the image — one Workspace window per image.
    var id: UUID { imageID }
    var imageID: UUID

    init(imageID: UUID) {
        self.imageID = imageID
    }
}

extension ImageWorkspaceWindowContext {
    static let windowID = "image-workspace"
}
