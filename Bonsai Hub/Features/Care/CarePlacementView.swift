//
//  CarePlacementView.swift
//  Bonsai World
//
//  Care → Placement — In Care trees whose Location is missing or unresolved.
//  No placement recommendation engine yet.
//

import SwiftUI

struct CarePlacementView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(WorkService.self) private var workService
    @Environment(ImageService.self) private var imageService

    @State private var registerTreeID: UUID?
    @State private var isRegisterPresented = false
    @State private var isPickTreePresented = false
    @State private var isAddTaskPresented = false

    private var treesMissingLocation: [Tree] {
        treeService.trees
            .filter(\.isInCare)
            .filter { referenceData.location(id: $0.locationID) == nil }
            .sorted {
                TreePresentation.title(for: $0).localizedCaseInsensitiveCompare(
                    TreePresentation.title(for: $1)
                ) == .orderedAscending
            }
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

    private var placementWorkTypeID: UUID? {
        workService.preferredPlacementWorkTypeID()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                CareHonestyLine(text: CareHonesty.trackingOnlyLine)
                headerActions

                CareTwoColumnLayout {
                    missingLocationCard
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
        .bonsaiWorkspaceNavigationTitle("Placement")
        .sheet(isPresented: $isRegisterPresented) {
            if let treeID = registerTreeID {
                NavigationStack {
                    AddWorkSheet(
                        treeID: treeID,
                        initialWorkTypeID: placementWorkTypeID
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
                AddTaskSheet(preselectedWorkTypeID: placementWorkTypeID)
            }
        }
    }

    private var headerActions: some View {
        HStack(alignment: .top) {
            Text("Trees in Care without a Location. Open a tree to assign placement. Add Task / Register use move and outdoor Seasonal Work Types.")
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: FaloSpacing.small) {
                Button("Add Task…") {
                    isAddTaskPresented = true
                }
                .disabled(placementWorkTypeID == nil)
                .help(
                    placementWorkTypeID == nil
                        ? "Add a Seasonal Work Type in Reference Data."
                        : "Create a Task or Schedule (same as Tasks → Add Task)"
                )

                Button("Register Placement Work…") {
                    isPickTreePresented = true
                }
                .disabled(inCareTrees.isEmpty || placementWorkTypeID == nil)
                .help(
                    placementWorkTypeID == nil
                        ? "Add a Seasonal Work Type in Reference Data."
                        : "Choose a tree, then register placement-related Work"
                )
            }
        }
    }

    private var missingLocationCard: some View {
        DetailCard(title: "Missing Location") {
            if treesMissingLocation.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Every In Care tree has a Location.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Trees whose Location is missing or no longer in the catalog appear here.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(treesMissingLocation.enumerated()), id: \.element.id) { index, tree in
                        missingRow(tree)
                        if index < treesMissingLocation.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private var recentCard: some View {
        let records = recentPlacementWork()
        return DetailCard(title: "Recent Placement Work") {
            if records.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("No placement-related Work yet.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Return Outdoors, Shade, Move, and Heat Work Types appear here.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                        recentRow(record)
                        if index < records.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func missingRow(_ tree: Tree) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)

            VStack(alignment: .leading, spacing: 2) {
                Text(TreePresentation.title(for: tree))
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)
                Text("No Location assigned")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Register") {
                presentRegister(for: tree.id)
            }
            .disabled(placementWorkTypeID == nil)

            Button("Open") {
                appState.showTreeFromMap(treeID: tree.id)
            }
            .buttonStyle(.borderless)
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
                Text(workService.workType(id: record.workTypeID)?.name ?? "Placement")
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

    private func recentPlacementWork(limit: Int = 25) -> [WorkRecord] {
        let matchingIDs = Set(
            workService.workTypes(in: .seasonal)
                .filter { nameSuggestsPlacement($0.name) }
                .map(\.id)
        )
        let now = Date.now
        return Array(
            workService.recentRecords(limit: 200)
                .filter { $0.performedAt <= now && matchingIDs.contains($0.workTypeID) }
                .prefix(limit)
        )
    }

    private func nameSuggestsPlacement(_ name: String) -> Bool {
        let lowered = name.lowercased()
        return lowered.contains("return")
            || lowered.contains("shade")
            || lowered.contains("move")
            || lowered.contains("heat")
            || lowered.contains("placement")
    }
}
