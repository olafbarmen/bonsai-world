//
//  NurseryPropagationService.swift
//  Bonsai World
//
//  Nursery → Cuttings / Air Layers / Grafting — project lifecycle.
//

import Foundation
import Observation

enum NurseryPropagationServiceError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidCount(String)
    case invalidStage(String)
    case missingLocation
    case missingAcquisitionMethod(String)
    case missingBotanicalName
    case missingMotherPlant
    case missingWorkType(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Propagation project not found (\(id.uuidString))."
        case .invalidCount(let detail), .invalidStage(let detail):
            return detail
        case .missingLocation:
            return "Choose a location for the new tree."
        case .missingAcquisitionMethod(let name):
            return "Acquisition Method “\(name)” is missing from Reference Data."
        case .missingBotanicalName:
            return "Enter a botanical name."
        case .missingMotherPlant:
            return "Choose a mother plant."
        case .missingWorkType(let name):
            return "Work Type “\(name)” is missing from Reference Data."
        }
    }
}

@Observable
@MainActor
final class NurseryPropagationService {
    static let airLayerCheckIntervalDays = 14

    private var repository: any NurseryPropagationRepository
    private let treeService: TreeService
    private let referenceData: ReferenceDataService
    private let taskService: TaskService

    private(set) var projects: [NurseryPropagationProject] = []

    init(
        repository: any NurseryPropagationRepository,
        treeService: TreeService,
        referenceData: ReferenceDataService,
        taskService: TaskService
    ) {
        self.repository = repository
        self.treeService = treeService
        self.referenceData = referenceData
        self.taskService = taskService
        reload()
    }

    func attachRepository(_ repository: any NurseryPropagationRepository) {
        self.repository = repository
        reload()
    }

    private func reload() {
        projects = repository.getAllProjects().sorted { $0.updatedAt > $1.updatedAt }
    }

    func project(id: UUID) -> NurseryPropagationProject? {
        projects.first { $0.id == id }
    }

    func projects(kind: NurseryPropagationKind) -> [NurseryPropagationProject] {
        projects.filter { $0.kind == kind }
    }

    func activeProjects(kind: NurseryPropagationKind) -> [NurseryPropagationProject] {
        projects(kind: kind).filter(\.isActive)
    }

