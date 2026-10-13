//
//  YamadoriTripProfileView.swift
//  Bonsai World
//
//  Trip shell — name, Wild Site map, Finds, Add Find, Edit Trip.
//

import SwiftUI

struct YamadoriTripProfileView: View {
    @Environment(DemoLibrary.self) private var library

    let tripID: UUID
    var onCreatedFind: ((UUID) -> Void)? = nil

    @State private var isShowingAddFind = false
    @State private var isShowingEditTrip = false
    @State private var pendingCreatedFindID: UUID?
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var didLoadSite = false

    private var trip: Yamadori? { library.yamadoriTrip(id: tripID) }

    var body: some View {
        Group {
            if let trip {
                profileList(trip)
            } else {
                ContentUnavailableView("Yamadori not found", systemImage: "leaf.circle")
            }
        }
        .onAppear { loadSiteIfNeeded() }
        .onChange(of: tripID) { _, _ in
            didLoadSite = false
            loadSiteIfNeeded()
        }
    }

    private func profileList(_ trip: Yamadori) -> some View {
        let finds = library.finds(forYamadoriID: trip.id)
        return List {
            Section {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text(trip.displayName.isEmpty ? "Yamadori" : trip.displayName)
                        .font(FaloTypography.pageTitle)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    if let tripDate = trip.tripDate {
                        Text(tripDate, style: .date)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                }
                .padding(.vertical, FaloSpacing.small)
                .listRowBackground(BonsaiWorldColors.surface)

                Button("Edit Trip") {
                    isShowingEditTrip = true
                }
                .font(FaloTypography.body)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Edit Trip")
            }

            Section("Wild Site") {
                MobileYamadoriMapCard(
                    latitude: $latitude,
                    longitude: $longitude,
                    primaryTitle: trip.displayName.isEmpty ? "Wild Site" : trip.displayName
                )
                .listRowBackground(BonsaiWorldColors.surface)

                Button("Save Site") {
                    library.updateYamadoriTripSite(id: tripID, latitude: latitude, longitude: longitude)
                }
                .font(FaloTypography.body.weight(.semibold))
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Save Site")
            }

            Section("Finds") {
                if finds.isEmpty {
                    Text("No Finds yet")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                } else {
                    ForEach(finds) { find in
                        NavigationLink(value: MobileRoute.yamadoriFind(find.id)) {
                            findRow(find)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                    }
                }

                Button("Add Find") {
                    isShowingAddFind = true
                }
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.accent)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Add Find")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle("Yamadori")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingEditTrip) {
            EditYamadoriTripView(tripID: tripID)
        }
        .sheet(isPresented: $isShowingAddFind, onDismiss: {
            if let id = pendingCreatedFindID {
                pendingCreatedFindID = nil
                onCreatedFind?(id)
            }
        }) {
            NewYamadoriFindView(tripID: tripID) { findID in
                pendingCreatedFindID = findID
            }
        }
    }

    private func findRow(_ find: YamadoriFind) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            if let imageID = find.primaryImageID ?? find.imageIDs.first {
                MobileAssetImage(imageID: imageID)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(find.displayName.isEmpty ? find.yamadoriCode : find.displayName)
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                Text("\(find.yamadoriCode) · \(find.status.title)")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
            Spacer(minLength: 0)
            if find.hasCoordinates {
                Image(systemName: "mappin.circle.fill")
                    .font(.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .accessibilityLabel("Has map pin")
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    private func loadSiteIfNeeded() {
        guard !didLoadSite, let trip else { return }
        latitude = trip.latitude
        longitude = trip.longitude
        didLoadSite = true
    }
}

#Preview {
    NavigationStack {
        YamadoriTripProfileView(tripID: UUID())
    }
    .environment(DemoLibrary.preview)
}
