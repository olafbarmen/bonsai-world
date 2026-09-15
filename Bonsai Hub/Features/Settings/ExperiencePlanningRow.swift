//
//  ExperiencePlanningRow.swift
//  Bonsai World
//
//  Settings → Experience planning matrix rows (menu packages + known extensions).
//  Not persisted and not wired to gating — grower planning only.
//

import Foundation

enum ExperiencePlanningGroup: String, CaseIterable, Identifiable, Sendable {
    case workspace
    case library
    case mediaExtensions

    var id: String { rawValue }

    var title: String {
        switch self {
        case .workspace: "Workspace"
        case .library: "Library"
        case .mediaExtensions: "Media extensions"
        }
    }
}

/// One matrix row = one menu package (or named extension). A check means the
/// edition includes that surface and its extended functions.
struct ExperiencePlanningRow: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let group: ExperiencePlanningGroup
}

enum ExperiencePlanningCatalog {
    static let rows: [ExperiencePlanningRow] = workspace + library + mediaExtensions

    static func defaultMembership() -> [String: Set<ExperienceEdition>] {
        Dictionary(uniqueKeysWithValues: rows.map { row in
            (row.id, Set<ExperienceEdition>([.complete]))
        })
    }

    private static let workspace: [ExperiencePlanningRow] = [
        .init(id: "dashboard", title: "Dashboard", group: .workspace),
        .init(id: "tasks", title: "Tasks", group: .workspace),
        .init(id: "trees", title: "Trees", group: .workspace),
        .init(id: "collections", title: "Collections", group: .workspace),
        .init(id: "care.today", title: "Care — Today", group: .workspace),
        .init(id: "care.watering", title: "Care — Watering", group: .workspace),
        .init(id: "care.fertilizing", title: "Care — Fertilizing", group: .workspace),
        .init(id: "care.repotting", title: "Care — Repotting", group: .workspace),
        .init(id: "care.placement", title: "Care — Placement", group: .workspace),
        .init(id: "care.health", title: "Care — Health", group: .workspace),
        .init(id: "care.seasonal", title: "Care — Seasonal Care", group: .workspace),
        .init(id: "care.winter", title: "Care — Winter Care", group: .workspace),
        .init(id: "nursery.seeds", title: "Nursery — Seeds", group: .workspace),
        .init(id: "nursery.cuttings", title: "Nursery — Cuttings", group: .workspace),
        .init(id: "nursery.airLayers", title: "Nursery — Air Layers", group: .workspace),
        .init(id: "yamadori", title: "Yamadori", group: .workspace),
        .init(id: "inventory.pots", title: "Inventory — Pots", group: .workspace),
        .init(id: "inventory.soil", title: "Inventory — Soil", group: .workspace),
        .init(id: "inventory.fertilizers", title: "Inventory — Fertilizers", group: .workspace),
        .init(id: "inventory.wire", title: "Inventory — Wire", group: .workspace),
        .init(id: "inventory.tools", title: "Inventory — Tools", group: .workspace),
        .init(id: "inventory.chemicals", title: "Inventory — Chemicals", group: .workspace),
        .init(id: "inventory.consumables", title: "Inventory — Consumables", group: .workspace),
        .init(id: "inventory.stockReport", title: "Inventory — Stock Report", group: .workspace)
    ]

    private static let library: [ExperiencePlanningRow] = [
        .init(id: "media.images", title: "Media — Images", group: .library),
        .init(id: "media.documents", title: "Media — Documents", group: .library),
        .init(id: "media.notes", title: "Media — Notes", group: .library),
        .init(id: "media.videos", title: "Media — Videos", group: .library),
        .init(id: "media.audio", title: "Media — Audio", group: .library),
        .init(id: "knowledge.quickGuides", title: "Knowledge — Quick Guides", group: .library),
        .init(id: "knowledge.handbook", title: "Knowledge — Bonsai Handbook", group: .library),
        .init(id: "knowledge.handbook.formsStyles", title: "Knowledge — Handbook — Bonsai Forms, Styles & Silhouette", group: .library),
        .init(id: "knowledge.handbook.artistry", title: "Knowledge — Handbook — Bonsai Artistry & the Bonsai Eye", group: .library),
        .init(id: "knowledge.handbook.material", title: "Knowledge — Handbook — Bonsai Material & Sourcing", group: .library),
        .init(id: "knowledge.handbook.pruning", title: "Knowledge — Handbook — Pruning", group: .library),
        .init(id: "knowledge.handbook.wiring", title: "Knowledge — Handbook — Wiring", group: .library),
        .init(id: "knowledge.handbook.repotting", title: "Knowledge — Handbook — Repotting", group: .library),
        .init(id: "knowledge.handbook.watering", title: "Knowledge — Handbook — Watering", group: .library),
        .init(id: "knowledge.handbook.potGuidelines", title: "Knowledge — Handbook — Pots & Containers", group: .library),
        .init(id: "knowledge.handbook.display", title: "Knowledge — Handbook — Display & Presentation", group: .library),
        .init(id: "knowledge.handbook.soilGuides", title: "Knowledge — Handbook — Soil & Substrate", group: .library),
        .init(id: "knowledge.handbook.fertilizing", title: "Knowledge — Handbook — Fertilizing", group: .library),
        .init(id: "knowledge.handbook.propagation", title: "Knowledge — Handbook — Propagation", group: .library),
        .init(id: "knowledge.handbook.airLayering", title: "Knowledge — Handbook — Air Layering", group: .library),
        .init(id: "knowledge.handbook.tools", title: "Knowledge — Handbook — Tools & Equipment", group: .library),
        .init(id: "knowledge.handbook.deadwood", title: "Knowledge — Handbook — Deadwood", group: .library),
        .init(id: "knowledge.handbook.advancedTechniques", title: "Knowledge — Handbook — Advanced Techniques", group: .library),
        .init(id: "knowledge.handbook.collectionManagement", title: "Knowledge — Handbook — Bonsai Collection Management", group: .library),
        .init(id: "knowledge.handbook.treeHealth", title: "Knowledge — Handbook — Tree Health", group: .library),
        .init(id: "knowledge.handbook.seasonalCare", title: "Knowledge — Handbook — Seasonal Care & Protection", group: .library),
        .init(id: "knowledge.speciesLibrary", title: "Knowledge — Species Library", group: .library),
        .init(id: "knowledge.fertilizerGuides", title: "Knowledge — Fertilizer Guides", group: .library),
        .init(id: "knowledge.seedStratification", title: "Knowledge — Seed Stratification", group: .library)
    ]

    private static let mediaExtensions: [ExperiencePlanningRow] = [
        .init(id: "media.crop", title: "Crop", group: .mediaExtensions),
        .init(id: "media.imageWorkspace", title: "Image Workspace", group: .mediaExtensions)
    ]
}
