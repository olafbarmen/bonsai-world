//
//  BonsaiHandbookChapter.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook — top-level chapters in the leading column.
//

import Foundation

enum BonsaiHandbookChapter: String, CaseIterable, Identifiable, Hashable, Sendable {
    case designGuidelines
    case formsStyles
    case artistry
    case material
    case pruning
    case wiring
    case repotting
    case watering
    case potGuidelines
    case airPruning
    case display
    case soilGuides
    case fertilizing
    case propagation
    case airLayering
    case tools
    case deadwood
    case advancedTechniques
    case collectionManagement
    case treeHealth
    case seasonalCare

    var id: Self { self }

    var title: String {
        switch self {
        case .designGuidelines: "Design Guidelines"
        case .formsStyles: "Bonsai Forms, Styles & Silhouette"
        case .artistry: "Bonsai Artistry & the Bonsai Eye"
        case .material: "Bonsai Material & Sourcing"
        case .pruning: "Pruning"
        case .wiring: "Wiring"
        case .repotting: "Repotting"
        case .watering: "Watering"
        case .potGuidelines: "Pots & Containers"
        case .airPruning: "Air Pruning & Air Pots"
        case .display: "Display & Presentation"
        case .soilGuides: "Soil & Substrate"
        case .fertilizing: "Fertilizing"
        case .propagation: "Propagation"
        case .airLayering: "Air Layering"
        case .tools: "Tools & Equipment"
        case .deadwood: "Deadwood"
        case .advancedTechniques: "Advanced Techniques"
        case .collectionManagement: "Bonsai Collection Management"
        case .treeHealth: "Tree Health"
        case .seasonalCare: "Seasonal Care & Protection"
        }
    }

    var systemImage: String {
        switch self {
        case .designGuidelines: "triangle"
        case .formsStyles: "pyramid"
        case .artistry: "eye"
        case .material: "tree"
        case .pruning: "scissors"
        case .wiring: "circle.hexagongrid"
        case .repotting: "arrow.triangle.2.circlepath"
        case .watering: "drop"
        case .potGuidelines: "shippingbox"
        case .airPruning: "wind"
        case .display: "rectangle.on.rectangle"
        case .soilGuides: "circle.grid.3x3"
        case .fertilizing: "leaf.circle"
        case .propagation: "leaf.arrow.triangle.circlepath"
        case .airLayering: "arrow.triangle.branch"
        case .tools: "wrench.and.screwdriver"
        case .deadwood: "leaf.slash"
        case .advancedTechniques: "gearshape.2"
        case .collectionManagement: "square.stack.3d.up"
        case .treeHealth: "heart.text.square"
        case .seasonalCare: "sun.horizon"
        }
    }
}
