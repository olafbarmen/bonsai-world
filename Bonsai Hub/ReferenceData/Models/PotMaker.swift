//
//  PotMaker.swift
//  Bonsai World
//
//  Reference Data — Pot Maker / Potter. Always optional on a Pot.
//  Brand / Kiln is optional: a Maker may exist independently when no reliable
//  Brand/Kiln relationship is documented. Never created ad-hoc from New Pot.
//
//  "Maker / Potter" is deliberately neutral: a mark may represent an individual
//  potter, family, workshop, kiln, partnership, or other maker identity.
//

import Foundation

/// What kind of maker identity a Pot Maker / Potter record represents.
enum PotMakerType: String, Codable, Hashable, Sendable, CaseIterable {
    case individualPotter
    case partnership
    case family
    case workshop
    case kiln
    case unknown

    var title: String {
        switch self {
        case .individualPotter: "Individual Potter"
        case .partnership: "Partnership"
        case .family: "Family"
        case .workshop: "Workshop"
        case .kiln: "Kiln"
        case .unknown: "Unknown"
        }
    }
}

struct PotMaker: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    /// Optional Brand / Kiln. Nil when the maker is documented independently.
    var brandID: UUID?
    /// Normalized English country (or documented multi-country text). Used especially
    /// when ``brandID`` is nil; when a Brand is set, Brand.country is preferred in UI.
    var country: String
    var makerType: PotMakerType
    /// Optional generation / period. Empty unless reliably documented — never guessed.
    var generation: String
    var notes: String
    var stampReferenceImageIDs: [UUID]
    var stampKnown: PotStampKnowledge
    var stampDescription: String
    var stampIdentificationNotes: String
    var sourceName: String
    var sourceURL: String
    var verificationNotes: String
    var lastVerified: Date?
    var isSystemSeed: Bool
    var sortOrder: Int
    var isActive: Bool
    var createdDate: Date
    var modifiedDate: Date

    init(
        id: UUID = UUID(),
        name: String,
        brandID: UUID? = nil,
        country: String = "",
        makerType: PotMakerType = .unknown,
        generation: String = "",
        notes: String = "",
        stampReferenceImageIDs: [UUID] = [],
        stampKnown: PotStampKnowledge = .unknown,
        stampDescription: String = "",
        stampIdentificationNotes: String = "",
        sourceName: String = "",
        sourceURL: String = "",
        verificationNotes: String = "",
        lastVerified: Date? = nil,
        isSystemSeed: Bool = false,
        sortOrder: Int = 0,
        isActive: Bool = true,
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.name = name
        self.brandID = brandID
        self.country = country
        self.makerType = makerType
        self.generation = generation
        self.notes = notes
        self.stampReferenceImageIDs = stampReferenceImageIDs
        self.stampKnown = stampKnown
        self.stampDescription = stampDescription
        self.stampIdentificationNotes = stampIdentificationNotes
        self.sourceName = sourceName
        self.sourceURL = sourceURL
        self.verificationNotes = verificationNotes
        self.lastVerified = lastVerified
        self.isSystemSeed = isSystemSeed
        self.sortOrder = sortOrder
        self.isActive = isActive
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, brandID, country, makerType, generation, notes
        case stampReferenceImageIDs
        case stampKnown, stampDescription, stampIdentificationNotes
        case sourceName, sourceURL, verificationNotes, lastVerified
        case isSystemSeed
        case sortOrder, isActive, createdDate, modifiedDate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        brandID = try c.decodeIfPresent(UUID.self, forKey: .brandID)
        country = try c.decodeIfPresent(String.self, forKey: .country) ?? ""
        makerType = try c.decodeIfPresent(PotMakerType.self, forKey: .makerType) ?? .unknown
        generation = try c.decodeIfPresent(String.self, forKey: .generation) ?? ""
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        stampReferenceImageIDs = try c.decodeIfPresent([UUID].self, forKey: .stampReferenceImageIDs) ?? []
        stampKnown = try c.decodeIfPresent(PotStampKnowledge.self, forKey: .stampKnown) ?? .unknown
        stampDescription = try c.decodeIfPresent(String.self, forKey: .stampDescription) ?? ""
        stampIdentificationNotes = try c.decodeIfPresent(String.self, forKey: .stampIdentificationNotes) ?? ""
        sourceName = try c.decodeIfPresent(String.self, forKey: .sourceName) ?? ""
        sourceURL = try c.decodeIfPresent(String.self, forKey: .sourceURL) ?? ""
        verificationNotes = try c.decodeIfPresent(String.self, forKey: .verificationNotes) ?? ""
        lastVerified = try c.decodeIfPresent(Date.self, forKey: .lastVerified)
        isSystemSeed = try c.decodeIfPresent(Bool.self, forKey: .isSystemSeed) ?? false
        sortOrder = try c.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
        isActive = try c.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
        createdDate = try c.decodeIfPresent(Date.self, forKey: .createdDate) ?? .now
        modifiedDate = try c.decodeIfPresent(Date.self, forKey: .modifiedDate) ?? .now
    }
}

/// Editor draft for Add / Edit Pot Maker.
struct PotMakerDraft: Identifiable, Hashable, Sendable {
    var id: UUID
    var entityID: UUID?
    var name: String
    var brandID: UUID?
    var country: String
    var makerType: PotMakerType
    var generation: String
    var notes: String
    var stampReferenceImageIDs: [UUID]
    var stampKnown: PotStampKnowledge
    var stampDescription: String
    var stampIdentificationNotes: String
    var sourceName: String
    var sourceURL: String
    var verificationNotes: String
    var lastVerified: Date?
    var isSystemSeed: Bool
    var sortOrder: Int
    var isActive: Bool

    var isNew: Bool { entityID == nil }

    static func blank(brandID: UUID?, sortOrder: Int) -> PotMakerDraft {
        PotMakerDraft(
            id: UUID(),
            entityID: nil,
            name: "",
            brandID: brandID,
            country: "",
            makerType: .individualPotter,
            generation: "",
            notes: "",
            stampReferenceImageIDs: [],
            stampKnown: .unknown,
            stampDescription: "",
            stampIdentificationNotes: "",
            sourceName: "",
            sourceURL: "",
            verificationNotes: "",
            lastVerified: nil,
            isSystemSeed: false,
            sortOrder: sortOrder,
            isActive: true
        )
    }

    static func from(_ maker: PotMaker) -> PotMakerDraft {
        PotMakerDraft(
            id: UUID(),
            entityID: maker.id,
            name: maker.name,
            brandID: maker.brandID,
            country: maker.country,
            makerType: maker.makerType,
            generation: maker.generation,
            notes: maker.notes,
            stampReferenceImageIDs: maker.stampReferenceImageIDs,
            stampKnown: maker.stampKnown,
            stampDescription: maker.stampDescription,
            stampIdentificationNotes: maker.stampIdentificationNotes,
            sourceName: maker.sourceName,
            sourceURL: maker.sourceURL,
            verificationNotes: maker.verificationNotes,
            lastVerified: maker.lastVerified,
            isSystemSeed: maker.isSystemSeed,
            sortOrder: maker.sortOrder,
            isActive: maker.isActive
        )
    }
}
