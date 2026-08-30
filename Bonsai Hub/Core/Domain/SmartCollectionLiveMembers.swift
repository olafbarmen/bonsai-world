//
//  SmartCollectionLiveMembers.swift
//  Bonsai World
//
//  Tree IDs for Smart Collections that resolve from Tasks (not stored lists).
//

import Foundation

/// Live membership for Needs Water, Today's Work, and Needs Repotting.
struct SmartCollectionLiveMembers: Sendable {
    var needsWater: Set<UUID> = []
    var todaysWork: Set<UUID> = []
    var needsRepotting: Set<UUID> = []
}
