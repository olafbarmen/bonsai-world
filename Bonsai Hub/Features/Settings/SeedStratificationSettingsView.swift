//
//  SeedStratificationSettingsView.swift
//  Bonsai World
//
//  Settings → Bonsai Knowledge → Seed Stratification — read-only catalog browse.
//

import SwiftUI

struct SeedStratificationSettingsView: View {
    @Environment(SeedStratificationCatalogService.self) private var catalog

    @State private var searchText = ""
    @State private var selectedID: UUID?

    private var matches: [SpeciesStratificationProfile] {
        catalog.matching(search: searchText)
    }

    private var selected: SpeciesStratificationProfile? {
        guard let selectedID else { return nil }
        return catalog.profile(speciesID: selectedID)
    }

    var body: some View {
        HStack(spacing: 0) {
            listPane
                .frame(minWidth: 280, idealWidth: 320, maxWidth: 380)
            Divider()
            detailPane
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Seed Stratification")
        .onAppear {
            if selectedID == nil {
                selectedID = matches.first?.speciesID
            }
        }
    }

    private var listPane: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search species", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(FaloSpacing.medium)

            Text("\(matches.count) species · single source of truth")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FaloSpacing.medium)
                .padding(.bottom, FaloSpacing.small)

            Divider()

            List(matches, selection: $selectedID) { profile in
                VStack(alignment: .leading, spacing: 2) {
                    Text(profile.scientificName)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    Text(profile.commonName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                    HStack(spacing: FaloSpacing.small) {
                        Text(profile.treatmentType.title)
                            .lineLimit(1)
                        Text("·")
                        Text(profile.confidenceLevel.title)
                    }
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
                }
                .tag(profile.speciesID)
                .listRowBackground(
                    SidebarRowBackground(
                        isSelected: selectedID == profile.speciesID,
                        baseFill: BonsaiWorldColors.canvas
                    )
                )
            }
            .faloWarmContentList()
            .listStyle(.sidebar)
        }
    }

    @ViewBuilder
    private var detailPane: some View {
        if let selected {
            ScrollView {
                SpeciesStratificationProfileDetailView(profile: selected, showsStartAction: false)
                    .padding(FaloSpacing.xLarge)
                    .frame(maxWidth: 720, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .faloScrollSurface()
        } else {
            ContentUnavailableView(
                "Select a Species",
                systemImage: "leaf.arrow.triangle.circlepath",
                description: Text("Browse the seed stratification database.")
            )
        }
    }
}
