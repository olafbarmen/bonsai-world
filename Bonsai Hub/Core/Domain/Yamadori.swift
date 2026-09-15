//
//  Yamadori.swift
//  Bonsai World
//
//  Yamadori = trip / activity. YamadoriFind = specimen on that trip.
//  Status and Transfer live on the Find. Many Finds per Yamadori.
//  See Product Blueprint §5.10.
//

import Foundation

/// Find workflow status. Distinct from Tree Stage / Tree lifecycle.
enum YamadoriStatus: String, Codable, Hashable, Sendable, CaseIterable {
    case scout
    case planned
    case collected
    case recovery
    case established
    case transferred
    case abandoned
    case archived

    var title: String {
        switch self {
        case .scout: "Uncollected"
        case .planned: "Planned"
        case .collected: "Collected"
        case .recovery: "Recovery"
        case .established: "Established"
        case .transferred: "Transferred"
        case .abandoned: "Abandoned"
        case .archived: "Archived"
        }
    }

    /// Pre-collection Finds shown under Uncollected Findings (and matching Image Library filter).
    var isUncollected: Bool {
        switch self {
        case .scout, .planned: true
        default: false
        }
    }

    /// Eligible for Move to My Trees (manual confirmation still required).
    var canTransferToTree: Bool {
        switch self {
        case .collected, .recovery, .established: true
        default: false
        }
    }

    /// Terminal-ish states that are not active field work.
    var isClosed: Bool {
        switch self {
        case .transferred, .abandoned, .archived: true
        default: false
        }
    }
}

/// Append-only field / recovery observation (on a Find).
struct YamadoriObservation: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var date: Date
    var text: String
    /// Optional category label (free text — not a forced taxonomy).
    var category: String
    var imageIDs: [UUID]

    init(
        id: UUID = UUID(),
        date: Date = .now,
        text: String = "",
        category: String = "",
        imageIDs: [UUID] = []
    ) {
        self.id = id
        self.date = date
        self.text = text
        self.category = category
        self.imageIDs = imageIDs
    }
}

struct YamadoriChecklistItem: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var title: String
    var isComplete: Bool

    init(id: UUID = UUID(), title: String, isComplete: Bool = false) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
    }
}

struct YamadoriHistoryEntry: Identifiable, Codable, Hashable, Sendable {
    enum Kind: String, Codable, Hashable, Sendable {
        case created
        case statusChanged
        case collected
        case recoveryStarted
        case established
        case transferred
        case abandoned
        case archived
        case observationAdded

        var title: String {
            switch self {
            case .created: "Created"
            case .statusChanged: "Status Changed"
            case .collected: "Collected"
            case .recoveryStarted: "Recovery Started"
            case .established: "Marked Established"
            case .transferred: "Transferred to Tree"
            case .abandoned: "Abandoned"
            case .archived: "Archived"
            case .observationAdded: "Observation Added"
            }
        }
    }

    var id: UUID
    var kind: Kind
    var date: Date
    var note: String

    init(id: UUID = UUID(), kind: Kind, date: Date = .now, note: String = "") {
        self.id = id
        self.kind = kind
        self.date = date
        self.note = note
    }
}

/// A Yamadori trip / activity — shell for one or more Finds.
struct Yamadori: Identifiable, Codable, Hashable, Sendable {

    // MARK: - Identity

    var id: UUID
    var displayName: String
    var tripDate: Date?
    var createdDate: Date
    var modifiedDate: Date

    // MARK: - Origin / location

    var latitude: Double?
    var longitude: Double?
    var locationDescription: String
    var countryRegion: String
    var landOwnershipNotes: String
    var permissionNotes: String
    /// Opaque future Site key — not a full Site subsystem.
    var siteKey: String

    // MARK: - Collection planning (trip-level)

    var plannedCollectionDate: Date?
    var collectionWindowNotes: String
    var preparationNotes: String
    var equipmentNotes: String
    var collectionPlanNotes: String
    var preCollectionChecklist: [YamadoriChecklistItem]
    var collectionKitChecklist: [YamadoriChecklistItem]

    // MARK: - Media & notes

