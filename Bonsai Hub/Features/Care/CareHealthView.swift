//
//  CareHealthView.swift
//  Bonsai World
//
//  Care → Health — trees Needs Attention / Recovering + Health-category Tasks due.
//  No separate health engine; status comes from Tree; due from Tasks.
//

import SwiftUI

struct CareHealthView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(TaskService.self) private var taskService
    @Environment(WorkService.self) private var workService
    @Environment(ImageService.self) private var imageService

    @State private var registerTreeID: UUID?
    @State private var isRegisterPresented = false
    @State private var isPickTreePresented = false
    @State private var isAddTaskPresented = false
    @State private var statusError: String?

    private var attentionTrees: [Tree] {
        treeService.trees
            .filter { $0.isInCare }
            .filter { $0.healthStatus == .needsAttention || $0.healthStatus == .recovering }
            .sorted { lhs, rhs in
                if lhs.healthStatus != rhs.healthStatus {
                    return lhs.healthStatus == .needsAttention
                }
                return TreePresentation.title(for: lhs).localizedCaseInsensitiveCompare(
                    TreePresentation.title(for: rhs)
                ) == .orderedAscending
            }
    }

    private var dueOccurrences: [TaskOccurrence] {
        taskService.pendingHealthCategoryOccurrences()
    }

    private var recentHealthWork: [WorkRecord] {
        workService.recentRecords(in: .health)
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

    private var healthWorkTypeID: UUID? {
        workService.preferredWorkTypeID(in: .health)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                CareHonestyLine(text: CareHonesty.trackingOnlyLine)
                headerActions

                CareTwoColumnLayout {
                    attentionCard
                    dueCard
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
        .bonsaiWorkspaceNavigationTitle("Health")
        .sheet(isPresented: $isRegisterPresented) {
            if let treeID = registerTreeID {
                NavigationStack {
                    AddWorkSheet(
                        treeID: treeID,
                        initialWorkTypeID: healthWorkTypeID
                    )
                }
            }
        }
        .onChange(of: isRegisterPresented) { _, presented in
            if !presented { registerTreeID = nil }
        }
        .sheet(isPresented: $isPickTreePresented) {
            NavigationStack { treePicker }
        }
        .sheet(isPresented: $isAddTaskPresented) {
            NavigationStack {
                AddTaskSheet(preselectedWorkTypeID: healthWorkTypeID)
            }
        }
        .alert(
            "Couldn't Update Health",
            isPresented: Binding(
                get: { statusError != nil },
                set: { if !$0 { statusError = nil } }
            )
        ) {
            Button("OK", role: .cancel) { statusError = nil }
        } message: {
            Text(statusError ?? "")
        }
    }

    private var headerActions: some View {
        HStack(alignment: .top) {
            Text("Attention from Tree health — set Needs Attention, Recovering, or Stable here. Due from Tasks (Health Work Types). Register as Work. Add Task opens the Tasks sheet.")
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: FaloSpacing.small) {
                Button("Add Task…") {
                    isAddTaskPresented = true
                }
                .disabled(healthWorkTypeID == nil)
                .help(
                    healthWorkTypeID == nil
                        ? "Add a Health Work Type in Reference Data."
                        : "Create a Task or Schedule (same as Tasks → Add Task)"
                )

                Button("Register Health Work…") {
                    isPickTreePresented = true
                }
                .disabled(inCareTrees.isEmpty || healthWorkTypeID == nil)
                .help(
                    healthWorkTypeID == nil
                        ? "Add a Health Work Type in Reference Data."
                        : "Choose a tree, then register Health Work"
                )
            }
        }
    }

    private var attentionCard: some View {
        DetailCard(title: "Needs Attention") {
            if attentionTrees.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("No trees need attention right now.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Trees marked Needs Attention or Recovering on Tree Detail appear here.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(attentionTrees.enumerated()), id: \.element.id) { index, tree in
                        attentionRow(tree)
                        if index < attentionTrees.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private var dueCard: some View {
        DetailCard(title: "Health Tasks Due") {
            if dueOccurrences.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Nothing due right now.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Add Task… with a Health Work Type — it will show here from Tasks.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(dueOccurrences.enumerated()), id: \.element.id) { index, occurrence in
                        dueRow(occurrence)
                        if index < dueOccurrences.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private var recentCard: some View {
        DetailCard(title: "Recent Health Work") {
            if recentHealthWork.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("No health Work yet.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Use Register Health Work… — it writes to the tree’s history.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(recentHealthWork.enumerated()), id: \.element.id) { index, record in
                        recentRow(record)
                        if index < recentHealthWork.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func attentionRow(_ tree: Tree) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)

            VStack(alignment: .leading, spacing: 2) {
                Text(TreePresentation.title(for: tree))
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)
                Text(tree.healthStatus.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Menu {
                ForEach(Self.careHealthStatusChoices) { status in
                    Button {
                        setHealthStatus(status, for: tree.id)
                    } label: {
                        if tree.healthStatus == status {
                            Label(status.title, systemImage: "checkmark")
                        } else {
                            Text(status.title)
                        }
                    }
                }
            } label: {
                Text("Set Status")
            }
            .menuStyle(.borderlessButton)
            .fixedSize()
            .help("Needs Attention, Recovering, or Stable — same labels as Tree Detail")

            Button("Register") {
                presentRegister(for: tree.id)
            }
            .disabled(healthWorkTypeID == nil)

            Button("Open") {
                appState.showTreeFromMap(treeID: tree.id)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    /// Care Health quick path: Needs Attention → Recovering → Stable (existing titles).
    private static let careHealthStatusChoices: [TreeHealthStatus] = [
        .needsAttention,
        .recovering,
        .stable,
    ]

    private func setHealthStatus(_ status: TreeHealthStatus, for treeID: UUID) {
        do {
            try treeService.setHealthStatus(id: treeID, healthStatus: status)
            statusError = nil
        } catch {
            statusError = error.localizedDescription
        }
    }

    @ViewBuilder
    private func dueRow(_ occurrence: TaskOccurrence) -> some View {
        let treeID = occurrence.treeID
        let tree = treeID.flatMap { treeService.getTree(id: $0) }
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(imageID: tree?.listImageID, imageService: imageService)

            VStack(alignment: .leading, spacing: 2) {
                Text(tree.map { TreePresentation.title(for: $0) } ?? "Unknown Tree")
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)
                Text(occurrence.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text("Due \(occurrence.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Register") {
                if let treeID { presentRegister(for: treeID) }
            }
            .disabled(healthWorkTypeID == nil || treeID == nil)

            Button("Open") {
                if let treeID { appState.showTreeFromMap(treeID: treeID) }
            }
            .buttonStyle(.borderless)
            .disabled(treeID == nil)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    @ViewBuilder
    private func recentRow(_ record: WorkRecord) -> some View {
        let treeID = record.treeIDs.first
        let tree = treeID.flatMap { treeService.getTree(id: $0) }
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(imageID: tree?.listImageID, imageService: imageService)

            VStack(alignment: .leading, spacing: 2) {
                Text(tree.map { TreePresentation.title(for: $0) } ?? "Unknown Tree")
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)
                Text(workService.workType(id: record.workTypeID)?.name ?? "Health")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                Text(record.performedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
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
                            Text(tree.healthStatus.title)
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

    private func presentRegister(for treeID: UUID) {
        registerTreeID = treeID
        isRegisterPresented = true
    }
}
