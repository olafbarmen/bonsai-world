//
//  SpeciesProfileDetailView.swift
//  Bonsai World
//
//  Full Species Profile reader (Knowledge → Species Library detail).
//

import SwiftUI

struct SpeciesProfileDetailView: View {
    @Environment(AppState.self) private var appState

    private var profile: SpeciesProfile? {
        guard let id = appState.selectedSpeciesProfileID else { return nil }
        return SpeciesProfileCatalog.profile(id: id)
    }

    var body: some View {
        Group {
            if let profile {
                content(for: profile)
            } else {
                ContentUnavailableView(
                    "Select a Species",
                    systemImage: "leaf",
                    description: Text("Choose a species profile from the list.")
                )
            }
        }
    }

    @ViewBuilder
    private func content(for profile: SpeciesProfile) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxxLarge) {
                header(profile)

                quickReference(profile)

                principle(profile)

                ForEach(Array(profile.sections.enumerated()), id: \.element.id) { index, section in
                    if index > 0 {
                        Divider()
                            .overlay(BonsaiWorldColors.borderSubtle)
                    }
                    sectionBlock(section)
                }

                sources(profile)
            }
            .padding(.horizontal, FaloSpacing.xLarge)
            .padding(.vertical, FaloSpacing.xxLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
    }

    // MARK: - Header

    private func header(_ profile: SpeciesProfile) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text(profile.scientificName)
                .font(FaloTypography.pageTitle)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityAddTraits(.isHeader)

            Text(profile.primaryCommonName)
                .font(FaloTypography.pageSubtitle)
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
                .padding(.top, FaloSpacing.xSmall)
        }
        .padding(.bottom, FaloSpacing.medium)
    }

    // MARK: - Quick Reference

    private func quickReference(_ profile: SpeciesProfile) -> some View {
        let t = profile.traits
        let bonsaiRows: [(String, String)] = [
            ("Bonsai suitability", t.bonsaiSuitability),
            ("Difficulty", t.difficulty),
            ("Beginner suitability", t.beginnerSuitability),
        ]
        let growthRows: [(String, String)] = [
            ("Growth", t.growthStrength),
            ("Growth speed", t.growthSpeed),
            (profile.foliageSizeLabel, t.leafSize),
            (profile.foliageReductionLabel, t.foliageReduction),
            ("Ramification", t.ramificationPotential),
            ("Back-budding", t.backBudding),
            ("Root development", t.rootDevelopment),
            ("Nebari", t.nebariPotential),
            ("Trunk development", t.trunkDevelopment),
            ("Bark development", t.barkDevelopment),
        ]
        let climateRows: [(String, String)] = [
            ("Winter dormancy", t.winterDormancyRequired ? "Required" : "Not required"),
            ("Winter hardiness", t.winterHardiness),
            ("Root frost sensitivity", t.rootFrostSensitivity),
        ]
        let practicalRows: [(String, String)] = [
            ("Wiring", t.wiring),
            ("Defoliation", t.defoliation),
        ]

        return VStack(alignment: .leading, spacing: FaloSpacing.large) {
            Text("Quick Reference")
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityAddTraits(.isHeader)

            ViewThatFits(in: .horizontal) {
                // Fill column 1 first (Bonsai → Growth), then column 2 (Climate → Practical).
                quickReferenceTwoColumn(
                    leftTop: ("Bonsai characteristics", bonsaiRows),
                    leftBottom: ("Growth and development", growthRows),
                    rightTop: ("Climate and hardiness", climateRows),
                    rightBottom: ("Practical cultivation", practicalRows)
                )

                VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                    quickReferenceGroup(title: "Bonsai characteristics", rows: bonsaiRows)
                    quickReferenceGroup(title: "Growth and development", rows: growthRows)
                    quickReferenceGroup(title: "Climate and hardiness", rows: climateRows)
                    quickReferenceGroup(title: "Practical cultivation", rows: practicalRows)
                }
            }
            .padding(FaloSpacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .fill(BonsaiWorldColors.surface)
            }
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .strokeBorder(BonsaiWorldColors.borderSubtle, lineWidth: 1)
            }
        }
    }

    private func quickReferenceTwoColumn(
        leftTop: (String, [(String, String)]),
        leftBottom: (String, [(String, String)]),
        rightTop: (String, [(String, String)]),
        rightBottom: (String, [(String, String)])
    ) -> some View {
        HStack(alignment: .top, spacing: FaloSpacing.xxLarge) {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                quickReferenceGroup(title: leftTop.0, rows: leftTop.1)
                quickReferenceGroup(title: leftBottom.0, rows: leftBottom.1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                quickReferenceGroup(title: rightTop.0, rows: rightTop.1)
                quickReferenceGroup(title: rightBottom.0, rows: rightBottom.1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 560)
    }

    private func quickReferenceGroup(title: String, rows: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text(title)
                .font(FaloCardTypography.sectionTitle)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
                .textCase(.uppercase)
                .tracking(FaloCardTypography.sectionTitleTracking)

            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    attribute(row.0, row.1)
                }
            }
        }
    }

    private func attribute(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
            Text(value)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Principle

    private func principle(_ profile: SpeciesProfile) -> some View {
        let shape = RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)

        return VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("Important Species Principle")
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            Text(profile.principleNote)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)
        }
        .padding(FaloSpacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            shape.fill(BonsaiWorldColors.accentSubtle)
        }
        .overlay {
            shape.strokeBorder(BonsaiWorldColors.borderSubtle, lineWidth: 1)
        }
        .clipShape(shape)
    }

    // MARK: - Sections

    private func sectionBlock(_ section: SpeciesProfileSection) -> some View {
        let isTaxonomic = section.title.localizedCaseInsensitiveContains("Taxonomic")

        return VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text(section.title)
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityAddTraits(.isHeader)

            ForEach(Array(section.paragraphs.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(FaloTypography.body)
                    .foregroundStyle(
                        isTaxonomic
                            ? BonsaiWorldColors.textSecondary
                            : BonsaiWorldColors.textPrimary
                    )
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
            }

            if !section.bullets.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    ForEach(Array(section.bullets.enumerated()), id: \.offset) { _, item in
                        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                            Text("·")
                                .foregroundStyle(BonsaiWorldColors.textTertiary)
                            Text(item)
                                .font(FaloTypography.body)
                                .foregroundStyle(
                                    isTaxonomic
                                        ? BonsaiWorldColors.textSecondary
                                        : BonsaiWorldColors.textPrimary
                                )
                                .fixedSize(horizontal: false, vertical: true)
                                .textSelection(.enabled)
                        }
                    }
                }
                .padding(.top, FaloSpacing.xSmall)
            }
        }
    }

    private func sources(_ profile: SpeciesProfile) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Divider()
                .overlay(BonsaiWorldColors.borderSubtle)

            Text("Sources")
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            Text(profile.sourcesNote)
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)
        }
    }
}
