//
//  TaskListView.swift
//  Bonsai World
//
//  Field Tasks — horizons + complete + Postpone (Mac labels).
//

import SwiftUI

struct TaskListView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.openMobileTree) private var openMobileTree

    @State private var workSheet: WorkSheetRequest?
    @State private var postponeTask: CareTask?
    @State private var isShowingNewTask = false
    @State private var horizon: DemoLibrary.MobileTasksHorizon = .today

    private struct WorkSheetRequest: Identifiable {
        var id: UUID { taskID }
        let taskID: UUID
        let treeID: UUID
        let workTypeID: UUID
    }

    var body: some View {
        let items = library.pendingTasks(due: horizon)

        VStack(spacing: 0) {
            horizonPicker
            if items.isEmpty {
                ContentUnavailableView {
                    Label("No tasks", systemImage: "checklist")
                } description: {
                    Text(emptyDescription)
                } actions: {
                    Button("New Task") {
                        isShowingNewTask = true
                    }
                    .accessibilityLabel("New Task")
                }
            } else {
                taskList(items)
            }
        }
        .navigationTitle("Tasks")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Task") {
                    isShowingNewTask = true
                }
                .accessibilityLabel("New Task")
            }
        }
        .sheet(isPresented: $isShowingNewTask) {
            NewTaskView { _ in }
        }
        .sheet(item: $workSheet) { request in
            AddWorkLogView(
                treeID: request.treeID,
                initialWorkTypeID: request.workTypeID,
                completingTaskID: request.taskID
            )
        }
        .sheet(item: $postponeTask) { task in
            PostponeTaskSheet(task: task)
        }
    }

    private var horizonPicker: some View {
        Picker("Horizon", selection: $horizon) {
            ForEach(DemoLibrary.MobileTasksHorizon.allCases) { item in
                Text(item.title).tag(item)
            }
        }
        .pickerStyle(.menu)
        .font(FaloTypography.body)
        .padding(.horizontal, FaloSpacing.large)
        .padding(.vertical, FaloSpacing.small)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BonsaiWorldColors.canvas)
        .accessibilityLabel(horizon.title)
    }

    private var emptyDescription: String {
        switch horizon {
        case .overdue: "Nothing overdue."
        case .today: "Nothing due today."
        case .thisWeek: "Nothing due this week."
        case .thisMonth: "Nothing due this month."
        case .thisYear: "Nothing due this year."
        case .nextYear: "Nothing due next year."
        }
    }

    private func taskList(_ items: [DemoLibrary.MobileTaskItem]) -> some View {
        List {
            Section {
                ForEach(items) { item in
                    taskRow(item)
                }
            } header: {
                Text(horizon.title)
            } footer: {
                Text("Swipe left to complete. Swipe right for Postpone or Open Tree.")
                    .font(FaloTypography.caption)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    @ViewBuilder
    private func taskRow(_ item: DemoLibrary.MobileTaskItem) -> some View {
        let treeTitle = library.tree(id: item.treeID).map(MobileTreePresentation.title(for:)) ?? "Tree"
        let typeName = CanonicalWorkTypeID.name(for: item.task.workTypeID)
        let dueCaption = dueCaption(for: item.task.dueDate)

        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            HStack(alignment: .top, spacing: FaloSpacing.medium) {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text(item.task.title.isEmpty ? typeName : item.task.title)
                        .font(FaloTypography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    Text(treeTitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                    Text(typeName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                    Text(dueCaption)
                        .font(FaloTypography.caption)
                        .foregroundStyle(
                            dueCaption == "Overdue"
                                ? BonsaiWorldColors.statusAttention
                                : BonsaiWorldColors.textTertiary
                        )
                }
                Spacer(minLength: 0)
            }

            Button("Open Tree") {
                openMobileTree(item.treeID)
            }
            .font(FaloTypography.body)
            .foregroundStyle(BonsaiWorldColors.accent)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .contentShape(Rectangle())
            .accessibilityLabel("Open Tree")
            .accessibilityHint("Opens this tree on Home")
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .listRowBackground(BonsaiWorldColors.surface)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(item.task.title.isEmpty ? typeName : item.task.title), \(treeTitle), \(dueCaption)")
        .accessibilityHint("Swipe left to complete, swipe right to postpone or open tree")
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Postpone…") {
                postponeTask = item.task
            }
            .tint(BonsaiWorldColors.statusAttention)
            .accessibilityLabel("Postpone")

            Button("Open Tree") {
                openMobileTree(item.treeID)
            }
            .tint(BonsaiWorldColors.accent)
            .accessibilityLabel("Open Tree")
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Complete") {
                complete(item)
            }
            .tint(BonsaiWorldColors.accent)
            .accessibilityLabel("Complete \(item.task.title)")
        }
    }

    private func dueCaption(for date: Date) -> String {
        let calendar = Calendar.current
        let dueDay = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: .now)
        if dueDay < today { return "Overdue" }
        if dueDay == today { return "Today" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    private func complete(_ item: DemoLibrary.MobileTaskItem) {
        if item.isInstant {
            _ = library.completeTaskInstantly(id: item.task.id)
        } else {
            workSheet = WorkSheetRequest(
                taskID: item.task.id,
                treeID: item.treeID,
                workTypeID: item.task.workTypeID
            )
        }
    }

}

#Preview {
    NavigationStack {
        TaskListView()
    }
    .environment(DemoLibrary.preview)
}
