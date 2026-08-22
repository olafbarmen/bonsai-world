//
//  ReferencePreviewData.swift
//  Bonsai World
//
//  Aggregates per-list PreviewData seeds for Reference Data.
//  Loaded by ReferenceDataService / ReferenceDataManager. Not persistence.
//

import Foundation
import Observation

/// In-memory Reference Data catalog composed from typed PreviewData files.
@Observable
@MainActor
final class ReferencePreviewData {
    var genus: [Genus]
    var species: [Species]
    var cultivars: [Cultivar]

    var acquisitionMethods: [AcquisitionMethod]
    var disposalMethods: [DisposalMethod]
    var suppliers: [Supplier]
    var countries: [Country]

    var styles: [Style]
    var sizeClasses: [SizeClass]
    var treeStatuses: [TreeStatus]
    var workTypes: [WorkType]
    var developmentStages: [DevelopmentStage]

    var locations: [LocationReference]
    var locationTypes: [LocationType]
    var potTypes: [PotType]
    var lightConditions: [LightCondition]

    var soilComponents: [SoilComponent]
    var soilMixes: [SoilMix]

    var fertilizerTypes: [FertilizerType]
    var fertilizerBrands: [FertilizerBrand]

    var inventoryPots: [InventoryPot]
    var tools: [Tool]
    var wire: [Wire]
    var chemicals: [Chemical]

    /// Incremented on catalog mutations so readers (Service / Manager) refresh.
    private(set) var revision: Int = 0

    init() {
        genus = GenusPreviewData.all
        species = SpeciesPreviewData.all
        cultivars = CultivarPreviewData.all

        acquisitionMethods = AcquisitionMethodPreviewData.all
        disposalMethods = DisposalMethodPreviewData.all
        suppliers = SupplierPreviewData.all
        countries = CountryPreviewData.all

        styles = StylePreviewData.all
        sizeClasses = SizeClassPreviewData.all
        treeStatuses = TreeStatusPreviewData.all
        workTypes = WorkTypePreviewData.all
        developmentStages = DevelopmentStagePreviewData.all

        locations = LocationReferencePreviewData.all
        locationTypes = LocationTypePreviewData.all
        potTypes = PotTypePreviewData.all
        lightConditions = LightConditionPreviewData.all

        soilComponents = SoilComponentPreviewData.all
        soilMixes = SoilMixPreviewData.all

        fertilizerTypes = FertilizerTypePreviewData.all
        fertilizerBrands = FertilizerBrandPreviewData.all

        inventoryPots = InventoryPotPreviewData.all
        tools = ToolPreviewData.all
        wire = WirePreviewData.all
        chemicals = ChemicalPreviewData.all
    }

    func noteMutation() {
        revision += 1
    }
}
