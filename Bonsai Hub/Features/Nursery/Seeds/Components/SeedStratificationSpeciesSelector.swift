//
//  SeedStratificationSpeciesSelector.swift
//  Bonsai World
//
//  Searchable species selector bound to SeedStratificationCatalogService.
//  Avoid nested ScrollView of the full catalog (layout thrash / hang on macOS).
//

import SwiftUI

struct SeedStratificationSpeciesSelector: View {
    @Environment(SeedStratificationCatalogService.self) private var catalog

    @Binding var selectedSpeciesID: UUID?
    @State private var searchText = ""

    private var trimmedSearch: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var matches: [SpeciesStratificationProfile] {
        guard trimmedSearch.count >= 2 else { return [] }
        return Array(catalog.matching(search: trimmedSearch).prefix(40))
    }

    private var selectedProfile: SpeciesStratificationProfile? {
        guard let selectedSpeciesID else { return nil }
        return catalog.profile(speciesID: selectedSpeciesID)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.large) {
            DetailCard(title: "Select species") {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search botanical or common name", text: $searchText)
                        .textFieldStyle(.plain)
                }

                if catalog.profiles.isEmpty {
                    Text("No species profiles loaded.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                } else if trimmedSearch.count < 2 {
                    Text("Type at least 2 characters to search the catalog.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, FaloSpacing.xSmall)
                } else if matches.isEmpty {
                    Text("No species match “\(trimmedSearch)”.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, FaloSpacing.xSmall)
                } else {
                    // Fixed-height List — not a ScrollView inside the page ScrollView.
                    List(matches) { profile in
                        Button {
                            selectedSpeciesID = profile.speciesID
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(profile.scientificName)
                                        .font(FaloCardTypography.fieldValue)
                                        .foregroundStyle(.primary)
                                    Text(profile.commonName)
                                        .font(FaloTypography.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if selectedSpeciesID == profile.speciesID {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .frame(height: 220)
                }
            }

            if let selectedProfile {
                SpeciesStratificationProfileDetailView(profile: selectedProfile)
            } else {
                Text(SeedStratificationKnowledge.speciesSelectorPlaceholder)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
