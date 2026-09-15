//
//  AirLayeringKnowledgeView.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Air Layering chapter body.
//

import SwiftUI

struct AirLayeringKnowledgeView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedLessonID: String?

    var body: some View {
        HSplitView {
            List(AirLayeringKnowledge.lessons, selection: $selectedLessonID) { lesson in
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: "%02d — %@", lesson.number, lesson.title))
                        .font(FaloCardTypography.fieldValue)
                    Text(lesson.summary)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, FaloSpacing.xSmall)
                .tag(lesson.id)
            }
            .faloScrollSurface()
            .frame(minWidth: 240, idealWidth: 300)

            Group {
                if let id = selectedLessonID, let lesson = AirLayeringKnowledge.lesson(id: id) {
                    AirLayeringKnowledgeLessonView(lesson: lesson)
                } else {
                    ContentUnavailableView(
                        "Air layering — from existing tree to independent bonsai",
                        systemImage: "arrow.triangle.branch",
                        description: Text(AirLayeringKnowledge.openingLine)
                    )
                }
            }
            .frame(minWidth: 400)
        }
        .onAppear {
            applyPendingOrDefault()
        }
        .onChange(of: appState.pendingHandbookTopic) { _, _ in
            applyPendingOrDefault()
        }
    }

    private func applyPendingOrDefault() {
        if applyPending() { return }
        if selectedLessonID == nil {
            selectedLessonID = AirLayeringKnowledge.lessons.first?.id
        }
    }

    private func applyPending() -> Bool {
        guard case .airLayering(let id) = appState.pendingHandbookTopic else { return false }
        selectedLessonID = id
        appState.clearPendingHandbookTopic()
        return true
    }
}

struct AirLayeringKnowledgeLessonView: View {
    let lesson: AirLayeringKnowledgeLesson

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(String(format: "%02d — %@", lesson.number, lesson.title))
                        .font(FaloTypography.headline)
                        .accessibilityAddTraits(.isHeader)
                    Text(lesson.summary)
                        .font(FaloTypography.body)
                    Text(AirLayeringKnowledge.disclaimer)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                ForEach(lesson.sections) { section in
                    DetailCard(title: section.heading) {
                        ForEach(section.paragraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(FaloTypography.body)
                                .padding(.bottom, FaloSpacing.xSmall)
                        }
                        if !section.bullets.isEmpty {
                            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                                ForEach(section.bullets, id: \.self) { bullet in
                                    Text("• \(bullet)")
                                        .font(FaloTypography.body)
                                }
                            }
                            .padding(.bottom, FaloSpacing.xSmall)
                        }
                        ForEach(section.callouts) { callout in
                            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                                Text(callout.title)
                                    .font(FaloCardTypography.fieldLabel)
                                    .foregroundStyle(.secondary)
                                Text(callout.body)
                                    .font(FaloTypography.body)
                            }
                            .padding(.vertical, FaloSpacing.xSmall)
                            .accessibilityElement(children: .combine)
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
