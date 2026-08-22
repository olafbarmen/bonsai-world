//
//  TreeAutoSaveStatus.swift
//  Bonsai World
//
//  Auto Save feedback for Tree Detail Edit Mode.
//

import Foundation

enum TreeAutoSaveStatus: Equatable, Sendable {
    case idle
    case saving
    case saved
    case failed
}
