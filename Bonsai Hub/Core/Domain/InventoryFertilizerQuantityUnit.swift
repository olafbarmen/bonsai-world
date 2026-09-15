//
//  InventoryFertilizerQuantityUnit.swift
//  Bonsai World
//
//  Quantity unit chosen per Fertilizer stock line.
//

import Foundation

enum InventoryFertilizerQuantityUnit: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case kg
    case liter
    case pack

    var id: Self { self }

    /// Display unit — grower wording: kg / L / pack.
    var title: String {
        switch self {
        case .kg: "kg"
        case .liter: "L"
        case .pack: "pack"
        }
    }

    var priceFieldLabel: String {
        switch self {
        case .kg: "Price per kg"
        case .liter: "Price per L"
        case .pack: "Price per pack"
        }
    }
}
