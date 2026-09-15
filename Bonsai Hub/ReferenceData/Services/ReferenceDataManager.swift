//
//  ReferenceDataManager.swift
//  Bonsai World
//
//  CRUD for flat Settings → Reference Data lists.
//  Botanical Genus / Species / Cultivar is managed only by BotanicalService.
//  Persistence is not implemented for most lists — mutations stay in memory.
//  Locations are the exception: they persist through an injected
//  LocationRepository (UserDefaults-free — PreviewLocationRepository before a
//  Library exists, Database/Locations.json once one is open; see
//  LocationMigrationService and ``attachLibraryLocationRepository(_:)``).
//
//  Flat saves / active / delete go through ``ReferenceListItem`` helpers —
//  do not add per-list duplicate save methods.
//

import Foundation
import Observation

@Observable
@MainActor
final class ReferenceDataManager {
    private let store: ReferencePreviewData
    private var locationRepository: LocationRepository
    private var potBrandRepository: PotBrandRepository

    init(
        store: ReferencePreviewData,
        locationRepository: LocationRepository? = nil,
        potBrandRepository: PotBrandRepository? = nil
    ) {
        self.store = store
        self.locationRepository = locationRepository ?? PreviewLocationRepository(store: store)
        self.potBrandRepository = potBrandRepository ?? PreviewPotBrandRepository(store: store)
    }

    /// Switches Location persistence to a Library-backed repository once one becomes
    /// available (mirrors `UserProfileStore.attachLibraryGardenRepository(_:)`).
    /// The caller is expected to have migrated the prior source into it first
    /// (see `LocationMigrationService`); this re-reads the result into `store`.
    func attachLibraryLocationRepository(_ repository: LocationRepository) {
        locationRepository = repository
        store.locations = repository.getAllLocations()
        store.noteMutation()
    }

    /// Switches Pot Brand / Maker persistence to a Library-backed repository once
    /// one becomes available. No prior source to migrate — Brand/Maker are new,
    /// grower-built lists — so this simply re-reads the (likely empty) catalog.
    func attachLibraryPotBrandRepository(_ repository: PotBrandRepository) {
        potBrandRepository = repository
        store.potBrands = repository.getAllBrands()
        store.potMakers = repository.getAllMakers()
        store.noteMutation()
    }

    /// Mirrors store revision so views observing the Manager refresh.
    var revision: Int { store.revision }

    // MARK: - Read

    func records(in category: ReferenceDataCategory) -> [ReferenceDataRecord] {
        _ = store.revision
        switch category {
        case .botanicalLibrary:
            return []
        case .acquisitionMethods:
            return AcquisitionMethod.mapRecords(store.acquisitionMethods)
        case .disposalMethods:
            return DisposalMethod.mapRecords(store.disposalMethods)
        case .suppliers:
            return Supplier.mapRecords(store.suppliers)
        case .countries:
            return Country.mapRecords(store.countries)
        case .styles:
            return Style.mapRecords(store.styles)
        case .sizeClasses:
            return SizeClass.mapRecords(store.sizeClasses)
        case .treeStages:
            return TreeStage.mapRecords(store.treeStages)
        case .workTypes:
            return WorkType.mapRecords(store.workTypes)
        case .locations:
            return LocationReference.mapRecords(store.locations)
        case .locationTypes:
            return LocationType.mapRecords(store.locationTypes)
        case .potTypes:
            return PotType.mapRecords(store.potTypes)
        case .lightConditions:
            return LightCondition.mapRecords(store.lightConditions)
        case .soilComponents:
            return SoilComponent.mapRecords(store.soilComponents)
        case .soilMixes:
            return SoilMix.mapRecords(store.soilMixes)
        case .fertilizerTypes:
            return FertilizerType.mapRecords(store.fertilizerTypes)
        case .inventoryPots:
            return InventoryPot.mapRecords(store.inventoryPots)
        case .tools:
            return Tool.mapRecords(store.tools)
        case .wire:
            return Wire.mapRecords(store.wire)
        case .chemicals:
            return Chemical.mapRecords(store.chemicals)
        case .consumables:
            return Consumable.mapRecords(store.consumables)
        }
    }

