//
//  TreeBrowserSort.swift
//  Bonsai World
//
//  Sort options for the Trees list.
//

import Foundation

enum TreeBrowserSort: String, CaseIterable, Identifiable {
    case name
    case species
    case recentlyUpdated

    var id: Self { self }

    var title: String {
        switch self {
        case .name: "Name"
        case .species: "Species"
        case .recentlyUpdated: "Recently Updated"
        }
    }
}
