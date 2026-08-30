//
//  CollectionSummaryHeroCard.swift
//  Bonsai World
//
//  Dashboard hero — My Trees (whole-library counts) + dominant Species list.
//  Reads live Trees + Reference Data via DashboardCollectionSummary — no placeholder numbers.
//

import SwiftUI

struct CollectionSummaryHeroCard: View {
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData

    private let collectionColumnWidth: CGFloat = 200

    private var speciesColumns: [GridItem] {
        [
            GridItem(.flexible(minimum: 140), spacing: FaloSpacing.large),
            GridItem(.flexible(minimum: 140), spacing: FaloSpacing.large),
            GridItem(.flexible(minimum: 140), spacing: FaloSpacing.large)
        ]
    }

    private var heroMetrics: [DashboardCollectionSummary.Metric] {
        DashboardCollectionSummary.heroMetrics(
            trees: treeService.trees,
            treeStatuses: referenceData.treeStatuses,
            acquisitionMethods: referenceData.acquisitionMethods,
            disposalMethods: referenceData.disposalMethods
        )
    }

    private var speciesBreakdown: [DashboardCollectionSummary.SpeciesBreakdown] {
        DashboardCollectionSummary.speciesBreakdown(
            trees: treeService.treesInCare,
            genus: referenceData.genus,
            species: referenceData.species
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.titleToContent) {
            Text("My Trees")
                .font(FaloTypography.headline)
                .foregroundStyle(.primary)

            HStack(alignment: .top, spacing: 0) {
                collectionColumn

                columnDivider

                speciesColumn
            }
        }
        .padding(DashboardSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .dashboardCardChrome()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("My Trees")
    }

    private var collectionColumn: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("Collection")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                ForEach(heroMetrics) { metric in
                    HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                        Text(metric.count, format: .number)
                            .font(FaloTypography.headline)
                            .monospacedDigit()
                        Text(metric.label)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .frame(width: collectionColumnWidth, alignment: .topLeading)
        .padding(.trailing, FaloSpacing.medium)
    }

    private var speciesColumn: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("Species")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            if speciesBreakdown.isEmpty {
                Text("Add trees with a Genus or Species to see a breakdown here.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: speciesColumns, alignment: .leading, spacing: FaloSpacing.small) {
                    ForEach(speciesBreakdown) { item in
                        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                            Text(item.name)
                                .font(FaloTypography.body)
                                .lineLimit(1)
                            Spacer(minLength: FaloSpacing.xSmall)
                            Text(item.count, format: .number)
                                .font(FaloTypography.body)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.leading, FaloSpacing.medium)
    }

    private var columnDivider: some View {
        Rectangle()
            .fill(FaloColors.borderSubtle)
            .frame(width: 1)
            .padding(.vertical, FaloSpacing.xSmall)
            .accessibilityHidden(true)
    }
}

#Preview {
    let preview = PreviewData()
    let referenceStore = ReferencePreviewData()
    return CollectionSummaryHeroCard()
        .environment(TreeService.preview(previewData: preview))
        .environment(ReferenceDataService(previewData: referenceStore))
        .padding()
        .frame(width: 960)
}
