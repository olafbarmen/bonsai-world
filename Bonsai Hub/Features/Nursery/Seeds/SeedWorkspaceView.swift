//
//  SeedWorkspaceView.swift
//  Bonsai World
//
//  Nursery → Seeds — list on top, detail below (Trees rhythm).
//  Seed Work = active batches; Overview = all batches.
//

import SwiftUI

enum SeedWorkspaceTab: String, CaseIterable, Identifiable, Hashable, Sendable {
    case seedWork
    case overview

    var id: Self { self }

    var title: String {
        switch self {
        case .seedWork: "Seed Work"
        case .overview: "Overview"
        }
    }

    var listScope: SeedBatchListScope {
        switch self {
        case .seedWork: .active
        case .overview: .all
        }
    }
}

struct SeedWorkspaceView: View {
    @Binding var selectedTab: SeedWorkspaceTab

    @Environment(AppState.self) private var appState
    @Environment(SeedBatchService.self) private var seedBatchService

    @State private var isCreatePresented = false

    var body: some View {
        VStack(spacing: 0) {
            Picker("Seeds", selection: $selectedTab) {
                ForEach(SeedWorkspaceTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(FaloSpacing.medium)

            Divider()

            VSplitView {
                SeedBatchListView(scope: selectedTab.listScope)
                    .frame(minHeight: 120, idealHeight: 240)

                seedDetailPane
                    .frame(minHeight: 200)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .faloWorkspaceCanvas()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Seeds")
        .sheet(isPresented: $isCreatePresented) {
            NewSeedBatchView()
        }
        .onAppear { consumeWantsNewSeedBatch() }
        .onChange(of: appState.wantsNewSeedBatch) { _, wants in
            guard wants else { return }
            consumeWantsNewSeedBatch()
        }
    }

    @ViewBuilder
    private var seedDetailPane: some View {
        if let batchID = appState.selectedSeedBatchID,
           seedBatchService.batch(id: batchID) != nil {
            SeedBatchDetailView(batchID: batchID)
        } else {
            ContentUnavailableView(
                "Select a Seed Batch",
                systemImage: "leaf.circle",
                description: Text("Choose a row above to see details. Double-click to open in a new window.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func consumeWantsNewSeedBatch() {
        guard appState.wantsNewSeedBatch else { return }
        isCreatePresented = true
        appState.wantsNewSeedBatch = false
    }
}