    @discardableResult
    func createProject(_ draft: NurseryPropagationCreateDraft) throws -> NurseryPropagationProject {
        let botanical = draft.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else {
            throw NurseryPropagationServiceError.missingBotanicalName
        }
        if draft.kind == .airLayer, draft.parentTreeID == nil {
            throw NurseryPropagationServiceError.missingMotherPlant
        }
        let quantity = draft.kind == .fieldTree ? 1 : draft.quantity
        guard quantity > 0 else {
            throw NurseryPropagationServiceError.invalidCount("Quantity must be at least 1.")
        }

        let code = nextProjectCode(kind: draft.kind)
        var project = NurseryPropagationProject(
            kind: draft.kind,
            projectCode: code,
            genusID: draft.genusID,
            speciesID: draft.speciesID,
            cultivarID: draft.cultivarID,
            botanicalName: botanical,
            commonName: draft.commonName.trimmingCharacters(in: .whitespacesAndNewlines),
            parentTreeID: draft.kind == .fieldTree ? nil : draft.parentTreeID,
            quantity: quantity,
            stage: .planned,
            plantedAt: draft.kind == .fieldTree ? (draft.plantedAt ?? .now) : draft.plantedAt,
            locationID: draft.locationID,
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            events: [
                NurseryPropagationEvent(
                    kind: .created,
                    quantity: quantity,
                    notes: "\(draft.kind.projectNoun) \(code) created."
                )
            ],
            cuttingTakenAt: draft.kind == .cutting ? draft.cuttingTakenAt : nil,
            cuttingRootMedium: draft.kind == .cutting
                ? draft.cuttingRootMedium.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            cuttingSoilMix: draft.kind == .cutting
                ? draft.cuttingSoilMix.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            cuttingLength: draft.kind == .cutting
                ? draft.cuttingLength.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            cuttingLeafCount: draft.kind == .cutting ? draft.cuttingLeafCount : nil,
            cuttingWoodMaturity: draft.kind == .cutting ? draft.cuttingWoodMaturity : nil,
            cuttingWoodMaturityOverride: draft.kind == .cutting
                ? draft.cuttingWoodMaturityOverride.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            cuttingBaseTechnique: draft.kind == .cutting ? draft.cuttingBaseTechnique : nil,
            cuttingBaseTechniqueOverride: draft.kind == .cutting
                ? draft.cuttingBaseTechniqueOverride.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            cuttingStructure: draft.kind == .cutting ? draft.cuttingStructure : nil,
            cuttingStructureOverride: draft.kind == .cutting
                ? draft.cuttingStructureOverride.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerMethod: draft.kind == .airLayer ? (draft.airLayerMethod ?? .completeRing) : nil,
            airLayerMethodOverride: draft.kind == .airLayer
                ? draft.airLayerMethodOverride.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerRingWidthMM: draft.kind == .airLayer ? draft.airLayerRingWidthMM : nil,
            airLayerLayerDiameterMM: draft.kind == .airLayer ? draft.airLayerLayerDiameterMM : nil,
            airLayerLocation: draft.kind == .airLayer ? draft.airLayerLocation : nil,
            airLayerLocationOverride: draft.kind == .airLayer
                ? draft.airLayerLocationOverride.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerRootingAid: draft.kind == .airLayer ? (draft.airLayerRootingAid ?? .none) : nil,
            airLayerRootingAidOverride: draft.kind == .airLayer
                ? draft.airLayerRootingAidOverride.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerHormoneProduct: draft.kind == .airLayer
                ? draft.airLayerHormoneProduct.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerHormoneConcentration: draft.kind == .airLayer
                ? draft.airLayerHormoneConcentration.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerMediumPreset: draft.kind == .airLayer ? draft.airLayerMediumPreset : nil,
            airLayerMediumCustom: draft.kind == .airLayer
                ? draft.airLayerMediumCustom.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerWrapSystem: draft.kind == .airLayer ? draft.airLayerWrapSystem : nil,
            airLayerWrapSystemOverride: draft.kind == .airLayer
                ? draft.airLayerWrapSystemOverride.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerPurpose: draft.kind == .airLayer ? draft.airLayerPurpose : nil,
            airLayerPurposeOverride: draft.kind == .airLayer
                ? draft.airLayerPurposeOverride.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerRootDevelopment: draft.kind == .airLayer
                ? (draft.airLayerRootDevelopment ?? .noRoots) : nil,
            airLayerStartedAt: draft.kind == .airLayer ? (draft.airLayerStartedAt ?? .now) : nil,
            airLayerWinterCare: draft.kind == .airLayer ? draft.airLayerWinterCare : nil,
            airLayerWinterCareNotes: draft.kind == .airLayer
                ? draft.airLayerWinterCareNotes.trimmingCharacters(in: .whitespacesAndNewlines) : "",
            airLayerSeparated: draft.kind == .airLayer ? draft.airLayerSeparated : false,
            airLayerSeparationDate: draft.kind == .airLayer ? draft.airLayerSeparationDate : nil,
            airLayerSeparationNotes: draft.kind == .airLayer
                ? draft.airLayerSeparationNotes.trimmingCharacters(in: .whitespacesAndNewlines) : ""
        )
        let created = try repository.createProject(project)
        if created.kind == .airLayer {
            project = try scheduleAirLayerStartupTasks(for: created)
            let saved = try repository.updateProject(project)
            reload()
            return saved
        }
        reload()
        return created
    }

    @discardableResult
    func updateFieldTreeDetails(
        projectID: UUID,
        genusID: UUID?,
        speciesID: UUID?,
        cultivarID: UUID?,
        botanicalName: String,
        commonName: String,
        plantedAt: Date?,
        locationID: UUID?,
        notes: String
    ) throws -> NurseryPropagationProject {
        guard var project = repository.getProject(id: projectID) else {
            throw NurseryPropagationServiceError.notFound(projectID)
        }
        guard project.kind == .fieldTree else {
            throw NurseryPropagationServiceError.invalidStage("Identity editor is for Field Tree only.")
        }
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else {
            throw NurseryPropagationServiceError.missingBotanicalName
        }
        project.genusID = genusID
        project.speciesID = speciesID
        project.cultivarID = cultivarID
        project.botanicalName = botanical
        project.commonName = commonName.trimmingCharacters(in: .whitespacesAndNewlines)
        project.plantedAt = plantedAt
        project.locationID = locationID
        project.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        project.quantity = 1
        project.updatedAt = .now
        let saved = try repository.updateProject(project)
        reload()
        return saved
    }

