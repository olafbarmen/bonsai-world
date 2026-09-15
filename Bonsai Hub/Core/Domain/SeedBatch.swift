//
//  SeedBatch.swift
//  Bonsai World
//
//  Seed Batch — one propagation unit (bag of seeds), not individual Trees.
//  Species stratification profiles remain the botanical source of truth.
//

import Foundation

enum SeedBatchStage: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case planned
    case stratifying
    case readyToSow
    case sown
    case germinating
    case seedling
    case developing
    case completed
    case failed
    case archived

    var id: Self { self }

    var title: String {
        switch self {
        case .planned: "Planned"
        case .stratifying: "Stratifying"
        case .readyToSow: "Ready to Sow"
        case .sown: "Sown"
        case .germinating: "Germinating"
        case .seedling: "Seedling"
        case .developing: "Developing"
        case .completed: "Completed"
        case .failed: "Failed"
        case .archived: "Archived"
        }
    }

    var isActive: Bool {
        switch self {
        case .completed, .failed, .archived: false
        default: true
        }
    }
}

enum SeedBatchEventKind: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case created
    case stratificationStarted
    case moistureChecked
    case moldDetected
    case moldRemoved
    case stratificationCompleted
    case seedsSown
    case firstGermination
    case germinationCountUpdated
    case seedlingLoss
    case seedlingsMoved
    case locationChanged
    case soilMixChanged
    case seedlingSeparated
    case treeCreated
    case treatmentExtended
    case treatmentStoppedEarly
    case checkCompleted
    case viableCountUpdated
    case discarded
    case failed
    case archived
    case noteAdded
    case photoAdded

    var id: Self { self }

    var title: String {
        switch self {
        case .created: "Seed batch created"
        case .stratificationStarted: "Stratification started"
        case .moistureChecked: "Moisture checked"
        case .moldDetected: "Mold detected"
        case .moldRemoved: "Mold removed"
        case .stratificationCompleted: "Stratification completed"
        case .seedsSown: "Seeds sown"
        case .firstGermination: "First germination"
        case .germinationCountUpdated: "Germination count updated"
        case .seedlingLoss: "Seedling loss recorded"
        case .seedlingsMoved: "Seedlings moved"
        case .locationChanged: "Location changed"
        case .soilMixChanged: "Soil mix changed"
        case .seedlingSeparated: "Seedlings separated"
        case .treeCreated: "Tree created"
        case .treatmentExtended: "Treatment extended"
        case .treatmentStoppedEarly: "Treatment stopped early"
        case .checkCompleted: "Check completed"
        case .viableCountUpdated: "Viable seed count updated"
        case .discarded: "Seeds discarded"
        case .failed: "Batch failed"
        case .archived: "Batch archived"
        case .noteAdded: "Note added"
        case .photoAdded: "Photo added"
        }
    }
}

struct SeedBatchEvent: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var date: Date
    var kind: SeedBatchEventKind
    var quantity: Int?
    var notes: String
    var imageID: UUID?
    var locationID: UUID?
    var soilMixID: UUID?
    /// When true, this event records a user decision that differs from the scientific recommendation.
    var isUserDecision: Bool

    init(
        id: UUID = UUID(),
        date: Date = .now,
        kind: SeedBatchEventKind,
        quantity: Int? = nil,
        notes: String = "",
        imageID: UUID? = nil,
        locationID: UUID? = nil,
        soilMixID: UUID? = nil,
        isUserDecision: Bool = false
    ) {
        self.id = id
        self.date = date
        self.kind = kind
        self.quantity = quantity
        self.notes = notes
        self.imageID = imageID
        self.locationID = locationID
        self.soilMixID = soilMixID
        self.isUserDecision = isUserDecision
    }
}

/// One phase copied from the species profile when stratification starts.
struct SeedBatchTreatmentPhase: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var order: Int
    var phaseType: StratificationPhaseType
    var recommendedTemperatureMin: Double?
    var recommendedTemperatureMax: Double?
    var recommendedDurationMinDays: Int?
    var recommendedDurationMaxDays: Int?
    /// User-selected duration within or outside the recommended range.
    var selectedDurationDays: Int?
    var isUserAdjustedDuration: Bool
    var mediumDescription: String
    /// Optional link to a Seeds-tagged soil mix used as treatment medium.
    var soilMixID: UUID?
    var startedAt: Date?
    var targetEndAt: Date?
    var completedAt: Date?
    var notes: String

    init(
        id: UUID = UUID(),
        order: Int,
        phaseType: StratificationPhaseType,
        recommendedTemperatureMin: Double? = nil,
        recommendedTemperatureMax: Double? = nil,
        recommendedDurationMinDays: Int? = nil,
        recommendedDurationMaxDays: Int? = nil,
        selectedDurationDays: Int? = nil,
        isUserAdjustedDuration: Bool = false,
        mediumDescription: String = "",
        soilMixID: UUID? = nil,
        startedAt: Date? = nil,
        targetEndAt: Date? = nil,
        completedAt: Date? = nil,
        notes: String = ""
    ) {
        self.id = id
        self.order = order
        self.phaseType = phaseType
        self.recommendedTemperatureMin = recommendedTemperatureMin
        self.recommendedTemperatureMax = recommendedTemperatureMax
        self.recommendedDurationMinDays = recommendedDurationMinDays
        self.recommendedDurationMaxDays = recommendedDurationMaxDays
        self.selectedDurationDays = selectedDurationDays
        self.isUserAdjustedDuration = isUserAdjustedDuration
        self.mediumDescription = mediumDescription
        self.soilMixID = soilMixID
        self.startedAt = startedAt
        self.targetEndAt = targetEndAt
        self.completedAt = completedAt
        self.notes = notes
    }

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

