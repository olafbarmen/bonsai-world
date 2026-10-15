//
//  CareSeasonalView.swift
//  Bonsai World
//
//  Care → Seasonal Care — Due from Tasks (Seasonal Work Types) + register Work.
//  No seasonal recommendation engine yet.
//

import SwiftUI

struct CareSeasonalView: View {
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
        taskService.pendingSeasonalOccurrences()
    }

    private var recentSeasonal: [WorkRecord] {
        workService.recentRecords(in: .seasonal)
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

    private var seasonalWorkTypeID: UUID? {
        workService.preferredWorkTypeID(in: .seasonal)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                CarePageIntro(pageKey: "seasonal", helpBody: CarePageHelp.seasonal)
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
        .sheet(isPresented: $isRegisterPresented) {
            if let treeID = registerTreeID {
                NavigationStack {
                    AddWorkSheet(
                        treeID: treeID,
                        initialWorkTypeID: seasonalWorkTypeID
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
                AddTaskSheet(preselectedWorkTypeID: seasonalWorkTypeID)
            }
        }
    }

    private var headerActions: some View {
        HStack(alignment: .top) {
            Text("Due from Tasks (Seasonal Work Types). Register as Work. Add Task opens the Tasks sheet.")
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: FaloSpacing.small) {
                Button("Add Task…") {
                    isAddTaskPresented = true
                }
                .disabled(seasonalWorkTypeID == nil)
                .help(
                    seasonalWorkTypeID == nil
                        ? "Add a Seasonal Work Type in Reference Data."
                        : "Create a Task or Schedule (same as Tasks → Add Task)"
                )

                Button("Register Seasonal Work…") {
                    isPickTreePresented = true
                }
                .disabled(inCareTrees.isEmpty || seasonalWorkTypeID == nil)
                .help(
                    seasonalWorkTypeID == nil
                        ? "Add a Seasonal Work Type in Reference Data."
                        : "Choose a tree, then register Seasonal Work"
                )
            }
        }
    }

    private var needsCard: some View {
        DetailCard(title: "Seasonal Tasks Due") {
            if needsOccurrences.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Nothing due right now.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Add Task… with a Seasonal Work Type — it will show here from Tasks.")
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
        DetailCard(title: "Recent Seasonal Work") {
            if recentSeasonal.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("No seasonal Work yet.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Use Register Seasonal Work… — it writes to the tree’s history.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(recentSeasonal.enumerated()), id: \.element.id) { index, record in
                        recentRow(record)
                        if index < recentSeasonal.count - 1 {
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
                if let treeID = tree?.id,
                   let date = workService.lastCompletedDate(for: treeID, in: .seasonal) {
                    Text("Last \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Register") {
                if let treeID { presentRegister(for: treeID) }
            }
            .disabled(seasonalWorkTypeID == nil || treeID == nil)

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
                Text(workService.workType(id: record.workTypeID)?.name ?? "Seasonal")
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
                        Text(TreePresentation.title(for: tree))
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