    func nextSortOrder(in category: ReferenceDataCategory) -> Int {
        (records(in: category).map(\.sortOrder).max() ?? -1) + 1
    }

    func draft(from record: ReferenceDataRecord) -> ReferenceDataDraft {
        ReferenceDataDraft(
            id: UUID(),
            entityID: record.id,
            name: record.name,
            sortOrder: record.sortOrder,
            isActive: record.isActive,
            parentID: record.parentID
        )
    }

    // MARK: - Write

    @discardableResult
    func save(_ draft: ReferenceDataDraft, in category: ReferenceDataCategory) -> Bool {
        let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        guard category != .botanicalLibrary else { return false }

        var working = draft
        working.name = trimmed

        switch category {
        case .botanicalLibrary:
            return false
        case .acquisitionMethods:
            AcquisitionMethod.upsert(working, into: &store.acquisitionMethods)
        case .disposalMethods:
            DisposalMethod.upsert(working, into: &store.disposalMethods)
        case .suppliers:
            Supplier.upsert(working, into: &store.suppliers)
        case .countries:
            Country.upsert(working, into: &store.countries)
        case .styles:
            Style.upsert(working, into: &store.styles)
        case .sizeClasses:
            SizeClass.upsert(working, into: &store.sizeClasses)
        case .treeStages:
            TreeStage.upsert(working, into: &store.treeStages)
        case .workTypes:
            return false
        case .locations:
            return false
        case .locationTypes:
            LocationType.upsert(working, into: &store.locationTypes)
        case .potTypes:
            PotType.upsert(working, into: &store.potTypes)
        case .lightConditions:
            LightCondition.upsert(working, into: &store.lightConditions)
        case .soilComponents:
            SoilComponent.upsert(working, into: &store.soilComponents)
        case .soilMixes:
            return false
        case .fertilizerTypes:
            return false
        case .inventoryPots:
            InventoryPot.upsert(working, into: &store.inventoryPots)
        case .tools:
            Tool.upsert(working, into: &store.tools)
        case .wire:
            Wire.upsert(working, into: &store.wire)
        case .chemicals:
            Chemical.upsert(working, into: &store.chemicals)
        case .consumables:
            Consumable.upsert(working, into: &store.consumables)
        }

        store.noteMutation()
        return true
    }

    func setActive(_ id: UUID, in category: ReferenceDataCategory, isActive: Bool) {
        switch category {
        case .botanicalLibrary:
            return
        case .acquisitionMethods:
            AcquisitionMethod.setActive(id, isActive: isActive, in: &store.acquisitionMethods)
        case .disposalMethods:
            DisposalMethod.setActive(id, isActive: isActive, in: &store.disposalMethods)
        case .suppliers:
            Supplier.setActive(id, isActive: isActive, in: &store.suppliers)
        case .countries:
            Country.setActive(id, isActive: isActive, in: &store.countries)
        case .styles:
            Style.setActive(id, isActive: isActive, in: &store.styles)
        case .sizeClasses:
            SizeClass.setActive(id, isActive: isActive, in: &store.sizeClasses)
        case .treeStages:
            TreeStage.setActive(id, isActive: isActive, in: &store.treeStages)
        case .workTypes:
            WorkType.setActive(id, isActive: isActive, in: &store.workTypes)
        case .locations:
            LocationReference.setActive(id, isActive: isActive, in: &store.locations)
        case .locationTypes:
            LocationType.setActive(id, isActive: isActive, in: &store.locationTypes)
        case .potTypes:
            PotType.setActive(id, isActive: isActive, in: &store.potTypes)
        case .lightConditions:
            LightCondition.setActive(id, isActive: isActive, in: &store.lightConditions)
        case .soilComponents:
            SoilComponent.setActive(id, isActive: isActive, in: &store.soilComponents)
        case .soilMixes:
            SoilMix.setActive(id, isActive: isActive, in: &store.soilMixes)
        case .fertilizerTypes:
            FertilizerType.setActive(id, isActive: isActive, in: &store.fertilizerTypes)
        case .inventoryPots:
            InventoryPot.setActive(id, isActive: isActive, in: &store.inventoryPots)
        case .tools:
            Tool.setActive(id, isActive: isActive, in: &store.tools)
        case .wire:
            Wire.setActive(id, isActive: isActive, in: &store.wire)
        case .chemicals:
            Chemical.setActive(id, isActive: isActive, in: &store.chemicals)
        case .consumables:
            Consumable.setActive(id, isActive: isActive, in: &store.consumables)
        }
        store.noteMutation()
        if category == .locations {
            persistLocationsIfNeeded()
        }
    }

