//
//  YamadoriFindWorkspaceWindowContext.swift
//  Bonsai World
//
//  Value type for opening a Yamadori Find workspace window.
//

import Foundation

struct YamadoriFindWorkspaceWindowContext: Identifiable, Codable, Hashable, Sendable {
    var id: UUID { findID }
    var findID: UUID
    var tripID: UUID

    init(findID: UUID, tripID: UUID) {
        self.findID = findID
        self.tripID = tripID
    }

    static let windowID = "yamadori-find-workspace"
}
