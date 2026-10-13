//
//  TaskListView.swift
//  Bonsai World
//
//  Field Tasks — Overdue + Today. Complete watering instantly; other types open Add Work.
//

import SwiftUI

struct TaskListView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.openMobileTree) private var openMobileTree

    @State private var workSheet: WorkSheetRequest?
    @State private var isShowingNewTask = false

    private struct WorkSheetRequest: Identifiable {
        var id: UUID { taskID }
        let taskID: UUID
        let treeID: UUID
        let workTypeID: UUID
    }

    var body: some View {
        let overdue = library.pendingTasks(due: .overdue)
        let today = library.pendingTasks(due: .today)
        let isEmpty = overdue.isEmpty && today.isEmpty

        Group {
            if isEmpty {
                ContentUnavailableView {
                    Label("No tasks", systemImage: "checklist")
                } description: {
                    Text("Add a task for today or later.")
                } actions: {
                    Button("New Task") {
                        isShowingNewTask = true
                    }
                    .accessibilityLabel("New Task")
                }
            } else {
                taskList(overdue: overdue, today: today)
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
    }

    private func taskList(
        overdue: [DemoLibrary.MobileTaskItem],
        today: [DemoLibrary.MobileTaskItem]
    ) -> some View {
        List {
            Section {
                if overdue.isEmpty {
                    emptyLine("Nothing overdue.")
                } else {
                    ForEach(overdue) { item in
                        taskRow(item)
                    }
                }
            } header: {
                Text("Overdue")
            } footer: {
                if !overdue.isEmpty {
                    Text("Swipe left to complete. Swipe right to open tree.")
                        .font(FaloTypography.caption)
                }
            }

            Section {
                if today.isEmpty {
                    emptyLine("Nothing due today.")
                } else {
                    ForEach(today) { item in
                        taskRow(item)
                    }
                }
            } header: {
                Text("Today")
            } footer: {
                if !today.isEmpty && overdue.isEmpty {
                    Text("Swipe left to complete. Swipe right to open tree.")
                        .font(FaloTypography.caption)
                }
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
        .accessibilityHint("Swipe left to complete, swipe right to open tree")
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
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

    private func emptyLine(_ text: String) -> some View {
        Text(text)
            .font(FaloTypography.body)
            .foregroundStyle(BonsaiWorldColors.textSecondary)
            .listRowBackground(BonsaiWorldColors.surface)
    }
}

#Preview {
    NavigationStack {
        TaskListView()
    }
    .environment(DemoLibrary.preview)
}
