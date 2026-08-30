//
//  CareNotificationService.swift
//  Bonsai World
//
//  Rebuilds the care-notification plan from TaskService whenever occurrences
//  change, then hands it to a platform scheduler. Views never talk to
//  UserNotifications directly.
//

import Foundation
import Observation

@Observable
@MainActor
final class CareNotificationService {
    private let taskService: TaskService
    private let scheduler: any CareNotificationScheduling

    init(taskService: TaskService, scheduler: any CareNotificationScheduling) {
        self.taskService = taskService
        self.scheduler = scheduler
    }

    func refresh() {
        taskService.pruneExpiredMissedOneOffTasks()
        _ = taskService.revision
        let todayCount = taskService.pendingOccurrences(due: .today).count
        let overdueCount = taskService.pendingOccurrences(due: .overdue).count
        scheduler.apply(
            CareNotificationPlanner.plan(todayCount: todayCount, overdueCount: overdueCount)
        )
    }
}
