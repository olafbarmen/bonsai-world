//
//  ImageWorkspaceWindowView.swift
//  Bonsai World
//
//  Image Workspace window — full Bonsai World shell (Sidebar, Image Tools)
//  dedicated to one image — not a second Media browser.
//

import SwiftUI

/// Full-app window whose content area is one Image Workspace.
struct ImageWorkspaceWindowView: View {
    @State private var appState: AppState

    let imageID: UUID

    init(imageID: UUID) {
        self.imageID = imageID
        _appState = State(initialValue: AppState.makeImageWorkspace(imageID: imageID))
    }

    var body: some View {
        ContentView()
            .environment(appState)
            .frame(minWidth: 1000, minHeight: 680)
    }
}
