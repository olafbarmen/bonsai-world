//
//  YamadoriQuickActionCommand.swift
//  Bonsai World
//

import Foundation

enum YamadoriQuickActionCommand: String, Hashable, Sendable {
    case editYamadori
    case addFind
    case addObservation
    case addImage
    case advanceStatus
    case markCollected
    case transferToTree
    case abandon
    case archive
    case deleteYamadori
    case cancel
}

struct YamadoriQuickActionRequest: Hashable, Sendable, Identifiable {
    let id: UUID
    let command: YamadoriQuickActionCommand

    init(command: YamadoriQuickActionCommand) {
        self.id = UUID()
        self.command = command
    }
}

enum YamadoriServiceError: Error, LocalizedError, Sendable {
    case codeIdentityLocked
    case invalidStatusTransition(from: YamadoriStatus, to: YamadoriStatus)
    case notEstablishedForTransfer
    case alreadyTransferred
    case genusAndSpeciesRequired
    case locationRequired
    case locationNotFound
    case acquisitionMethodRequired
    case treeStageRequired
    case bonsaiNameRequired

    var errorDescription: String? {
        switch self {
        case .codeIdentityLocked:
            return "Find code cannot be changed after create."
        case .invalidStatusTransition(let from, let to):
            return "Cannot move from \(from.title) to \(to.title)."
        case .notEstablishedForTransfer:
            return "Move to My Trees is available after the Find is collected."
        case .alreadyTransferred:
            return "This Find is already linked to a Tree."
        case .genusAndSpeciesRequired:
            return "Genus and Species are required before Transfer to Tree."
        case .locationRequired:
            return "Choose a garden Location for the new Tree."
        case .locationNotFound:
            return "That Location could not be found."
        case .acquisitionMethodRequired:
            return "Acquisition Method “Yamadori” is missing from Reference Data."
        case .treeStageRequired:
            return "Tree Stage “Yamadori – Newly Collected” is missing from Reference Data."
        case .bonsaiNameRequired:
            return "A Bonsai Name could not be generated. Check Genus and Species."
        }
    }
}
