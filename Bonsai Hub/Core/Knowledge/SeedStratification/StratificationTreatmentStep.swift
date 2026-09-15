//
//  StratificationTreatmentStep.swift
//  Bonsai World
//
//  Ordered treatment phase with range-based temperature and duration.
//

import Foundation

struct StratificationTreatmentStep: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var order: Int
    var type: StratificationPhaseType
    var temperatureMin: Double?
    var temperatureMax: Double?
    var durationMinDays: Int?
    var durationMaxDays: Int?
    var moisture: MoistureLevel?
    var notes: String
    /// When true, this phase is optional depending on seed lot / condition.
    var isOptional: Bool

    init(
        id: UUID = UUID(),
        order: Int,
        type: StratificationPhaseType,
        temperatureMin: Double? = nil,
        temperatureMax: Double? = nil,
        durationMinDays: Int? = nil,
        durationMaxDays: Int? = nil,
        moisture: MoistureLevel? = nil,
        notes: String = "",
        isOptional: Bool = false
    ) {
        self.id = id
        self.order = order
        self.type = type
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax
        self.durationMinDays = durationMinDays
        self.durationMaxDays = durationMaxDays
        self.moisture = moisture
        self.notes = notes
        self.isOptional = isOptional
    }

    var temperatureLabel: String? {
        SpeciesStratificationProfile.temperatureRangeLabel(min: temperatureMin, max: temperatureMax)
    }

    var durationLabel: String? {
        SpeciesStratificationProfile.durationRangeLabel(minDays: durationMinDays, maxDays: durationMaxDays)
    }
}
