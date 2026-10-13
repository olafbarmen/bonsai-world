//
//  LocationListView.swift
//  Bonsai World
//
//  Locations — persisted Location records. New Location from the list.
//

import SwiftUI

struct LocationListView: View {
    @Environment(DemoLibrary.self) private var library

    var onCreatedLocation: ((UUID) -> Void)? = nil

    @State private var isShowingNewLocation = false
    @State private var pendingCreatedLocationID: UUID?

    var body: some View {
        Group {
            if library.orderedLocations.isEmpty {
                ContentUnavailableView {
                    Label("No Locations yet", systemImage: "mappin.and.ellipse")
                } description: {
                    Text("Add a location for your trees.")
                } actions: {
                    Button("New Location") {
                        isShowingNewLocation = true
                    }
                    .accessibilityLabel("New Location")
                }
            } else {
                locationList
            }
        }
        .navigationTitle("Locations")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Location") {
                    isShowingNewLocation = true
                }
                .accessibilityLabel("New Location")
            }
        }
        .sheet(isPresented: $isShowingNewLocation, onDismiss: {
            if let id = pendingCreatedLocationID {
                pendingCreatedLocationID = nil
                onCreatedLocation?(id)
            }
        }) {
            NewLocationView { id in
                pendingCreatedLocationID = id
            }
        }
    }

    private var locationList: some View {
        List {
            ForEach(library.orderedLocations) { location in
                NavigationLink(value: MobileRoute.location(location.id)) {
                    locationRow(location)
                }
                .listRowBackground(BonsaiWorldColors.surface)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private func locationRow(_ location: Location) -> some View {
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
}

#Preview {
    NavigationStack {
        LocationListView()
    }
    .environment(DemoLibrary.preview)
}
