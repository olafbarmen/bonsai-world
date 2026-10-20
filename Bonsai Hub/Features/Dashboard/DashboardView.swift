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
        .background {
            ZStack(alignment: .topTrailing) {
                BonsaiWorldColors.canvas
                FaloBonsaiWash(width: 440)
                    .padding(.top, 8)
                    .padding(.trailing, 12)
            }
        }
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
    }

    private func cardStack(contentWidth: CGFloat) -> some View {
        DashboardAdaptiveContent()
            .environment(\.faloAdaptiveContentWidth, contentWidth)
            .frame(width: contentWidth, alignment: .topLeading)
    }
}

private struct DashboardAdaptiveContent: View {
    @Environment(\.faloAdaptiveContentWidth) private var contentWidth

    private var gap: CGFloat { DashboardSpacing.cardGap }

    private var columnWidth: CGFloat {
        FaloGridMetrics.columnWidth(columns: 2, in: contentWidth, gap: gap)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: gap) {
            DashboardStatStrip()
                .frame(width: contentWidth, alignment: .topLeading)

            row {
                CareCalendarDashboardCard(fillsRowHeight: true).frame(width: columnWidth)
                TasksDashboardCard(prominence: .primary, fillsRowHeight: true).frame(width: columnWidth)
            }
            row {
                TreesAttentionDashboardCard(fillsRowHeight: true).frame(width: columnWidth)
                AlertsDashboardCard(prominence: .primary, fillsRowHeight: true).frame(width: columnWidth)
            }
            row {
                WeatherDashboardCard(fillsRowHeight: true).frame(width: columnWidth)
                LibraryDashboardCard(fillsRowHeight: true).frame(width: columnWidth)
            }
            row {
                UpcomingDashboardCard(prominence: .secondary, fillsRowHeight: true).frame(width: columnWidth)
                InventoryAlertsDashboardCard(fillsRowHeight: true).frame(width: columnWidth)
            }
            row {
                ShapingInProgressDashboardCard(fillsRowHeight: true).frame(width: columnWidth)
                CollectionOverviewDashboardCard(fillsRowHeight: true).frame(width: columnWidth)
            }
            DashboardKnowledgeCard()
                .frame(width: contentWidth, alignment: .topLeading)
        }
        .frame(width: contentWidth, alignment: .topLeading)
    }

    private func row<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        FaloEqualHeightRow(spacing: gap) {
            content()
        }
        .frame(width: contentWidth, alignment: .topLeading)
    }
}

/// Falo mark, faded into the canvas at the top trailing corner.
private struct FaloBonsaiWash: View {
    var width: CGFloat

    var body: some View {
        Image("FaloBonsaiWash")
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .blendMode(.multiply)
            .opacity(0.88)
            .mask(
                RadialGradient(
                    colors: [.black, .black.opacity(0.45), .clear],
                    center: .center,
                    startRadius: width * 0.18,
                    endRadius: width * 0.52
                )
            )
            .allowsHitTesting(false)
            .accessibilityHidden(true)
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
