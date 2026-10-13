//
//  LocationEditorPickers.swift
//  Bonsai World
//
//  Shared Garden / Location Type picker rows for New Location and Edit Location.
//

import Foundation

func pickerOptions(
    _ catalog: [CanonicalLocationID.Item],
    selected: UUID,
    name: (UUID) -> String?
) -> [CanonicalLocationID.Item] {
    var items = catalog
    if !items.contains(where: { $0.id == selected }) {
        items.insert(CanonicalLocationID.Item(id: selected, name: name(selected) ?? ""), at: 0)
    }
    return items
}
