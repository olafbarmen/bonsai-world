//
//  GardenProfileView.swift
//  Bonsai World
//
//  Garden Profile — persisted Garden + Locations in that Garden.
//  Opens the existing LocationProfileView.
//

import SwiftUI

struct GardenProfileView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appendMobileRoute) private var appendMobileRoute

    let gardenID: UUID

    @State private var confirmDelete = false
    @State private var isShowingNewLocation = false
    @State private var pendingCreatedLocationID: UUID?

    private var garden: Garden? { library.garden(id: gardenID) }

    /// Mac User Profile: Delete is offered for non-default Gardens when more than one exists.
    private var canDelete: Bool {
        guard let garden else { return false }
        return library.gardens.count > 1 && !garden.isDefault
    }

    var body: some View {
        Group {
            if let garden {
                profileList(garden)
            } else {
                ContentUnavailableView("Garden not found", systemImage: "mappin.and.ellipse")
            }
        }
    }

    private func profileList(_ garden: Garden) -> some View {
        let locationsHere = library.locations(inGarden: garden.id)
        return List {
            Section {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(garden.name)
                        .font(FaloTypography.pageTitle)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    if garden.isDefault {
                        Text("Default")
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textTertiary)
                    }
                    if !locationsHere.isEmpty {
                        Text(pinnedLocationsCaption(locationsHere))
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textTertiary)
                    }
                }
                .padding(.vertical, FaloSpacing.small)
                .listRowBackground(BonsaiWorldColors.surface)
            }

            if hasAddress(garden) {
                Section("Address") {
                    if !trimmed(garden.address).isEmpty {
                        profileLine(garden.address)
                    }
                    if !trimmed(garden.postalCode).isEmpty || !trimmed(garden.city).isEmpty {
                        profileLine([garden.postalCode, garden.city].filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.joined(separator: " "))
                    }
                    if !trimmed(garden.country).isEmpty {
                        profileLine(garden.country)
                    }
                }
            }

            Section("Locations") {
                if locationsHere.isEmpty {
                    Text("Empty")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                    Button("New Location") {
                        isShowingNewLocation = true
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("New Location")
                    .accessibilityHint("Add a location in this garden")
                } else {
                    ForEach(locationsHere) { location in
                        NavigationLink(value: MobileRoute.location(location.id)) {
                            gardenLocationRow(location)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                    }
                }
            }

            if canDelete {
                Section {
                    Button("Delete Garden", role: .destructive) {
                        confirmDelete = true
                    }
                    .font(FaloTypography.body)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Delete Garden")
                    .accessibilityHint("Remove this garden. Locations stay in the library.")
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle(garden.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: MobileRoute.editGarden(garden.id)) {
                    Text("Edit")
                }
                .accessibilityLabel("Edit Garden")
            }
        }
        .confirmationDialog(
            "Delete this garden?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                library.deleteGarden(id: garden.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Locations stay in the library. Assign them to another Garden.")
        }
        .sheet(isPresented: $isShowingNewLocation, onDismiss: {
            if let id = pendingCreatedLocationID {
                pendingCreatedLocationID = nil
                appendMobileRoute(.location(id))
            }
        }) {
            NewLocationView(initialGardenID: garden.id) { id in
                pendingCreatedLocationID = id
            }
        }
    }

    private func pinnedLocationsCaption(_ locations: [Location]) -> String {
        let pinned = locations.filter { $0.geographicPosition != nil }.count
        let total = locations.count
        if pinned == 0 { return total == 1 ? "1 Location" : "\(total) Locations" }
        if pinned == total {
            return pinned == 1 ? "1 Location pinned" : "\(pinned) Locations pinned"
        }
        return "\(pinned) of \(total) pinned"
    }

    private func gardenLocationRow(_ location: Location) -> some View {
        let count = library.trees(at: location.id).count
        let hasPin = location.geographicPosition != nil
        return HStack(alignment: .center, spacing: FaloSpacing.medium) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(location.name)
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                Text(count == 0 ? "Empty" : (count == 1 ? "1 Tree" : "\(count) Trees"))
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
            }
            Spacer(minLength: 0)
            if hasPin {
                Image(systemName: "mappin.circle.fill")
                    .font(.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .accessibilityLabel("Has map pin")
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    private func hasAddress(_ garden: Garden) -> Bool {
        !trimmed(garden.address).isEmpty
            || !trimmed(garden.postalCode).isEmpty
            || !trimmed(garden.city).isEmpty
            || !trimmed(garden.country).isEmpty
    }

    private func profileLine(_ text: String) -> some View {
        Text(text)
            .font(FaloTypography.body)
            .foregroundStyle(BonsaiWorldColors.textPrimary)
            .listRowBackground(BonsaiWorldColors.surface)
    }

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    NavigationStack {
        GardenProfileView(gardenID: CanonicalLocationID.defaultGardenID)
    }
    .environment(DemoLibrary.preview)
}
