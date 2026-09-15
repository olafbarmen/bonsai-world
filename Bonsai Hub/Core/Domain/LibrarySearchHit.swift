//
//  LibrarySearchHit.swift
//  Bonsai World
//
//  One Search result — a stored record or a Workspace place.
//

import Foundation

enum LibrarySearchHit: Identifiable, Hashable, Sendable {
    case tree(UUID)
    case location(UUID)
    case collection(UUID)
    case task(occurrenceID: String, horizon: TasksHorizon)
    case image(UUID)
    case place(AppRoute)

    var id: String {
        switch self {
        case .tree(let id): "tree-\(id.uuidString)"
        case .location(let id): "location-\(id.uuidString)"
        case .collection(let id): "collection-\(id.uuidString)"
        case .task(let occurrenceID, _): "task-\(occurrenceID)"
        case .image(let id): "image-\(id.uuidString)"
        case .place(let route): "place-\(route.rawValue)"
        }
    }
}

struct LibrarySearchSection: Identifiable, Hashable, Sendable {
    let title: String
    let hits: [LibrarySearchHit]

    var id: String { title }
}