    var primaryImageID: UUID?
    var imageIDs: [UUID]
    var notes: String

    // MARK: - Init

    init(
        id: UUID = UUID(),
        displayName: String = "",
        tripDate: Date? = .now,
        createdDate: Date = .now,
        modifiedDate: Date = .now,
        latitude: Double? = nil,
        longitude: Double? = nil,
        locationDescription: String = "",
        countryRegion: String = "",
        landOwnershipNotes: String = "",
        permissionNotes: String = "",
        siteKey: String = "",
        plannedCollectionDate: Date? = nil,
        collectionWindowNotes: String = "",
        preparationNotes: String = "",
        equipmentNotes: String = "",
        collectionPlanNotes: String = "",
        preCollectionChecklist: [YamadoriChecklistItem] = YamadoriChecklistDefaults.preCollection,
        collectionKitChecklist: [YamadoriChecklistItem] = YamadoriChecklistDefaults.collectionKit,
        primaryImageID: UUID? = nil,
        imageIDs: [UUID] = [],
        notes: String = ""
    ) {
        self.id = id
        self.displayName = displayName
        self.tripDate = tripDate
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.latitude = latitude
        self.longitude = longitude
        self.locationDescription = locationDescription
        self.countryRegion = countryRegion
        self.landOwnershipNotes = landOwnershipNotes
        self.permissionNotes = permissionNotes
        self.siteKey = siteKey
        self.plannedCollectionDate = plannedCollectionDate
        self.collectionWindowNotes = collectionWindowNotes
        self.preparationNotes = preparationNotes
        self.equipmentNotes = equipmentNotes
        self.collectionPlanNotes = collectionPlanNotes
        self.preCollectionChecklist = preCollectionChecklist
        self.collectionKitChecklist = collectionKitChecklist
        self.primaryImageID = primaryImageID
        self.imageIDs = imageIDs
        self.notes = notes
    }

    var listImageID: UUID? { primaryImageID ?? imageIDs.first }

    var hasCoordinates: Bool { latitude != nil && longitude != nil }
}

/// One wild-material Find on a Yamadori trip. Owns status and Transfer to Tree.
struct YamadoriFind: Identifiable, Codable, Hashable, Sendable {

    // MARK: - Identity

    var id: UUID
    /// Parent trip.
    var yamadoriID: UUID
    /// Immutable display code, e.g. `YAM-2026-024`. Never reused as Tree ID.
    var yamadoriCode: String
    var displayName: String
    var genusID: UUID?
    var speciesID: UUID?
    var cultivarID: UUID?
    var status: YamadoriStatus
    var createdDate: Date
    var modifiedDate: Date
    var discoveryDate: Date?

    // MARK: - Precise site (Find-level; trip Wild Site is area-level)

    var latitude: Double?
    var longitude: Double?

    // MARK: - Evaluation (text, not scores)

    var evaluationTrunk: String
    var evaluationNebari: String
    var evaluationMovement: String
    var evaluationTaper: String
    var evaluationBranches: String
    var evaluationHealth: String
    var evaluationAccessibility: String
    var evaluationDifficulty: String
    var evaluationOverall: String

    // MARK: - Collection

    var collectionDate: Date?
    var collectionObservations: String
    var rootNotes: String
    var transportNotes: String
    var initialPlacement: String
    var initialRecoveryNotes: String

    // MARK: - Recovery / establishment

    var recoveryStartDate: Date?
    var recoveryLocationNotes: String
    var recoveryCareNotes: String
    var establishmentAssessment: String
    var establishedDate: Date?

    // MARK: - Transfer

    var transferDate: Date?
    var linkedTreeID: UUID?
    var transferNotes: String

    // MARK: - Media & timeline

    var primaryImageID: UUID?
    var imageIDs: [UUID]
    var observations: [YamadoriObservation]
    var history: [YamadoriHistoryEntry]
    var notes: String

    // MARK: - Init

