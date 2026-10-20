//
//  PropagationHubView.swift
//  Bonsai World
//
//  Field Propagation stub — Mac nursery Cuttings / Air Layers titles.
//  NurseryPropagationProject is Mac-only (AppRoute); handbook chapters exist.
//

import SwiftUI

struct PropagationHubView: View {
    var body: some View {
        List {
            Section {
                Text("Cuttings and Air Layers share the Propagation workspace on Mac. Project records are not on iOS yet — open the handbook chapters below.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            }

            Section("Nursery") {
                NavigationLink(value: MobileRoute.handbookChapter(.propagation)) {
                    Text("Cuttings")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Cuttings")
                .accessibilityHint("Open Propagation handbook chapter")

                NavigationLink(value: MobileRoute.handbookChapter(.airLayering)) {
                    Text("Air Layers")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Air Layers")
                .accessibilityHint("Open Air Layering handbook chapter")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle("Propagation")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        PropagationHubView()
    }
}
