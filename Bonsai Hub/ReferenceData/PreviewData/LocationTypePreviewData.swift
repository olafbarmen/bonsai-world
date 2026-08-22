//
//  LocationTypePreviewData.swift
//  Bonsai World
//
//  Reference Data seed — Location Types.
//

import Foundation

enum LocationTypePreviewData {
    static let all: [LocationType] = ReferencePreviewSeed.names(list: 15, [
        "Greenhouse",
        "Outdoor",
        "Indoor",
        "Winter Storage",
        "Bench",
        "Display Area",
        "Cold Frame",
        "Other",
    ]).map { LocationType(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
