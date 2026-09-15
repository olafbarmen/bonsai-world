//
//  SeedBatchService.swift
//  Bonsai World
//
//  Seed Work — batch lifecycle. Views talk only to SeedBatchService.
//  Species stratification catalog remains the botanical source of truth.
//  Trees are created via TreeService; Tasks via TaskService.
//

import Foundation
import Observation

enum SeedBatchServiceError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidCount(String)
    case invalidStage(String)
    case missingLocation
    case missingSpeciesProfile
    case missingWorkType(String)
    case missingAcquisitionMethod

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Seed batch not found (\(id.uuidString))."
        case .invalidCount(let detail), .invalidStage(let detail):
            return detail
        case .missingLocation:
            return "Choose a location for this batch."
        case .missingSpeciesProfile:
            return "No stratification profile found for this species."
        case .missingWorkType(let name):
            return "Work Type “\(name)” is missing from Reference Data."
        case .missingAcquisitionMethod:
            return "Acquisition Method “Seed” is missing from Reference Data."
        }
    }
}

struct SeedBatchCreateDraft: Hashable, Sendable {
    var speciesID: UUID
    var botanicalName: String
    var commonName: String
    var initialSeedCount: Int
    var source: String
    var collectionDate: Date?
    var acquisitionDate: Date?
    var seedYear: Int
    var locationID: UUID?
    var notes: String
    var imageID: UUID?
}

@Observable
@MainActor
final class SeedBatchService {
    static let defaultCheckIntervalDays = 7

    private var repository: any SeedBatchRepository
    private let catalog: SeedStratificationCatalogService
    private let treeService: TreeService
    private let taskService: TaskService
    private let referenceData: ReferenceDataService

    private(set) var batches: [SeedBatch] = []

    init(
        repository: any SeedBatchRepository,
        catalog: SeedStratificationCatalogService,
        treeService: TreeService,
        taskService: TaskService,
        referenceData: ReferenceDataService
    ) {
        self.repository = repository
        self.catalog = catalog
        self.treeService = treeService
        self.taskService = taskService
        self.referenceData = referenceData
        reload()
    }

    func attachRepository(_ repository: any SeedBatchRepository) {
        self.repository = repository
        reload()
    }

    private func reload() {
        batches = repository.getAllBatches().sorted {
            $0.updatedAt > $1.updatedAt
        }
    }

    func batch(id: UUID) -> SeedBatch? {
        batches.first { $0.id == id }
    }

    var activeBatches: [SeedBatch] {
        batches.filter(\.stage.isActive)
    }

    // MARK: - Create

