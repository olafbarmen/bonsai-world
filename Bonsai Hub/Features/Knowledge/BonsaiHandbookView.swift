//
//  BonsaiHandbookView.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook — chapter list + chapter content.
//  Every chapter uses the same pattern: section/lesson list → detail.
//

import SwiftUI

struct BonsaiHandbookView: View {
    @Environment(AppState.self) private var appState
    @State private var searchText = ""

    private var trimmedSearch: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var searchHits: [HandbookSearchHit] {
        HandbookSearch.hits(matching: trimmedSearch)
    }

    var body: some View {
        HSplitView {
            chapterColumn
                .frame(minWidth: 200, idealWidth: 240, maxWidth: 320)
            chapterDetail
                .frame(minWidth: 400)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Bonsai Handbook")
    }

    private var chapterColumn: some View {
        VStack(spacing: 0) {
            HStack(spacing: FaloSpacing.small) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(.horizontal, FaloSpacing.medium)
            .padding(.vertical, FaloSpacing.small)

            if trimmedSearch.isEmpty {
                chapterNavigationList
            } else if searchHits.isEmpty {
                ContentUnavailableView(
                    "No handbook topics match that search.",
                    systemImage: "magnifyingglass"
                )
            } else {
                searchResultsList
            }
        }
        .faloScrollSurface()
    }

    private var chapterNavigationList: some View {
        List(selection: Binding(
            get: { appState.selectedHandbookChapter },
            set: { appState.selectedHandbookChapter = $0 ?? .designGuidelines }
        )) {
            Section("Chapters") {
                ForEach(BonsaiHandbookChapter.allCases) { chapter in
                    Label(chapter.title, systemImage: chapter.systemImage)
                        .tag(chapter)
                }
            }
        }
        .listStyle(.sidebar)
    }

    private var searchResultsList: some View {
        List(searchHits) { hit in
            Button {
                appState.openHandbookTopic(hit.topic)
                searchText = ""
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(hit.numberedTitle)
                        .font(FaloCardTypography.fieldValue)
                    Text(hit.chapterTitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, FaloSpacing.xSmall)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .listStyle(.sidebar)
    }

    @ViewBuilder
    private var chapterDetail: some View {
        switch appState.selectedHandbookChapter {
        case .designGuidelines:
            DesignGuidelinesChapterView()
        case .formsStyles:
            FormsStylesKnowledgeView()
        case .artistry:
            ArtistryKnowledgeView()
        case .material:
            MaterialKnowledgeView()
        case .pruning:
            PruningKnowledgeView()
        case .wiring:
            WiringKnowledgeView()
        case .repotting:
            RepottingKnowledgeView()
        case .watering:
            WateringKnowledgeView()
        case .potGuidelines:
            PotGuidelinesView()
        case .airPruning:
            AirPruningKnowledgeView()
        case .display:
            DisplayKnowledgeView()
        case .soilGuides:
            SoilKnowledgeView()
        case .fertilizing:
            FertilizingKnowledgeView()
        case .propagation:
            PropagationKnowledgeView()
        case .airLayering:
            AirLayeringKnowledgeView()
        case .tools:
            ToolsKnowledgeView()
        case .deadwood:
            DeadwoodKnowledgeView()
        case .advancedTechniques:
            AdvancedTechniquesKnowledgeView()
        case .collectionManagement:
            CollectionManagementKnowledgeView()
        case .treeHealth:
            TreeHealthKnowledgeView()
        case .seasonalCare:
            SeasonalCareKnowledgeView()
        }
    }
}

/// Design Guidelines — section list (column 2) + section detail (column 3).
private struct DesignGuidelinesChapterView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedItem: DesignGuidelinesListItem?

    var body: some View {
        HSplitView {
            List(selection: $selectedItem) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(handbookNumberedTitle(1, "Introduction"))
                        .font(FaloCardTypography.fieldValue)
                    Text("Guidelines, not laws — a check, not a recipe.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, FaloSpacing.xSmall)
                .tag(DesignGuidelinesListItem.introduction)

                ForEach(Array(DesignGuidelines.entries.enumerated()), id: \.element.section) { index, entry in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(handbookNumberedTitle(index + 2, entry.section.title))
                            .font(FaloCardTypography.fieldValue)
                        Text(entry.excerpt)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                    .tag(DesignGuidelinesListItem.section(entry.section))
                }
            }
            .faloScrollSurface()
            .frame(minWidth: 240, idealWidth: 300)

            Group {
                switch selectedItem {
                case .introduction:
                    DesignGuidelinesIntroductionView()
                case .section(let section):
                    DesignGuidelinesSectionDetailView(entry: DesignGuidelines.entry(for: section))
                case nil:
                    ContentUnavailableView(
                        DesignGuidelines.chapterTitle,
                        systemImage: "triangle",
                        description: Text(DesignGuidelines.introduction.first ?? "Choose a section.")
                    )
                }
            }
            .frame(minWidth: 400)
        }
        .onAppear {
            applyPendingOrDefaultSelection()
        }
        .onChange(of: appState.pendingHandbookTopic) { _, _ in
            applyPendingOrDefaultSelection()
        }
    }

    private func applyPendingOrDefaultSelection() {
        if applyPendingTopic() { return }
        if selectedItem == nil {
            selectedItem = .introduction
        }
    }

    private func applyPendingTopic() -> Bool {
        guard let topic = appState.pendingHandbookTopic else { return false }
        switch topic {
        case .designIntroduction:
            selectedItem = .introduction
        case .design(let section):
            selectedItem = .section(section)
        default:
            return false
        }
        appState.clearPendingHandbookTopic()
        return true
    }
}

private enum DesignGuidelinesListItem: Hashable {
    case introduction
    case section(DesignGuidelineSection)
}

private struct DesignGuidelinesIntroductionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                Text(handbookNumberedTitle(1, "Introduction"))
                    .font(FaloTypography.headline)
                    .accessibilityAddTraits(.isHeader)

                DetailCard(title: "Introduction") {
                    ForEach(Array(DesignGuidelines.introduction.enumerated()), id: \.offset) { _, paragraph in
                        Text(paragraph)
                            .font(FaloTypography.body)
                            .padding(.bottom, FaloSpacing.xSmall)
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

private struct DesignGuidelinesSectionDetailView: View {
    let entry: DesignGuidelineEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(handbookNumberedTitle(designGuidelineNumber(entry.section), entry.section.title))
                        .font(FaloTypography.headline)
                        .accessibilityAddTraits(.isHeader)
                    Text(entry.excerpt)
                        .font(FaloTypography.body)
                }

                DetailCard(title: entry.section.title) {
                    ForEach(Array(entry.paragraphs.enumerated()), id: \.offset) { _, paragraph in
                        Text(paragraph)
                            .font(FaloTypography.body)
                            .padding(.bottom, FaloSpacing.xSmall)
                    }

                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text("On the tree")
                            .font(FaloCardTypography.fieldLabel)
                            .foregroundStyle(.secondary)
                        Text(entry.onTheTree)
                            .font(FaloTypography.body)
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                    .accessibilityElement(children: .combine)
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

private func handbookNumberedTitle(_ number: Int, _ title: String) -> String {
    String(format: "%02d — %@", number, title)
}

private func designGuidelineNumber(_ section: DesignGuidelineSection) -> Int {
    (DesignGuidelineSection.allCases.firstIndex(of: section) ?? 0) + 2
}

#Preview {
    BonsaiHandbookView()
        .environment(AppState())
}
