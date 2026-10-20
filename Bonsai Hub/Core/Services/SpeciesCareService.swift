//
//  SpeciesCareService.swift
//  Bonsai World
//
//  One pending task per tree per job, inside the garden's year.
//  Does not move a due date the grower has postponed.
//

import Foundation
import Observation

@Observable
@MainActor
final class SpeciesCareService {
    private let treeService: TreeService
    private let taskService: TaskService

    init(treeService: TreeService, taskService: TaskService) {
        self.treeService = treeService
        self.taskService = taskService
    }

    func sync(
        hemisphere: GardenHemisphere?,
        season: GardenSeason?,
        now: Date = .now,
        calendar: Calendar = .current
    ) throws {
        guard let hemisphere, let season, season != .tropical else { return }

        for tree in treeService.trees where tree.isInCare {
            guard let job = SpeciesCareJob.job(
                speciesID: tree.speciesID,
                cultivarID: tree.cultivarID,
                botanicalName: tree.botanicalName
            ),
            taskService.workType(id: job.workTypeID) != nil,
            let window = SpeciesCareCalendar.activeWindow(
                job: job,
                on: now,
                hemisphere: hemisphere,
                season: season,
                calendar: calendar
            )
            else { continue }

            let related = taskService.tasks.filter {
                $0.systemKind == job.systemKind && $0.treeIDs.contains(tree.id)
            }
            let pending = related.first { $0.status == .pending }
            let covered = related.contains { window.covers($0.dueDate, calendar: calendar) }
            switch SpeciesCareCalendar.action(
                now: now,
                window: window,
                pendingDue: pending?.dueDate,
                covered: covered,
                calendar: calendar
            ) {
            case .none:
                break
            case .retire:
                guard var task = pending else { break }
                task.status = .cancelled
                _ = try taskService.updateTask(task)
            case .create(let due):
                _ = try taskService.createTask(
                    title: job.title,
                    workTypeID: job.workTypeID,
                    treeIDs: [tree.id],
                    systemKind: job.systemKind,
                    dueDate: due,
                    notes: job.notes
                )
            }
        }
    }
}
