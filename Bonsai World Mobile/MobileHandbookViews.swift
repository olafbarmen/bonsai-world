//
//  MobileHandbookViews.swift
//  Bonsai World
//

import SwiftUI

struct MobileHandbookChapterListView: View {
    @State private var searchText = ""

    private var trimmedSearch: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var searchHits: [HandbookSearchHit] {
        HandbookSearch.hits(matching: trimmedSearch)
    }

    var body: some View {
        List {
            if trimmedSearch.isEmpty {
                Section("Chapters") {
                    ForEach(BonsaiHandbookChapter.allCases) { chapter in
                        NavigationLink(value: MobileRoute.handbookChapter(chapter)) {
                            Label(chapter.title, systemImage: chapter.systemImage)
                        }
                    }
                }
            } else if searchHits.isEmpty {
                ContentUnavailableView(
                    "No handbook topics match that search.",
                    systemImage: "magnifyingglass"
                )
            } else {
                ForEach(searchHits) { hit in
                    NavigationLink(
                        value: MobileRoute.handbookLesson(
                            hit.topic.chapter,
                            MobileHandbookCatalog.lessonID(for: hit.topic)
                        )
                    ) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(hit.numberedTitle)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                            Text(hit.chapterTitle)
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText, prompt: "Search")
        .navigationTitle("Bonsai Handbook")
    }
}

struct MobileHandbookLessonListView: View {
    let chapter: BonsaiHandbookChapter

    private var lessons: [MobileHandbookLesson] {
        MobileHandbookCatalog.lessons(for: chapter)
    }

    var body: some View {
        List(lessons) { lesson in
            NavigationLink(value: MobileRoute.handbookLesson(chapter, lesson.id)) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(lesson.numberedTitle)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    if !lesson.summary.isEmpty {
                        Text(lesson.summary)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                            .lineLimit(2)
                    }
                }
                .padding(.vertical, FaloSpacing.xSmall)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(chapter.title)
    }
}

struct MobileHandbookLessonView: View {
    let chapter: BonsaiHandbookChapter
    let lessonID: String

    private var lesson: MobileHandbookLesson? {
        MobileHandbookCatalog.lesson(chapter: chapter, id: lessonID)
    }

    var body: some View {
        Group {
            if let lesson {
                ScrollView {
                    VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                        Text(lesson.numberedTitle)
                            .font(FaloTypography.pageTitle)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                            .accessibilityAddTraits(.isHeader)

                        if !lesson.summary.isEmpty {
                            Text(lesson.summary)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        }

                        ForEach(lesson.sections) { section in
                            sectionBlock(section)
                        }
                    }
                    .padding(FaloSpacing.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .navigationTitle(lesson.title)
            } else {
                ContentUnavailableView("Lesson not found", systemImage: "book.closed")
                    .navigationTitle(chapter.title)
            }
        }
    }

    private func sectionBlock(_ section: MobileHandbookSection) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            if section.heading != lesson?.title {
                Text(section.heading)
                    .font(FaloTypography.sectionHeading)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
            }
            ForEach(section.paragraphs, id: \.self) { paragraph in
                Text(paragraph)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
            }
            ForEach(section.bullets, id: \.self) { bullet in
                Text("· \(bullet)")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
            }
            ForEach(section.callouts) { callout in
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text(callout.title)
                        .font(FaloTypography.sectionHeading)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    Text(callout.body)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }
                .padding(FaloSpacing.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(BonsaiWorldColors.surface, in: RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous))
            }
        }
    }
}
