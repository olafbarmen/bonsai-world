//
//  NurseryPropagationWorkspaceWindowContext.swift
//  Bonsai World
//
//  Opens a dedicated Cuttings / Air Layers / Grafting window (double-click from list).
//

import Foundation

struct NurseryPropagationWorkspaceWindowContext: Identifiable, Codable, Hashable, Sendable {
    /// One window per project.
    var id: UUID { projectID }
    var kind: NurseryPropagationKind
    var projectID: UUID

    init(kind: NurseryPropagationKind, projectID: UUID) {
        self.kind = kind
        self.projectID = projectID
    }
}

extension NurseryPropagationWorkspaceWindowContext {
    static let windowID = "nursery-propagation-workspace"
}
