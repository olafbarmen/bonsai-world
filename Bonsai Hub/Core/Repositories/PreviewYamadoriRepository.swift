//
//  PreviewYamadoriRepository.swift
//  Bonsai World
//

import Foundation

@MainActor
final class PreviewYamadoriRepository: YamadoriRepository {
    private var trips: [Yamadori]
    private var finds: [YamadoriFind]

    init(trips: [Yamadori] = [], finds: [YamadoriFind] = []) {
        self.trips = trips
        self.finds = finds
    }

    /// Convenience for tests that only seed trips (no finds yet).
    convenience init(records: [Yamadori]) {
        self.init(trips: records, finds: [])
    }

    func getAllYamadori() -> [Yamadori] { trips }

    func getYamadori(id: UUID) -> Yamadori? {
        trips.first { $0.id == id }
    }

    func createYamadori(_ yamadori: Yamadori) throws -> Yamadori {
        guard getYamadori(id: yamadori.id) == nil else {
            throw YamadoriRepositoryError.duplicateID(yamadori.id)
        }
        trips.append(yamadori)
        return yamadori
    }

    func updateYamadori(_ yamadori: Yamadori) throws -> Yamadori {
        guard let index = trips.firstIndex(where: { $0.id == yamadori.id }) else {
            throw YamadoriRepositoryError.notFound(yamadori.id)
        }
        trips[index] = yamadori
        return yamadori
    }

    func deleteYamadori(id: UUID) throws {
        guard trips.contains(where: { $0.id == id }) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        trips.removeAll { $0.id == id }
        finds.removeAll { $0.yamadoriID == id }
    }

    func getAllFinds() -> [YamadoriFind] { finds }

    func getFind(id: UUID) -> YamadoriFind? {
        finds.first { $0.id == id }
    }

    func finds(forYamadoriID yamadoriID: UUID) -> [YamadoriFind] {
        finds.filter { $0.yamadoriID == yamadoriID }
    }

    func createFind(_ find: YamadoriFind) throws -> YamadoriFind {
        guard getYamadori(id: find.yamadoriID) != nil else {
            throw YamadoriRepositoryError.notFound(find.yamadoriID)
        }
        guard getFind(id: find.id) == nil else {
            throw YamadoriRepositoryError.duplicateID(find.id)
        }
        finds.append(find)
        return find
    }

    func updateFind(_ find: YamadoriFind) throws -> YamadoriFind {
        guard let index = finds.firstIndex(where: { $0.id == find.id }) else {
            throw YamadoriRepositoryError.notFound(find.id)
        }
        finds[index] = find
        return find
    }

    func deleteFind(id: UUID) throws {
        guard finds.contains(where: { $0.id == id }) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        finds.removeAll { $0.id == id }
    }
}
