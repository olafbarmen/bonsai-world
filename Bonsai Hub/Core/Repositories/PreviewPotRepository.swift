//
//  PreviewPotRepository.swift
//  Bonsai World
//
//  PotRepository backed by an in-memory array only.
//  Used before a Library is open (first launch) and for SwiftUI #Preview fixtures —
//  not the runtime store once a library is ready. Pot has no legacy data to migrate,
//  so there is nothing to seed here beyond an empty session.
//

import Foundation
import Observation

/// In-memory `PotRepository` for previews and pre-library sessions.
@Observable
@MainActor
final class PreviewPotRepository: PotRepository {
    private var pots: [Pot]

    init(pots: [Pot] = []) {
        self.pots = pots
    }

    func getAllPots() -> [Pot] {
        pots
    }

    func getPot(id: UUID) -> Pot? {
        pots.first { $0.id == id }
    }

    @discardableResult
    func createPot(_ pot: Pot) throws -> Pot {
        guard !pots.contains(where: { $0.id == pot.id }) else {
            throw PotRepositoryError.invalidPot("A pot with this id already exists.")
        }
        pots.append(pot)
        return pot
    }

    @discardableResult
    func updatePot(_ pot: Pot) throws -> Pot {
        guard let index = pots.firstIndex(where: { $0.id == pot.id }) else {
            throw PotRepositoryError.notFound(pot.id)
        }
        pots[index] = pot
        return pot
    }

    func deletePot(id: UUID) throws {
        guard pots.contains(where: { $0.id == id }) else {
            throw PotRepositoryError.notFound(id)
        }
        pots.removeAll { $0.id == id }
    }
}
