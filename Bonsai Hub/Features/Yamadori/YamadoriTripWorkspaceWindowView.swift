//
//  YamadoriTripWorkspaceWindowView.swift
//  Bonsai World
//
//  Full Bonsai World shell focused on one Yamadori trip.
//

import SwiftUI

struct YamadoriTripWorkspaceWindowView: View {
    @State private var appState: AppState
    let tripID: UUID

    init(tripID: UUID) {
        self.tripID = tripID
        _appState = State(initialValue: AppState.makeYamadoriTripWorkspace(tripID: tripID))
    }

    var body: some View {
        ContentView()
            .environment(appState)
            .frame(minWidth: 1000, minHeight: 640)
    }
}
