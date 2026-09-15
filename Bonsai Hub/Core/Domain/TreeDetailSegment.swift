//
//  TreeDetailSegment.swift
//  Bonsai World
//
//  Tree Detail / Tree Workspace — Overview vs Shaping for one tree.
//

import Foundation

enum TreeDetailSegment: String, CaseIterable, Identifiable, Sendable {
    case overview
    case shaping

    var id: Self { self }

    var title: String {
        switch self {
        case .overview: "Overview"
        case .shaping: "Shaping"
        }
    }
}