    init(
        id: UUID = UUID(),
        yamadoriID: UUID,
        yamadoriCode: String,
        displayName: String = "",
        genusID: UUID? = nil,
        speciesID: UUID? = nil,
        cultivarID: UUID? = nil,
        status: YamadoriStatus = .scout,
        createdDate: Date = .now,
        modifiedDate: Date = .now,
        discoveryDate: Date? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        evaluationTrunk: String = "",
        evaluationNebari: String = "",
        evaluationMovement: String = "",
        evaluationTaper: String = "",
        evaluationBranches: String = "",
        evaluationHealth: String = "",
        evaluationAccessibility: String = "",
        evaluationDifficulty: String = "",
        evaluationOverall: String = "",
        collectionDate: Date? = nil,
        collectionObservations: String = "",
        rootNotes: String = "",
        transportNotes: String = "",
        initialPlacement: String = "",
        initialRecoveryNotes: String = "",
        recoveryStartDate: Date? = nil,
        recoveryLocationNotes: String = "",
        recoveryCareNotes: String = "",
        establishmentAssessment: String = "",
        establishedDate: Date? = nil,
        transferDate: Date? = nil,
        linkedTreeID: UUID? = nil,
        transferNotes: String = "",
        primaryImageID: UUID? = nil,
        imageIDs: [UUID] = [],
        observations: [YamadoriObservation] = [],
        history: [YamadoriHistoryEntry] = [],
        notes: String = ""
    ) {
        self.id = id
        self.yamadoriID = yamadoriID
        self.yamadoriCode = yamadoriCode
        self.displayName = displayName
        self.genusID = genusID
        self.speciesID = speciesID
        self.cultivarID = cultivarID
        self.status = status
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.discoveryDate = discoveryDate
        self.latitude = latitude
        self.longitude = longitude
        self.evaluationTrunk = evaluationTrunk
        self.evaluationNebari = evaluationNebari
        self.evaluationMovement = evaluationMovement
        self.evaluationTaper = evaluationTaper
        self.evaluationBranches = evaluationBranches
        self.evaluationHealth = evaluationHealth
        self.evaluationAccessibility = evaluationAccessibility
        self.evaluationDifficulty = evaluationDifficulty
        self.evaluationOverall = evaluationOverall
        self.collectionDate = collectionDate
        self.collectionObservations = collectionObservations
        self.rootNotes = rootNotes
        self.transportNotes = transportNotes
        self.initialPlacement = initialPlacement
        self.initialRecoveryNotes = initialRecoveryNotes
        self.recoveryStartDate = recoveryStartDate
        self.recoveryLocationNotes = recoveryLocationNotes
        self.recoveryCareNotes = recoveryCareNotes
        self.establishmentAssessment = establishmentAssessment
        self.establishedDate = establishedDate
        self.transferDate = transferDate
        self.linkedTreeID = linkedTreeID
        self.transferNotes = transferNotes
        self.primaryImageID = primaryImageID
        self.imageIDs = imageIDs
        self.observations = observations
        self.history = history
        self.notes = notes
    }

    var listImageID: UUID? { primaryImageID ?? imageIDs.first }

    var hasCoordinates: Bool { latitude != nil && longitude != nil }
}

enum YamadoriChecklistDefaults {
    static var preCollection: [YamadoriChecklistItem] {
        [
            "Permission confirmed",
            "Tree inspected",
            "Root zone assessed",
            "Collection timing reviewed",
            "Weather considered",
            "Transport planned",
            "Container prepared",
            "Recovery location prepared",
        ].map { YamadoriChecklistItem(title: $0) }
    }

    static var collectionKit: [YamadoriChecklistItem] {
        [
            "Spade",
            "Saw",
            "Pruning tools",
            "Tie material",
            "Protection material",
            "Water",
            "Transport container",
            "Labels",
            "Camera / phone",
        ].map { YamadoriChecklistItem(title: $0) }
    }
}

// MARK: - Legacy v1 record (fat project) for migration

