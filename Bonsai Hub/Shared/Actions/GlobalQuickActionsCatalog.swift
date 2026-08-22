//
//  GlobalQuickActionsCatalog.swift
//  Bonsai World
//
//  World-specific Global Quick Actions (always visible).
//  Consumed by QuickActionsView — do not hardcode these inside the view.
//

import Foundation

enum GlobalQuickActionsCatalog {
    static let newTreeID = "global.newTree"
    static let searchID = "global.search"
    static let importID = "global.import"

    /// Canonical global Quick Actions (sidebar order).
    static var actions: [ActionDefinition] {
        [
            ActionDefinition(
                id: newTreeID,
                title: "New Tree",
                systemImage: "leaf",
                availability: .available,
                help: "Add a tree to your collection"
            ),
            ActionDefinition(
                id: searchID,
                title: "Search",
                systemImage: "magnifyingglass",
                availability: .comingSoon,
                help: "Find trees, places, and notes"
            ),
            ActionDefinition(
                id: importID,
                title: "Import",
                systemImage: "square.and.arrow.down",
                availability: .comingSoon,
                help: "Bring data into Bonsai World"
            )
        ]
    }
}
