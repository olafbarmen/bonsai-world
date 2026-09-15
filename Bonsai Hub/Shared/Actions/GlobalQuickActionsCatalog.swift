//
//  GlobalQuickActionsCatalog.swift
//  Bonsai World
//
//  Cross-module Context Tools (Search). Create actions live on their module
//  catalogs — see ContextQuickActionsCatalog.
//

import Foundation

enum GlobalQuickActionsCatalog {
    /// Kept for Context Tools Expandable Add Tree (Trees module).
    static let addTreeMenuID = "global.addTreeMenu"
    static let newTreeID = "global.newTree"
    static let copyExistingTreeID = "global.copyExistingTree"
    static let newPotID = "global.newPot"
    static let newYamadoriID = "global.newYamadori"
    static let searchID = "global.search"

    /// Always-visible tools (any workspace).
    static var actions: [ActionDefinition] {
        [
            ActionDefinition(
                id: searchID,
                title: "Search",
                systemImage: "magnifyingglass",
                availability: .available,
                help: "Find Trees, Locations, Collections, Tasks, Images, and Places"
            ),
        ]
    }
}
