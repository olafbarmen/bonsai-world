//
//  CareRepottingView.swift
//  Bonsai World
//
//  Care → Repotting — trees that need repotting, recent Work history, register via Add Work.
//

import SwiftUI

struct CareRepottingView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(TaskService.self) private var taskService
    @Environment(WorkService.self) private var workService
    @Environment(ImageService.self) private var imageService

    @State private var registerTreeID: UUID?
    @State private var isRegisterPresented = false
    @State private var isPickTreePresented = false
    @State private var isAddTaskPresented = false

    private var needsOccurrences: [TaskOccurrence] {
        taskService.pendingRepottingOccurrences()
    }

    private var recentRepots: [WorkRecord] {
        workService.recentRepottingRecords()
    }

    private var inCareTrees: [Tree] {
        treeService.trees
            .filter(\.isInCare)
            .sorted {
                TreePresentation.title(for: $0).localizedCaseInsensitiveCompare(
                    TreePresentation.title(for: $1)
                ) == .orderedAscending
            }
    }

    private var repottingWorkTypeID: UUID? {
        workService.preferredRepottingWorkTypeID()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                CareHonestyLine(text: CareHonesty.trackingOnlyLine)
                headerActions

                CareTwoColumnLayout {
                    needsCard
                } secondary: {
                    recentCard
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 1100, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Repotting")
        .sheet(isPresented: $isRegisterPresented) {
            if let treeID = registerTreeID {
                NavigationStack {
                    AddWorkSheet(
                        treeID: treeID,
                        initialWorkTypeID: repottingWorkTypeID
                    )
                }
            }
        }
        .onChange(of: isRegisterPresented) { _, presented in
            if !presented { registerTreeID = nil }
        }
        .sheet(isPresented: $isPickTreePresented) {
            NavigationStack {
                treePicker
            }
        }
        .sheet(isPresented: $isAddTaskPresented) {
            NavigationStack {
                AddTaskSheet(preselectedWorkTypeID: repottingWorkTypeID)
            }
        }
    }

    private var headerActions: some View {
        HStack(alignment: .top) {
            Text("Due from Tasks. Register as Work. Add Task opens the Tasks sheet.")
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: FaloSpacing.small) {
                Button("Add Task…") {
                    isAddTaskPresented = true
                }
                .disabled(repottingWorkTypeID == nil)
                .help(
                    repottingWorkTypeID == nil
                        ? "Add a Work Type whose name contains “repot” in Reference Data."
                        : "Create a Task or Schedule (same as Tasks → Add Task)"
                )

                Button("Register Repotting…") {
                    isPickTreePresented = true
                }
                .disabled(inCareTrees.isEmpty || repottingWorkTypeID == nil)
                .help(
                    repottingWorkTypeID == nil
                        ? "Add a Work Type whose name contains “repot” in Reference Data."
                        : "Choose a tree, then register Repotting Work"
                )
            }
        }
    }

    private var needsCard: some View {
        DetailCard(title: "Needs Repotting") {
            if needsOccurrences.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Nothing due right now.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Add Task… when a tree needs repotting — it will show here from Tasks.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(needsOccurrences.enumerated()), id: \.element.id) { index, occurrence in
                        needsRow(occurrence)
                        if index < needsOccurrences.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private var recentCard: some View {
        DetailCard(title: "Recent Repotting") {
            if recentRepots.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("No repotting Work yet.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Use Register Repotting… or Register on a due row — it writes to the tree’s history.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(recentRepots.enumerated()), id: \.element.id) { index, record in
                        recentRow(record)
                        if index < recentRepots.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func needsRow(_ occurrence: TaskOccurrence) -> some View {
        let treeID = occurrence.treeID
        let tree = treeID.flatMap { treeService.getTree(id: $0) }
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(
                imageID: tree?.listImageID,
                imageService: imageService
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(tree.map { TreePresentation.title(for: $0) } ?? "Unknown Tree")
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text("Due \(occurrence.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                if let treeID {
                    Text(lastRepotLabel(for: treeID))
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Register") {
                if let treeID { presentRegister(for: treeID) }
            }
            .disabled(repottingWorkTypeID == nil || treeID == nil)

            Button("Open") {
                if let treeID { appState.showTreeFromMap(treeID: treeID) }
            }
            .buttonStyle(.borderless)
            .disabled(treeID == nil)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private func recentRow(_ record: WorkRecord) -> some View {
        let treeID = record.treeIDs.first
        let tree = treeID.flatMap { treeService.getTree(id: $0) }
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(
                imageID: tree?.listImageID,
                imageService: imageService
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(tree.map { TreePresentation.title(for: $0) } ?? "Unknown Tree")
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)

                Text(record.performedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                let notes = record.notes.trimmingCharacters(in: .whitespacesAndNewlines)
                if !notes.isEmpty {
                    Text(notes)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let treeID {
                Button("Open") {
                    appState.showTreeFromMap(treeID: treeID)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private var treePicker: some View {
        List {
            ForEach(inCareTrees) { tree in
                Button {
                    isPickTreePresented = false
                    presentRegister(for: tree.id)
                } label: {
                    HStack(spacing: FaloSpacing.medium) {
                        TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(TreePresentation.title(for: tree))
                            Text(lastRepotLabel(for: tree.id))
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Choose Tree")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { isPickTreePresented = false }
            }
        }
        .frame(minWidth: 360, minHeight: 420)
    }

    private func lastRepotLabel(for treeID: UUID) -> String {
        if let date = workService.lastCompletedRepottingDate(for: treeID) {
            return "Last repotted \(date.formatted(date: .abbreviated, time: .omitted))"
        }
        return "No repotting Work yet"
    }

    private func presentRegister(for treeID: UUID) {
        registerTreeID = treeID
        isRegisterPresented = true
    }
}