    func delete(_ id: UUID, in category: ReferenceDataCategory) {
        switch category {
        case .botanicalLibrary:
            return
        case .acquisitionMethods:
            AcquisitionMethod.delete(id, from: &store.acquisitionMethods)
        case .disposalMethods:
            DisposalMethod.delete(id, from: &store.disposalMethods)
        case .suppliers:
            Supplier.delete(id, from: &store.suppliers)
        case .countries:
            Country.delete(id, from: &store.countries)
        case .styles:
            Style.delete(id, from: &store.styles)
        case .sizeClasses:
            SizeClass.delete(id, from: &store.sizeClasses)
        case .treeStages:
            TreeStage.delete(id, from: &store.treeStages)
        case .workTypes:
            WorkType.delete(id, from: &store.workTypes)
        case .locations:
            LocationReference.delete(id, from: &store.locations)
        case .locationTypes:
            LocationType.delete(id, from: &store.locationTypes)
        case .potTypes:
            PotType.delete(id, from: &store.potTypes)
        case .lightConditions:
            LightCondition.delete(id, from: &store.lightConditions)
        case .soilComponents:
            SoilComponent.delete(id, from: &store.soilComponents)
        case .soilMixes:
            SoilMix.delete(id, from: &store.soilMixes)
        case .fertilizerTypes:
            FertilizerType.delete(id, from: &store.fertilizerTypes)
        case .inventoryPots:
            InventoryPot.delete(id, from: &store.inventoryPots)
        case .tools:
            Tool.delete(id, from: &store.tools)
        case .wire:
            Wire.delete(id, from: &store.wire)
        case .chemicals:
            Chemical.delete(id, from: &store.chemicals)
        case .consumables:
            Consumable.delete(id, from: &store.consumables)
        }
        store.noteMutation()
        if category == .locations {
            persistLocationsIfNeeded()
        }
    }

    // MARK: - Soil Mixes

