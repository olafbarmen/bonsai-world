//
//  SpeciesLibraryView.swift
//  Bonsai World
//
//  Knowledge → Species Library — search + category-sectioned list of Species Profiles.
//  List sits in an inset raised panel on warm canvas (same rhythm as My Trees table).
//

import SwiftUI

struct SpeciesLibraryView: View {
    @Environment(AppState.self) private var appState

    @State private var searchText = ""

    private var groupedProfiles: [(category: SpeciesLibraryCategory, profiles: [SpeciesProfile])] {
        SpeciesProfileCatalog.groupedMatching(search: searchText)
    }

    private var flatProfiles: [SpeciesProfile] {
        groupedProfiles.flatMap(\.profiles)
    }

    var body: some View {
        @Bindable var appState = appState
        let panelShape = RoundedRectangle(cornerRadius: FaloRadius.large, style: .continuous)

        VStack(spacing: 0) {
            HStack(spacing: FaloSpacing.small) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
                TextField("Search scientific or common name", text: $searchText)
                    .textFieldStyle(.plain)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
            }
            .padding(.horizontal, FaloSpacing.large)
            .padding(.vertical, FaloSpacing.medium)

            List(selection: $appState.selectedSpeciesProfileID) {
                ForEach(groupedProfiles, id: \.category) { group in
                    Section {
                        ForEach(Array(group.profiles.enumerated()), id: \.element.id) { index, profile in
                            let isSelected = appState.selectedSpeciesProfileID == profile.id
                            SpeciesLibraryRow(
                                scientificName: profile.scientificName,
                                commonName: profile.primaryCommonName,
                                isSelected: isSelected
                            )
                            .tag(profile.id)
                            .listRowInsets(
                                EdgeInsets(
                                    top: FaloSpacing.small,
                                    leading: FaloSpacing.large,
                                    bottom: FaloSpacing.small,
                                    trailing: FaloSpacing.large
                                )
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                SpeciesLibraryRowBackground(
                                    isSelected: isSelected,
                                    isAlternate: BonsaiWorldTableZebra.isAlternate(at: index)
                                )
                            )
                        }
                    } header: {
                        Text(group.category.title)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                            .textCase(.uppercase)
                            .tracking(0.6)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .tint(BonsaiWorldColors.accent)
            .background(BonsaiWorldColors.canvas)
            .clipShape(panelShape)
            .overlay {
                panelShape.strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
            }
            .shadow(
                color: FaloShadow.color,
                radius: FaloShadow.radius,
                x: 0,
                y: FaloShadow.y
            )
            .overlay {
                if flatProfiles.isEmpty {
                    ContentUnavailableView(
                        "No Species Profiles",
                        systemImage: "leaf",
                        description: Text(
                            searchText.isEmpty
                                ? "Species profiles will appear here as they are published."
                                : "No profile matches that search."
                        )
                    )
                }
            }
            .padding(.horizontal, FaloSpacing.medium)
            .padding(.bottom, FaloSpacing.medium)
        }
        .faloWorkspaceCanvas()
        .onAppear {
            if appState.selectedSpeciesProfileID == nil {
                appState.selectedSpeciesProfileID = flatProfiles.first?.id
            }
        }
    }
}

// MARK: - Row

private struct SpeciesLibraryRow: View {
    let scientificName: String
    let commonName: String
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(scientificName)
                .font(FaloTypography.cardRowTitle)
                .foregroundStyle(isSelected ? Color.white : BonsaiWorldColors.textPrimary)
                .lineLimit(2)
            Text(commonName)
                .font(FaloTypography.caption)
                .foregroundStyle(
                    isSelected
                        ? Color.white.opacity(0.82)
                        : BonsaiWorldColors.textTertiary
                )
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Row background (warm zebra + solid forest selection)

/// Inside the raised panel: calm zebra bands; selected = solid World accent (My Trees rhythm).
private struct SpeciesLibraryRowBackground: View {
    var isSelected: Bool
    var isAlternate: Bool
    @State private var isHovered = false

    var body: some View {
        ZStack {
            zebraBase

            if isSelected {
                BonsaiWorldColors.accent
            } else if isHovered {
                BonsaiWorldColors.sidebarHover
            }
        }
        .onHover { hovering in
            isHovered = hovering
        }
    }

    private var zebraBase: Color {
        // Same canvas / surface bands as My Trees (``WarmTableZebraChrome``).
        isAlternate ? BonsaiWorldColors.surface : BonsaiWorldColors.canvas
    }
}
