//
//  SoilMixPreviewData.swift
//  Bonsai World
//
//  Reference Data seed — example Soil Mixes (same model as user-defined mixes).
//

import Foundation

enum SoilMixPreviewData {
    private static func componentID(_ n: Int) -> UUID {
        ReferencePreviewSeed.id(list: 12, n: n)
    }

    static let all: [SoilMix] = [
        SoilMix(
            id: ReferencePreviewSeed.id(list: 13, n: 1),
            name: "Deciduous Standard",
            mixDescription: "Balanced open mix for maples and other deciduous stock.",
            intendedUse: "Deciduous",
            parts: [
                SoilMixPart(componentID: componentID(1), percentage: 50), // Akadama
                SoilMixPart(componentID: componentID(2), percentage: 25), // Pumice
                SoilMixPart(componentID: componentID(3), percentage: 25), // Lava
            ],
            sortOrder: 1
        ),
        SoilMix(
            id: ReferencePreviewSeed.id(list: 13, n: 2),
            name: "Pine Development",
            mixDescription: "Drier, free-draining mix for pine development.",
            intendedUse: "Pines",
            parts: [
                SoilMixPart(componentID: componentID(1), percentage: 40), // Akadama
                SoilMixPart(componentID: componentID(2), percentage: 30), // Pumice
                SoilMixPart(componentID: componentID(3), percentage: 30), // Lava
            ],
            sortOrder: 2
        ),
        SoilMix(
            id: ReferencePreviewSeed.id(list: 13, n: 3),
            name: "Shohin Mix",
            mixDescription: "Finer particles for small pots.",
            intendedUse: "Shohin",
            parts: [
                SoilMixPart(componentID: componentID(1), percentage: 60), // Akadama
                SoilMixPart(componentID: componentID(2), percentage: 20), // Pumice
                SoilMixPart(componentID: componentID(3), percentage: 20), // Lava
            ],
            sortOrder: 3
        ),
    ]
}
