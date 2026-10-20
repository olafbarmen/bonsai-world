//
//  NewYamadoriView.swift
//  Bonsai World
//
//  New Yamadori = trip only (Wild Site). Findings via Add Find.
//

import SwiftUI

struct NewYamadoriView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var displayName = ""
    @State private var discoveryDate = Date.now
    @State private var hasDiscoveryDate = true
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var locationDescription = ""
    @State private var countryRegion = ""
    @State private var permissionNotes = ""
    @State private var notes = ""

    private var canCreate: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Wild Site") {
                    TextField("Display Name", text: $displayName)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Display Name")

                    Toggle("Discovery Date", isOn: $hasDiscoveryDate)
                    if hasDiscoveryDate {
                        DatePicker("Date", selection: $discoveryDate, displayedComponents: .date)
                    }

                    TextField("Location Description", text: $locationDescription, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityLabel("Location Description")

                    TextField("Country / Region", text: $countryRegion)
                        .accessibilityLabel("Country / Region")

                    MobileYamadoriMapCard(
                        latitude: $latitude,
                        longitude: $longitude,
                        primaryTitle: displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? "Trip"
                            : displayName,
                        mapHeight: 200
                    )
                    .listRowInsets(EdgeInsets(
                        top: FaloSpacing.small,
                        leading: FaloSpacing.medium,
                        bottom: FaloSpacing.small,
                        trailing: FaloSpacing.medium
                    ))
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Area Map")

                    TextField("Permission Notes", text: $permissionNotes, axis: .vertical)
                        .lineLimit(2...4)
                        .accessibilityLabel("Permission Notes")
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                        .accessibilityLabel("Notes")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Yamadori")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                        .fontWeight(.semibold)
                        .disabled(!canCreate)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    private func create() {
        guard let trip = library.addYamadoriTrip(
            displayName: displayName,
            discoveryDate: hasDiscoveryDate ? discoveryDate : nil,
            latitude: latitude,
            longitude: longitude,
            locationDescription: locationDescription,
            countryRegion: countryRegion,
            permissionNotes: permissionNotes,
            notes: notes
        ) else { return }
        onCreated(trip.id)
        dismiss()
    }
}

#Preview {
    NewYamadoriView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
