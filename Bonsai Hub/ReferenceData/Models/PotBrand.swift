//
//  PotBrand.swift
//  Bonsai World
//
//  Reference Data — Pot Brand / Kiln (manufacturer / studio / kiln). User-managed via
//  Settings → Pot Brands & Makers. Never created ad-hoc from the New Pot sheet —
//  that would allow silent duplicates.
//
//  Brand and Maker are separate concepts (Maker is optional and belongs to a Brand).
//  Country is a normalized English name. Origin (e.g. Tokoname) is place/tradition —
//  never a synthetic Brand.
//

import Foundation

/// Whether a Pot Brand record is a commercial brand/studio or a kiln.
enum PotBrandKind: String, Codable, Hashable, Sendable, CaseIterable {
    case brand
    case kiln

    var title: String {
        switch self {
        case .brand: "Brand"
        case .kiln: "Kiln"
        }
    }
}

/// Whether identifying stamp / chop information is known for this record.
/// Does not imply Bonsai World owns stamp images — images are user-supplied only.
enum PotStampKnowledge: String, Codable, Hashable, Sendable, CaseIterable {
    case unknown
    case yes
    case no

    var title: String {
        switch self {
        case .unknown: "Unknown"
        case .yes: "Yes"
        case .no: "No"
        }
    }
}

struct PotBrand: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    /// Brand vs Kiln distinction. Defaults to Brand for existing records.
    var kind: PotBrandKind
    /// Normalized English country name (e.g. "Japan", "United Kingdom"). Empty when unset.
    var country: String
    /// Free-text region / tradition detail (e.g. "Tokoname"). Not a manufacturer name.
    var originText: String
    var notes: String
    /// Reference images of the brand generally (kiln, ware, catalog photos).
    var referenceImageIDs: [UUID]
    /// Known identifying stamps for this brand — separate from a specific pot's
    /// actual stamp photo (``Pot/stampImageIDs``).
    var stampReferenceImageIDs: [UUID]
    /// Whether stamp identity is documented. Images remain user-uploaded only.
    var stampKnown: PotStampKnowledge
    /// Short description of known stamps / chops (no external image copying).
    var stampDescription: String
    /// Identification notes for matching stamps on actual pots.
    var stampIdentificationNotes: String
    /// Research source label (internal quality control — not ownership of the source).
    var sourceName: String
    /// Research URL when available. Stored for curation; not presented as Bonsai World content.
    var sourceURL: String
    var verificationNotes: String
    var lastVerified: Date?
    /// True for curated seed rows. Users may still edit, archive, or extend.
    var isSystemSeed: Bool
    var sortOrder: Int
    var isActive: Bool
    var createdDate: Date
    var modifiedDate: Date

    init(
        id: UUID = UUID(),
        name: String,
        kind: PotBrandKind = .brand,
        country: String = "",
        originText: String = "",
        notes: String = "",
        referenceImageIDs: [UUID] = [],
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
        self.kind = kind
        self.country = country
        self.originText = originText
        self.notes = notes
        self.referenceImageIDs = referenceImageIDs
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
        case id, name, kind, country, originText, notes
        case referenceImageIDs, stampReferenceImageIDs
        case stampKnown, stampDescription, stampIdentificationNotes
        case sourceName, sourceURL, verificationNotes, lastVerified
        case isSystemSeed
        case sortOrder, isActive, createdDate, modifiedDate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        kind = try c.decodeIfPresent(PotBrandKind.self, forKey: .kind) ?? .brand
        country = try c.decodeIfPresent(String.self, forKey: .country) ?? ""
        originText = try c.decodeIfPresent(String.self, forKey: .originText) ?? ""
        notes = try c.decodeIfPresent(String.self, forKey: .notes) ?? ""
        referenceImageIDs = try c.decodeIfPresent([UUID].self, forKey: .referenceImageIDs) ?? []
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

/// Editor draft for Add / Edit Pot Brand.
struct PotBrandDraft: Identifiable, Hashable, Sendable {
    var id: UUID
    var entityID: UUID?
    var name: String
    var kind: PotBrandKind
    var country: String
    var originText: String
    var notes: String
    var referenceImageIDs: [UUID]
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

    static func blank(sortOrder: Int) -> PotBrandDraft {
        PotBrandDraft(
            id: UUID(),
            entityID: nil,
            name: "",
            kind: .brand,
            country: "",
            originText: "",
            notes: "",
            referenceImageIDs: [],
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

    static func from(_ brand: PotBrand) -> PotBrandDraft {
        PotBrandDraft(
            id: UUID(),
            entityID: brand.id,
            name: brand.name,
            kind: brand.kind,
            country: brand.country,
            originText: brand.originText,
            notes: brand.notes,
            referenceImageIDs: brand.referenceImageIDs,
            stampReferenceImageIDs: brand.stampReferenceImageIDs,
            stampKnown: brand.stampKnown,
            stampDescription: brand.stampDescription,
            stampIdentificationNotes: brand.stampIdentificationNotes,
            sourceName: brand.sourceName,
            sourceURL: brand.sourceURL,
            verificationNotes: brand.verificationNotes,
            lastVerified: brand.lastVerified,
            isSystemSeed: brand.isSystemSeed,
            sortOrder: brand.sortOrder,
            isActive: brand.isActive
        )
    }
}
