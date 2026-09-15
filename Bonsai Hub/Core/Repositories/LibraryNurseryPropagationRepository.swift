//
//  LibraryNurseryPropagationRepository.swift
//  Bonsai World
//

import Foundation
import Observation

struct LibraryNurseryPropagationFile: Codable, Hashable, Sendable {
    var schemaVersion: Int
    var projects: [NurseryPropagationProject]

    init(schemaVersion: Int = 1, projects: [NurseryPropagationProject] = []) {
        self.schemaVersion = schemaVersion
        self.projects = projects
    }
}

@Observable
@MainActor
final class LibraryNurseryPropagationRepository: NurseryPropagationRepository {
    private let storage: StorageService
    private var projects: [NurseryPropagationProject] = []
    private var didLoad = false

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllProjects() -> [NurseryPropagationProject] {
        ensureLoaded()
        return projects
    }

    func getProject(id: UUID) -> NurseryPropagationProject? {
        ensureLoaded()
        return projects.first { $0.id == id }
    }

    func createProject(_ project: NurseryPropagationProject) throws -> NurseryPropagationProject {
        ensureLoaded()
        guard !projects.contains(where: { $0.id == project.id }) else {
            throw NurseryPropagationRepositoryError.duplicateID(project.id)
        }
        projects.append(project)
        try persist()
        return project
    }

    func updateProject(_ project: NurseryPropagationProject) throws -> NurseryPropagationProject {
        ensureLoaded()
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
            throw NurseryPropagationRepositoryError.notFound(project.id)
        }
        projects[index] = project
        try persist()
        return project
    }

    func deleteProject(id: UUID) throws {
        ensureLoaded()
        guard projects.contains(where: { $0.id == id }) else {
            throw NurseryPropagationRepositoryError.notFound(id)
        }
        projects.removeAll { $0.id == id }
        try persist()
    }

    private func ensureLoaded() {
        guard !didLoad else { return }
        didLoad = true
        projects = loadFromDisk()
    }

    private func loadFromDisk() -> [NurseryPropagationProject] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.nurseryPropagationProjectsFileName
            ), !data.isEmpty
            else { return [] }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let file = try decoder.decode(LibraryNurseryPropagationFile.self, from: data)
            return file.projects
        } catch {
            return []
        }
    }

    private func persist() throws {
        let file = LibraryNurseryPropagationFile(projects: projects)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(file) else {
            throw NurseryPropagationRepositoryError.invalidProject("Could not encode propagation projects.")
        }
        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.nurseryPropagationProjectsFileName,
                data: data
            )
        } catch {
            throw NurseryPropagationRepositoryError.invalidProject(error.localizedDescription)
        }
    }
}

@MainActor
final class PreviewNurseryPropagationRepository: NurseryPropagationRepository {
    private var projects: [NurseryPropagationProject]

    init(projects: [NurseryPropagationProject] = []) {
        self.projects = projects
    }

    func getAllProjects() -> [NurseryPropagationProject] { projects }

    func getProject(id: UUID) -> NurseryPropagationProject? {
        projects.first { $0.id == id }
    }

    func createProject(_ project: NurseryPropagationProject) throws -> NurseryPropagationProject {
        guard getProject(id: project.id) == nil else {
            throw NurseryPropagationRepositoryError.duplicateID(project.id)
        }
        projects.append(project)
        return project
    }

    func updateProject(_ project: NurseryPropagationProject) throws -> NurseryPropagationProject {
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
            throw NurseryPropagationRepositoryError.notFound(project.id)
        }
        projects[index] = project
        return project
    }

    func deleteProject(id: UUID) throws {
        guard projects.contains(where: { $0.id == id }) else {
            throw NurseryPropagationRepositoryError.notFound(id)
        }
        projects.removeAll { $0.id == id }
    }
}
