//
//  MobileSpeciesLibraryViews.swift
//  Bonsai World
//

import SwiftUI

struct MobileSpeciesLibraryView: View {
    @State private var searchText = ""

    private var groups: [(category: SpeciesLibraryCategory, profiles: [SpeciesProfile])] {
        SpeciesProfileCatalog.groupedMatching(search: searchText)
    }

    var body: some View {
        List {
            if groups.isEmpty {
                ContentUnavailableView(
                    "No Species Profiles",
                    systemImage: "leaf",
                    description: Text(
                        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? "Species profiles will appear here as they are published."
                            : "No profile matches that search."
                    )
                )
            } else {
                ForEach(groups, id: \.category) { group in
                    Section(group.category.title) {
                        ForEach(group.profiles) { profile in
                            NavigationLink(value: MobileRoute.speciesProfile(profile.id)) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(profile.scientificName)
                                        .font(FaloTypography.body)
                                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                                    Text(profile.primaryCommonName)
                                        .font(FaloTypography.caption)
                                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText, prompt: "Search scientific or common name")
        .navigationTitle("Species Library")
    }
}

struct MobileSpeciesProfileView: View {
    let profileID: UUID

    private var profile: SpeciesProfile? {
        SpeciesProfileCatalog.profile(id: profileID)
    }

    var body: some View {
        Group {
            if let profile {
                ScrollView {
                    VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                        header(profile)
                        quickReference(profile)
                        principle(profile)
                        ForEach(profile.sections) { section in
                            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                                Text(section.title)
                                    .font(FaloTypography.sectionHeading)
                                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                                    .accessibilityAddTraits(.isHeader)
                                ForEach(section.paragraphs, id: \.self) { paragraph in
                                    Text(paragraph)
                                        .font(FaloTypography.body)
                                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                                }
                                ForEach(section.bullets, id: \.self) { bullet in
                                    Text("· \(bullet)")
                                        .font(FaloTypography.body)
                                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: FaloSpacing.small) {
                            Text("Sources")
                                .font(FaloTypography.sectionHeading)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                                .accessibilityAddTraits(.isHeader)
                            Text(profile.sourcesNote)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                    }
                    .padding(FaloSpacing.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .navigationTitle(profile.scientificName)
            } else {
                ContentUnavailableView("Select a Species", systemImage: "leaf", description: Text("Choose a species profile from the list."))
                    .navigationTitle("Species Library")
            }
        }
    }

    private func header(_ profile: SpeciesProfile) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text(profile.scientificName)
                .font(FaloTypography.pageTitle)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            Text(profile.primaryCommonName)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
            Text("\(profile.family) · \(profile.plantType)")
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textTertiary)
            Text("Origin: \(profile.originSummary)")
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textTertiary)
            Text(profile.summaryLine)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
        }
    }

    private func principle(_ profile: SpeciesProfile) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("Important Species Principle")
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            Text(profile.principleNote)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
        }
    }

    private func quickReference(_ profile: SpeciesProfile) -> some View {
        let traits = profile.traits
        return VStack(alignment: .leading, spacing: FaloSpacing.large) {
            Text("Quick Reference")
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            referenceGroup(
                title: "Bonsai characteristics",
                rows: [
                    ("Bonsai suitability", traits.bonsaiSuitability),
                    ("Difficulty", traits.difficulty),
                    ("Beginner suitability", traits.beginnerSuitability),
                ]
            )
            referenceGroup(
                title: "Growth and development",
                rows: [
                    ("Growth", traits.growthStrength),
                    ("Growth speed", traits.growthSpeed),
                    (profile.foliageSizeLabel, traits.leafSize),
                    (profile.foliageReductionLabel, traits.foliageReduction),
                    ("Ramification", traits.ramificationPotential),
                    ("Back-budding", traits.backBudding),
                    ("Root development", traits.rootDevelopment),
                    ("Nebari", traits.nebariPotential),
                    ("Trunk development", traits.trunkDevelopment),
                    ("Bark development", traits.barkDevelopment),
                ]
            )
            referenceGroup(
                title: "Climate and hardiness",
                rows: [
                    ("Winter dormancy", traits.winterDormancyRequired ? "Required" : "Not required"),
                    ("Winter hardiness", traits.winterHardiness),
                    ("Root frost sensitivity", traits.rootFrostSensitivity),
                ]
            )
            referenceGroup(
                title: "Practical cultivation",
                rows: [
                    ("Wiring", traits.wiring),
                    ("Defoliation", traits.defoliation),
                ]
            )
        }
        .padding(FaloSpacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BonsaiWorldColors.surface, in: RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous))
    }

    private func referenceGroup(title: String, rows: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text(title)
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            ForEach(rows, id: \.0) { row in
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.0)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                    Text(row.1)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}
