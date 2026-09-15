//
//  SoilWorkspaceView.swift
//  Bonsai World
//
//  Inventory → Soil — Stock · Mixes. Knowledge lives under Handbook → Soil & Substrate.
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
                    SoilStockSplitView()
                case .mixes:
                    SoilMixesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Soil")
    }
}
