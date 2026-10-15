//
//  SearchSheet.swift
//  Bonsai World
//
//  Quick Actions → Search. Records (Trees, Locations, Collections, Tasks,
//  Images) plus Places (sidebar routes, including unused modules).
//

import SwiftUI

struct SearchSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TaskService.self) private var taskService
    @Environment(ImageService.self) private var imageService
    @Environment(\.dismiss) private var dismiss

    @State private var query = ""

    private var sections: [LibrarySearchSection] {
        LibrarySearch.sections(
            query: query,
            treeService: treeService,
            referenceData: referenceData,
            taskService: taskService,
            imageService: imageService
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ContentUnavailableView(
                        "Search",
                        systemImage: "magnifyingglass",
                        description: Text("Trees, Locations, Collections, Tasks, Images, and Places.")
                    )
                } else if sections.isEmpty {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("Nothing matches “\(query)”.")
                    )
                } else {
                    List {
                        ForEach(sections) { section in
                            Section(section.title) {
                                ForEach(section.hits) { hit in
                                    Button {
                                        open(hit)
                                    } label: {
                                        hitRow(hit)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .faloScrollSurface()
                }
            }
            .searchable(text: $query, prompt: "Search")
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
        .frame(minWidth: 480, minHeight: 520)
    }

    @ViewBuilder
    private func hitRow(_ hit: LibrarySearchHit) -> some View {
        switch hit {
        case .tree(let id):
            if let tree = treeService.getTree(id: id) {
                HStack(spacing: FaloSpacing.medium) {
                    TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(TreePresentation.registryName(for: tree))
                            .foregroundStyle(.primary)
                        Text(treeSubtitle(tree))
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
        case .location(let id):
            if let location = referenceData.location(id: id) {
                labeledRow(title: location.name, detail: location.locationDescription)
            }
        case .collection(let id):
            if let collection = treeService.collection(id: id) {
                labeledRow(title: collection.name, detail: collectionGroupName(collection))
            }
        case .task(let occurrenceID, let horizon):
            if let occurrence = taskOccurrence(id: occurrenceID, horizon: horizon) {
                let workName = taskService.workType(id: occurrence.workTypeID)?.name ?? "Task"
                let treeName: String = {
                    if occurrence.libraryInventoryKind == .soilStocktake { return "Soil" }
                    guard let treeID = occurrence.treeID else { return "" }
                    return treeService.getTree(id: treeID)?.bonsaiName ?? ""
                }()
                labeledRow(
                    title: occurrence.title,
                    detail: [workName, treeName, horizon.title].filter { !$0.isEmpty }.joined(separator: " · ")
                )
            }
        case .image(let id):
            HStack(spacing: FaloSpacing.medium) {
                TreeListThumbnail(imageID: id, imageService: imageService)
                Text(imageService.photoName(for: id))
                    .foregroundStyle(.primary)
            }
        case .place(let route):
            labeledRow(title: route.title, detail: route.module.title)
        }
    }

    private func labeledRow(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .foregroundStyle(.primary)
            if !detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(detail)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    private func treeSubtitle(_ tree: Tree) -> String {
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        let group = tree.isInCare ? "My Trees" : "Former Trees"
        if botanical.isEmpty { return group }
        return "\(botanical) · \(group)"
    }

    private func collectionGroupName(_ collection: Collection) -> String {
        if SystemSmartCollections.lifecycleOutcome(for: collection.id) != nil {
            return "Former Trees"
        }
        return collection.isSmart ? "Smart Collections" : "My Collections"
    }

    private func taskOccurrence(id: String, horizon: TasksHorizon) -> TaskOccurrence? {
        taskService.pendingOccurrences(due: horizon).first { $0.id == id }
    }

    private func open(_ hit: LibrarySearchHit) {
        switch hit {
        case .tree(let id):
            appState.showTreeFromMap(treeID: id)
        case .location(let id):
            appState.selectedLocationID = id
            appState.selectSection(.locationsPlaces)
        case .collection(let id):
            appState.selectedCollectionID = id
            appState.lastOpenedCollectionID = id
            appState.selectSection(.gardenCollections)
        case .task(_, let horizon):
            appState.selectSection(AppRoute(tasksHorizon: horizon))
        case .image(let id):
            appState.selectedMediaImageID = id
            appState.selectSection(.mediaImages)
        case .place(let route):
            appState.selectSection(route)
        }
        dismiss()
    }
}
