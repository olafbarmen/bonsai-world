//
//  SeedBatchTreatmentPhase+Labels.swift
//  Bonsai World
//
//  Display helpers for treatment phases — uses stratification knowledge.
//

import Foundation

extension SeedBatchTreatmentPhase {
    var recommendedDurationLabel: String? {
        SpeciesStratificationProfile.durationRangeLabel(
            minDays: recommendedDurationMinDays,
            maxDays: recommendedDurationMaxDays
        )
    }

    var temperatureLabel: String? {
        SpeciesStratificationProfile.temperatureRangeLabel(
            min: recommendedTemperatureMin,
            max: recommendedTemperatureMax
        )
    }
}
