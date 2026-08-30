//
//  CropWorkspaceWindowContext.swift
//  Bonsai World
//
//  Opens a focused Crop Workspace for one Original image.
//

import Foundation

struct CropWorkspaceWindowContext: Identifiable, Codable, Hashable, Sendable {
    var id: UUID { imageID }
    var imageID: UUID

    init(imageID: UUID) {
        self.imageID = imageID
    }
}

extension CropWorkspaceWindowContext {
    static let windowID = "crop-workspace"
}
