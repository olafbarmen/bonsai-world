//
//  ReferenceDataService.swift
//  Bonsai World
//
//  Read-only entry point for Reference Data pickers (master data).
//  Mutations go through ReferenceDataManager; both share ReferencePreviewData.
//  No persistence or Excel import for most lists. Locations are the exception —
//  ReferenceDataManager keeps previewData.locations in sync with the injected
//  LocationRepository (Database/Locations.json once a Library is open), so
//  reads here already reflect persisted state.
//
//  Usage:
//    @Environment(ReferenceDataService.self) private var referenceData
//    ForEach(referenceData.species) { … }
//

import Foundation
import Observation

/// App-wide Reference Data access for pickers. Inject via `.environment`.
@Observable
@MainActor
final class ReferenceDataService {
    private let previewData: ReferencePreviewData

    init(previewData: ReferencePreviewData) {
        self.previewData = previewData
    }

    // MARK: - Botanical

    var genus: [Genus] {
        activeSorted(previewData.genus, name: \.name, sortOrder: \.sortOrder, isActive: \.isActive)
    }

    var species: [Species] {
        activeSorted(previewData.species, name: \.name, sortOrder: \.sortOrder, isActive: \.isActive)
    }

    var cultivars: [Cultivar] {
        activeSorted(previewData.cultivars, name: \.name, sortOrder: \.sortOrder, isActive: \.isActive)
    }

    // MARK: - Acquisition

    var acquisitionMethods: [AcquisitionMethod] {
        activeSorted(previewData.acquisitionMethods)
    }

    var disposalMethods: [DisposalMethod] {
        activeSorted(previewData.disposalMethods)
    }

    var suppliers: [Supplier] {
        activeSorted(previewData.suppliers)
    }

    var countries: [Country] {
        activeSorted(previewData.countries)
    }

    // MARK: - Tree

    var styles: [Style] {
        activeSorted(previewData.styles)
    }

    var sizeClasses: [SizeClass] {
        activeSorted(previewData.sizeClasses)
    }

    var treeStages: [TreeStage] {
        activeSorted(previewData.treeStages)
    }

    var workTypes: [WorkType] {
        activeSorted(
            previewData.workTypes,
            name: \.name,
            sortOrder: \.sortOrder,
            isActive: \.isActive
        )
    }

    // MARK: - Growing

    var locations: [LocationReference] {
        activeSorted(
            previewData.locations,
            name: \.name,
            sortOrder: \.sortOrder,
            isActive: \.isActive
        )
    }

    var locationTypes: [LocationType] {
        activeSorted(previewData.locationTypes)
    }

    var potTypes: [PotType] {
        activeSorted(previewData.potTypes)
    }

    var lightConditions: [LightCondition] {
        activeSorted(previewData.lightConditions)
    }

    // MARK: - Pot Brands & Makers

    var potBrands: [PotBrand] {
        activeSorted(previewData.potBrands, name: \.name, sortOrder: \.sortOrder, isActive: \.isActive)
    }

    var potMakers: [PotMaker] {
        activeSorted(previewData.potMakers, name: \.name, sortOrder: \.sortOrder, isActive: \.isActive)
    }

    /// Active Makers belonging to a given Brand, for the New Pot / Pot Detail Maker picker.
    func potMakers(forBrandID brandID: UUID) -> [PotMaker] {
        potMakers.filter { $0.brandID == brandID }
    }

    /// Active Makers with no Brand / Kiln — documented independently.
    var independentPotMakers: [PotMaker] {
        potMakers.filter { $0.brandID == nil }
    }

    /// Makers offered when assigning to a Pot: makers of the selected Brand, plus independents.
    func potMakersSelectable(forBrandID brandID: UUID?) -> [PotMaker] {
        if let brandID {
            return potMakers(forBrandID: brandID) + independentPotMakers
        }
        return independentPotMakers
    }

    // MARK: - Soil

    var soilComponents: [SoilComponent] {
        activeSorted(previewData.soilComponents)
    }

    var soilMixes: [SoilMix] {
        activeSorted(
            previewData.soilMixes,
            name: \.name,
            sortOrder: \.sortOrder,
            isActive: \.isActive
        )
    }

    // MARK: - Fertilizer

    var fertilizerTypes: [FertilizerType] {
        activeSorted(previewData.fertilizerTypes, name: \.name, sortOrder: \.sortOrder, isActive: \.isActive)
    }

    // MARK: - Inventory Preparation

    var inventoryPots: [InventoryPot] {
        activeSorted(previewData.inventoryPots)
    }

