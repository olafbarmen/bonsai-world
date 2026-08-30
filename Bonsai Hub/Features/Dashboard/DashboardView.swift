//
//  DashboardView.swift
//  Bonsai World
//
//  Dashboard layout — two independent vertical stacks (not a row grid).
//  Each column is a VStack with ``DashboardSpacing/cardGap`` between cards.
//

import SwiftUI

struct DashboardView: View {
    var identity: DashboardIdentity = DashboardPlaceholderData.identity
    var layout: DashboardLayout = DashboardPlaceholderData.layout

    var body: some View {
        FaloAdaptiveDesktopWorkspace(profile: .dashboard) {
            DashboardAdaptiveContent(identity: identity, layout: layout)
        }
        .background(.windowBackground)
        .navigationTitle("Dashboard")
    }
}

// MARK: - Adaptive content

private struct DashboardAdaptiveContent: View {
    @Environment(\.faloAdaptiveContentWidth) private var contentWidth

    let identity: DashboardIdentity
    let layout: DashboardLayout

    private var dashboardColumnWidth: CGFloat {
        FaloGridMetrics.columnWidth(
            columns: 2,
            in: contentWidth,
            gap: DashboardSpacing.cardGap
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.cardGap) {
            DashboardHeaderView(identity: identity)

            CollectionSummaryHeroCard()

            HStack(alignment: .top, spacing: DashboardSpacing.cardGap) {
                columnStack(cards: leftColumnCards)
                    .frame(width: dashboardColumnWidth, alignment: .topLeading)
                columnStack(cards: rightColumnCards)
                    .frame(width: dashboardColumnWidth, alignment: .topLeading)
            }
            .frame(width: contentWidth, alignment: .topLeading)
        }
    }

    /// Even indices → left column (Tasks, …).
    private var leftColumnCards: [DashboardCardPlacement] {
        layout.visibleCards.enumerated().compactMap { index, card in
            index.isMultiple(of: 2) ? card : nil
        }
    }

    /// Odd indices → right column (Weather, …).
    private var rightColumnCards: [DashboardCardPlacement] {
        layout.visibleCards.enumerated().compactMap { index, card in
            index.isMultiple(of: 2) ? nil : card
        }
    }

    private func columnStack(cards: [DashboardCardPlacement]) -> some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.cardGap) {
            ForEach(cards) { placement in
                cardView(for: placement)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .id(placement.id)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    private func cardView(for placement: DashboardCardPlacement) -> some View {
        switch placement.id {
        case .tasks:
            TasksDashboardCard(prominence: placement.prominence)
        case .todaysCare:
            TodaysCareDashboardCard(prominence: placement.prominence)
        case .alerts:
            AlertsDashboardCard(prominence: placement.prominence)
        case .collectionOverview:
            CollectionOverviewDashboardCard(prominence: placement.prominence)
        case .upcoming:
            UpcomingDashboardCard(prominence: placement.prominence)
        case .inventoryStatus:
            InventoryStatusDashboardCard(prominence: placement.prominence)
        case .repotting:
            RepottingDashboardCard(prominence: placement.prominence)
        case .treesRequiringAttention:
            TreesAttentionDashboardCard(prominence: placement.prominence)
        case .weather:
            WeatherDashboardCard()
        case .quickStatistics:
            QuickStatisticsDashboardCard(prominence: placement.prominence)
        case .library:
            LibraryDashboardCard(prominence: placement.prominence)
        case .recentWork:
            RecentWorkDashboardCard(prominence: placement.prominence)
        }
    }
}

#Preview {
    let preview = PreviewData()
    let referenceStore = ReferencePreviewData()
    let profile = UserProfileStore()
    let treeService = TreeService.preview(previewData: preview)
    let referenceData = ReferenceDataService(previewData: referenceStore)
    let workService = WorkService(referenceData: referenceData)
    let botanical = BotanicalService(store: referenceStore)
    let taskService = TaskService(
        referenceData: referenceData,
        workService: workService,
        treeService: treeService,
        botanicalService: botanical
    )
    return NavigationStack {
        DashboardView()
    }
    .environment(treeService)
    .environment(referenceData)
    .environment(AppSettings())
    .environment(profile)
    .environment(WeatherService(profile: profile))
    .environment(taskService)
    .environment(workService)
    .environment(AppState())
    .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
    .frame(width: 1100, height: 920)
}
