//
//  NurseryPropagationWorkspaceWindowView.swift
//  Bonsai World
//
//  Dedicated window for one Cutting / Air Layer / Graft (double-click from list).
//

import AppKit
import SwiftUI

struct NurseryPropagationWorkspaceWindowView: View {
    @State private var appState: AppState
    @Environment(NurseryPropagationService.self) private var service

    let kind: NurseryPropagationKind
    let projectID: UUID

    init(kind: NurseryPropagationKind, projectID: UUID) {
        self.kind = kind
        self.projectID = projectID
        let state = AppState()
        state.selectedSection = kind.route
        state.setSelectedNurseryPropagationProjectID(projectID, for: kind)
        _appState = State(initialValue: state)
    }

    private var windowTitle: String {
        if let project = service.project(id: projectID) {
            let name = project.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
            if !name.isEmpty { return name }
            return project.projectCode
        }
        return kind.singularTitle
    }

    var body: some View {
        NurseryPropagationDetailView(kind: kind, projectID: projectID)
            .environment(appState)
            .frame(minWidth: 800, minHeight: 560)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .faloWorkspaceCanvas()
            .bonsaiWorkspaceNavigationTitle(windowTitle)
            .background(NurseryPropagationWindowTitleSync(title: windowTitle))
    }
}

private struct NurseryPropagationWindowTitleSync: NSViewRepresentable {
    let title: String

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        applyTitle(to: view)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        applyTitle(to: nsView)
    }

    private func applyTitle(to view: NSView) {
        DispatchQueue.main.async {
            view.window?.title = title
        }
    }
}