struct SeedBatch: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    /// Display code e.g. `AP-2026-01`.
    var batchCode: String
    var speciesID: UUID
    /// Snapshot for display if Botanical Library entry changes later.
    var botanicalName: String
    var commonName: String
    var source: String
    var collectionDate: Date?
    var acquisitionDate: Date?
    var seedYear: Int
    var initialSeedCount: Int
    var viableSeedCount: Int
    var stratifiedSeedCount: Int
    var sownSeedCount: Int
    var germinatedSeedCount: Int
    var survivingSeedlingCount: Int
    var selectedTreeCount: Int
    var discardedSeedCount: Int
    var createdTreeIDs: [UUID]
    var stage: SeedBatchStage
    var locationID: UUID?
    var soilMixID: UUID?
    var containerDescription: String
    var treatmentPhases: [SeedBatchTreatmentPhase]
    var currentTreatmentPhaseIndex: Int
    var checkIntervalDays: Int
    var nextCheckTaskID: UUID?
    var treatmentCompleteTaskID: UUID?
    var events: [SeedBatchEvent]
    var imageIDs: [UUID]
    var notes: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        batchCode: String,
        speciesID: UUID,
        botanicalName: String,
        commonName: String = "",
        source: String = "",
        collectionDate: Date? = nil,
        acquisitionDate: Date? = nil,
        seedYear: Int,
        initialSeedCount: Int,
        viableSeedCount: Int? = nil,
        stratifiedSeedCount: Int = 0,
        sownSeedCount: Int = 0,
        germinatedSeedCount: Int = 0,
        survivingSeedlingCount: Int = 0,
        selectedTreeCount: Int = 0,
        discardedSeedCount: Int = 0,
        createdTreeIDs: [UUID] = [],
        stage: SeedBatchStage = .planned,
        locationID: UUID? = nil,
        soilMixID: UUID? = nil,
        containerDescription: String = "",
        treatmentPhases: [SeedBatchTreatmentPhase] = [],
        currentTreatmentPhaseIndex: Int = 0,
        checkIntervalDays: Int = 7,
        nextCheckTaskID: UUID? = nil,
        treatmentCompleteTaskID: UUID? = nil,
        events: [SeedBatchEvent] = [],
        imageIDs: [UUID] = [],
        notes: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.batchCode = batchCode
        self.speciesID = speciesID
        self.botanicalName = botanicalName
        self.commonName = commonName
        self.source = source
        self.collectionDate = collectionDate
        self.acquisitionDate = acquisitionDate
        self.seedYear = seedYear
        self.initialSeedCount = initialSeedCount
        self.viableSeedCount = viableSeedCount ?? initialSeedCount
        self.stratifiedSeedCount = stratifiedSeedCount
        self.sownSeedCount = sownSeedCount
        self.germinatedSeedCount = germinatedSeedCount
        self.survivingSeedlingCount = survivingSeedlingCount
        self.selectedTreeCount = selectedTreeCount
        self.discardedSeedCount = discardedSeedCount
        self.createdTreeIDs = createdTreeIDs
        self.stage = stage
        self.locationID = locationID
        self.soilMixID = soilMixID
        self.containerDescription = containerDescription
        self.treatmentPhases = treatmentPhases
        self.currentTreatmentPhaseIndex = currentTreatmentPhaseIndex
        self.checkIntervalDays = checkIntervalDays
        self.nextCheckTaskID = nextCheckTaskID
        self.treatmentCompleteTaskID = treatmentCompleteTaskID
        self.events = events
        self.imageIDs = imageIDs
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var currentPhase: SeedBatchTreatmentPhase? {
        guard treatmentPhases.indices.contains(currentTreatmentPhaseIndex) else { return nil }
        return treatmentPhases[currentTreatmentPhaseIndex]
    }

    var orderedEvents: [SeedBatchEvent] {
        events.sorted { $0.date < $1.date }
    }

    // MARK: Success metrics (nil when denominator is zero)

    var germinationRate: Double? {
        guard sownSeedCount > 0 else { return nil }
        return Double(germinatedSeedCount) / Double(sownSeedCount)
    }

    var survivalRate: Double? {
        guard germinatedSeedCount > 0 else { return nil }
        return Double(survivingSeedlingCount) / Double(germinatedSeedCount)
    }

    var seedToSeedlingRate: Double? {
        guard initialSeedCount > 0 else { return nil }
        return Double(survivingSeedlingCount) / Double(initialSeedCount)
    }

    var selectionRate: Double? {
        guard initialSeedCount > 0 else { return nil }
        return Double(selectedTreeCount) / Double(initialSeedCount)
    }

    var seedToTreeRate: Double? {
        guard initialSeedCount > 0 else { return nil }
        return Double(createdTreeIDs.count) / Double(initialSeedCount)
    }

    static func percentLabel(_ rate: Double?) -> String {
        guard let rate else { return "—" }
        return String(format: "%.0f%%", rate * 100)
    }
}
