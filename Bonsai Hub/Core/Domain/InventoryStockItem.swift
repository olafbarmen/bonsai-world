//
//  InventoryStockItem.swift
//  Bonsai World
//
//  Physical inventory line for Wire / Tools / Chemicals / Consumables / Fertilizers.
//  Catalog identity (when used) lives in Settings Reference Data.
//

import Foundation

struct InventoryStockItem: Identifiable, Hashable, Sendable {
    var id: UUID
    var kind: InventoryStockKind
    /// Settings catalog ID for Wire / Tool / Chemical / Fertilizer / Consumable.
    var catalogItemID: UUID?
    /// Optional display override; catalog kinds resolve name from Reference Data.
    var name: String
    var brand: String
    var supplier: String
    var notes: String
    /// Owned count — Wire: rolls; Fertilizer: amount in `fertilizerQuantityUnit`; else pieces/packs.
    var quantity: Double
    var minimumQuantity: Double
    /// Required for Wire — each stock line is one roll size.
    var wireRollSize: InventoryWireRollSize?
    /// Required for Fertilizer — kg / L / pack.
    var fertilizerQuantityUnit: InventoryFertilizerQuantityUnit?
    /// Unit cost for stock valuation — Wire: per roll; Fertilizer: per quantity unit; else per piece.
    var unitPrice: Double?
    var primaryImageID: UUID?
    var imageIDs: [UUID]
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        kind: InventoryStockKind,
        catalogItemID: UUID? = nil,
        name: String = "",
        brand: String = "",
        supplier: String = "",
        notes: String = "",
        quantity: Double = 1,
        minimumQuantity: Double = 0,
        wireRollSize: InventoryWireRollSize? = nil,
        fertilizerQuantityUnit: InventoryFertilizerQuantityUnit? = nil,
        unitPrice: Double? = nil,
        primaryImageID: UUID? = nil,
        imageIDs: [UUID] = [],
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.kind = kind
        self.catalogItemID = catalogItemID
        self.name = name
        self.brand = brand
        self.supplier = supplier
        self.notes = notes
        self.quantity = quantity
        self.minimumQuantity = minimumQuantity
        self.wireRollSize = wireRollSize
        self.fertilizerQuantityUnit = fertilizerQuantityUnit
        self.unitPrice = unitPrice
        self.primaryImageID = primaryImageID
        self.imageIDs = imageIDs
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var listImageID: UUID? { primaryImageID ?? imageIDs.first }

    var isLowStock: Bool {
        minimumQuantity > 0 && quantity < minimumQuantity
    }

    var stockStatusTitle: String {
        isLowStock ? "Low" : "OK"
    }

    /// List/detail quantity line — Wire includes roll size; Fertilizer includes unit.
    var quantitySummary: String {
        let count = quantity.formatted(.number.precision(.fractionLength(0...2)))
        if kind == .wire, let wireRollSize {
            return "\(count) × \(wireRollSize.title)"
        }
        if kind == .fertilizer, let fertilizerQuantityUnit {
            return "\(count) \(fertilizerQuantityUnit.title)"
        }
        return "Qty \(count)"
    }

    /// Line value when unit price is set.
    var stockValue: Double? {
        guard let unitPrice else { return nil }
        return max(0, quantity) * max(0, unitPrice)
    }

    var resolvedUnitPriceFieldLabel: String {
        if kind == .fertilizer, let fertilizerQuantityUnit {
            return fertilizerQuantityUnit.priceFieldLabel
        }
        return kind.unitPriceFieldLabel
    }
}

extension InventoryStockItem: Codable {
    enum CodingKeys: String, CodingKey {
        case id, kind, catalogItemID, name, brand, supplier, notes
        case quantity, minimumQuantity, wireRollSize, fertilizerQuantityUnit
        case unitPrice, primaryImageID, imageIDs, createdAt, updatedAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        kind = try c.decode(InventoryStockKind.self, forKey: .kind)
        catalogItemID = try c.decodeIfPresent(UUID.self, forKey: .catalogItemID)
        name = try c.decodeIfPresent(String.self, forKey: .name) ?? ""
        brand = try c.decodeIfPresent(String.self, forKey: .brand) ?? ""
        supplier = try c.decodeIfPresent(String.self, forKey: .supplier) ?? ""
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        quantity = try c.decodeIfPresent(Double.self, forKey: .quantity) ?? 0
        minimumQuantity = try c.decodeIfPresent(Double.self, forKey: .minimumQuantity) ?? 0
        wireRollSize = try c.decodeIfPresent(InventoryWireRollSize.self, forKey: .wireRollSize)
        fertilizerQuantityUnit = try c.decodeIfPresent(
            InventoryFertilizerQuantityUnit.self,
            forKey: .fertilizerQuantityUnit
        )
        unitPrice = try c.decodeIfPresent(Double.self, forKey: .unitPrice)
        primaryImageID = try c.decodeIfPresent(UUID.self, forKey: .primaryImageID)
        imageIDs = try c.decodeIfPresent([UUID].self, forKey: .imageIDs) ?? []
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? .now
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? .now
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(kind, forKey: .kind)
        try c.encodeIfPresent(catalogItemID, forKey: .catalogItemID)
        try c.encode(name, forKey: .name)
        try c.encode(brand, forKey: .brand)
        try c.encode(supplier, forKey: .supplier)
        try c.encode(notes, forKey: .notes)
        try c.encode(quantity, forKey: .quantity)
        try c.encode(minimumQuantity, forKey: .minimumQuantity)
        try c.encodeIfPresent(wireRollSize, forKey: .wireRollSize)
        try c.encodeIfPresent(fertilizerQuantityUnit, forKey: .fertilizerQuantityUnit)
        try c.encodeIfPresent(unitPrice, forKey: .unitPrice)
        try c.encodeIfPresent(primaryImageID, forKey: .primaryImageID)
        try c.encode(imageIDs, forKey: .imageIDs)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(updatedAt, forKey: .updatedAt)
    }
}

struct NewInventoryStockDraft: Hashable, Sendable {
    var catalogItemID: UUID?
    var name: String = ""
    var brand: String = ""
    var supplier: String = ""
    var notes: String = ""
    var quantity: Double = 1
    var minimumQuantity: Double = 0
    var wireRollSize: InventoryWireRollSize? = .grams100
    var fertilizerQuantityUnit: InventoryFertilizerQuantityUnit? = .kg
    var unitPrice: Double?
    var primaryImageID: UUID?
    var imageIDs: [UUID] = []
}
