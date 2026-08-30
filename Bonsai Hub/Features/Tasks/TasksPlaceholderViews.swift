//
//  TasksPlaceholderViews.swift
//  Bonsai World
//
//  Route entry points for Tasks horizons — placeholder workspace only.
//

import SwiftUI

enum TasksPlaceholderViews {
    static var overdue: some View {
        TasksWorkspaceView(horizon: .overdue)
    }

    static var today: some View {
        TasksWorkspaceView(horizon: .today)
    }

    static var thisWeek: some View {
        TasksWorkspaceView(horizon: .thisWeek)
    }

    static var thisMonth: some View {
        TasksWorkspaceView(horizon: .thisMonth)
    }

    static var thisYear: some View {
        TasksWorkspaceView(horizon: .thisYear)
    }

    static var nextYear: some View {
        TasksWorkspaceView(horizon: .nextYear)
    }
}
