//
//  Pot.swift
//  BonsaiCore
//
//  Central domain entity for an individual pot — a first-class inventory object,
//  not a label on Tree. Mirrors Tree.swift shape and conventions.
//
//  Identity: name (optional grower label) + Pot Type (Reference Data).
//  Lifecycle: Available → In Use (linked to a Tree) → Sold / Broken / Retired.
//  Sold / Broken / Retired pots remain in the database — never deleted by lifecycle.
//  Delete stays reserved for mistaken / duplicate records (see PotService.deletePot).
//

import Foundation

/// How reliable the pot's production dating is. Never invent a year — leave
/// ``unknown`` when evidence is missing.
enum PotDatingConfidence: String, Codable, Hashable, Sendable, CaseIterable {
    case confirmed
    case estimated
    case unknown

    var title: String {
        switch self {
        case .confirmed: "Confirmed"
        case .estimated: "Estimated"
        case .unknown: "Unknown"
        }
    }
}

/// Where a Pot currently stands in its lifecycle.
enum PotStatus: String, Codable, Hashable, Sendable, CaseIterable {
    case available
    case inUse
    case sold
    case broken
    case retired

    var title: String {
        switch self {
        case .available: "Available"
        case .inUse: "In Use"
        case .sold: "Sold"
        case .broken: "Broken"
        case .retired: "Retired"
        }
    }

    /// Pots normally offered when assigning to a Tree.
    var isNormallyAvailable: Bool { self == .available }
}

/// One dated lifecycle event for a Pot (append-only — never rewritten).
struct PotHistoryEntry: Identifiable, Hashable, Sendable {
    enum Kind: String, Codable, Hashable, Sendable {
        case purchased
        case linkedToTree
        case unlinkedFromTree
        case sold
        case broken
        case retired
        case returnedToAvailable
        case created

        var title: String {
            switch self {
            case .purchased: "Purchased"
            case .linkedToTree: "Linked to Tree"
            case .unlinkedFromTree: "Unlinked from Tree"
            case .sold: "Sold"
            case .broken: "Broken"
            case .retired: "Retired"
            case .returnedToAvailable: "Returned to Available"
            case .created: "Added to Inventory"
            }
        }
    }

    var id: UUID
    var kind: Kind
    var date: Date
    /// Free-text detail (e.g. tree name, buyer, reason). Empty when not applicable.
    var note: String
    /// Tree involved in a link/unlink event, when known. Nil for non-relationship events
    /// and for history written before this field existed.
    var relatedTreeID: UUID?

    init(
        id: UUID = UUID(),
        kind: Kind,
        date: Date = .now,
        note: String = "",
        relatedTreeID: UUID? = nil
    ) {
        self.id = id
        self.kind = kind
        self.date = date
        self.note = note
        self.relatedTreeID = relatedTreeID
    }
}

extension PotHistoryEntry: Codable {
    enum CodingKeys: String, CodingKey {
        case id, kind, date, note, relatedTreeID
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        kind = try c.decode(Kind.self, forKey: .kind)
        date = try c.decode(Date.self, forKey: .date)
        note = try c.decodeIfPresent(String.self, forKey: .note) ?? ""
        relatedTreeID = try c.decodeIfPresent(UUID.self, forKey: .relatedTreeID)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(kind, forKey: .kind)
        try c.encode(date, forKey: .date)
        try c.encode(note, forKey: .note)
        try c.encodeIfPresent(relatedTreeID, forKey: .relatedTreeID)
    }
}

/// An individual pot in the grower's inventory.
struct Pot: Identifiable, Codable, Hashable, Sendable {

    // MARK: - Identity

    var id: UUID
    /// Optional grower-facing label (e.g. "Blue Yixing round #2"). Empty when unset.
    var name: String
    /// Reference Data — Pot Type.
    var potTypeID: UUID?
    /// Reference Data — Pot Brand. Optional — many pots have no known manufacturer.
    var brandID: UUID?
    /// Reference Data — Pot Maker / Potter. Optional — Maker is a refinement of Brand, never required.
    var makerID: UUID?
    /// Optional pot-specific generation / period (e.g. "3rd Generation", "Early Period", "1970s").
    /// When empty, Pot Detail falls back to the selected Maker's generation.
    var generationPeriod: String