    /// Updates Cuttings / Air Layers / Grafting projects (quantity, identity, parent, location, notes, technique).
    @discardableResult
    func updateVegetativeProjectDetails(
        projectID: UUID,
        genusID: UUID?,
        speciesID: UUID?,
        cultivarID: UUID?,
        botanicalName: String,
        commonName: String,
        parentTreeID: UUID?,
        quantity: Int,
        locationID: UUID?,
        notes: String,
        cuttingTakenAt: Date? = nil,
        cuttingRootMedium: String = "",
        cuttingSoilMix: String = "",
        cuttingLength: String = "",
        cuttingLeafCount: Int? = nil,
        cuttingWoodMaturity: NurseryCuttingWoodMaturity? = nil,
        cuttingWoodMaturityOverride: String = "",
        cuttingBaseTechnique: NurseryCuttingBaseTechnique? = nil,
        cuttingBaseTechniqueOverride: String = "",
        cuttingStructure: NurseryCuttingStructure? = nil,
        cuttingStructureOverride: String = "",
        airLayerMethod: NurseryAirLayerMethod? = nil,
        airLayerMethodOverride: String = "",
        airLayerRingWidthMM: Double? = nil,
        airLayerLayerDiameterMM: Double? = nil,
        airLayerLocation: NurseryAirLayerLocation? = nil,
        airLayerLocationOverride: String = "",
        airLayerRootingAid: NurseryAirLayerRootingAid? = nil,
        airLayerRootingAidOverride: String = "",
        airLayerHormoneProduct: String = "",
        airLayerHormoneConcentration: String = "",
        airLayerMediumPreset: NurseryAirLayerMediumPreset? = nil,
        airLayerMediumCustom: String = "",
        airLayerWrapSystem: NurseryAirLayerWrapSystem? = nil,
        airLayerWrapSystemOverride: String = "",
        airLayerPurpose: NurseryAirLayerPurpose? = nil,
        airLayerPurposeOverride: String = "",
        airLayerRootDevelopment: NurseryAirLayerRootDevelopment? = nil,
        airLayerStartedAt: Date? = nil,
        airLayerWinterCare: Bool? = nil,
        airLayerWinterCareNotes: String = "",
        airLayerSeparated: Bool = false,
        airLayerSeparationDate: Date? = nil,
        airLayerSeparationNotes: String = ""
    ) throws -> NurseryPropagationProject {
        guard var project = repository.getProject(id: projectID) else {
            throw NurseryPropagationServiceError.notFound(projectID)
        }
        guard project.kind != .fieldTree else {
            throw NurseryPropagationServiceError.invalidStage("Use Field Tree editor for Field Tree.")
        }
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !botanical.isEmpty else {
            throw NurseryPropagationServiceError.missingBotanicalName
        }
        guard quantity > 0 else {
            throw NurseryPropagationServiceError.invalidCount("Quantity must be at least 1.")
        }
        guard quantity >= project.createdTreeIDs.count else {
            throw NurseryPropagationServiceError.invalidCount(
                "Quantity cannot be below trees already created (\(project.createdTreeIDs.count))."
            )
        }
        if project.kind == .airLayer, parentTreeID == nil {
            throw NurseryPropagationServiceError.missingMotherPlant
        }

        let previousQuantity = project.quantity
        project.genusID = genusID
        project.speciesID = speciesID
        project.cultivarID = cultivarID
        project.botanicalName = botanical
        project.commonName = commonName.trimmingCharacters(in: .whitespacesAndNewlines)
        project.parentTreeID = parentTreeID
        project.quantity = quantity
        project.locationID = locationID
        project.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)

