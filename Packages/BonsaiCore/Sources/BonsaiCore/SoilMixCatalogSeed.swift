//
//  SoilMixCatalogSeed.swift
//  BonsaiCore
//
//  Canonical starter Soil Mixes — same IDs on Mac and iPhone so a mix
//  chosen on one device resolves on the other after iCloud sync.
//

import Foundation

/// Built-in soil recipes written to `Database/SoilMixes.json` when the catalog is empty.
enum SoilMixCatalogSeed {
    /// Index-stable UUID matching Mac `ReferencePreviewSeed.id(list:n:)`.
    private static func id(list: Int, n: Int) -> UUID {
        UUID(uuidString: String(format: "10000000-0000-4000-8000-%02x%010d", list, n))!
    }

    private static func componentID(_ n: Int) -> UUID { id(list: 12, n: n) }

    static let all: [SoilMix] = [
        SoilMix(
            id: id(list: 13, n: 1),
            name: "Deciduous Standard",
            mixDescription: "Balanced open mix for maples and other deciduous stock.",
            intendedUse: "Deciduous",
            parts: [
                SoilMixPart(componentID: componentID(1), componentName: "Akadama", percentage: 50),
                SoilMixPart(componentID: componentID(2), componentName: "Pumice", percentage: 25),
                SoilMixPart(componentID: componentID(3), componentName: "Lava", percentage: 25),
            ],
            sortOrder: 1
        ),
        SoilMix(
            id: id(list: 13, n: 2),
            name: "Pine Development",
            mixDescription: "Drier, free-draining mix for pine development.",
            intendedUse: "Pines",
            parts: [
                SoilMixPart(componentID: componentID(1), componentName: "Akadama", percentage: 40),
                SoilMixPart(componentID: componentID(2), componentName: "Pumice", percentage: 30),
                SoilMixPart(componentID: componentID(3), componentName: "Lava", percentage: 30),
            ],
            sortOrder: 2
        ),
        SoilMix(
            id: id(list: 13, n: 3),
            name: "Shohin Mix",
            mixDescription: "Finer particles for small pots.",
            intendedUse: "Shohin",
            parts: [
                SoilMixPart(componentID: componentID(1), componentName: "Akadama", percentage: 60),
                SoilMixPart(componentID: componentID(2), componentName: "Pumice", percentage: 20),
                SoilMixPart(componentID: componentID(3), componentName: "Lava", percentage: 20),
            ],
            sortOrder: 3
        ),
    ]
}