    @discardableResult
    func createBatch(_ draft: SeedBatchCreateDraft) throws -> SeedBatch {
        guard draft.initialSeedCount > 0 else {
            throw SeedBatchServiceError.invalidCount("Initial seed count must be at least 1.")
        }

        let code = nextBatchCode(speciesID: draft.speciesID, botanicalName: draft.botanicalName, year: draft.seedYear)
        var batch = SeedBatch(
            batchCode: code,
            speciesID: draft.speciesID,
            botanicalName: draft.botanicalName,
            commonName: draft.commonName,
            source: draft.source.trimmingCharacters(in: .whitespacesAndNewlines),
            collectionDate: draft.collectionDate,
            acquisitionDate: draft.acquisitionDate ?? .now,
            seedYear: draft.seedYear,
            initialSeedCount: draft.initialSeedCount,
            locationID: draft.locationID,
            checkIntervalDays: Self.defaultCheckIntervalDays,
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        if let imageID = draft.imageID {
            batch.imageIDs = [imageID]
        }
        batch.events.append(
            SeedBatchEvent(
                kind: .created,
                quantity: draft.initialSeedCount,
                notes: "\(draft.initialSeedCount) seeds",
                imageID: draft.imageID,
                locationID: draft.locationID
            )
        )

        let saved = try repository.createBatch(batch)
        reload()
        return saved
    }

    // MARK: - Stratification

    @discardableResult
    func startStratification(
        batchID: UUID,
        mediumDescription: String,
        locationID: UUID?,
        soilMixID: UUID? = nil,
        notes: String = "",
        selectedDurationDaysByPhaseOrder: [Int: Int] = [:],
        startDate: Date = .now
    ) throws -> SeedBatch {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard batch.stage == .planned || batch.stage == .readyToSow else {
            throw SeedBatchServiceError.invalidStage("Stratification can start from Planned.")
        }

        let profile = catalog.profile(speciesID: batch.speciesID)
            ?? catalog.profile(matchingScientificName: batch.botanicalName)
        guard let profile else {
            throw SeedBatchServiceError.missingSpeciesProfile
        }

        let treatmentSteps = profile.orderedSequence.filter {
            switch $0.type {
            case .warmStratification, .coldStratification, .scarification, .soaking:
                true
            default:
                false
            }
        }

        if treatmentSteps.isEmpty || profile.treatmentType == .none {
            batch.stage = .readyToSow
            batch.events.append(
                SeedBatchEvent(
                    kind: .noteAdded,
                    notes: "Species profile indicates no pretreatment normally required — ready to sow."
                )
            )
            batch.updatedAt = .now
            let saved = try repository.updateBatch(batch)
            reload()
            return saved
        }

        let trimmedMedium = mediumDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        /// Mix name when chosen; otherwise grower notes (paper towel, box, …) for the Medium row.
        let phaseMedium = trimmedMedium.isEmpty ? trimmedNotes : trimmedMedium

        var phases: [SeedBatchTreatmentPhase] = []
        for step in treatmentSteps {
            let suggested = SpeciesStratificationProfile.suggestedMidpointDays(
                minDays: step.durationMinDays,
                maxDays: step.durationMaxDays
            ) ?? step.durationMinDays ?? step.durationMaxDays
            let userSelected = selectedDurationDaysByPhaseOrder[step.order]
            let selected = userSelected ?? suggested
            let adjusted = userSelected != nil && userSelected != suggested
            var phase = SeedBatchTreatmentPhase(
                order: step.order,
                phaseType: step.type,
                recommendedTemperatureMin: step.temperatureMin,
                recommendedTemperatureMax: step.temperatureMax,
                recommendedDurationMinDays: step.durationMinDays,
                recommendedDurationMaxDays: step.durationMaxDays,
                selectedDurationDays: selected,
                isUserAdjustedDuration: adjusted,
                mediumDescription: phaseMedium,
                soilMixID: soilMixID,
                notes: step.notes
            )
            phases.append(phase)
        }

        guard !phases.isEmpty else {
            throw SeedBatchServiceError.invalidStage("No treatment phases to start.")
        }

        phases[0].startedAt = startDate
        if let days = phases[0].selectedDurationDays {
            phases[0].targetEndAt = Calendar.current.date(byAdding: .day, value: days, to: startDate)
        }

        batch.treatmentPhases = phases
        batch.currentTreatmentPhaseIndex = 0
        batch.stage = .stratifying
        batch.stratifiedSeedCount = batch.viableSeedCount
        if let locationID {
            batch.locationID = locationID
        }
        var eventNoteParts: [String] = [phases[0].phaseType.title]
        if !trimmedMedium.isEmpty {
            eventNoteParts.append(trimmedMedium)
        }
        if !trimmedNotes.isEmpty, trimmedNotes != trimmedMedium {
            eventNoteParts.append(trimmedNotes)
        }
        batch.events.append(
            SeedBatchEvent(
                kind: .stratificationStarted,
                quantity: batch.stratifiedSeedCount,
                notes: eventNoteParts.joined(separator: " — "),
                locationID: batch.locationID,
                soilMixID: soilMixID,
                isUserDecision: phases[0].isUserAdjustedDuration || !trimmedNotes.isEmpty
            )
        )
        if phases[0].isUserAdjustedDuration, let days = phases[0].selectedDurationDays {
            batch.events.append(
                SeedBatchEvent(
                    kind: .noteAdded,
                    notes: "User-adjusted treatment duration: \(days) days (scientific range: \(phases[0].recommendedDurationLabel ?? "variable")).",
                    isUserDecision: true
                )
            )
        }

        batch = try scheduleStratificationTasks(for: batch)
        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    @discardableResult
    func completeCheck(
        batchID: UUID,
        notes: String = "",
        moldDetected: Bool = false,
        earlyGermination: Bool = false
    ) throws -> SeedBatch {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }

        if let taskID = batch.nextCheckTaskID,
           let task = taskService.tasks.first(where: { $0.id == taskID && $0.status == .pending }) {
            _ = try taskService.completeSeedBatchTask(task)
        }

        batch.events.append(
            SeedBatchEvent(kind: .checkCompleted, notes: notes.trimmingCharacters(in: .whitespacesAndNewlines))
        )
        if moldDetected {
            batch.events.append(SeedBatchEvent(kind: .moldDetected, notes: notes))
        }
        if earlyGermination {
            batch.events.append(
                SeedBatchEvent(kind: .firstGermination, notes: "Germination observed during treatment.")
            )
            batch.stage = .readyToSow
        }

        if batch.stage == .stratifying {
            batch = try scheduleNextCheck(for: batch)
        }

        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    @discardableResult
    func completeCurrentTreatmentPhase(batchID: UUID, notes: String = "") throws -> SeedBatch {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard batch.stage == .stratifying,
              batch.treatmentPhases.indices.contains(batch.currentTreatmentPhaseIndex)
        else {
            throw SeedBatchServiceError.invalidStage("No active treatment phase.")
        }

        batch.treatmentPhases[batch.currentTreatmentPhaseIndex].completedAt = .now
        batch.events.append(
            SeedBatchEvent(
                kind: .stratificationCompleted,
                notes: notes.isEmpty
                    ? "Completed \(batch.treatmentPhases[batch.currentTreatmentPhaseIndex].phaseType.title)"
                    : notes
            )
        )

        let nextIndex = batch.currentTreatmentPhaseIndex + 1
        if nextIndex < batch.treatmentPhases.count {
            batch.currentTreatmentPhaseIndex = nextIndex
            batch.treatmentPhases[nextIndex].startedAt = .now
            if let days = batch.treatmentPhases[nextIndex].selectedDurationDays {
                batch.treatmentPhases[nextIndex].targetEndAt = Calendar.current.date(
                    byAdding: .day,
                    value: days,
                    to: .now
                )
            }
            batch.events.append(
                SeedBatchEvent(
                    kind: .stratificationStarted,
                    notes: "Started \(batch.treatmentPhases[nextIndex].phaseType.title)"
                )
            )
            batch = try scheduleStratificationTasks(for: batch)
        } else {
            batch.stage = .readyToSow
            if let taskID = batch.treatmentCompleteTaskID,
               let task = taskService.tasks.first(where: { $0.id == taskID && $0.status == .pending }) {
                _ = try? taskService.completeSeedBatchTask(task)
            }
        }

        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    @discardableResult
    func extendCurrentPhase(batchID: UUID, additionalDays: Int, reason: String) throws -> SeedBatch {
        guard additionalDays > 0 else {
            throw SeedBatchServiceError.invalidCount("Additional days must be positive.")
        }
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard batch.treatmentPhases.indices.contains(batch.currentTreatmentPhaseIndex) else {
            throw SeedBatchServiceError.invalidStage("No active treatment phase.")
        }
        var phase = batch.treatmentPhases[batch.currentTreatmentPhaseIndex]
        let current = phase.selectedDurationDays ?? 0
        phase.selectedDurationDays = current + additionalDays
        phase.isUserAdjustedDuration = true
        if let start = phase.startedAt, let days = phase.selectedDurationDays {
            phase.targetEndAt = Calendar.current.date(byAdding: .day, value: days, to: start)
        }
        batch.treatmentPhases[batch.currentTreatmentPhaseIndex] = phase
        batch.events.append(
            SeedBatchEvent(
                kind: .treatmentExtended,
                notes: "Extended by \(additionalDays) days. \(reason)".trimmingCharacters(in: .whitespacesAndNewlines),
                isUserDecision: true
            )
        )
        batch = try scheduleStratificationTasks(for: batch)
        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    /// Sets absolute duration for the current treatment phase (Your time).
    @discardableResult
    func setCurrentPhaseDuration(
        batchID: UUID,
        days: Int,
        notes: String = ""
    ) throws -> SeedBatch {
        guard days > 0 else {
            throw SeedBatchServiceError.invalidCount("Duration must be at least 1 day.")
        }
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard batch.stage == .stratifying else {
            throw SeedBatchServiceError.invalidStage("Change time only while stratifying.")
        }
        guard batch.treatmentPhases.indices.contains(batch.currentTreatmentPhaseIndex) else {
            throw SeedBatchServiceError.invalidStage("No active treatment phase.")
        }
        var phase = batch.treatmentPhases[batch.currentTreatmentPhaseIndex]
        let previous = phase.selectedDurationDays
        phase.selectedDurationDays = days
        phase.isUserAdjustedDuration = true
        if let start = phase.startedAt {
            phase.targetEndAt = Calendar.current.date(byAdding: .day, value: days, to: start)
        }
        batch.treatmentPhases[batch.currentTreatmentPhaseIndex] = phase

        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        var eventNotes = "Your time set to \(days) days"
        if let previous, previous != days {
            eventNotes += " (was \(previous))"
        }
        if !trimmedNotes.isEmpty {
            eventNotes += ". \(trimmedNotes)"
        }
        batch.events.append(
            SeedBatchEvent(
                kind: .treatmentExtended,
                notes: eventNotes,
                isUserDecision: true
            )
        )
        batch = try scheduleStratificationTasks(for: batch)
        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    // MARK: - Sowing / Germination / Seedlings

    @discardableResult
    func recordSowing(
        batchID: UUID,
        sownCount: Int,
        date: Date = .now,
        soilMixID: UUID?,
        locationID: UUID?,
        containerDescription: String,
        sowingDepth: String,
        notes: String
    ) throws -> SeedBatch {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard sownCount > 0 else {
            throw SeedBatchServiceError.invalidCount("Sown count must be at least 1.")
        }
        let available = max(batch.viableSeedCount - batch.discardedSeedCount, 0)
        guard sownCount <= available else {
            throw SeedBatchServiceError.invalidCount("Cannot sow more seeds than available (\(available)).")
        }

        batch.sownSeedCount = sownCount
        batch.stage = .sown
        if let soilMixID { batch.soilMixID = soilMixID }
        if let locationID { batch.locationID = locationID }
        batch.containerDescription = containerDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        var noteParts = [notes.trimmingCharacters(in: .whitespacesAndNewlines)]
        if !sowingDepth.isEmpty { noteParts.append("Depth: \(sowingDepth)") }
        batch.events.append(
            SeedBatchEvent(
                date: date,
                kind: .seedsSown,
                quantity: sownCount,
                notes: noteParts.filter { !$0.isEmpty }.joined(separator: " · "),
                locationID: batch.locationID,
                soilMixID: batch.soilMixID
            )
        )
        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        _ = try? createGerminationCheckTask(for: saved, due: Calendar.current.date(byAdding: .day, value: 7, to: date) ?? date)
        return repository.getBatch(id: batchID) ?? saved
    }

    @discardableResult
    func recordGermination(
        batchID: UUID,
        germinatedCount: Int,
        date: Date = .now,
        notes: String = ""
    ) throws -> SeedBatch {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard germinatedCount >= 0 else {
            throw SeedBatchServiceError.invalidCount("Germination count cannot be negative.")
        }
        guard germinatedCount <= batch.sownSeedCount else {
            throw SeedBatchServiceError.invalidCount("Germinated cannot exceed sown (\(batch.sownSeedCount)).")
        }
        guard germinatedCount >= batch.germinatedSeedCount else {
            throw SeedBatchServiceError.invalidCount("Germination counts are cumulative — enter a total, not a decrease. Use losses later.")
        }

        let isFirst = batch.germinatedSeedCount == 0 && germinatedCount > 0
        batch.germinatedSeedCount = germinatedCount
        batch.survivingSeedlingCount = max(batch.survivingSeedlingCount, germinatedCount)
        batch.stage = .germinating
        batch.events.append(
            SeedBatchEvent(
                date: date,
                kind: isFirst ? .firstGermination : .germinationCountUpdated,
                quantity: germinatedCount,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        )
        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    @discardableResult
    func recordSeedlingSurvival(
        batchID: UUID,
        survivingCount: Int,
        notes: String = ""
    ) throws -> SeedBatch {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard survivingCount >= 0, survivingCount <= batch.germinatedSeedCount else {
            throw SeedBatchServiceError.invalidCount("Surviving must be between 0 and germinated (\(batch.germinatedSeedCount)).")
        }
        let lost = batch.survivingSeedlingCount - survivingCount
        batch.survivingSeedlingCount = survivingCount
        batch.stage = .seedling
        if lost > 0 {
            batch.events.append(
                SeedBatchEvent(kind: .seedlingLoss, quantity: lost, notes: notes)
            )
        } else {
            batch.events.append(
                SeedBatchEvent(kind: .noteAdded, quantity: survivingCount, notes: notes.isEmpty ? "Survival updated" : notes)
            )
        }
        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    @discardableResult
    func separateSeedlings(batchID: UUID, selectCount: Int, notes: String = "") throws -> SeedBatch {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard selectCount > 0 else {
            throw SeedBatchServiceError.invalidCount("Select at least one seedling.")
        }
        guard selectCount <= batch.survivingSeedlingCount else {
            throw SeedBatchServiceError.invalidCount("Cannot select more than surviving seedlings (\(batch.survivingSeedlingCount)).")
        }
        batch.selectedTreeCount += selectCount
        batch.survivingSeedlingCount -= selectCount
        batch.stage = .developing
        batch.events.append(
            SeedBatchEvent(
                kind: .seedlingSeparated,
                quantity: selectCount,
                notes: notes.isEmpty
                    ? "\(selectCount) selected for bonsai development; \(batch.survivingSeedlingCount) remain in batch."
                    : notes
            )
        )
        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    /// Creates `count` Trees linked to this batch (N trees in one action).
    @discardableResult
    func createTrees(
        batchID: UUID,
        count: Int,
        locationID: UUID,
        acquisitionMethodID: UUID?
    ) throws -> (batch: SeedBatch, trees: [Tree]) {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        guard count > 0 else {
            throw SeedBatchServiceError.invalidCount("Create at least one tree.")
        }
        let available = batch.selectedTreeCount - batch.createdTreeIDs.count
        let fromSurviving = available > 0 ? available : batch.survivingSeedlingCount
        guard count <= max(fromSurviving, batch.survivingSeedlingCount) else {
            throw SeedBatchServiceError.invalidCount("Not enough seedlings/selections for \(count) trees.")
        }

        let methodID = acquisitionMethodID
            ?? referenceData.acquisitionMethods.first { $0.name.caseInsensitiveCompare("Seed") == .orderedSame }?.id
        guard let methodID else {
            throw SeedBatchServiceError.missingAcquisitionMethod
        }

        let species = referenceData.species(id: batch.speciesID)
        var created: [Tree] = []
        for index in 1...count {
            let nickname = "\(batch.botanicalName) seedling \(batch.createdTreeIDs.count + index)"
            let tree = Tree(
                botanicalName: batch.botanicalName,
                nickname: nickname,
                bonsaiName: "",
                genusID: species?.genusID,
                speciesID: batch.speciesID,
                locationID: locationID,
                soilMixID: batch.soilMixID,
                sourceSeedBatchID: batch.id,
                acquisitionDate: .now,
                acquisitionMethodID: methodID,
                acquisitionSourceName: batch.batchCode,
                acquisitionNotes: "From seed batch \(batch.batchCode) (\(batch.initialSeedCount) initial seeds)."
            )
            // Assign temporary unique bonsai name via tree service rules — empty may fail.
            // Use batch code + sequence.
            var named = tree
            named.bonsaiName = "\(batch.batchCode)-\(String(format: "%03d", batch.createdTreeIDs.count + index))"
            let savedTree = try treeService.createTree(named)
            created.append(savedTree)
            batch.createdTreeIDs.append(savedTree.id)
            batch.events.append(
                SeedBatchEvent(kind: .treeCreated, quantity: 1, notes: savedTree.bonsaiName)
            )
        }

        if batch.selectedTreeCount < batch.createdTreeIDs.count {
            batch.selectedTreeCount = batch.createdTreeIDs.count
        }
        if batch.survivingSeedlingCount >= count {
            batch.survivingSeedlingCount -= count
        }
        if batch.createdTreeIDs.count > 0 {
            batch.stage = .developing
        }
        if batch.survivingSeedlingCount == 0 && batch.createdTreeIDs.count > 0 {
            batch.stage = .completed
        }

        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return (saved, created)
    }

    @discardableResult
    func markFailed(batchID: UUID, notes: String) throws -> SeedBatch {
        guard var batch = repository.getBatch(id: batchID) else {
            throw SeedBatchServiceError.notFound(batchID)
        }
        batch.stage = .failed
        batch.events.append(SeedBatchEvent(kind: .failed, notes: notes))
        batch.updatedAt = .now
        let saved = try repository.updateBatch(batch)
        reload()
        return saved
    }

    // MARK: - Tasks helpers

    private func scheduleStratificationTasks(for batch: SeedBatch) throws -> SeedBatch {
        var batch = batch
        let workTypeID = try stratificationWorkTypeID()
        let phase = batch.currentPhase
        let label = phase?.phaseType.title ?? "Stratification"

        if let taskID = batch.nextCheckTaskID,
           let existing = taskService.tasks.first(where: { $0.id == taskID && $0.status == .pending }) {
            try? taskService.deleteTask(id: existing.id)
        }

        let checkDue = Calendar.current.date(
            byAdding: .day,
            value: batch.checkIntervalDays,
            to: .now
        ) ?? .now
        let check = try taskService.createTask(
            title: "Check \(batch.botanicalName) seeds",
            workTypeID: workTypeID,
            seedBatchIDs: [batch.id],
            dueDate: checkDue,
            notes: "\(label) — moisture, mold, premature germination."
        )
        batch.nextCheckTaskID = check.id

        if let end = phase?.targetEndAt {
            if let old = batch.treatmentCompleteTaskID,
               let existing = taskService.tasks.first(where: { $0.id == old && $0.status == .pending }) {
                try? taskService.deleteTask(id: existing.id)
            }
            let complete = try taskService.createTask(
                title: "\(label) complete — prepare for sowing",
                workTypeID: workTypeID,
                seedBatchIDs: [batch.id],
                dueDate: end,
                notes: batch.batchCode
            )
            batch.treatmentCompleteTaskID = complete.id
        }
        return batch
    }

    private func scheduleNextCheck(for batch: SeedBatch) throws -> SeedBatch {
        var batch = batch
        let workTypeID = try stratificationWorkTypeID()
        let due = Calendar.current.date(
            byAdding: .day,
            value: batch.checkIntervalDays,
            to: .now
        ) ?? .now
        if let end = batch.currentPhase?.targetEndAt, due > end {
            return batch
        }
        let check = try taskService.createTask(
            title: "Check \(batch.botanicalName) seeds",
            workTypeID: workTypeID,
            seedBatchIDs: [batch.id],
            dueDate: due,
            notes: batch.batchCode
        )
        batch.nextCheckTaskID = check.id
        return batch
    }

    private func createGerminationCheckTask(for batch: SeedBatch, due: Date) throws -> CareTask {
        let workTypeID = try sowingWorkTypeID()
        return try taskService.createTask(
            title: "Check germination — \(batch.botanicalName)",
            workTypeID: workTypeID,
            seedBatchIDs: [batch.id],
            dueDate: due,
            notes: batch.batchCode
        )
    }

    private func stratificationWorkTypeID() throws -> UUID {
        if let id = referenceData.workTypes.first(where: { $0.name == "Stratification" })?.id {
            return id
        }
        throw SeedBatchServiceError.missingWorkType("Stratification")
    }

    private func sowingWorkTypeID() throws -> UUID {
        if let id = referenceData.workTypes.first(where: { $0.name == "Seed Sowing" })?.id {
            return id
        }
        throw SeedBatchServiceError.missingWorkType("Seed Sowing")
    }

    private func nextBatchCode(speciesID: UUID, botanicalName: String, year: Int) -> String {
        let prefix: String = {
            if let species = referenceData.species(id: speciesID), let code = species.code, !code.isEmpty {
                return code.uppercased()
            }
            let parts = botanicalName.split(separator: " ")
            if parts.count >= 2 {
                return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
            }
            return String(botanicalName.prefix(2)).uppercased()
        }()
        let existing = batches.filter { $0.seedYear == year && $0.batchCode.hasPrefix("\(prefix)-\(year)-") }
        let next = existing.count + 1
        return "\(prefix)-\(year)-\(String(format: "%02d", next))"
    }

    func pendingTasks(for batchID: UUID) -> [CareTask] {
        taskService.tasks.filter {
            $0.status == .pending && $0.seedBatchIDs.contains(batchID)
        }
        .sorted { $0.dueDate < $1.dueDate }
    }

    func dueTodayTasks() -> [CareTask] {
        let cal = Calendar.current
        return taskService.tasks.filter { task in
            task.status == .pending
                && !task.seedBatchIDs.isEmpty
                && cal.isDateInToday(task.dueDate)
        }
        .sorted { $0.dueDate < $1.dueDate }
    }

    func upcomingTasks(withinDays days: Int = 14) -> [CareTask] {
        let cal = Calendar.current
        let start = cal.startOfDay(for: .now)
        let end = cal.date(byAdding: .day, value: days, to: start) ?? start
        return taskService.tasks.filter { task in
            task.status == .pending
                && !task.seedBatchIDs.isEmpty
                && task.dueDate > start
                && task.dueDate <= end
                && !cal.isDateInToday(task.dueDate)
        }
        .sorted { $0.dueDate < $1.dueDate }
    }
}
