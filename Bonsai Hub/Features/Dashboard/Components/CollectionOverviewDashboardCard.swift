//
//  CollectionOverviewDashboardCard.swift
//  Bonsai World
//
//  Dashboard Collection Overview — two columns inside one card:
//  Collections (manual) | Smart Collections. Same TreeService counts/navigation
//  as the Collections workspace.
//

import SwiftUI

struct CollectionOverviewDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary
    var fillsRowHeight: Bool = false

    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TaskService.self) private var taskService
    @Environment(AppState.self) private var appState

    private let rowLimit = 8

    /// Same set and sort as Collections → My Collections.
    private var collections: [Collection] {
        treeService.manualCollections
    }

    /// Same set and sort as Collections → Smart Collections (excludes Former Trees).
    private var smartCollections: [Collection] {
        treeService.smartCollections
    }

    var body: some View {
        // Compute once per body — calling liveSmartCollectionMembers() per row
        // rescans all Task occurrences and pegs the main thread (~100% CPU).
        let liveMembers = taskService.liveSmartCollectionMembers()

        DashboardCard(id: .collectionOverview, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            HStack(alignment: .top, spacing: FaloSpacing.large) {
                column(
                    title: "Collections",
                    collections: collections,
                    liveMembers: liveMembers,
                    emptyText: "No collections yet."
                )

                column(
                    title: "Smart Collections",
                    collections: smartCollections,
                    liveMembers: liveMembers,
                    emptyText: "No smart collections."
                )
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    private func column(
        title: String,
        collections: [Collection],
        liveMembers: SmartCollectionLiveMembers,
        emptyText: String
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            DashboardCardSectionLabel(title: title)

            if collections.isEmpty {
                DashboardEmptyMessage(text: emptyText)
            } else {
                ForEach(collections.prefix(rowLimit)) { collection in
                    DashboardCardTapButton {
                        openCollection(collection.id)
                    } label: {
                        DashboardMetricRow(
                            title: collection.name,
                            value: "\(memberCount(for: collection, liveMembers: liveMembers))",
                            systemImage: collection.icon,
                            compact: true
                        )
                    }
                }

                let extra = collections.count - rowLimit
                if extra > 0 {
                    Text("\(extra) more in Garden")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    /// Same membership resolution as ``CollectionsView`` / Collection detail.
    private func memberCount(
        for collection: Collection,
        liveMembers: SmartCollectionLiveMembers
    ) -> Int {
        treeService.treeCount(
            inCollection: collection.id,
            disposalMethods: referenceData.disposalMethods,
            liveMembers: liveMembers
        )
    }

    private func openCollection(_ id: UUID) {
        appState.showCollection(id)
    }
}
