//
//  YamadoriFindWorkspaceWindowView.swift
//  Bonsai World
//
//  Full Bonsai World shell focused on one Yamadori Find.
//

import SwiftUI

struct YamadoriFindWorkspaceWindowView: View {
    @State private var appState: AppState
    let findID: UUID
    let tripID: UUID

    init(findID: UUID, tripID: UUID) {
        self.findID = findID
        self.tripID = tripID
        _appState = State(initialValue: AppState.makeYamadoriFindWorkspace(findID: findID, tripID: tripID))
    }

    var body: some View {
        ContentView()
            .environment(appState)
            .frame(minWidth: 1000, minHeight: 640)
    }
}
