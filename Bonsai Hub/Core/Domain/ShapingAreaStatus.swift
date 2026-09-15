//
//  ShapingAreaStatus.swift
//  Bonsai World
//
//  Current development state for one Shaping area on a Tree.
//

import Foundation

enum ShapingAreaStatus: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case planned
    case inProgress
    case monitor
    case completed

    var id: Self { self }

    var title: String {
        switch self {
        case .planned: "Planned"
        case .inProgress: "In Progress"
        case .monitor: "Monitor"
        case .completed: "Completed"
        }
    }
}
