//
//  LocationProfileView.swift
//  Bonsai World
//
//  Location Profile — persisted Location + trees at that place.
//  Opens the existing TreeProfileView. Delete removes the Location record only.
//

import CoreLocation
import MapKit
import SwiftUI

struct LocationProfileView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openMobileTree) private var openMobileTree
    let locationID: UUID

    @State private var confirmDelete = false
    @State private var isShowingNewTree = false
    @State private var pendingCreatedTreeID: UUID?

    private var location: Location? { library.location(id: locationID) }

    var body: some View {
        Group {
            if let location {
                profileList(location)
            } else {
                ContentUnavailableView("Location not found", systemImage: "mappin.and.ellipse")
            }
        }
    }

    private func profileList(_ location: Location) -> some View {
        let treesHere = library.trees(at: location.id)
        let description = location.locationDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let notes = location.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let typeName = CanonicalLocationID.locationTypeName(for: location.locationTypeID)
        let gardenName = library.gardenName(for: location.gardenID)
        return List {
            Section {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(location.name)
                        .font(FaloTypography.pageTitle)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    if let typeName, !typeName.isEmpty {
                        Text(typeName)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                    if !description.isEmpty {
                        Text(description)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                    if !notes.isEmpty {
                        Text(notes)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                    Text(treesHere.count == 1 ? "1 Tree" : "\(treesHere.count) Trees")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                }
                .padding(.vertical, FaloSpacing.small)
                .listRowBackground(BonsaiWorldColors.surface)
            }

            if let gardenName, !gardenName.isEmpty {
                Section("Details") {
                    profileRow(label: "Garden", value: gardenName)
                }
            }

            Section("Map") {
                if let latitude = location.latitude, let longitude = location.longitude {
                    LocationProfileMapPin(
                        latitude: latitude,
                        longitude: longitude,
                        title: location.name
                    )
                    .listRowInsets(EdgeInsets(
                        top: FaloSpacing.small,
                        leading: FaloSpacing.medium,
                        bottom: FaloSpacing.small,
                        trailing: FaloSpacing.medium
                    ))
                    .listRowBackground(BonsaiWorldColors.surface)
                } else {
                    Text("No pin")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                }

                NavigationLink(value: MobileRoute.editLocation(location.id)) {
                    Text("Edit Map")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.accent)
                }
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Edit Map")
                .accessibilityHint("Place, move, or clear the map pin")
            }

            Section("Trees Here") {
                if treesHere.isEmpty {
                    Text("Empty")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                    Button("New Tree") {
                        isShowingNewTree = true
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("New Tree")
                    .accessibilityHint("Adds a tree at this location")
                } else {
                    ForEach(treesHere) { tree in
                        NavigationLink(value: MobileRoute.tree(tree.id)) {
                            locationTreeRow(tree)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                    }
                }
            }

            Section {
                Button("Delete Location", role: .destructive) {
                    confirmDelete = true
                }
                .font(FaloTypography.body)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Delete Location")
                .accessibilityHint("Remove this location. Trees stay in the library.")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: MobileRoute.editLocation(location.id)) {
                    Text("Edit")
                }
                .accessibilityLabel("Edit Location")
            }
        }
        .sheet(isPresented: $isShowingNewTree, onDismiss: {
            if let id = pendingCreatedTreeID {
                pendingCreatedTreeID = nil
                openMobileTree(id)
            }
        }) {
            NewTreeView(initialLocationID: locationID) { id in
                pendingCreatedTreeID = id
            }
        }
        .confirmationDialog(
            "Delete this location?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                library.deleteLocation(id: location.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Trees stay in the library.")
        }
    }

    private func profileRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
            Text(value)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
        }
        .listRowBackground(BonsaiWorldColors.surface)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(value)")
    }

    private func locationTreeRow(_ tree: Tree) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            MobileTreeImage(tree: tree, style: .list)
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(MobileTreePresentation.title(for: tree))
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                if !MobileTreePresentation.subtitle(for: tree).isEmpty {
                    Text(MobileTreePresentation.subtitle(for: tree))
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}

private struct LocationProfileMapPin: View {
    let latitude: Double
    let longitude: Double
    let title: String

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var body: some View {
        Map(initialPosition: .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            )
        )) {
            Marker(title, systemImage: "mappin.circle.fill", coordinate: coordinate)
                .tint(BonsaiWorldColors.accent)
        }
        .mapStyle(.standard)
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
        .allowsHitTesting(false)
        .accessibilityLabel("Map pin for \(title)")
    }
}

#Preview {
    NavigationStack {
        LocationProfileView(locationID: CanonicalLocationID.altan)
    }
    .environment(DemoLibrary.preview)
}
