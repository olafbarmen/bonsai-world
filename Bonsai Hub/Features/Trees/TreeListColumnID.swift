//
//  TreeListColumnID.swift
//  Bonsai World
//
//  Identifiers for Tree List information columns.
//  Visibility and order are owned by TreeListColumnConfiguration.
//

import Foundation

/// Columns available in the Trees collection data grid.
/// Botanical Name is the identity column (always visible).
enum TreeListColumnID: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case botanicalName
    case style
    case treeStatus
    case location
    case pot
    case acquisition
    case lastRepot

    var id: String { rawValue }

    var title: String {
        switch self {
        case .botanicalName: "Botanical Name"
        case .style: "Style"
        case .treeStatus: "Tree Status"
        case .location: "Location"
        case .pot: "Pot"
        case .acquisition: "Acquisition"
        case .lastRepot: "Last Repot"
        }
    }

    /// Identity column — cannot be hidden.
    var isRequired: Bool {
        self == .botanicalName
    }

    /// Soft minimum so labels remain readable when many columns share the row.
    var minimumWidth: CGFloat {
        switch self {
        case .botanicalName: 196
        case .style, .location, .pot: 80
        case .treeStatus, .lastRepot: 80
        case .acquisition: 64
        }
    }

    /// Default column order (and default visible set).
    /// Count must stay ≤ slots in `TreeListView.table` (indexed `tableColumn(at:)`).
    static let defaultOrder: [TreeListColumnID] = [
        .botanicalName,
        .style,
        .treeStatus,
        .location,
        .pot,
        .acquisition,
        .lastRepot
    ]

    static var maximumColumnCount: Int { allCases.count }
}
