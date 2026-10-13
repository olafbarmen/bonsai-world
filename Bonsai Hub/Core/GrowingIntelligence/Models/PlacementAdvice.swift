//
//  PlacementAdvice.swift
//  Bonsai World
//
//  Advisory output from PlacementEngine — gaps only (AJ1). Never changes Tasks or Work.
//

import Foundation

enum PlacementGapKind: String, Hashable, Sendable, CaseIterable {
    case missingLocation
    case shouldMoveToWinter
    case shouldMoveToSummer

    var line: String {
        switch self {
        case .missingLocation:
            "No Location assigned — set where this tree stands now (Growing → Placement / Location)."
        case .shouldMoveToWinter:
            "Seasonal tree still on Summer placement while Winter Care is active — move to winter protection, then set Season to Winter placement."
        case .shouldMoveToSummer:
            "Seasonal tree still on Winter placement while Spring Care is active — move to summer place, then set Season to Summer placement."
        }
    }
}

struct PlacementAdviceItem: Identifiable, Hashable, Sendable {
    var id: String { "\(treeID.uuidString)-\(kind.rawValue)" }
    var treeID: UUID
    var treeTitle: String
    var kind: PlacementGapKind

    var line: String { kind.line }
}

struct PlacementAdvice: Hashable, Sendable {
    var items: [PlacementAdviceItem]

    var hasContent: Bool { !items.isEmpty }

    static let empty = PlacementAdvice(items: [])
}
