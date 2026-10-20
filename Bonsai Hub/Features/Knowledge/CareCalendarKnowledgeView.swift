//
//  CareCalendarKnowledgeView.swift
//  Bonsai World
//
//  Knowledge → Care Calendar. Months follow the default Garden.
//

import SwiftUI

struct CareCalendarKnowledgeView: View {
    @Environment(UserProfileStore.self) private var profile
    @State private var selectedEntryID: String?

    private var garden: Garden? { profile.defaultGarden }

    private var entries: [CareCalendarEntry] {
        CareCalendarKnowledge.entries(
            hemisphere: garden?.hemisphere,
            season: garden?.season
        )
    }

    var body: some View {
        HSplitView {
            List(entries, selection: $selectedEntryID) { entry in
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title)
                        .font(FaloCardTypography.fieldValue)
                    Text(entry.subtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, FaloSpacing.xSmall)
                .tag(entry.id)
            }
            .faloScrollSurface()
            .frame(minWidth: 220, idealWidth: 280)

            Group {
                if let entry = entries.first(where: { $0.id == selectedEntryID }) {
                    CareCalendarEntryView(
                        entry: entry,
                        context: contextLine,
                        seasonNote: CareCalendarKnowledge.seasonNote(
                            season: garden?.season,
                            chapters: entry.chapters
                        )
                    )
                } else {
                    ContentUnavailableView(
                        CareCalendarKnowledge.pageTitle,
                        systemImage: "calendar",
                        description: Text(CareCalendarKnowledge.openingLine)
                    )
                }
            }
            .frame(minWidth: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle(CareCalendarKnowledge.pageTitle)
        .onAppear { selectCurrentEntryIfNeeded() }
        .onChange(of: garden?.hemisphere) { _, _ in selectCurrentEntryIfNeeded(force: true) }
        .onChange(of: garden?.season) { _, _ in selectCurrentEntryIfNeeded(force: true) }
    }

    private var contextLine: String {
        CareCalendarKnowledge.contextLine(
            gardenName: garden?.name,
            hemisphere: garden?.hemisphere,
            season: garden?.season
        )
    }

    private func selectCurrentEntryIfNeeded(force: Bool = false) {
        guard force || selectedEntryID == nil else { return }
        let month = Calendar.current.component(.month, from: .now)
        if let match = entries.first(where: { $0.id == "local-\(month)" }) {
            selectedEntryID = match.id
        } else {
            selectedEntryID = entries.first?.id
        }
    }
}

private struct CareCalendarEntryView: View {
    let entry: CareCalendarEntry
    let context: String
    let seasonNote: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(entry.title)
                        .font(FaloTypography.headline)
                        .accessibilityAddTraits(.isHeader)
                    Text(entry.subtitle)
                        .font(FaloTypography.body)
                    Text(context)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(CareCalendarKnowledge.disclaimer)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    if entry.continues {
                        Text("This phase started earlier. It is still the reading for this month.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    if let seasonNote {
                        Text(seasonNote)
                            .font(FaloTypography.body)
                    }
                }

                ForEach(entry.chapters) { chapter in
                    DetailCard(title: chapter.phase) {
                        CareCalendarTaskList(tasks: chapter.tasks)
                        if !chapter.note.isEmpty {
                            Text(chapter.note)
                                .font(FaloTypography.body)
                                .foregroundStyle(.secondary)
                                .padding(.top, FaloSpacing.small)
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .faloWorkspaceCanvas()
    }
}

private struct CareCalendarTaskList: View {
    let tasks: [CareCalendarTaskGroup]

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            ForEach(tasks) { group in
                HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.medium) {
                    Text(group.title)
                        .font(FaloTypography.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 96, alignment: .leading)
                    Text(group.line)
                        .font(FaloTypography.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}
