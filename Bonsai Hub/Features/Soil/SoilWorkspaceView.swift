//
//  SoilWorkspaceView.swift
//  Bonsai World
//
//  Inventory → Soil list column (CG1 / Pots pattern). Stock · Mixes in the list header.
//

import SwiftUI

enum SoilWorkspaceTab: String, CaseIterable, Identifiable, Hashable, Sendable {
    case stock
    case mixes

    var id: Self { self }

    var title: String {
        switch self {
        case .stock: "Stock"
        case .mixes: "Mixes"
        }
    }
}

struct SoilWorkspaceView: View {
    @Binding var selectedTab: SoilWorkspaceTab
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 0) {
            Picker("Soil", selection: $selectedTab) {
                ForEach(SoilWorkspaceTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(FaloSpacing.medium)

            Divider()

            Group {
                switch selectedTab {
                case .stock:
                    SoilStockListView()
                case .mixes:
                    SoilMixListView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .bonsaiWorkspaceNavigationTitle("Soil")
        .onChange(of: selectedTab) { _, tab in
            switch tab {
            case .stock:
                appState.selectedSoilMixID = nil
            case .mixes:
                appState.selectedSoilStockID = nil
            }
        }
    }
}
