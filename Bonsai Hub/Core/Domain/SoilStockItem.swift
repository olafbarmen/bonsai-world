//
//  SoilStockItem.swift
//  Bonsai World
//
//  Physical soil inventory line. Catalog identity lives in Settings
//  (SoilComponent). This record is bag-based stock status only.
//  Estimated quantity is approximate between stocktakes — never auto-deducted.
//

import Foundation

struct SoilStocktakeRecord: Identifiable, Hashable, Codable, Sendable {
    var id: UUID
    var date: Date
    var estimatedVolumeLiters: Double
    var actualVolumeLiters: Double
    var notes: String

    init(
        id: UUID = UUID(),
        date: Date = .now,
        estimatedVolumeLiters: Double,
        actualVolumeLiters: Double,
        notes: String = ""
    ) {
        self.id = id
        self.date = date
        self.estimatedVolumeLiters = estimatedVolumeLiters
        self.actualVolumeLiters = actualVolumeLiters
        self.notes = notes
    }

    var differenceLiters: Double {
        actualVolumeLiters - estimatedVolumeLiters
    }
}

enum SoilStocktakeFrequency: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case monthly
    case quarterly
    case everySixMonths
    case yearly
    case custom

    var id: Self { self }

    var title: String {
        switch self {
        case .monthly: "Monthly"
        case .quarterly: "Quarterly"
        case .everySixMonths: "Every 6 months"
        case .yearly: "Yearly"
        case .custom: "Custom"
        }
    }

    func intervalDays(customDays: Int) -> Int {
        switch self {
        case .monthly: 30
        case .quarterly: 91
        case .everySixMonths: 182
        case .yearly: 365
        case .custom: max(1, customDays)
        }
    }
}

/// One owned material in Inventory → Soil → Stock.
struct SoilStockItem: Identifiable, Hashable, Sendable {
    var id: UUID
    /// Settings → Reference Data → Soil Components.
    var componentID: UUID
    var brand: String
    var supplier: String
    var batchReference: String
    var notes: String
    var grainSize: SoilGrainSize
    /// Litres per unopened bag.
    var bagSizeLiters: Double
    /// Count of unopened (or counted) bags.
    var bagCount: Double
    /// Litres remaining in a started bag. Optional — most growers only count bags.
    var openBagRemainingLiters: Double
    var minimumStockLiters: Double
    var purchasePricePerBag: Double?
    var purchaseDate: Date?
    /// Last confirmed physical count. Distinct from estimated volume.
    var lastActualVolumeLiters: Double?
    var lastStocktakeDate: Date?
    var stocktakes: [SoilStocktakeRecord]
    /// Primary gallery photo for list / Identity.
    var primaryImageID: UUID?
    /// Gallery order. May include `primaryImageID`.
    var imageIDs: [UUID]
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        componentID: UUID,
        brand: String = "",
        supplier: String = "",
        batchReference: String = "",
        notes: String = "",
        grainSize: SoilGrainSize = SoilGrainSize(),
        bagSizeLiters: Double,
        bagCount: Double,
        openBagRemainingLiters: Double = 0,
        minimumStockLiters: Double = 0,
        purchasePricePerBag: Double? = nil,
        purchaseDate: Date? = nil,
        lastActualVolumeLiters: Double? = nil,
        lastStocktakeDate: Date? = nil,
        stocktakes: [SoilStocktakeRecord] = [],
        primaryImageID: UUID? = nil,
        imageIDs: [UUID] = [],
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.componentID = componentID
        self.brand = brand
        self.supplier = supplier
        self.batchReference = batchReference
        self.notes = notes
        self.grainSize = grainSize
        self.bagSizeLiters = bagSizeLiters
        self.bagCount = bagCount
        self.openBagRemainingLiters = openBagRemainingLiters
        self.minimumStockLiters = minimumStockLiters
        self.purchasePricePerBag = purchasePricePerBag
        self.purchaseDate = purchaseDate
        self.lastActualVolumeLiters = lastActualVolumeLiters
        self.lastStocktakeDate = lastStocktakeDate
        self.stocktakes = stocktakes
        self.primaryImageID = primaryImageID
        self.imageIDs = imageIDs
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var listImageID: UUID? { primaryImageID ?? imageIDs.first }

    /// Approximate volume from bag counts. Not updated by mixing or repotting.
    var estimatedVolumeLiters: Double {
        max(0, bagCount) * max(0, bagSizeLiters) + max(0, openBagRemainingLiters)
    }

    var isLowStock: Bool {
        minimumStockLiters > 0 && estimatedVolumeLiters < minimumStockLiters
    }

    var stockStatusTitle: String {
        isLowStock ? "Low" : "OK"
    }

    func applyingStocktake(actualVolumeLiters: Double, date: Date = .now, notes: String = "") -> SoilStockItem {
        var next = self
        let estimated = estimatedVolumeLiters
        let record = SoilStocktakeRecord(
            date: date,
            estimatedVolumeLiters: estimated,
            actualVolumeLiters: actualVolumeLiters,
            notes: notes
        )
        next.stocktakes.insert(record, at: 0)
        next.lastActualVolumeLiters = actualVolumeLiters
        next.lastStocktakeDate = date
        next.rebaseBags(toVolumeLiters: actualVolumeLiters)
        next.updatedAt = date
        return next
    }

