//
//  WateringKnowledgeView.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Watering chapter body.
//

import SwiftUI

struct WateringKnowledgeView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedLessonID: String?

    var body: some View {
        HSplitView {
            List(WateringKnowledge.lessons, selection: $selectedLessonID) { lesson in
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
                if let id = selectedLessonID, let lesson = WateringKnowledge.lesson(id: id) {
                    WateringKnowledgeLessonView(lesson: lesson)
                } else {
                    ContentUnavailableView(
                        WateringKnowledge.chapterTitle,
                        systemImage: "drop",
                        description: Text(WateringKnowledge.openingLine)
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
            selectedLessonID = WateringKnowledge.lessons.first?.id
        }
    }

    private func applyPending() -> Bool {
        guard case .watering(let id) = appState.pendingHandbookTopic else { return false }
        selectedLessonID = id
        appState.clearPendingHandbookTopic()
        return true
    }
}

struct WateringKnowledgeLessonView: View {
    let lesson: WateringKnowledgeLesson

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(String(format: "%02d — %@", lesson.number, lesson.title))
                        .font(FaloTypography.headline)
                        .accessibilityAddTraits(.isHeader)
                    Text(lesson.summary)
                        .font(FaloTypography.body)
                    Text(WateringKnowledge.disclaimer)
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

#Preview {
    WateringKnowledgeView()
        .environment(AppState())
        .frame(width: 980, height: 860)
}
