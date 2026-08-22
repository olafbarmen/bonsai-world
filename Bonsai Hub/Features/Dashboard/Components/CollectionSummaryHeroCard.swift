//
//  CollectionSummaryHeroCard.swift
//  Bonsai World
//
//  Dashboard hero — Collection column + dominant Species list with counts.
//

import SwiftUI

struct CollectionSummaryHeroCard: View {
    private let collectionColumnWidth: CGFloat = 200

    private var speciesColumns: [GridItem] {
        [
            GridItem(.flexible(minimum: 140), spacing: FaloSpacing.large),
            GridItem(.flexible(minimum: 140), spacing: FaloSpacing.large),
            GridItem(.flexible(minimum: 140), spacing: FaloSpacing.large)
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.titleToContent) {
            Text("Collection Summary")
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
        .accessibilityLabel("Collection Summary")
    }

    private var collectionColumn: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("Collection")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                ForEach(DashboardPlaceholderData.heroCollection) { metric in
                    HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                        Text(metric.value)
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

            LazyVGrid(columns: speciesColumns, alignment: .leading, spacing: FaloSpacing.small) {
                ForEach(DashboardPlaceholderData.heroSpecies) { item in
                    HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                        Text(item.title)
                            .font(FaloTypography.body)
                            .lineLimit(1)
                        Spacer(minLength: FaloSpacing.xSmall)
                        if let detail = item.detail {
                            Text(detail)
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
    CollectionSummaryHeroCard()
        .padding()
        .frame(width: 960)
}
