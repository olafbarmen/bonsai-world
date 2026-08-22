//
//  DetailPickerOption.swift
//  Bonsai World
//
//  Lightweight picker row model for Falo Detail Edit Mode (UI only).
//

import Foundation

struct DetailPickerOption: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String

    static func map<Item: Identifiable & ReferenceNamedItem>(
        _ items: [Item]
    ) -> [DetailPickerOption] where Item.ID == UUID {
        items.map { DetailPickerOption(id: $0.id, name: $0.name) }
    }
}

/// Compatibility alias for Tree Detail call sites.
typealias TreeDetailPickerOption = DetailPickerOption
