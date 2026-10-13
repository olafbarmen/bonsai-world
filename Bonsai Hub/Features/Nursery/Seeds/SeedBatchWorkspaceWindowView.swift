//
//  SeedBatchWorkspaceWindowView.swift
//  Bonsai World
//
//  Dedicated window for one Seed Batch (double-click from list).
//

import AppKit
import SwiftUI

struct SeedBatchWorkspaceWindowView: View {
    @State private var appState: AppState
    @Environment(SeedBatchService.self) private var seedBatchService

    let batchID: UUID

    init(batchID: UUID) {
        self.batchID = batchID
        let state = AppState()
        state.selectedSection = .nurserySeeds
        state.selectedSeedBatchID = batchID
        state.selectedSeedWorkspaceTab = .seedWork
        _appState = State(initialValue: state)
    }

    private var windowTitle: String {
        if let batch = seedBatchService.batch(id: batchID) {
            let name = batch.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
            if !name.isEmpty { return name }
            return batch.batchCode
        }
        return "Seed Batch"
    }

    var body: some View {
        SeedBatchDetailView(batchID: batchID)
            .environment(appState)
            .frame(minWidth: 800, minHeight: 560)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .faloWorkspaceCanvas()
            .bonsaiWorkspaceNavigationTitle(windowTitle)
            .background(SeedBatchWindowTitleSync(title: windowTitle).allowsHitTesting(false))
    }
}

private struct SeedBatchWindowTitleSync: NSViewRepresentable {
    let title: String

    func makeNSView(context: Context) -> NSView {
        let view = SeedBatchTitleSyncPassthroughView()
        applyTitle(to: view)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        applyTitle(to: nsView)
    }

    private func applyTitle(to view: NSView) {
        DispatchQueue.main.async {
            guard let window = view.window, window.title != title else { return }
            window.title = title
        }
    }
}

private final class SeedBatchTitleSyncPassthroughView: NSView {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
}
