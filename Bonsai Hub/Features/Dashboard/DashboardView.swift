//
//  DashboardView.swift
//  Bonsai World
//
//  Dashboard — 4-column grid matching StatStrip column width.
//  Sticky greeting + header weather stay fixed; only the white cards scroll
//  (vertical always, horizontal when the window is narrower than content).
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.faloShellProvidesLeadingInset) private var shellProvidesLeadingInset

    private var profile: FaloAdaptiveWorkspaceProfile { .dashboard }

    var body: some View {
        GeometryReader { geometry in
            let pageInset = profile.pageInset
            let leadingInset = shellProvidesLeadingInset ? 0 : pageInset
            let trailingInset = shellProvidesLeadingInset ? 0 : pageInset
            let horizontalChrome = leadingInset + trailingInset
            let innerAvailable = max(0, geometry.size.width - horizontalChrome)
            let contentWidth = profile.locksContentToMinimumWidth
                ? profile.minimumContentWidth
                : max(profile.minimumContentWidth, innerAvailable)
            let needsHorizontalScroll = innerAvailable < contentWidth

            VStack(alignment: .leading, spacing: 0) {
                stickyHeader(leadingInset: leadingInset, trailingInset: trailingInset, pageInset: pageInset)

                ScrollView(.vertical, showsIndicators: true) {
                    Group {
                        if needsHorizontalScroll {
                            ScrollView(.horizontal, showsIndicators: true) {
                                cardStack(contentWidth: contentWidth)
                                    .padding(.leading, leadingInset)
                                    .padding(.trailing, trailingInset)
                                    .padding(.bottom, pageInset)
                            }
                        } else {
                            cardStack(contentWidth: contentWidth)
                                .padding(.leading, leadingInset)
                                .padding(.trailing, trailingInset)
                                .padding(.bottom, pageInset)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .faloScrollSurface()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BonsaiWorldColors.canvas)
        .bonsaiWorkspaceNavigationTitle("Dashboard")
    }

    /// Greeting + compact weather stay in the visible viewport (not in card scroll).
    private func stickyHeader(leadingInset: CGFloat, trailingInset: CGFloat, pageInset: CGFloat) -> some View {
        DashboardHeaderView()
            .padding(.leading, leadingInset)
            .padding(.trailing, trailingInset)
            .padding(.top, pageInset)
            .padding(.bottom, DashboardSpacing.cardGap)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(BonsaiWorldColors.canvas)
    }

    private func cardStack(contentWidth: CGFloat) -> some View {
        DashboardAdaptiveContent()
            .environment(\.faloAdaptiveContentWidth, contentWidth)
            .frame(width: contentWidth, alignment: .topLeading)
    }
}

private struct DashboardAdaptiveContent: View {
    @Environment(\.faloAdaptiveContentWidth) private var contentWidth

    private let columns = 4
    private var gap: CGFloat { DashboardSpacing.cardGap }

    private var column: CGFloat {
        FaloGridMetrics.columnWidth(columns: columns, in: contentWidth, gap: gap)
    }

    private var span2: CGFloat {
        FaloGridMetrics.spanWidth(columnSpan: 2, columns: columns, in: contentWidth, gap: gap)
    }

    private var span4: CGFloat {
        FaloGridMetrics.spanWidth(columnSpan: 4, columns: columns, in: contentWidth, gap: gap)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: gap) {
            DashboardStatStrip()
                .frame(width: contentWidth, alignment: .topLeading)

            DashboardEqualHeightRow(spacing: gap) {
                TreesAttentionDashboardCard(fillsRowHeight: true)
                    .frame(width: span2)
                TasksDashboardCard(prominence: .primary, fillsRowHeight: true)
                    .frame(width: column)
                AlertsDashboardCard(prominence: .primary, fillsRowHeight: true)
                    .frame(width: column)
            }

            DashboardEqualHeightRow(spacing: gap) {
                WeatherDashboardCard(fillsRowHeight: true)
                    .frame(width: span2)
                UpcomingDashboardCard(prominence: .primary, fillsRowHeight: true)
                    .frame(width: column)
                LibraryDashboardCard(prominence: .secondary, fillsRowHeight: true)
                    .frame(width: column)
            }

            DashboardEqualHeightRow(spacing: gap) {
                CollectionOverviewDashboardCard(prominence: .secondary, fillsRowHeight: true)
                    .frame(width: span2)
                RecentWorkDashboardCard(prominence: .secondary, fillsRowHeight: true)
                    .frame(width: column)
                InventoryAlertsDashboardCard(prominence: .secondary, fillsRowHeight: true)
                    .frame(width: column)
            }

            DashboardEqualHeightRow(spacing: gap) {
                RepottingDashboardCard(prominence: .secondary, fillsRowHeight: true)
                    .frame(width: span2)
                QuickStatisticsDashboardCard(prominence: .secondary, fillsRowHeight: true)
                    .frame(width: span2)
            }

            DashboardEqualHeightRow(spacing: gap) {
                DashboardKnowledgeCard(fillsRowHeight: true)
                    .frame(width: span4)
            }
        }
        .frame(width: contentWidth, alignment: .topLeading)
    }
}

/// Lays out cards in a row at the tallest child’s height so chrome bottoms align.
private struct DashboardEqualHeightRow<Content: View>: View {
    var spacing: CGFloat
    @ViewBuilder var content: () -> Content

    var body: some View {
        FaloEqualHeightRow(spacing: spacing) {
            content()
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
    .frame(width: 1100, height: 900)
}
