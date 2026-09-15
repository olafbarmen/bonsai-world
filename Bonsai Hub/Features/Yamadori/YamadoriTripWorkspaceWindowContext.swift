//
//  YamadoriTripWorkspaceWindowContext.swift
//  Bonsai World
//
//  Value type for opening a Yamadori trip workspace window.
//

import Foundation

struct YamadoriTripWorkspaceWindowContext: Identifiable, Codable, Hashable, Sendable {
    var id: UUID { tripID }
    var tripID: UUID

    init(tripID: UUID) {
        self.tripID = tripID
    }

    static let windowID = "yamadori-trip-workspace"
}