/// Pre–trip/Find split Yamadori shape. Decode-only for `Database/Yamadori.json` v1.
struct LegacyYamadoriRecord: Codable, Sendable {
    var id: UUID
    var yamadoriCode: String
    var displayName: String
    var genusID: UUID?
    var speciesID: UUID?
    var cultivarID: UUID?
    var status: YamadoriStatus
    var createdDate: Date
    var modifiedDate: Date
    var latitude: Double?
    var longitude: Double?
    var locationDescription: String
    var countryRegion: String
    var landOwnershipNotes: String
    var permissionNotes: String
    var discoveryDate: Date?
    var siteKey: String
    var evaluationTrunk: String
    var evaluationNebari: String
    var evaluationMovement: String
    var evaluationTaper: String
    var evaluationBranches: String
    var evaluationHealth: String
    var evaluationAccessibility: String
    var evaluationDifficulty: String
    var evaluationOverall: String
    var plannedCollectionDate: Date?
    var collectionWindowNotes: String
    var preparationNotes: String
    var equipmentNotes: String
    var collectionPlanNotes: String
    var preCollectionChecklist: [YamadoriChecklistItem]
    var collectionKitChecklist: [YamadoriChecklistItem]
    var collectionDate: Date?
    var collectionObservations: String
    var rootNotes: String
    var transportNotes: String
    var initialPlacement: String
    var initialRecoveryNotes: String
    var recoveryStartDate: Date?
    var recoveryLocationNotes: String
    var recoveryCareNotes: String
    var establishmentAssessment: String
    var establishedDate: Date?
    var transferDate: Date?
    var linkedTreeID: UUID?
    var transferNotes: String
    var primaryImageID: UUID?
    var imageIDs: [UUID]
    var observations: [YamadoriObservation]
    var history: [YamadoriHistoryEntry]
    var notes: String

    func migratedTripAndFind() -> (Yamadori, YamadoriFind) {
        let tripID = UUID()
        let trip = Yamadori(
            id: tripID,
            displayName: displayName.isEmpty ? yamadoriCode : displayName,
            tripDate: discoveryDate ?? collectionDate ?? createdDate,
            createdDate: createdDate,
            modifiedDate: modifiedDate,
            latitude: latitude,
            longitude: longitude,
            locationDescription: locationDescription,
            countryRegion: countryRegion,
            landOwnershipNotes: landOwnershipNotes,
            permissionNotes: permissionNotes,
            siteKey: siteKey,
            plannedCollectionDate: plannedCollectionDate,
            collectionWindowNotes: collectionWindowNotes,
            preparationNotes: preparationNotes,
            equipmentNotes: equipmentNotes,
            collectionPlanNotes: collectionPlanNotes,
            preCollectionChecklist: preCollectionChecklist,
            collectionKitChecklist: collectionKitChecklist,
            primaryImageID: nil,
            imageIDs: [],
            notes: ""
        )
        // Preserve original UUID on the Find so Tree.sourceYamadoriID stays valid.
        let find = YamadoriFind(
            id: id,
            yamadoriID: tripID,
            yamadoriCode: yamadoriCode,
            displayName: displayName,
            genusID: genusID,
            speciesID: speciesID,
            cultivarID: cultivarID,
            status: status,
            createdDate: createdDate,
            modifiedDate: modifiedDate,
            discoveryDate: discoveryDate,
            evaluationTrunk: evaluationTrunk,
            evaluationNebari: evaluationNebari,
            evaluationMovement: evaluationMovement,
            evaluationTaper: evaluationTaper,
            evaluationBranches: evaluationBranches,
            evaluationHealth: evaluationHealth,
            evaluationAccessibility: evaluationAccessibility,
            evaluationDifficulty: evaluationDifficulty,
            evaluationOverall: evaluationOverall,
            collectionDate: collectionDate,
            collectionObservations: collectionObservations,
            rootNotes: rootNotes,
            transportNotes: transportNotes,
            initialPlacement: initialPlacement,
            initialRecoveryNotes: initialRecoveryNotes,
            recoveryStartDate: recoveryStartDate,
            recoveryLocationNotes: recoveryLocationNotes,
            recoveryCareNotes: recoveryCareNotes,
            establishmentAssessment: establishmentAssessment,
            establishedDate: establishedDate,
            transferDate: transferDate,
            linkedTreeID: linkedTreeID,
            transferNotes: transferNotes,
            primaryImageID: primaryImageID,
            imageIDs: imageIDs,
            observations: observations,
            history: history,
            notes: notes
        )
        return (trip, find)
    }
}
