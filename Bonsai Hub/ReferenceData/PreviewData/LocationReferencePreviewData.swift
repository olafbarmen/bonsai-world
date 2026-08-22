//
//  LocationReferencePreviewData.swift
//  Bonsai World
//
//  Reference Data seed — Growing → Locations (scoped to Default Garden).
//

import Foundation

enum LocationReferencePreviewData {
    private static func typeID(_ n: Int) -> UUID {
        ReferencePreviewSeed.id(list: 15, n: n)
    }

    private static var gardenID: UUID { GardenSeed.defaultGardenID }

    static let all: [LocationReference] = [
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 1),
            name: "Hage",
            gardenID: gardenID,
            locationTypeID: typeID(2), // Outdoor
            sortOrder: 1
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 2),
            name: "Drivhus",
            gardenID: gardenID,
            locationTypeID: typeID(1), // Greenhouse
            sortOrder: 2
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 3),
            name: "Kaldbenk",
            gardenID: gardenID,
            locationTypeID: typeID(7), // Cold Frame
            sortOrder: 3
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 4),
            name: "Bonsai-bord",
            gardenID: gardenID,
            locationTypeID: typeID(5), // Bench
            sortOrder: 4
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 5),
            name: "Vinterlagring",
            gardenID: gardenID,
            locationTypeID: typeID(4), // Winter Storage
            sortOrder: 5
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 6),
            name: "Innendørs",
            gardenID: gardenID,
            locationTypeID: typeID(3), // Indoor
            sortOrder: 6
        ),
        // Olaf Excel “Fysisk plassering” values (development migration).
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 7),
            name: "Voksebedd nedside",
            gardenID: gardenID,
            locationTypeID: typeID(2), // Outdoor
            sortOrder: 7
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 8),
            name: "Trapp",
            gardenID: gardenID,
            locationTypeID: typeID(2),
            sortOrder: 8
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 9),
            name: "Drivhus oppside",
            gardenID: gardenID,
            locationTypeID: typeID(1), // Greenhouse
            sortOrder: 9
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 10),
            name: "Under altan",
            gardenID: gardenID,
            locationTypeID: typeID(2),
            sortOrder: 10
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 11),
            name: "Benk oppside",
            gardenID: gardenID,
            locationTypeID: typeID(5), // Bench
            sortOrder: 11
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 12),
            name: "Bedd Peisestue",
            gardenID: gardenID,
            locationTypeID: typeID(2),
            sortOrder: 12
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 13),
            name: "Yamadoribedd",
            gardenID: gardenID,
            locationTypeID: typeID(2),
            sortOrder: 13
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 14),
            name: "Jordbedd nede",
            gardenID: gardenID,
            locationTypeID: typeID(2),
            sortOrder: 14
        ),
        LocationReference(
            id: ReferencePreviewSeed.id(list: 11, n: 15),
            name: "Altan",
            gardenID: gardenID,
            locationTypeID: typeID(2),
            sortOrder: 15
        ),
    ]
}
