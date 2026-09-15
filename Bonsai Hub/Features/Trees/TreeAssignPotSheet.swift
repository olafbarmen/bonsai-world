//
//  TreeAssignPotSheet.swift
//  Bonsai World
//
//  Picks an Available Inventory Pot for this Tree.
//  PotService.assignPot owns Tree ↔ Pot sync (including replacing a prior link).
//  Inverse of PotAssignTreeSheet (Pot → Tree).
//

import SwiftUI

struct TreeAssignPotSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PotService.self) private var potService
    @Environment(ReferenceDataService.self) private var referenceData

    let treeID: UUID
    /// When changing an existing assignment, exclude that pot from the list.
    var excludingPotID: UUID? = nil

    @State private var selectedPotID: UUID?
    @State private var searchText = ""
    @State private var errorMessage: String?
    @State private var eligiblePots: [Pot] = []

    private var filteredPots: [Pot] {
        let needle = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return eligiblePots }
        return eligiblePots.filter { pot in
            displayName(for: pot).localizedCaseInsensitiveContains(needle)
                || pot.material.localizedCaseInsensitiveContains(needle)
                || pot.shape.localizedCaseInsensitiveContains(needle)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Text(excludingPotID == nil ? "Assign Pot" : "Change Pot")
                    .font(FaloTypography.headline)
                Spacer()
                Button(excludingPotID == nil ? "Assign" : "Change") { assign() }
                    .keyboardShortcut(.defaultAction)
                    .disabled(selectedPotID == nil)
            }
            .padding(.horizontal, FaloSpacing.large)
            .padding(.vertical, FaloSpacing.medium)

            Divider()

            if eligiblePots.isEmpty {
                ContentUnavailableView(
                    "No Available Pots",
                    systemImage: "archivebox",
                    description: Text("Add an Available pot in Pots before assigning it to this tree.")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                TextField("Name, material, or shape", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, FaloSpacing.large)
                    .padding(.top, FaloSpacing.medium)

                if filteredPots.isEmpty {
                    ContentUnavailableView(
                        "No Matching Pots",
                        systemImage: "magnifyingglass",
                        description: Text("Try another name, material, or shape.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredPots, id: \.id, selection: $selectedPotID) { pot in
                        potRow(pot)
                            .tag(pot.id)
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
            eligiblePots = potService.availablePots
                .filter { $0.id != excludingPotID }
                .sorted {
                    displayName(for: $0).localizedCaseInsensitiveCompare(displayName(for: $1)) == .orderedAscending
                }
        }
    }

    private func potRow(_ pot: Pot) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(displayName(for: pot))
                .font(FaloTypography.body.weight(.semibold))
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .lineLimit(1)

            let subtitle = [pot.material, pot.shape]
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: " · ")
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(displayName(for: pot))
    }

    private func displayName(for pot: Pot) -> String {
        let trimmed = pot.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        if let potTypeID = pot.potTypeID, let type = referenceData.potType(id: potTypeID) {
            return type.name
        }
        return "Untitled Pot"
    }

    private func assign() {
        guard let selectedPotID else { return }
        do {
            try potService.assignPot(selectedPotID, toTreeID: treeID)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
