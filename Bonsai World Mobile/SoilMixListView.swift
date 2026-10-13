//
//  SoilMixListView.swift
//  Bonsai World
//
//  Field Soil — Soil Mix list + New Soil Mix.
//

import SwiftUI

struct SoilMixListView: View {
    @Environment(DemoLibrary.self) private var library

    var onCreatedMix: ((UUID) -> Void)? = nil

    @State private var isShowingNew = false
    @State private var pendingCreatedID: UUID?
    @State private var mixPendingDelete: UUID?
    @State private var confirmDelete = false

    var body: some View {
        Group {
            if library.orderedSoilMixes.isEmpty {
                ContentUnavailableView {
                    Label("No soil mixes yet", systemImage: "square.stack.3d.up")
                } description: {
                    Text("Add a soil mix for trees and seeds.")
                } actions: {
                    Button("New Soil Mix") {
                        isShowingNew = true
                    }
                    .accessibilityLabel("New Soil Mix")
                }
            } else {
                mixList
            }
        }
        .navigationTitle("Soil")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Soil Mix") {
                    isShowingNew = true
                }
                .accessibilityLabel("New Soil Mix")
            }
        }
        .sheet(isPresented: $isShowingNew, onDismiss: {
            if let id = pendingCreatedID {
                pendingCreatedID = nil
                onCreatedMix?(id)
            }
        }) {
            NewSoilMixView { id in
                pendingCreatedID = id
            }
        }
        .confirmationDialog(
            "Delete this soil mix?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let id = mixPendingDelete {
                    library.deleteSoilMix(id: id)
                }
                mixPendingDelete = nil
            }
            Button("Cancel", role: .cancel) {
                mixPendingDelete = nil
            }
        } message: {
            Text("Trees that used this mix keep their other fields. The Soil Mix link is cleared.")
        }
    }

    private var mixList: some View {
        List {
            ForEach(library.orderedSoilMixes) { mix in
                NavigationLink(value: MobileRoute.soilMix(mix.id)) {
                    mixRow(mix)
                }
                .listRowBackground(BonsaiWorldColors.surface)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button("Delete", role: .destructive) {
                        mixPendingDelete = mix.id
                        confirmDelete = true
                    }
                    .accessibilityLabel("Delete Soil Mix")
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private func mixRow(_ mix: SoilMix) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(mix.name)
                .font(FaloTypography.body)
                .fontWeight(.semibold)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            if !mix.compositionSummary.isEmpty {
                Text(mix.compositionSummary)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .lineLimit(2)
            }
            if !mix.mixDescription.isEmpty {
                Text(mix.mixDescription)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
                    .lineLimit(2)
            }
            Text(treeCountCaption(for: mix.id))
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textTertiary)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    private func treeCountCaption(for mixID: UUID) -> String {
        let count = library.trees(usingSoilMix: mixID).count
        return count == 1 ? "1 Tree" : "\(count) Trees"
    }
}

#Preview {
    NavigationStack {
        SoilMixListView()
    }
    .environment(DemoLibrary.preview)
}