        if project.kind == .cutting {
            project.cuttingTakenAt = cuttingTakenAt
            project.cuttingRootMedium = cuttingRootMedium.trimmingCharacters(in: .whitespacesAndNewlines)
            project.cuttingSoilMix = cuttingSoilMix.trimmingCharacters(in: .whitespacesAndNewlines)
            project.cuttingLength = cuttingLength.trimmingCharacters(in: .whitespacesAndNewlines)
            project.cuttingLeafCount = cuttingLeafCount
            project.cuttingWoodMaturity = cuttingWoodMaturity
            project.cuttingWoodMaturityOverride = cuttingWoodMaturityOverride.trimmingCharacters(in: .whitespacesAndNewlines)
            project.cuttingBaseTechnique = cuttingBaseTechnique
            project.cuttingBaseTechniqueOverride = cuttingBaseTechniqueOverride.trimmingCharacters(in: .whitespacesAndNewlines)
            project.cuttingStructure = cuttingStructure
            project.cuttingStructureOverride = cuttingStructureOverride.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if project.kind == .airLayer {
            project.airLayerMethod = airLayerMethod
            project.airLayerMethodOverride = airLayerMethodOverride.trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerRingWidthMM = airLayerRingWidthMM
            project.airLayerLayerDiameterMM = airLayerLayerDiameterMM
            project.airLayerLocation = airLayerLocation
            project.airLayerLocationOverride = airLayerLocationOverride.trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerRootingAid = airLayerRootingAid
            project.airLayerRootingAidOverride = airLayerRootingAidOverride.trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerHormoneProduct = airLayerHormoneProduct.trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerHormoneConcentration = airLayerHormoneConcentration
                .trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerMediumPreset = airLayerMediumPreset
            project.airLayerMediumCustom = airLayerMediumCustom.trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerWrapSystem = airLayerWrapSystem
            project.airLayerWrapSystemOverride = airLayerWrapSystemOverride
                .trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerPurpose = airLayerPurpose
            project.airLayerPurposeOverride = airLayerPurposeOverride.trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerRootDevelopment = airLayerRootDevelopment
            project.airLayerStartedAt = airLayerStartedAt
            project.airLayerWinterCare = airLayerWinterCare
            project.airLayerWinterCareNotes = airLayerWinterCareNotes.trimmingCharacters(in: .whitespacesAndNewlines)
            project.airLayerSeparated = airLayerSeparated
            project.airLayerSeparationDate = airLayerSeparationDate
            project.airLayerSeparationNotes = airLayerSeparationNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if previousQuantity != quantity {
            project.events.append(
                NurseryPropagationEvent(
                    kind: .quantityUpdated,
                    quantity: quantity,
                    notes: "Quantity changed from \(previousQuantity) to \(quantity)."
                )
            )
        }
        project.updatedAt = .now
        let saved = try repository.updateProject(project)
        reload()
        return saved
    }

    /// Success rate from completed vs failed projects (optionally for one species).
    func successRate(
        kind: NurseryPropagationKind,
        speciesID: UUID? = nil
    ) -> NurseryPropagationSuccessRate {
        let scoped = projects(kind: kind).filter { project in
            guard let speciesID else { return true }
            return project.speciesID == speciesID
        }
        let completed = scoped.filter { $0.stage == .completed }.count
        let failed = scoped.filter { $0.stage == .failed }.count
        return NurseryPropagationSuccessRate(completedCount: completed, failedCount: failed)
    }

    @discardableResult
    func advanceStage(projectID: UUID) throws -> NurseryPropagationProject {
        guard var project = repository.getProject(id: projectID) else {
            throw NurseryPropagationServiceError.notFound(projectID)
        }
        let previous = project.stage
        let next: NurseryPropagationStage
        if project.kind == .cutting, project.stage == .developing {
            // Legacy Developing → Potted on the new Cuttings path.
            next = .potted
        } else if project.kind == .airLayer, project.stage == .developing {
            // Legacy Developing → Potted on the new Air Layer path.
            next = .potted
        } else {
            let path = project.kind.mainPath
            guard let index = path.firstIndex(of: project.stage), index + 1 < path.count else {
                throw NurseryPropagationServiceError.invalidStage(
                    "No next stage from \(project.stage.title(for: project.kind))."
                )
            }
            next = path[index + 1]
        }
        project.stage = next
        project.events.append(
            NurseryPropagationEvent(
                kind: .stageChanged,
                notes: "Moved to \(next.title(for: project.kind))."
            )
        )
        if project.kind == .airLayer {
            if previous == .active, next != .active {
                project = clearPendingAirLayerCheck(for: project)
            }
            if next == .active {
                project = try scheduleAirLayerCheck(for: project)
            }
        }
        project.updatedAt = .now
        let saved = try repository.updateProject(project)
        reload()
        return saved
    }

    @discardableResult
    func setStage(projectID: UUID, stage: NurseryPropagationStage) throws -> NurseryPropagationProject {
        guard var project = repository.getProject(id: projectID) else {
            throw NurseryPropagationServiceError.notFound(projectID)
        }
        let allowed = Set(project.kind.mainPath + [.failed, .archived])
        guard allowed.contains(stage) else {
            throw NurseryPropagationServiceError.invalidStage("\(stage.title) is not valid for \(project.kind.title).")
        }
        project.stage = stage
        project.events.append(
            NurseryPropagationEvent(kind: .stageChanged, notes: "Stage set to \(stage.title).")
        )
        project.updatedAt = .now
        let saved = try repository.updateProject(project)
        reload()
        return saved
    }

    @discardableResult
    func updateNotes(projectID: UUID, notes: String) throws -> NurseryPropagationProject {
        guard var project = repository.getProject(id: projectID) else {
            throw NurseryPropagationServiceError.notFound(projectID)
        }
        project.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        project.events.append(NurseryPropagationEvent(kind: .noteAdded, notes: project.notes))
        project.updatedAt = .now
        let saved = try repository.updateProject(project)
        reload()
        return saved
    }

    @discardableResult
    func markFailed(projectID: UUID, notes: String = "") throws -> NurseryPropagationProject {
        guard var project = repository.getProject(id: projectID) else {
            throw NurseryPropagationServiceError.notFound(projectID)
        }
        if project.kind == .airLayer {
            project = clearPendingAirLayerCheck(for: project)
        }
        project.stage = .failed
        project.events.append(
            NurseryPropagationEvent(
                kind: .failed,
                notes: notes.isEmpty ? "Marked failed by grower." : notes
            )
        )
        project.updatedAt = .now
        let saved = try repository.updateProject(project)
        reload()
        return saved
    }

    // MARK: - Air Layer tasks

    func pendingTasks(for projectID: UUID) -> [CareTask] {
        taskService.tasks.filter {
            $0.status == .pending && $0.nurseryPropagationProjectIDs.contains(projectID)
        }
        .sorted { $0.dueDate < $1.dueDate }
    }

    @discardableResult
    func completeAirLayerCheck(
        projectID: UUID,
        rootDevelopment: NurseryAirLayerRootDevelopment? = nil,
        moisture: NurseryAirLayerMoisture? = nil,
        notes: String = ""
    ) throws -> NurseryPropagationProject {
        guard var project = repository.getProject(id: projectID) else {
            throw NurseryPropagationServiceError.notFound(projectID)
        }
        guard project.kind == .airLayer else {
            throw NurseryPropagationServiceError.invalidStage("Check is for Air Layers only.")
        }
        if let taskID = project.nextCheckTaskID,
           let task = taskService.tasks.first(where: { $0.id == taskID && $0.status == .pending }) {
            _ = try taskService.completeNurseryPropagationTask(task)
        }
        if let rootDevelopment {
            project.airLayerRootDevelopment = rootDevelopment
        }
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        var summaryParts: [String] = []
        if let rootDevelopment { summaryParts.append(rootDevelopment.title) }
        if let moisture { summaryParts.append("Moisture: \(moisture.title)") }
        if !trimmed.isEmpty { summaryParts.append(trimmed) }
        let eventNotes = summaryParts.isEmpty ? "Wrapping checked." : summaryParts.joined(separator: " · ")
        project.events.append(
            NurseryPropagationEvent(
                kind: .wrappingChecked,
                notes: eventNotes,
                airLayerRootDevelopment: rootDevelopment,
                airLayerMoisture: moisture
            )
        )
        if project.stage == .active || project.stage == .planned {
            project = try scheduleAirLayerCheck(for: project)
        } else {
            project.nextCheckTaskID = nil
        }
        project.updatedAt = .now
        let saved = try repository.updateProject(project)
        reload()
        return saved
    }

    private func scheduleAirLayerStartupTasks(
        for project: NurseryPropagationProject
    ) throws -> NurseryPropagationProject {
        var project = project
        let workTypeID = try airLayerWorkTypeID()
        _ = try taskService.createTask(
            title: "Air layer — \(project.botanicalName)",
            workTypeID: workTypeID,
            nurseryPropagationProjectIDs: [project.id],
            dueDate: .now,
            notes: "\(project.projectCode) — apply air layer on mother plant."
        )
        project = try scheduleAirLayerCheck(for: project)
        return project
    }

    private func scheduleAirLayerCheck(
        for project: NurseryPropagationProject
    ) throws -> NurseryPropagationProject {
        var project = project
        let workTypeID = try airLayerWorkTypeID()
        if let taskID = project.nextCheckTaskID,
           let existing = taskService.tasks.first(where: { $0.id == taskID && $0.status == .pending }) {
            try? taskService.deleteTask(id: existing.id)
        }
        let due = Calendar.current.date(
            byAdding: .day,
            value: Self.airLayerCheckIntervalDays,
            to: .now
        ) ?? .now
        let check = try taskService.createTask(
            title: "Check air layer — \(project.botanicalName)",
            workTypeID: workTypeID,
            nurseryPropagationProjectIDs: [project.id],
            dueDate: due,
            notes: "\(project.projectCode) — check wrap, moisture, and roots."
        )
        project.nextCheckTaskID = check.id
        return project
    }

    private func clearPendingAirLayerCheck(
        for project: NurseryPropagationProject
    ) -> NurseryPropagationProject {
        var project = project
        if let taskID = project.nextCheckTaskID,
           let existing = taskService.tasks.first(where: { $0.id == taskID && $0.status == .pending }) {
            try? taskService.deleteTask(id: existing.id)
        }
        project.nextCheckTaskID = nil
        return project
    }

    private func airLayerWorkTypeID() throws -> UUID {
        if let id = referenceData.workTypes.first(where: { $0.name == "Air Layer" })?.id {
            return id
        }
        throw NurseryPropagationServiceError.missingWorkType("Air Layer")
    }

    /// Creates `count` Trees linked to this project.
    @discardableResult
    func createTrees(
        projectID: UUID,
        count: Int,
        locationID: UUID
    ) throws -> (project: NurseryPropagationProject, trees: [Tree]) {
        guard var project = repository.getProject(id: projectID) else {
            throw NurseryPropagationServiceError.notFound(projectID)
        }
        guard project.stage.canCreateTree else {
            throw NurseryPropagationServiceError.invalidStage(
                "Transfer to Tree is available from \(createTreeStageHint(for: project.kind))."
            )
        }
        let resolvedCount = project.kind == .fieldTree ? 1 : count
        guard resolvedCount > 0 else {
            throw NurseryPropagationServiceError.invalidCount("Create at least one tree.")
        }
        if project.kind != .fieldTree {
            let remaining = max(project.quantity - project.createdTreeIDs.count, 0)
            guard resolvedCount <= max(remaining, 1) else {
                throw NurseryPropagationServiceError.invalidCount(
                    "Only \(remaining) remaining from quantity \(project.quantity)."
                )
            }
        } else if !project.createdTreeIDs.isEmpty {
            throw NurseryPropagationServiceError.invalidCount(
                "This Field Tree already generated a Tree."
            )
        }

        let methodName = project.kind.acquisitionMethodName
        guard let methodID = acquisitionMethodID(named: methodName, kind: project.kind) else {
            throw NurseryPropagationServiceError.missingAcquisitionMethod(methodName)
        }

        let species = project.speciesID.flatMap { referenceData.species(id: $0) }
        var created: [Tree] = []
        for index in 1...resolvedCount {
            let sequence = project.createdTreeIDs.count + index
            var acquisitionNotes = "From \(project.kind.projectNoun.lowercased()) \(project.projectCode)."
            if project.kind == .fieldTree, let plantedAt = project.plantedAt {
                let planted = plantedAt.formatted(date: .abbreviated, time: .omitted)
                acquisitionNotes += " Planted in ground \(planted)."
            }
            if !project.notes.isEmpty {
                acquisitionNotes += " \(project.notes)"
            }
            var tree = Tree(
                botanicalName: project.botanicalName,
                nickname: project.kind == .fieldTree
                    ? (project.commonName.isEmpty ? project.botanicalName : project.commonName)
                    : "\(project.botanicalName) \(project.kind.singularTitle.lowercased()) \(sequence)",
                bonsaiName: "\(project.projectCode)-\(String(format: "%03d", sequence))",
                genusID: project.genusID ?? species?.genusID,
                speciesID: project.speciesID,
                cultivarID: project.cultivarID,
                locationID: locationID,
                propagation: project.kind.treePropagation,
                acquisitionDate: .now,
                acquisitionMethodID: methodID,
                acquisitionSourceName: project.projectCode,
                acquisitionNotes: acquisitionNotes
            )
            if let parentTreeID = project.parentTreeID,
               let parent = treeService.getTree(id: parentTreeID) {
                if tree.cultivarID == nil { tree.cultivarID = parent.cultivarID }
                if tree.genusID == nil { tree.genusID = parent.genusID }
                if tree.speciesID == nil { tree.speciesID = parent.speciesID }
            }
            let savedTree = try treeService.createTree(tree)
            created.append(savedTree)
            project.createdTreeIDs.append(savedTree.id)
            project.events.append(
                NurseryPropagationEvent(kind: .treeCreated, quantity: 1, notes: savedTree.bonsaiName)
            )
        }

        if project.kind == .fieldTree {
            project.stage = .completed
            project.events.append(
                NurseryPropagationEvent(kind: .stageChanged, notes: "Completed — Tree generated from Field Tree.")
            )
        } else if project.createdTreeIDs.count >= project.quantity {
            if project.kind == .airLayer {
                project = clearPendingAirLayerCheck(for: project)
            }
            project.stage = .completed
            project.events.append(
                NurseryPropagationEvent(
                    kind: .stageChanged,
                    notes: "Completed — transferred to Tree."
                )
            )
        }

        if project.locationID == nil {
            project.locationID = locationID
        }
        project.updatedAt = .now
        let saved = try repository.updateProject(project)
        reload()
        return (saved, created)
    }

    private func acquisitionMethodID(named name: String, kind: NurseryPropagationKind) -> UUID? {
        if let exact = referenceData.acquisitionMethods.first(where: {
            $0.name.caseInsensitiveCompare(name) == .orderedSame
        })?.id {
            return exact
        }
        guard kind == .fieldTree else { return nil }
        for fallback in ["Nursery", "Other"] {
            if let id = referenceData.acquisitionMethods.first(where: {
                $0.name.caseInsensitiveCompare(fallback) == .orderedSame
            })?.id {
                return id
            }
        }
        return nil
    }

    private func createTreeStageHint(for kind: NurseryPropagationKind) -> String {
        switch kind {
        case .cutting: "Rooted or Potted"
        case .airLayer: "Potted (or Separated)"
        case .grafting: "Established or Developing"
        case .fieldTree: "Trunk Building, Ramification, or Refining"
        }
    }

    private func nextProjectCode(kind: NurseryPropagationKind) -> String {
        let year = Calendar.current.component(.year, from: Date())
        let prefix = "\(kind.codePrefix)-\(year)-"
        let existing = projects(kind: kind)
            .map(\.projectCode)
            .compactMap { code -> Int? in
                guard code.hasPrefix(prefix) else { return nil }
                return Int(code.dropFirst(prefix.count))
            }
        let next = (existing.max() ?? 0) + 1
        return "\(prefix)\(String(format: "%02d", next))"
    }
}
