//
//  ImageWorkspaceContentView.swift
//  Bonsai World
//
//  Main workspace region below Related Images — full width, no side inspector.
//  Image tools and workflows will expand here; detailed viewing uses dedicated tools.
//

import SwiftUI

struct ImageWorkspaceContentView: View {
    let imageID: UUID

    var body: some View {
        ImageWorkspaceCanvasView(imageID: imageID)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