    /// After a count, bags become the new estimated baseline (no consumption ledger).
    mutating func rebaseBags(toVolumeLiters volume: Double) {
        let size = max(0, bagSizeLiters)
        let clamped = max(0, volume)
        guard size > 0 else {
            bagCount = 0
            openBagRemainingLiters = clamped
            return
        }
        let fullBags = floor(clamped / size)
        bagCount = fullBags
        openBagRemainingLiters = (clamped - fullBags * size).rounded(toPlaces: 2)
    }
}

extension SoilStockItem: Codable {
    enum CodingKeys: String, CodingKey {
        case id, componentID, brand, supplier, batchReference, notes, grainSize
        case bagSizeLiters, bagCount, openBagRemainingLiters, minimumStockLiters
        case purchasePricePerBag, purchaseDate, lastActualVolumeLiters, lastStocktakeDate
        case stocktakes, primaryImageID, imageIDs, createdAt, updatedAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        componentID = try c.decode(UUID.self, forKey: .componentID)
        brand = try c.decodeIfPresent(String.self, forKey: .brand) ?? ""
        supplier = try c.decodeIfPresent(String.self, forKey: .supplier) ?? ""
        batchReference = try c.decodeIfPresent(String.self, forKey: .batchReference) ?? ""
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        grainSize = try c.decodeIfPresent(SoilGrainSize.self, forKey: .grainSize) ?? SoilGrainSize()
        bagSizeLiters = try c.decode(Double.self, forKey: .bagSizeLiters)
        bagCount = try c.decode(Double.self, forKey: .bagCount)
        openBagRemainingLiters = try c.decodeIfPresent(Double.self, forKey: .openBagRemainingLiters) ?? 0
        minimumStockLiters = try c.decodeIfPresent(Double.self, forKey: .minimumStockLiters) ?? 0
        purchasePricePerBag = try c.decodeIfPresent(Double.self, forKey: .purchasePricePerBag)
        purchaseDate = try c.decodeIfPresent(Date.self, forKey: .purchaseDate)
        lastActualVolumeLiters = try c.decodeIfPresent(Double.self, forKey: .lastActualVolumeLiters)
        lastStocktakeDate = try c.decodeIfPresent(Date.self, forKey: .lastStocktakeDate)
        stocktakes = try c.decodeIfPresent([SoilStocktakeRecord].self, forKey: .stocktakes) ?? []
        primaryImageID = try c.decodeIfPresent(UUID.self, forKey: .primaryImageID)
        imageIDs = try c.decodeIfPresent([UUID].self, forKey: .imageIDs) ?? []
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? .now
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? .now
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(componentID, forKey: .componentID)
        try c.encode(brand, forKey: .brand)
        try c.encode(supplier, forKey: .supplier)
        try c.encode(batchReference, forKey: .batchReference)
        try c.encode(notes, forKey: .notes)
        try c.encode(grainSize, forKey: .grainSize)
        try c.encode(bagSizeLiters, forKey: .bagSizeLiters)
        try c.encode(bagCount, forKey: .bagCount)
        try c.encode(openBagRemainingLiters, forKey: .openBagRemainingLiters)
        try c.encode(minimumStockLiters, forKey: .minimumStockLiters)
        try c.encodeIfPresent(purchasePricePerBag, forKey: .purchasePricePerBag)
        try c.encodeIfPresent(purchaseDate, forKey: .purchaseDate)
        try c.encodeIfPresent(lastActualVolumeLiters, forKey: .lastActualVolumeLiters)
        try c.encodeIfPresent(lastStocktakeDate, forKey: .lastStocktakeDate)
        try c.encode(stocktakes, forKey: .stocktakes)
        try c.encodeIfPresent(primaryImageID, forKey: .primaryImageID)
        try c.encode(imageIDs, forKey: .imageIDs)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(updatedAt, forKey: .updatedAt)
    }
}

private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let factor = pow(10.0, Double(places))
        return (self * factor).rounded() / factor
    }
}

struct SoilInventoryPreferences: Hashable, Codable, Sendable {
    var stocktakeFrequency: SoilStocktakeFrequency
    var customStocktakeIntervalDays: Int
    var lastLibraryStocktakeDate: Date?

    init(
        stocktakeFrequency: SoilStocktakeFrequency = .monthly,
        customStocktakeIntervalDays: Int = 30,
        lastLibraryStocktakeDate: Date? = nil
    ) {
        self.stocktakeFrequency = stocktakeFrequency
        self.customStocktakeIntervalDays = customStocktakeIntervalDays
        self.lastLibraryStocktakeDate = lastLibraryStocktakeDate
    }

    var intervalDays: Int {
        stocktakeFrequency.intervalDays(customDays: customStocktakeIntervalDays)
    }

    func isStocktakeDue(now: Date = .now) -> Bool {
        guard let last = lastLibraryStocktakeDate else { return true }
        let deadline = Calendar.current.date(byAdding: .day, value: intervalDays, to: last) ?? last
        return now >= deadline
    }
}

struct SoilInventorySummary: Hashable, Sendable {
    var materialCount: Int
    var estimatedVolumeLiters: Double
    var lowStockCount: Int
    var lastStocktakeDate: Date?
}
