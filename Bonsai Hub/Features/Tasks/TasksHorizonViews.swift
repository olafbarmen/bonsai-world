//
//  TasksHorizonViews.swift
//  Bonsai World
//
//  Compatibility entry — Tasks is one workspace; horizon is AppState.tasksHorizon.
//

import SwiftUI

enum TasksHorizonViews {
    static var root: some View {
        TasksWorkspaceView()
    }

    /// Legacy names — all open the same Tasks page (horizon set by AppState / deep link).
    static var overdue: some View { root }
    static var today: some View { root }
    static var thisWeek: some View { root }
    static var thisMonth: some View { root }
    static var thisYear: some View { root }
    static var nextYear: some View { root }
}

/// Compatibility alias — prefer ``TasksHorizonViews``.
typealias TasksPlaceholderViews = TasksHorizonViews
