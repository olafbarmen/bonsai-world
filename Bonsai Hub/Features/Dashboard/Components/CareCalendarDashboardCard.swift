//
//  CareCalendarDashboardCard.swift
//  Bonsai World
//
//  Dashboard — this month's Care Calendar on the default Garden.
//  Title is Care Calendar. The line under it is the phase.
//

import SwiftUI

struct CareCalendarDashboardCard: View {
    var fillsRowHeight: Bool = false

    @Environment(UserProfileStore.self) private var profile
    @Environment(AppState.self) private var appState

    private var garden: Garden? { profile.defaultGarden }

    private var entry: CareCalendarEntry? {
        CareCalendarKnowledge.entry(
            on: .now,
            hemisphere: garden?.hemisphere,
            season: garden?.season
        )
    }

    private var phase: String {
        entry?.subtitle ?? ""
    }

    var body: some View {
        DashboardCard(
            id: .careCalendar,
            prominence: .primary,
            fillsRowHeight: fillsRowHeight,
            compact: true,
            showsHeader: false
        ) {
            DashboardCardTapButton {
                appState.selectSection(.knowledgeCareCalendar)
            } label: {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text(CareCalendarKnowledge.pageTitle)
                            .font(FaloTypography.sectionHeading)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        if !phase.isEmpty {
                            Text(phase)
                                .font(FaloTypography.headline)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                    }

                    if let entry {
                        reading(for: entry)
                    } else {
                        Text(contextLine)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
    }

    private var accessibilityLabel: String {
        if phase.isEmpty {
            return CareCalendarKnowledge.pageTitle
        }
        return "\(CareCalendarKnowledge.pageTitle), \(phase)"
    }

    private var contextLine: String {
        CareCalendarKnowledge.contextLine(
            gardenName: garden?.name,
            hemisphere: garden?.hemisphere,
            season: garden?.season
        )
    }

    @ViewBuilder
    private func reading(for entry: CareCalendarEntry) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            if garden?.hemisphere == nil || garden?.season == nil {
                Text(contextLine)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            ForEach(entry.chapters) { chapter in
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    if entry.chapters.count > 1 {
                        Text(chapter.phase)
                            .font(FaloTypography.caption.weight(.semibold))
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                    taskLines(chapter.tasks)
                }
            }

            if let note = CareCalendarKnowledge.seasonNote(season: garden?.season, chapters: entry.chapters) {
                Text(note)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func taskLines(_ tasks: [CareCalendarTaskGroup]) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            ForEach(tasks) { group in
                HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.medium) {
                    Text(group.title)
                        .font(FaloTypography.caption.weight(.semibold))
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .frame(width: 96, alignment: .leading)
                    Text(group.line)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}
