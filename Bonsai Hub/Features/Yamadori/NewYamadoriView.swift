//
//  NewYamadoriView.swift
//  Bonsai World
//
//  New Yamadori = trip only (Wild Site). Findings via Add Find (BZ1 / CB1).
//


import SwiftUI

struct NewYamadoriView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService

    @State private var displayName = ""
    @State private var discoveryDate = Date.now
    @State private var hasDiscoveryDate = true
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var locationDescription = ""
    @State private var countryRegion = ""
    @State private var permissionNotes = ""
    @State private var notes = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Wild Site") {
                    TextField("Display Name", text: $displayName)
                    Toggle("Discovery Date", isOn: $hasDiscoveryDate)
                    if hasDiscoveryDate {
                        DatePicker("Date", selection: $discoveryDate, displayedComponents: .date)
                    }
                    TextField("Location Description", text: $locationDescription)
                    TextField("Country / Region", text: $countryRegion)
                    YamadoriSiteMapCard(
                        title: "Area Map",
                        latitude: $latitude,
                        longitude: $longitude,
                        primaryTitle: displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? "Trip"
                            : displayName,
                        isEditing: true,
                        focusedLatitudeDelta: 0.12,
                        mapHeight: 200
                    )
                    .listRowInsets(EdgeInsets(
                        top: FaloSpacing.small,
                        leading: FaloSpacing.medium,
                        bottom: FaloSpacing.small,
                        trailing: FaloSpacing.medium
                    ))
                    TextField("Permission Notes", text: $permissionNotes, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("New Yamadori")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        appState.dismissYamadoriEditor()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                }
            }
            .alert("Could Not Create Yamadori", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .frame(minWidth: 520, minHeight: 560)
    }

    private func create() {
        var draft = NewYamadoriDraft()
        draft.displayName = displayName
        draft.discoveryDate = hasDiscoveryDate ? discoveryDate : nil
        draft.latitude = latitude
        draft.longitude = longitude
        draft.locationDescription = locationDescription
        draft.countryRegion = countryRegion
        draft.permissionNotes = permissionNotes
        draft.notes = notes

        do {
            let trip = try yamadoriService.createYamadori(fromDraft: draft)
            appState.selectedSection = .nurseryYamadori
            appState.selectedYamadoriWorkspaceTab = .yamadories
            appState.selectedYamadoriID = trip.id
            appState.selectedYamadoriFindID = nil
            appState.dismissYamadoriEditor()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
