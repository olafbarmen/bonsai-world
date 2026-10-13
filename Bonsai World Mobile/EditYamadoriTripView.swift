//
//  EditYamadoriTripView.swift
//  Bonsai World
//
//  Edit Trip — name and trip date.
//

import SwiftUI

struct EditYamadoriTripView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let tripID: UUID

    @State private var displayName: String = ""
    @State private var tripDate: Date = .now
    @State private var didLoad = false

    private var canSave: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $displayName)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Name")

                    DatePicker("Trip Date", selection: $tripDate, displayedComponents: .date)
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Edit Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear { loadIfNeeded() }
        }
    }

    private func loadIfNeeded() {
        guard !didLoad, let trip = library.yamadoriTrip(id: tripID) else { return }
        displayName = trip.displayName
        tripDate = trip.tripDate ?? trip.createdDate
        didLoad = true
    }

    private func save() {
        library.updateYamadoriTrip(id: tripID, displayName: displayName, tripDate: tripDate)
        dismiss()
    }
}

#Preview {
    EditYamadoriTripView(tripID: UUID())
        .environment(DemoLibrary.preview)
}
