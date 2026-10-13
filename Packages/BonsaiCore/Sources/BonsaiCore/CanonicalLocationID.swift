//
//  CanonicalLocationID.swift
//  Bonsai World
//
//  Stable Location UUIDs matching Mac Reference Data seeds
//  (`ReferencePreviewSeed.id(list: 11, n:)`). Display names are not identifiers.
//

import Foundation

enum CanonicalLocationID {
    /// Same list index as `LocationReferencePreviewData`.
    static let list = 11
    /// Same list index as `LocationTypePreviewData`.
    static let locationTypeList = 15
    /// Mac `GardenSeed.defaultGardenID`.
    static let defaultGardenID = UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567890")!
    /// Mac default Garden display name (`UserProfileStore` seed).
    static let defaultGardenName = "My Garden"
    /// Mac Location Type “Outdoor” (`LocationTypePreviewData` n = 2).
    static let defaultLocationTypeID = locationTypeID(n: 2)

    static let gardenCatalog: [Item] = [
        Item(id: defaultGardenID, name: defaultGardenName),
    ]

    /// Exact `LocationTypePreviewData.all` name order (n = 1…8).
    static let locationTypeCatalog: [Item] = locationTypeNames.enumerated().map { index, name in
        Item(id: locationTypeID(n: index + 1), name: name)
    }

    static func id(n: Int) -> UUID {
        UUID(uuidString: String(format: "10000000-0000-4000-8000-%02x%010d", list, n))!
    }

    static func locationTypeID(n: Int) -> UUID {
        UUID(uuidString: String(format: "10000000-0000-4000-8000-%02x%010d", locationTypeList, n))!
    }

    static let altan = id(n: 15)

    /// Display names in `LocationReferencePreviewData` seed order. Identity is `id(n:)`, not the name.
    static let catalog: [Item] = names.enumerated().map { index, name in
        Item(id: id(n: index + 1), name: name)
    }

    /// Seed catalog matching Mac `LocationReferencePreviewData.all` (IDs, names, types).
    static let seedLocations: [Location] = names.enumerated().map { index, name in
        Location(
            id: id(n: index + 1),
            name: name,
            gardenID: defaultGardenID,
            locationTypeID: locationTypeID(n: seedTypeN[index]),
            sortOrder: index + 1
        )
    }

    static func name(for id: UUID) -> String? {
        catalog.first { $0.id == id }?.name
    }

    static func gardenName(for id: UUID) -> String? {
        gardenCatalog.first { $0.id == id }?.name
    }

    static func locationTypeName(for id: UUID) -> String? {
        locationTypeCatalog.first { $0.id == id }?.name
    }

    struct Item: Identifiable, Hashable, Sendable {
        var id: UUID
        var name: String
    }

    /// Exact `LocationReferencePreviewData.all` name order (n = 1…15).
    private static let names: [String] = [
        "Hage",
        "Drivhus",
        "Kaldbenk",
        "Bonsai-bord",
        "Vinterlagring",
        "Innendørs",
        "Voksebedd nedside",
        "Trapp",
        "Drivhus oppside",
        "Under altan",
        "Benk oppside",
        "Bedd Peisestue",
        "Yamadoribedd",
        "Jordbedd nede",
        "Altan",
    ]

    private static let locationTypeNames: [String] = [
        "Greenhouse",
        "Outdoor",
        "Indoor",
        "Winter Storage",
        "Bench",
        "Display Area",
        "Cold Frame",
        "Other",
    ]

    /// Mac `LocationReferencePreviewData` locationTypeID n values, same order as `names`.
    private static let seedTypeN: [Int] = [
        2, 1, 7, 5, 4, 3, 2, 2, 1, 2, 5, 2, 2, 2, 2,
    ]
}
