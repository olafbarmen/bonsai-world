//
//  AssignInventoryPotView.swift
//  Bonsai World
//
//  Picks an Available Inventory Pot for a Tree (Mac Assign Inventory Pot).
//

import SwiftUI

struct AssignInventoryPotView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let treeID: UUID
    var excludingPotID: UUID? = nil

    @State private var selectedPotID: UUID?
    @State private var searchText = ""

    private var eligiblePots: [Pot] {
        library.availablePots
            .filter { $0.id != excludingPotID }
    }

    private var filteredPots: [Pot] {
        let needle = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return eligiblePots }
        return eligiblePots.filter { pot in
            library.displayName(for: pot).localizedCaseInsensitiveContains(needle)
                || pot.material.localizedCaseInsensitiveContains(needle)
                || pot.shape.localizedCaseInsensitiveContains(needle)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if eligiblePots.isEmpty {
                    ContentUnavailableView(
                        "No Available Pots",
                        systemImage: "archivebox",
                        description: Text("Add an Available pot in Pots before assigning it to this tree.")
                    )
                } else if filteredPots.isEmpty {
                    ContentUnavailableView(
                        "No Matching Pots",
                        systemImage: "magnifyingglass",
                        description: Text("Try another name, material, or shape.")
                    )
                } else {
                    List(filteredPots, selection: $selectedPotID) { pot in
                        potRow(pot)
                            .tag(Optional(pot.id))
                            .listRowBackground(BonsaiWorldColors.surface)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(BonsaiWorldColors.canvas)
                }
            }
            .searchable(text: $searchText, prompt: "Name, material, or shape")
            .navigationTitle(excludingPotID == nil ? "Assign Pot" : "Change Pot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(excludingPotID == nil ? "Assign" : "Change") {
                        assign()
                    }
                    .fontWeight(.semibold)
                    .disabled(selectedPotID == nil)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    private func potRow(_ pot: Pot) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(library.displayName(for: pot))
                .font(FaloTypography.body)
                .fontWeight(.semibold)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            let detail = [pot.material, pot.shape]
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: " · ")
            if !detail.isEmpty {
                Text(detail)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private func assign() {
        guard let selectedPotID else { return }
        if library.assignPot(selectedPotID, toTreeID: treeID) {
            dismiss()
        }
    }
}

#Preview {
    AssignInventoryPotView(treeID: UUID())
        .environment(DemoLibrary.preview)
}