    func soilComponentsForPicker() -> [SoilComponent] {
        _ = store.revision
        return store.soilComponents
            .filter(\.isActive)
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func soilMixDraft(for id: UUID) -> SoilMixDraft? {
        guard let mix = store.soilMixes.first(where: { $0.id == id }) else { return nil }
        return SoilMixDraft.from(mix)
    }

    func blankSoilMixDraft() -> SoilMixDraft {
        .blank(sortOrder: nextSortOrder(in: .soilMixes))
    }

    /// Saves a soil mix. Requires a name and composition totaling exactly 100%.
    @discardableResult
    func saveSoilMix(_ draft: SoilMixDraft) -> Bool {
        let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        guard draft.isPercentageValid else { return false }

        var parts: [SoilMixPart] = []
        parts.reserveCapacity(draft.parts.count)
        for part in draft.parts {
            guard let componentID = part.componentID, part.percentage > 0 else { return false }
            parts.append(SoilMixPart(id: part.id, componentID: componentID, percentage: part.percentage))
        }

        let mix = SoilMix(
            id: draft.entityID ?? UUID(),
            name: trimmed,
            mixDescription: draft.mixDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            intendedUse: draft.intendedUse.trimmingCharacters(in: .whitespacesAndNewlines),
            contextTags: draft.contextTags,
            genusIDs: draft.genusIDs,
            parts: parts,
            sortOrder: draft.sortOrder,
            isActive: draft.isActive
        )

        if let entityID = draft.entityID,
           let index = store.soilMixes.firstIndex(where: { $0.id == entityID }) {
            store.soilMixes[index] = mix
        } else {
            store.soilMixes.append(mix)
        }

        store.noteMutation()
        return true
    }

    // MARK: - Work Types

    func workTypeDraft(for id: UUID) -> WorkTypeDraft? {
        guard let workType = store.workTypes.first(where: { $0.id == id }) else { return nil }
        return WorkTypeDraft.from(workType)
    }

    func blankWorkTypeDraft() -> WorkTypeDraft {
        .blank(sortOrder: nextSortOrder(in: .workTypes))
    }

    @discardableResult
    func saveWorkType(_ draft: WorkTypeDraft) -> Bool {
        let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        let workType = WorkType(
            id: draft.entityID ?? UUID(),
            name: trimmed,
            category: draft.category,
            workDescription: draft.workDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            sortOrder: draft.sortOrder,
            isActive: draft.isActive,
            behaviour: draft.behaviour
        )

        if let entityID = draft.entityID,
           let index = store.workTypes.firstIndex(where: { $0.id == entityID }) {
            store.workTypes[index] = workType
        } else {
            store.workTypes.append(workType)
        }

        store.noteMutation()
        return true
    }

    // MARK: - Fertilizer Types

    func fertilizerTypeDraft(for id: UUID) -> FertilizerTypeDraft? {
        guard let fertilizerType = store.fertilizerTypes.first(where: { $0.id == id }) else { return nil }
        return FertilizerTypeDraft.from(fertilizerType)
    }

    func blankFertilizerTypeDraft() -> FertilizerTypeDraft {
        .blank(sortOrder: nextSortOrder(in: .fertilizerTypes))
    }

    @discardableResult
    func saveFertilizerType(_ draft: FertilizerTypeDraft) -> FertilizerType? {
        let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let fertilizerType = FertilizerType(
            id: draft.entityID ?? UUID(),
            brand: draft.brand.trimmingCharacters(in: .whitespacesAndNewlines),
            name: trimmed,
            form: draft.form,
            release: draft.release,
            origin: draft.origin,
            npk: draft.npk,
            sortOrder: draft.sortOrder,
            isActive: draft.isActive
        )

        if let entityID = draft.entityID,
           let index = store.fertilizerTypes.firstIndex(where: { $0.id == entityID }) {
            store.fertilizerTypes[index] = fertilizerType
        } else {
            store.fertilizerTypes.append(fertilizerType)
        }

        store.noteMutation()
        return fertilizerType
    }

    // MARK: - Locations

    func locations(inGarden gardenID: UUID) -> [LocationReference] {
        _ = store.revision
        return store.locations
            .filter { $0.gardenID == gardenID && $0.isActive }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func locationTypesForPicker() -> [LocationType] {
        _ = store.revision
        return store.locationTypes
            .filter(\.isActive)
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func locationDraft(for id: UUID) -> LocationReferenceDraft? {
        guard let location = store.locations.first(where: { $0.id == id }) else { return nil }
        return LocationReferenceDraft.from(location)
    }

    func blankLocationDraft(gardenID: UUID?) -> LocationReferenceDraft {
        .blank(sortOrder: nextSortOrder(in: .locations), gardenID: gardenID)
    }

    enum LocationSaveError: Error, Equatable {
        case missingName
        case missingGarden
        case missingLocationType
        case duplicateName
    }

    /// Validates and saves a Location into Reference Data (single Location library).
    @discardableResult
    func saveLocation(_ draft: LocationReferenceDraft) -> Result<UUID, LocationSaveError> {
        let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(.missingName) }
        guard let gardenID = draft.gardenID else { return .failure(.missingGarden) }
        guard let locationTypeID = draft.locationTypeID,
              store.locationTypes.contains(where: { $0.id == locationTypeID })
        else {
            return .failure(.missingLocationType)
        }

        let duplicate = store.locations.contains {
            $0.id != draft.entityID
                && $0.name.localizedCaseInsensitiveCompare(trimmed) == .orderedSame
        }
        guard !duplicate else { return .failure(.duplicateName) }

        let savedID = draft.entityID ?? UUID()
        let location = LocationReference(
            id: savedID,
            name: trimmed,
            gardenID: gardenID,
            locationTypeID: locationTypeID,
            locationDescription: draft.locationDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            sortOrder: draft.sortOrder,
            isActive: draft.isActive,
            geographicPosition: draft.geographicPosition,
            environment: draft.environment
        )

        if let entityID = draft.entityID,
           let index = store.locations.firstIndex(where: { $0.id == entityID }) {
            store.locations[index] = location
        } else {
            store.locations.append(location)
        }

        store.noteMutation()
        persistLocationsIfNeeded()
        return .success(savedID)
    }

    /// Updates only the geographic position for an existing Location.
    func updateLocationPosition(id: UUID, position: GeographicPosition?) {
        guard let index = store.locations.firstIndex(where: { $0.id == id }) else { return }
        store.locations[index].geographicPosition = position
        store.noteMutation()
        persistLocationsIfNeeded()
    }

    // MARK: - Private (Locations persistence)

    private func persistLocationsIfNeeded() {
        try? locationRepository.replaceCatalog(with: store.locations)
    }

    // MARK: - Pot Brands & Makers

    /// All Brands, active and archived — for the Settings screen only. Pickers
    /// elsewhere use `ReferenceDataService.potBrands` (active-only).
    func allPotBrands() -> [PotBrand] {
        _ = store.revision
        return store.potBrands
    }

    func blankPotBrandDraft() -> PotBrandDraft {
        .blank(sortOrder: (store.potBrands.map(\.sortOrder).max() ?? -1) + 1)
    }

    func potBrandDraft(for id: UUID) -> PotBrandDraft? {
        guard let brand = store.potBrands.first(where: { $0.id == id }) else { return nil }
        return PotBrandDraft.from(brand)
    }

    /// Saves a Brand. Requires a non-empty, unique (case-insensitive) name so the
    /// grower never ends up with two records for the same manufacturer.
    @discardableResult
    func savePotBrand(_ draft: PotBrandDraft) -> Bool {
        let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        let duplicate = store.potBrands.contains {
            $0.id != draft.entityID && $0.name.localizedCaseInsensitiveCompare(trimmed) == .orderedSame
        }
        guard !duplicate else { return false }

        let existing = draft.entityID.flatMap { id in store.potBrands.first { $0.id == id } }
        let brand = PotBrand(
            id: draft.entityID ?? UUID(),
            name: trimmed,
            kind: draft.kind,
            country: draft.country.trimmingCharacters(in: .whitespacesAndNewlines),
            originText: draft.originText.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            referenceImageIDs: draft.referenceImageIDs,
            stampReferenceImageIDs: draft.stampReferenceImageIDs,
            stampKnown: draft.stampKnown,
            stampDescription: draft.stampDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            stampIdentificationNotes: draft.stampIdentificationNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceName: draft.sourceName.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceURL: draft.sourceURL.trimmingCharacters(in: .whitespacesAndNewlines),
            verificationNotes: draft.verificationNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            lastVerified: draft.lastVerified,
            isSystemSeed: draft.isSystemSeed,
            sortOrder: draft.sortOrder,
            isActive: draft.isActive,
            createdDate: existing?.createdDate ?? .now,
            modifiedDate: .now
        )

        if let entityID = draft.entityID,
           let index = store.potBrands.firstIndex(where: { $0.id == entityID }) {
            store.potBrands[index] = brand
        } else {
            store.potBrands.append(brand)
        }

        store.noteMutation()
        persistPotBrandsIfNeeded()
        return true
    }

    func setPotBrandActive(_ id: UUID, isActive: Bool) {
        guard let index = store.potBrands.firstIndex(where: { $0.id == id }) else { return }
        store.potBrands[index].isActive = isActive
        store.potBrands[index].modifiedDate = .now
        store.noteMutation()
        persistPotBrandsIfNeeded()
    }

    /// True when at least one Maker still references this Brand — the UI should
    /// offer Archive instead of Delete in that case.
    func isPotBrandInUseByMakers(_ id: UUID) -> Bool {
        store.potMakers.contains { $0.brandID == id }
    }

    /// Deletes a Brand record outright. Callers must first confirm nothing
    /// references it (Makers via ``isPotBrandInUseByMakers(_:)``, Pots via
    /// `PotService`) — this is a mistaken/duplicate-record primitive, not a
    /// safety check.
    func deletePotBrand(_ id: UUID) {
        store.potBrands.removeAll { $0.id == id }
        store.noteMutation()
        persistPotBrandsIfNeeded()
    }

    func potMakers(forBrandID brandID: UUID) -> [PotMaker] {
        _ = store.revision
        return store.potMakers
            .filter { $0.brandID == brandID }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    /// Makers with no Brand / Kiln (Settings — Independent Makers section).
    func independentPotMakers() -> [PotMaker] {
        _ = store.revision
        return store.potMakers
            .filter { $0.brandID == nil }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func blankPotMakerDraft(brandID: UUID?) -> PotMakerDraft {
        .blank(brandID: brandID, sortOrder: (store.potMakers.map(\.sortOrder).max() ?? -1) + 1)
    }

    func potMakerDraft(for id: UUID) -> PotMakerDraft? {
        guard let maker = store.potMakers.first(where: { $0.id == id }) else { return nil }
        return PotMakerDraft.from(maker)
    }

    /// Saves a Maker. Requires a name. Brand is optional — independent makers are allowed.
    @discardableResult
    func savePotMaker(_ draft: PotMakerDraft) -> Bool {
        let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        if let brandID = draft.brandID {
            guard store.potBrands.contains(where: { $0.id == brandID }) else {
                return false
            }
        }

        let existing = draft.entityID.flatMap { id in store.potMakers.first { $0.id == id } }
        let maker = PotMaker(
            id: draft.entityID ?? UUID(),
            name: trimmed,
            brandID: draft.brandID,
            country: draft.country.trimmingCharacters(in: .whitespacesAndNewlines),
            makerType: draft.makerType,
            generation: draft.generation.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            stampReferenceImageIDs: draft.stampReferenceImageIDs,
            stampKnown: draft.stampKnown,
            stampDescription: draft.stampDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            stampIdentificationNotes: draft.stampIdentificationNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceName: draft.sourceName.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceURL: draft.sourceURL.trimmingCharacters(in: .whitespacesAndNewlines),
            verificationNotes: draft.verificationNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            lastVerified: draft.lastVerified,
            isSystemSeed: draft.isSystemSeed,
            sortOrder: draft.sortOrder,
            isActive: draft.isActive,
            createdDate: existing?.createdDate ?? .now,
            modifiedDate: .now
        )

        if let entityID = draft.entityID,
           let index = store.potMakers.firstIndex(where: { $0.id == entityID }) {
            store.potMakers[index] = maker
        } else {
            store.potMakers.append(maker)
        }

        store.noteMutation()
        persistPotBrandsIfNeeded()
        return true
    }

    func setPotMakerActive(_ id: UUID, isActive: Bool) {
        guard let index = store.potMakers.firstIndex(where: { $0.id == id }) else { return }
        store.potMakers[index].isActive = isActive
        store.potMakers[index].modifiedDate = .now
        store.noteMutation()
        persistPotBrandsIfNeeded()
    }

    /// Deletes a Maker record outright. Callers must first confirm nothing
    /// references it (Pots via `PotService`) — this is a mistaken/duplicate-record
    /// primitive, not a safety check.
    func deletePotMaker(_ id: UUID) {
        store.potMakers.removeAll { $0.id == id }
        store.noteMutation()
        persistPotBrandsIfNeeded()
    }

    private func persistPotBrandsIfNeeded() {
        try? potBrandRepository.replaceCatalog(brands: store.potBrands, makers: store.potMakers, seedVersion: nil)
    }
}