    // MARK: - Dating / production

    /// Exact production year when known. Never invent — leave nil when unknown.
    var madeYear: Int?
    /// Earliest estimated production year (inclusive).
    var estimatedFromYear: Int?
    /// Latest estimated production year (inclusive).
    var estimatedToYear: Int?
    var datingConfidence: PotDatingConfidence
    /// Free-form notes explaining the dating evidence. Empty when unset.
    var datingNotes: String

    // MARK: - Physical

    var material: String
    var glaze: String
    var shape: String
    var lengthMillimetres: Int?
    var widthMillimetres: Int?
    var heightMillimetres: Int?
    var diameterMillimetres: Int?
    /// Free-text condition (e.g. "Excellent", "Hairline crack on rim").
    var condition: String

    // MARK: - Purchase

    var purchaseDate: Date?
    var purchasePrice: Decimal?
    var purchaseSellerName: String
    var purchaseNotes: String

    // MARK: - Lifecycle status

    var status: PotStatus

    // MARK: - Current use (Tree relationship)

    /// The Tree currently using this pot, if any. Owning side of Pot ↔ Tree is
    /// synchronized by PotService — never edit directly on Tree or Pot alone.
    var linkedTreeID: UUID?

    // MARK: - Sale (when status == .sold)

    var saleDate: Date?
    var salePrice: Decimal?
    var saleBuyerName: String
    var saleNotes: String

    // MARK: - Broken (when status == .broken)

    var brokenDate: Date?
    var brokenReason: String
    var brokenNotes: String

    // MARK: - Retired (when status == .retired)

    var retiredDate: Date?
    var retiredNotes: String

    // MARK: - Notes

    var notes: String

    // MARK: - Images (identifiers only — never absolute paths)

    var primaryImageID: UUID?
    /// Gallery order. May include `primaryImageID`.
    var imageIDs: [UUID]
    /// Photos of the actual stamp on THIS pot — logically separate from
    /// Brand/Maker Stamp References, even though both use ImageService.
    var stampImageIDs: [UUID]

    // MARK: - History (append-only lifecycle events)

    var history: [PotHistoryEntry]

    // MARK: - Metadata

    var createdDate: Date
    var modifiedDate: Date

    // MARK: - Init

    init(
        id: UUID = UUID(),
        name: String = "",
        potTypeID: UUID? = nil,
        brandID: UUID? = nil,
        makerID: UUID? = nil,
        generationPeriod: String = "",
        madeYear: Int? = nil,
        estimatedFromYear: Int? = nil,
        estimatedToYear: Int? = nil,
        datingConfidence: PotDatingConfidence = .unknown,
        datingNotes: String = "",
        material: String = "",
        glaze: String = "",
        shape: String = "",
        lengthMillimetres: Int? = nil,
        widthMillimetres: Int? = nil,
        heightMillimetres: Int? = nil,
        diameterMillimetres: Int? = nil,
        condition: String = "",
        purchaseDate: Date? = nil,
        purchasePrice: Decimal? = nil,
        purchaseSellerName: String = "",
        purchaseNotes: String = "",
        status: PotStatus = .available,
        linkedTreeID: UUID? = nil,
        saleDate: Date? = nil,
        salePrice: Decimal? = nil,
        saleBuyerName: String = "",
        saleNotes: String = "",
        brokenDate: Date? = nil,
        brokenReason: String = "",
        brokenNotes: String = "",
        retiredDate: Date? = nil,
        retiredNotes: String = "",
        notes: String = "",
        primaryImageID: UUID? = nil,
        imageIDs: [UUID] = [],
        stampImageIDs: [UUID] = [],
        history: [PotHistoryEntry] = [],
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.name = name
        self.potTypeID = potTypeID
        self.brandID = brandID
        self.makerID = makerID
        self.generationPeriod = generationPeriod
        self.madeYear = madeYear
        self.estimatedFromYear = estimatedFromYear
        self.estimatedToYear = estimatedToYear
        self.datingConfidence = datingConfidence
        self.datingNotes = datingNotes
        self.material = material
        self.glaze = glaze
        self.shape = shape
        self.lengthMillimetres = lengthMillimetres
        self.widthMillimetres = widthMillimetres
        self.heightMillimetres = heightMillimetres
        self.diameterMillimetres = diameterMillimetres
        self.condition = condition
        self.purchaseDate = purchaseDate
        self.purchasePrice = purchasePrice
        self.purchaseSellerName = purchaseSellerName
        self.purchaseNotes = purchaseNotes
        self.status = status
        self.linkedTreeID = linkedTreeID
        self.saleDate = saleDate
        self.salePrice = salePrice
        self.saleBuyerName = saleBuyerName
        self.saleNotes = saleNotes
        self.brokenDate = brokenDate
        self.brokenReason = brokenReason
        self.brokenNotes = brokenNotes
        self.retiredDate = retiredDate
        self.retiredNotes = retiredNotes
        self.notes = notes
        self.primaryImageID = primaryImageID
        self.imageIDs = imageIDs
        self.stampImageIDs = stampImageIDs
        self.history = history
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }

    /// Photo for pot lists: primary, otherwise the first gallery image.
    var listImageID: UUID? { primaryImageID ?? imageIDs.first }

    /// True when this pot is currently attached to a Tree.
    var isLinkedToTree: Bool { linkedTreeID != nil }

    // MARK: - Codable (additive fields default when missing so existing Pots.json stays valid)

    private enum CodingKeys: String, CodingKey {
        case id, name, potTypeID, brandID, makerID
        case generationPeriod
        case madeYear, estimatedFromYear, estimatedToYear, datingConfidence, datingNotes
        case material, glaze, shape
        case lengthMillimetres, widthMillimetres, heightMillimetres, diameterMillimetres
        case condition
        case purchaseDate, purchasePrice, purchaseSellerName, purchaseNotes
        case status, linkedTreeID
        case saleDate, salePrice, saleBuyerName, saleNotes
        case brokenDate, brokenReason, brokenNotes
        case retiredDate, retiredNotes
        case notes
        case primaryImageID, imageIDs, stampImageIDs
        case history
        case createdDate, modifiedDate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decodeIfPresent(String.self, forKey: .name) ?? ""
        potTypeID = try c.decodeIfPresent(UUID.self, forKey: .potTypeID)
        brandID = try c.decodeIfPresent(UUID.self, forKey: .brandID)
        makerID = try c.decodeIfPresent(UUID.self, forKey: .makerID)
        generationPeriod = try c.decodeIfPresent(String.self, forKey: .generationPeriod) ?? ""
        madeYear = try c.decodeIfPresent(Int.self, forKey: .madeYear)
        estimatedFromYear = try c.decodeIfPresent(Int.self, forKey: .estimatedFromYear)
        estimatedToYear = try c.decodeIfPresent(Int.self, forKey: .estimatedToYear)
        datingConfidence = try c.decodeIfPresent(PotDatingConfidence.self, forKey: .datingConfidence) ?? .unknown
        datingNotes = try c.decodeIfPresent(String.self, forKey: .datingNotes) ?? ""
        material = try c.decodeIfPresent(String.self, forKey: .material) ?? ""
        glaze = try c.decodeIfPresent(String.self, forKey: .glaze) ?? ""
        shape = try c.decodeIfPresent(String.self, forKey: .shape) ?? ""
        lengthMillimetres = try c.decodeIfPresent(Int.self, forKey: .lengthMillimetres)
        widthMillimetres = try c.decodeIfPresent(Int.self, forKey: .widthMillimetres)
        heightMillimetres = try c.decodeIfPresent(Int.self, forKey: .heightMillimetres)
        diameterMillimetres = try c.decodeIfPresent(Int.self, forKey: .diameterMillimetres)
        condition = try c.decodeIfPresent(String.self, forKey: .condition) ?? ""
        purchaseDate = try c.decodeIfPresent(Date.self, forKey: .purchaseDate)
        purchasePrice = try c.decodeIfPresent(Decimal.self, forKey: .purchasePrice)
        purchaseSellerName = try c.decodeIfPresent(String.self, forKey: .purchaseSellerName) ?? ""
        purchaseNotes = try c.decodeIfPresent(String.self, forKey: .purchaseNotes) ?? ""
        status = try c.decodeIfPresent(PotStatus.self, forKey: .status) ?? .available
        linkedTreeID = try c.decodeIfPresent(UUID.self, forKey: .linkedTreeID)
        saleDate = try c.decodeIfPresent(Date.self, forKey: .saleDate)
        salePrice = try c.decodeIfPresent(Decimal.self, forKey: .salePrice)
        saleBuyerName = try c.decodeIfPresent(String.self, forKey: .saleBuyerName) ?? ""
        saleNotes = try c.decodeIfPresent(String.self, forKey: .saleNotes) ?? ""
        brokenDate = try c.decodeIfPresent(Date.self, forKey: .brokenDate)
        brokenReason = try c.decodeIfPresent(String.self, forKey: .brokenReason) ?? ""
        brokenNotes = try c.decodeIfPresent(String.self, forKey: .brokenNotes) ?? ""
        retiredDate = try c.decodeIfPresent(Date.self, forKey: .retiredDate)
        retiredNotes = try c.decodeIfPresent(String.self, forKey: .retiredNotes) ?? ""
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        primaryImageID = try c.decodeIfPresent(UUID.self, forKey: .primaryImageID)
        imageIDs = try c.decodeIfPresent([UUID].self, forKey: .imageIDs) ?? []
        stampImageIDs = try c.decodeIfPresent([UUID].self, forKey: .stampImageIDs) ?? []
        history = try c.decodeIfPresent([PotHistoryEntry].self, forKey: .history) ?? []
        createdDate = try c.decodeIfPresent(Date.self, forKey: .createdDate) ?? .now
        modifiedDate = try c.decodeIfPresent(Date.self, forKey: .modifiedDate) ?? .now
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encodeIfPresent(potTypeID, forKey: .potTypeID)
        try c.encodeIfPresent(brandID, forKey: .brandID)
        try c.encodeIfPresent(makerID, forKey: .makerID)
        try c.encode(generationPeriod, forKey: .generationPeriod)
        try c.encodeIfPresent(madeYear, forKey: .madeYear)
        try c.encodeIfPresent(estimatedFromYear, forKey: .estimatedFromYear)
        try c.encodeIfPresent(estimatedToYear, forKey: .estimatedToYear)
        try c.encode(datingConfidence, forKey: .datingConfidence)
        try c.encode(datingNotes, forKey: .datingNotes)
        try c.encode(material, forKey: .material)
        try c.encode(glaze, forKey: .glaze)
        try c.encode(shape, forKey: .shape)
        try c.encodeIfPresent(lengthMillimetres, forKey: .lengthMillimetres)
        try c.encodeIfPresent(widthMillimetres, forKey: .widthMillimetres)
        try c.encodeIfPresent(heightMillimetres, forKey: .heightMillimetres)
        try c.encodeIfPresent(diameterMillimetres, forKey: .diameterMillimetres)
        try c.encode(condition, forKey: .condition)
        try c.encodeIfPresent(purchaseDate, forKey: .purchaseDate)
        try c.encodeIfPresent(purchasePrice, forKey: .purchasePrice)
        try c.encode(purchaseSellerName, forKey: .purchaseSellerName)
        try c.encode(purchaseNotes, forKey: .purchaseNotes)
        try c.encode(status, forKey: .status)
        try c.encodeIfPresent(linkedTreeID, forKey: .linkedTreeID)
        try c.encodeIfPresent(saleDate, forKey: .saleDate)
        try c.encodeIfPresent(salePrice, forKey: .salePrice)
        try c.encode(saleBuyerName, forKey: .saleBuyerName)
        try c.encode(saleNotes, forKey: .saleNotes)
        try c.encodeIfPresent(brokenDate, forKey: .brokenDate)
        try c.encode(brokenReason, forKey: .brokenReason)
        try c.encode(brokenNotes, forKey: .brokenNotes)
        try c.encodeIfPresent(retiredDate, forKey: .retiredDate)
        try c.encode(retiredNotes, forKey: .retiredNotes)
        try c.encode(notes, forKey: .notes)
        try c.encodeIfPresent(primaryImageID, forKey: .primaryImageID)
        try c.encode(imageIDs, forKey: .imageIDs)
        try c.encode(stampImageIDs, forKey: .stampImageIDs)
        try c.encode(history, forKey: .history)
        try c.encode(createdDate, forKey: .createdDate)
        try c.encode(modifiedDate, forKey: .modifiedDate)
    }
}