    var tools: [Tool] {
        activeSorted(previewData.tools)
    }

    var wire: [Wire] {
        activeSorted(previewData.wire)
    }

    var chemicals: [Chemical] {
        activeSorted(previewData.chemicals)
    }

    var consumables: [Consumable] {
        activeSorted(previewData.consumables)
    }

    // MARK: - Lookups

    func genus(id: UUID) -> Genus? { previewData.genus.first { $0.id == id } }
    func species(id: UUID) -> Species? { previewData.species.first { $0.id == id } }
    func cultivar(id: UUID) -> Cultivar? { previewData.cultivars.first { $0.id == id } }

    func acquisitionMethod(id: UUID) -> AcquisitionMethod? { previewData.acquisitionMethods.first { $0.id == id } }
    func disposalMethod(id: UUID) -> DisposalMethod? { previewData.disposalMethods.first { $0.id == id } }
    func supplier(id: UUID) -> Supplier? { previewData.suppliers.first { $0.id == id } }
    func country(id: UUID) -> Country? { previewData.countries.first { $0.id == id } }

    func style(id: UUID) -> Style? { previewData.styles.first { $0.id == id } }
    func sizeClass(id: UUID) -> SizeClass? { previewData.sizeClasses.first { $0.id == id } }
    func treeStage(id: UUID) -> TreeStage? { previewData.treeStages.first { $0.id == id } }
    func workType(id: UUID) -> WorkType? { previewData.workTypes.first { $0.id == id } }

    func location(id: UUID) -> LocationReference? { previewData.locations.first { $0.id == id } }
    func locationType(id: UUID) -> LocationType? { previewData.locationTypes.first { $0.id == id } }
    func potType(id: UUID) -> PotType? { previewData.potTypes.first { $0.id == id } }
    func lightCondition(id: UUID) -> LightCondition? { previewData.lightConditions.first { $0.id == id } }

    func potBrand(id: UUID) -> PotBrand? { previewData.potBrands.first { $0.id == id } }
    func potMaker(id: UUID) -> PotMaker? { previewData.potMakers.first { $0.id == id } }

    func soilComponent(id: UUID) -> SoilComponent? { previewData.soilComponents.first { $0.id == id } }
    func soilMix(id: UUID) -> SoilMix? { previewData.soilMixes.first { $0.id == id } }

    func fertilizerType(id: UUID) -> FertilizerType? { previewData.fertilizerTypes.first { $0.id == id } }

    func inventoryPot(id: UUID) -> InventoryPot? { previewData.inventoryPots.first { $0.id == id } }
    func tool(id: UUID) -> Tool? { previewData.tools.first { $0.id == id } }
    func wire(id: UUID) -> Wire? { previewData.wire.first { $0.id == id } }
    func chemical(id: UUID) -> Chemical? { previewData.chemicals.first { $0.id == id } }
    func consumable(id: UUID) -> Consumable? { previewData.consumables.first { $0.id == id } }

    // MARK: - Hierarchy

    func species(for genus: Genus) -> [Species] {
        species(forGenusID: genus.id)
    }

    func cultivars(for species: Species) -> [Cultivar] {
        cultivars(forSpeciesID: species.id)
    }

    func species(forGenusID genusID: UUID) -> [Species] {
        activeSorted(
            previewData.species.filter { $0.genusID == genusID },
            name: \.name,
            sortOrder: \.sortOrder,
            isActive: \.isActive
        )
    }

    func cultivars(forSpeciesID speciesID: UUID) -> [Cultivar] {
        activeSorted(
            previewData.cultivars.filter { $0.speciesID == speciesID },
            name: \.name,
            sortOrder: \.sortOrder,
            isActive: \.isActive
        )
    }

    // MARK: - Private

    private func activeSorted<T: ReferenceListItem>(_ items: [T]) -> [T] {
        activeSorted(items, name: \.name, sortOrder: \.sortOrder, isActive: \.isActive)
    }

    private func activeSorted<T>(
        _ items: [T],
        name: KeyPath<T, String>,
        sortOrder: KeyPath<T, Int>,
        isActive: KeyPath<T, Bool>
    ) -> [T] {
        _ = previewData.revision
        return items
            .filter { $0[keyPath: isActive] }
            .sorted {
                let lhs = $0[keyPath: sortOrder]
                let rhs = $1[keyPath: sortOrder]
                if lhs != rhs { return lhs < rhs }
                return $0[keyPath: name].localizedCaseInsensitiveCompare($1[keyPath: name]) == .orderedAscending
            }
    }
}
