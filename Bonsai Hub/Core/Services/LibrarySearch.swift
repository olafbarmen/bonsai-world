//
//  LibrarySearch.swift
//  Bonsai World
//
//  Quick Actions → Search. Records first, then Places (sidebar routes).
//

import Foundation

@MainActor
enum LibrarySearch {
    private static let rowLimit = 8

    static func sections(
        query: String,
        treeService: TreeService,
        referenceData: ReferenceDataService,
        taskService: TaskService,
        imageService: ImageService
    ) -> [LibrarySearchSection] {
        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return [] }

        var sections: [LibrarySearchSection] = []
        append(&sections, title: "Trees", hits: trees(needle, treeService: treeService))
        append(&sections, title: "Locations", hits: locations(needle, referenceData: referenceData))
        append(&sections, title: "Collections", hits: collections(needle, treeService: treeService))
        append(&sections, title: "Tasks", hits: tasks(needle, taskService: taskService))
        append(&sections, title: "Images", hits: images(needle, imageService: imageService))
        append(&sections, title: "Places", hits: places(needle))
        return sections
    }

    private static func append(
        _ sections: inout [LibrarySearchSection],
        title: String,
        hits: [LibrarySearchHit]
    ) {
        guard !hits.isEmpty else { return }
        sections.append(LibrarySearchSection(title: title, hits: hits))
    }

    private static func matches(_ value: String, needle: String) -> Bool {
        value.localizedStandardContains(needle)
    }

    private static func trees(_ needle: String, treeService: TreeService) -> [LibrarySearchHit] {
        treeService.trees
            .filter { tree in
                matches(tree.bonsaiName, needle: needle)
                    || matches(tree.botanicalName, needle: needle)
                    || matches(tree.nickname, needle: needle)
                    || matches(tree.notes, needle: needle)
            }
            .sorted { $0.bonsaiName.localizedStandardCompare($1.bonsaiName) == .orderedAscending }
            .prefix(rowLimit)
            .map { .tree($0.id) }
    }

    private static func locations(
        _ needle: String,
        referenceData: ReferenceDataService
    ) -> [LibrarySearchHit] {
        referenceData.locations
            .filter { location in
                matches(location.name, needle: needle)
                    || matches(location.locationDescription, needle: needle)
                    || matches(location.notes, needle: needle)
            }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
            .prefix(rowLimit)
            .map { .location($0.id) }
    }

    private static func collections(_ needle: String, treeService: TreeService) -> [LibrarySearchHit] {
        treeService.collections
            .filter { collection in
                matches(collection.name, needle: needle)
                    || matches(collection.description, needle: needle)
            }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
            .prefix(rowLimit)
            .map { .collection($0.id) }
    }

    private static func tasks(_ needle: String, taskService: TaskService) -> [LibrarySearchHit] {
        var seen: Set<String> = []
        var hits: [LibrarySearchHit] = []
        for horizon in TasksHorizon.allCases {
            for occurrence in taskService.pendingOccurrences(due: horizon) {
                guard seen.insert(occurrence.id).inserted else { continue }
                let workName = taskService.workType(id: occurrence.workTypeID)?.name ?? ""
                guard matches(occurrence.title, needle: needle) || matches(workName, needle: needle) else {
                    continue
                }
                hits.append(.task(occurrenceID: occurrence.id, horizon: horizon))
                if hits.count == rowLimit { return hits }
            }
        }
        return hits
    }

    private static func images(_ needle: String, imageService: ImageService) -> [LibrarySearchHit] {
        imageService.allAssets()
            .filter { matches($0.photoName, needle: needle) }
            .sorted { $0.photoName.localizedStandardCompare($1.photoName) == .orderedAscending }
            .prefix(rowLimit)
            .map { .image($0.id) }
    }

    private static func places(_ needle: String) -> [LibrarySearchHit] {
        let searchable = AppRoute.allCases.filter {
            $0.isShippedInNavigation || $0.isSearchableWhileHidden
        }
        var hits: [LibrarySearchHit] = []
        var modulesCovered: Set<AppModule> = []

        for route in searchable where matches(route.title, needle: needle) {
            hits.append(.place(route))
            modulesCovered.insert(route.module)
            if hits.count == rowLimit { return hits }
        }

        let modulesForSearch = AppModule.workspaceModules + AppModule.toolsModules + [.social]
        for module in modulesForSearch {
            guard matches(module.title, needle: needle), !modulesCovered.contains(module) else {
                continue
            }
            hits.append(.place(module.defaultRoute))
            if hits.count == rowLimit { return hits }
        }
        return hits
    }
}
