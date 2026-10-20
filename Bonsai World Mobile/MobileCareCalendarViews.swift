//
//  MobileCareCalendarViews.swift
//  Bonsai World
//
//  Knowledge → Care Calendar. Same months as Mac, from the default Garden.
//

import SwiftUI

struct MobileCareCalendarListView: View {
    @Environment(DemoLibrary.self) private var library

    private var garden: Garden? { library.defaultGarden }

    private var entries: [CareCalendarEntry] {
        CareCalendarKnowledge.entries(
            hemisphere: garden?.hemisphere,
            season: garden?.season
        )
    }

    var body: some View {
        List(entries) { entry in
            NavigationLink(value: MobileRoute.careCalendarEntry(entry.id)) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    Text(entry.subtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .lineLimit(2)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(CareCalendarKnowledge.pageTitle)
        .safeAreaInset(edge: .bottom) {
            Text(contextLine)
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(FaloSpacing.medium)
                .background(BonsaiWorldColors.canvas)
        }
    }

    private var contextLine: String {
        CareCalendarKnowledge.contextLine(
            gardenName: garden?.name,
            hemisphere: garden?.hemisphere,
            season: garden?.season
        )
    }
}

struct MobileCareCalendarEntryView: View {
    @Environment(DemoLibrary.self) private var library

    let entryID: String

    private var garden: Garden? { library.defaultGarden }

    private var entry: CareCalendarEntry? {
        CareCalendarKnowledge.entries(
            hemisphere: garden?.hemisphere,
            season: garden?.season
        ).first { $0.id == entryID }
    }

    var body: some View {
        Group {
            if let entry {
                ScrollView {
                    VStack(alignment: .leading, spacing: FaloSpacing.large) {
                        Text(entry.subtitle)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        Text(CareCalendarKnowledge.contextLine(
                            gardenName: garden?.name,
                            hemisphere: garden?.hemisphere,
                            season: garden?.season
                        ))
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        Text(CareCalendarKnowledge.disclaimer)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        if entry.continues {
                            Text("This phase started earlier. It is still the reading for this month.")
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        }
                        if let note = CareCalendarKnowledge.seasonNote(
                            season: garden?.season,
                            chapters: entry.chapters
                        ) {
                            Text(note)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                        ForEach(entry.chapters) { chapter in
                            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                                Text(chapter.phase)
                                    .font(FaloTypography.headline)
                                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                                ForEach(chapter.tasks) { group in
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(group.title)
                                            .font(FaloTypography.caption.weight(.semibold))
                                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                                        Text(group.line)
                                            .font(FaloTypography.body)
                                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                                    }
                                    .accessibilityElement(children: .combine)
                                }
                                if !chapter.note.isEmpty {
                                    Text(chapter.note)
                                        .font(FaloTypography.body)
                                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                                }
                            }
                        }
                    }
                    .padding(FaloSpacing.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(BonsaiWorldColors.canvas)
                .navigationTitle(entry.title)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView("Month not found", systemImage: "calendar")
            }
        }
    }
}
