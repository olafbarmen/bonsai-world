//
//  GardenListView.swift
//  Bonsai World
//
//  Gardens — persisted Garden records. New Garden from the list.
//

import SwiftUI

struct GardenListView: View {
    @Environment(DemoLibrary.self) private var library

    var onCreatedGarden: ((UUID) -> Void)? = nil

    @State private var isShowingNewGarden = false
    @State private var pendingCreatedGardenID: UUID?

    var body: some View {
        Group {
            if library.orderedGardens.isEmpty {
                ContentUnavailableView {
                    Label("No gardens yet", systemImage: "building.2")
                } description: {
                    Text("Add a garden to organize locations.")
                } actions: {
                    Button("New Garden") {
                        isShowingNewGarden = true
                    }
                    .accessibilityLabel("New Garden")
                }
            } else {
                gardenList
            }
        }
        .navigationTitle("Gardens")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Garden") {
                    isShowingNewGarden = true
                }
                .accessibilityLabel("New Garden")
            }
        }
        .sheet(isPresented: $isShowingNewGarden, onDismiss: {
            if let id = pendingCreatedGardenID {
                pendingCreatedGardenID = nil
                onCreatedGarden?(id)
            }
        }) {
            NewGardenView { id in
                pendingCreatedGardenID = id
            }
        }
    }

    private var gardenList: some View {
        List {
            ForEach(library.orderedGardens) { garden in
                NavigationLink(value: MobileRoute.garden(garden.id)) {
                    gardenRow(garden)
                }
                .listRowBackground(BonsaiWorldColors.surface)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private func gardenRow(_ garden: Garden) -> some View {
        let locations = library.locations(inGarden: garden.id)
        let locationCount = locations.count
        let pinned = locations.filter { $0.geographicPosition != nil }.count
        return VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(garden.name)
                .font(FaloTypography.body)
                .fontWeight(.semibold)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            Text(gardenLocationsCaption(total: locationCount, pinned: pinned))
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
            if garden.isDefault {
                Text("Default")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    private func gardenLocationsCaption(total: Int, pinned: Int) -> String {
        if total == 0 { return "Empty" }
        if pinned == 0 {
            return total == 1 ? "1 Location" : "\(total) Locations"
        }
        if pinned == total {
            return pinned == 1 ? "1 Location pinned" : "\(pinned) Locations pinned"
        }
        return "\(pinned) of \(total) pinned"
    }
}

#Preview {
    NavigationStack {
        GardenListView()
    }
    .environment(DemoLibrary.preview)
}
