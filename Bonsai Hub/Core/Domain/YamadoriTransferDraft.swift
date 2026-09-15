//
//  YamadoriTransferDraft.swift
//  Bonsai World
//

import Foundation

/// Inputs for Mark Collected — creates a Yamadori Tree at the chosen Location.
struct YamadoriCollectDraft: Hashable, Sendable {
    var locationID: UUID?
    var copyImages: Bool = true
    var collectionNotes: String = ""
}

/// Inputs for Move to My Trees (graduation). Location optional when updating an existing Tree.
struct YamadoriTransferDraft: Hashable, Sendable {
    var locationID: UUID?
    var nickname: String = ""
    var transferNotes: String = ""
    var copyImages: Bool = true
    /// Acquisition date on the new Tree — defaults to collection date or today in the service.
    var acquisitionDate: Date?
}

/// Editable Yamadori trip fields.
struct YamadoriTripDetailDraft: Hashable, Sendable {
    var displayName: String
    var tripDate: Date?
    var latitude: Double?
    var longitude: Double?
    var locationDescription: String
    var countryRegion: String
    var landOwnershipNotes: String
    var permissionNotes: String
    var siteKey: String
    var plannedCollectionDate: Date?
    var collectionWindowNotes: String
    var preparationNotes: String
    var equipmentNotes: String
    var collectionPlanNotes: String
    var notes: String

    init(from trip: Yamadori) {
        displayName = trip.displayName
        tripDate = trip.tripDate
        latitude = trip.latitude
        longitude = trip.longitude
        locationDescription = trip.locationDescription
        countryRegion = trip.countryRegion
        landOwnershipNotes = trip.landOwnershipNotes
        permissionNotes = trip.permissionNotes
        siteKey = trip.siteKey
        plannedCollectionDate = trip.plannedCollectionDate
        collectionWindowNotes = trip.collectionWindowNotes
        preparationNotes = trip.preparationNotes
        equipmentNotes = trip.equipmentNotes
        collectionPlanNotes = trip.collectionPlanNotes
        notes = trip.notes
    }
}

/// Editable Find fields (status / transfer / history stay outside Edit Mode).
struct YamadoriFindDetailDraft: Hashable, Sendable {
    var displayName: String
    var genusID: UUID?
    var speciesID: UUID?
    var cultivarID: UUID?
    var discoveryDate: Date?
    var latitude: Double?
    var longitude: Double?
    var evaluationTrunk: String
    var evaluationNebari: String
    var evaluationMovement: String
    var evaluationTaper: String
    var evaluationBranches: String
    var evaluationHealth: String
    var evaluationAccessibility: String
    var evaluationDifficulty: String
    var evaluationOverall: String
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
    var notes: String

    init(from find: YamadoriFind) {
        displayName = find.displayName
        genusID = find.genusID
        speciesID = find.speciesID
        cultivarID = find.cultivarID
        discoveryDate = find.discoveryDate
        latitude = find.latitude
        longitude = find.longitude
        evaluationTrunk = find.evaluationTrunk
        evaluationNebari = find.evaluationNebari
        evaluationMovement = find.evaluationMovement
        evaluationTaper = find.evaluationTaper
        evaluationBranches = find.evaluationBranches
        evaluationHealth = find.evaluationHealth
        evaluationAccessibility = find.evaluationAccessibility
        evaluationDifficulty = find.evaluationDifficulty
        evaluationOverall = find.evaluationOverall
        collectionDate = find.collectionDate
        collectionObservations = find.collectionObservations
        rootNotes = find.rootNotes
        transportNotes = find.transportNotes
        initialPlacement = find.initialPlacement
        initialRecoveryNotes = find.initialRecoveryNotes
        recoveryStartDate = find.recoveryStartDate
        recoveryLocationNotes = find.recoveryLocationNotes
        recoveryCareNotes = find.recoveryCareNotes
        establishmentAssessment = find.establishmentAssessment
        establishedDate = find.establishedDate
        notes = find.notes
    }
}

/// Backward-compatible alias used by older call sites during the split.
typealias YamadoriDetailDraft = YamadoriFindDetailDraft
