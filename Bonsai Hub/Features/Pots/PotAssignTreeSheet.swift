//
//  PotAssignTreeSheet.swift
//  Bonsai World
//
//  Picks a Tree (in care) to receive this Available pot.
//  PotService.assignPot owns the Tree ↔ Pot sync and history.
//  Rows identify Trees by immutable bonsaiName (registry), not species alone.
//  Text-only list — no thumbnails — so opening the sheet cannot stall on image I/O.
//

import SwiftUI

struct PotAssignTreeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TreeService.self) private var treeService
    @Environment(PotService.self) private var potService

    let potID: UUID

    @State private var selectedTreeID: UUID?
    @State private var searchText = ""
    @State private var errorMessage: String?
    /// Snapshot at open — avoids re-sorting the whole catalog on every keystroke/render.
    @State private var eligibleTrees: [Tree] = []

    private var filteredTrees: [Tree] {
        let needle = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return eligibleTrees }
        return eligibleTrees.filter { tree in
            tree.bonsaiName.localizedCaseInsensitiveContains(needle)
                || tree.botanicalName.localizedCaseInsensitiveContains(needle)
                || tree.nickname.localizedCaseInsensitiveContains(needle)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Text("Assign to Tree")
                    .font(FaloTypography.headline)
                Spacer()
                Button("Assign") { assign() }
                    .keyboardShortcut(.defaultAction)
                    .disabled(selectedTreeID == nil)
            }
            .padding(.horizontal, FaloSpacing.large)
            .padding(.vertical, FaloSpacing.medium)

            Divider()

            if eligibleTrees.isEmpty {
                ContentUnavailableView(
                    "No Trees Available",
                    systemImage: "leaf",
                    description: Text("Add an in-care Tree before assigning this pot.")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                TextField("Bonsai name, species, or nickname", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, FaloSpacing.large)
                    .padding(.top, FaloSpacing.medium)

                if filteredTrees.isEmpty {
                    ContentUnavailableView(
                        "No Matching Trees",
                        systemImage: "magnifyingglass",
                        description: Text("Try the Bonsai Name (e.g. ACE-PAL-…) or species.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredTrees, id: \.id, selection: $selectedTreeID) { tree in
                        treeRow(tree)
                            .tag(tree.id)
                            .contentShape(Rectangle())
                    }
                    .listStyle(.inset(alternatesRowBackgrounds: true))
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(BonsaiWorldColors.statusCritical)
                    .font(FaloTypography.caption)
                    .padding(.horizontal, FaloSpacing.large)
                    .padding(.bottom, FaloSpacing.small)
            }
        }
        .frame(minWidth: 440, minHeight: 420)
        .onAppear {
            eligibleTrees = treeService.trees
                .filter(\.isInCare)
                .sorted {
                    $0.bonsaiName.localizedCaseInsensitiveCompare($1.bonsaiName) == .orderedAscending
                }
        }
    }

    private func treeRow(_ tree: Tree) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(TreePresentation.registryName(for: tree))
                .font(FaloTypography.body.weight(.semibold))
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .lineLimit(1)

            if let subtitle = TreePresentation.registrySubtitle(for: tree) {
                Text(subtitle)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(TreePresentation.registryLabel(for: tree))
    }

    private func assign() {
        guard let selectedTreeID else { return }
        do {
            try potService.assignPot(potID, toTreeID: selectedTreeID)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
