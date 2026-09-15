//
//  PruningKnowledgeView.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Pruning chapter body.
//

import SwiftUI

struct PruningKnowledgeView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedLessonID: String?

    var body: some View {
        HSplitView {
            List(PruningKnowledge.lessons, selection: $selectedLessonID) { lesson in
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
                if let id = selectedLessonID, let lesson = PruningKnowledge.lesson(id: id) {
                    PruningKnowledgeLessonView(lesson: lesson)
                } else {
                    ContentUnavailableView(
                        PruningKnowledge.chapterTitle,
                        systemImage: "scissors",
                        description: Text(PruningKnowledge.openingLine)
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
            selectedLessonID = PruningKnowledge.lessons.first?.id
        }
    }

    private func applyPending() -> Bool {
        guard case .pruning(let id) = appState.pendingHandbookTopic else { return false }
        selectedLessonID = id
        appState.clearPendingHandbookTopic()
        return true
    }
}

struct PruningKnowledgeLessonView: View {
    let lesson: PruningKnowledgeLesson

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(String(format: "%02d — %@", lesson.number, lesson.title))
                        .font(FaloTypography.headline)
                        .accessibilityAddTraits(.isHeader)
                    Text(lesson.summary)
                        .font(FaloTypography.body)
                    Text(PruningKnowledge.disclaimer)
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
    PruningKnowledgeView()
        .environment(AppState())
        .frame(width: 980, height: 860)
}
