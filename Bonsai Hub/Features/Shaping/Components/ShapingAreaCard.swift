//
//  ShapingAreaCard.swift
//  Bonsai World
//
//  Working record for one Shaping area — observation, plan, next action, history.
//

import SwiftUI

struct ShapingAreaCard: View {
    let treeID: UUID
    let area: ShapingAreaID
    @Binding var record: ShapingAreaRecord
    var onReload: () -> Void = {}

    @Environment(AppState.self) private var appState
    @Environment(TaskService.self) private var taskService

    @State private var showAddHistory = false
    @State private var showCreateTask = false
    @State private var completingTask: CareTask?

    private var pendingTasks: [CareTask] {
        taskService.pendingShapingTasks(for: treeID, area: area)
    }

    var body: some View {
        DetailCard(title: area.title) {
            HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                Text("Status")
                    .font(FaloCardTypography.fieldLabel)
                    .foregroundStyle(.secondary)
                Picker("Status", selection: $record.status) {
                    ForEach(ShapingAreaStatus.allCases) { status in
                        Text(status.title).tag(status)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .font(FaloCardTypography.fieldValue)
            }
            .fixedSize(horizontal: true, vertical: false)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text("Guidelines")
                    .font(FaloCardTypography.fieldLabel)
                    .foregroundStyle(.secondary)
                Text(DesignGuidelines.excerpt(for: area))
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                Button("Open in Handbook") {
                    appState.openDesignGuidelines(section: DesignGuidelines.section(for: area))
                }
                .buttonStyle(.borderless)
                .font(FaloTypography.caption)
            }
            .padding(.bottom, FaloSpacing.xSmall)

            ShapingTextField(label: "Current Observation", text: $record.observation)
            ShapingTextField(label: "Development Plan", text: $record.developmentPlan)
            ShapingTextField(label: "Next Action", text: $record.nextAction, minHeight: 56)

            ShapingReferenceImagesSection(
                treeID: treeID,
                imageIDs: $record.referenceImageIDs,
                helperText: "Reference for this area — not photos of this tree."
            )
            .padding(.top, FaloSpacing.xSmall)

            HStack(spacing: FaloSpacing.small) {
                Button {
                    showCreateTask = true
                } label: {
                    Label("Create Task", systemImage: "checklist")
                }
                .buttonStyle(.bordered)

                Button {
                    showAddHistory = true
                } label: {
                    Label("Add History", systemImage: "plus")
                }
                .buttonStyle(.bordered)
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding(.top, FaloSpacing.xSmall)

            if !pendingTasks.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Linked Tasks")
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)
                    ForEach(pendingTasks) { task in
                        HStack(spacing: FaloSpacing.small) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(task.title)
                                    .font(FaloCardTypography.fieldValue)
                                Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer(minLength: FaloSpacing.small)
                            Button("Complete") {
                                completingTask = task
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        }
                    }
                }
                .padding(.top, FaloSpacing.small)
            }

            ShapingHistoryList(treeID: treeID, entries: record.history)
                .padding(.top, FaloSpacing.small)
        }
        .sheet(isPresented: $showAddHistory) {
            AddShapingHistorySheet(treeID: treeID, area: area) { entry in
                record.history.append(entry)
            }
        }
        .sheet(isPresented: $showCreateTask) {
            AddTaskSheet(
                preselectedTreeID: treeID,
                preselectedShapingAreaID: area,
                prefillTitle: defaultTaskTitle,
                prefillNotes: defaultTaskNotes
            ) { _ in }
        }
        .sheet(item: $completingTask) { task in
            ShapingTaskCompletionSheet(task: task, treeID: treeID) {
                onReload()
            }
        }
    }

    private var defaultTaskTitle: String {
        let action = record.nextAction.trimmingCharacters(in: .whitespacesAndNewlines)
        if !action.isEmpty { return action }
        return area.title
    }

    private var defaultTaskNotes: String {
        var parts: [String] = []
        let plan = record.developmentPlan.trimmingCharacters(in: .whitespacesAndNewlines)
        let observation = record.observation.trimmingCharacters(in: .whitespacesAndNewlines)
        if !observation.isEmpty { parts.append("Observation: \(observation)") }
        if !plan.isEmpty { parts.append("Plan: \(plan)") }
        return parts.joined(separator: "\n")
    }
}
