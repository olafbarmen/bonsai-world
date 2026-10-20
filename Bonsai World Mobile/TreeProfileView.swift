//
//  TreeProfileView.swift
//  Bonsai World
//
//  Field Tree Profile — canonical Tree, not a Mac detail replica.
//

import PhotosUI
import SwiftUI
import UIKit

struct TreeProfileView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss
    let treeID: UUID

    @State private var isShowingAddPhotoOptions = false
    @State private var isShowingCamera = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @State private var isShowingAddWork = false
    @State private var workSheet: DueWorkSheetRequest?
    @State private var postponeTask: CareTask?
    @State private var isShowingMove = false
    @State private var photoPendingRemoval: UUID?
    @State private var confirmRemovePhoto = false
    @State private var confirmDeleteTree = false
    @State private var confirmRemovePot = false
    @State private var isAssignPotPresented = false
    @State private var workTypeFilter: TreeWorkTypeFilter = .all
    @State private var didLoadWorkFilter = false
    @State private var photoViewer: PhotoViewerRequest?

    private struct DueWorkSheetRequest: Identifiable {
        var id: UUID { taskID }
        let taskID: UUID
        let workTypeID: UUID
    }

    private struct PhotoViewerRequest: Identifiable {
        let id = UUID()
        let pages: [MobilePhotoPage]
        let index: Int
    }

    private enum TreeWorkTypeFilter: Hashable {
        case all
        case type(UUID)
    }

    private var tree: Tree? { library.tree(id: treeID) }
    private var cameraAvailable: Bool { MobilePhotoImport.isCameraAvailable }
    private var linkedFind: YamadoriFind? { library.find(linkedToTreeID: treeID) }
    private var canMoveToMyTrees: Bool {
        tree?.yamadoriNursery == true && linkedFind?.status.canTransferToTree == true
    }

    var body: some View {
        Group {
            if let tree {
                profileList(tree)
            } else {
                ContentUnavailableView("Tree not found", systemImage: "leaf")
            }
        }
        .fullScreenCover(item: $photoViewer) { viewer in
            MobilePhotoViewer(pages: viewer.pages, startIndex: viewer.index)
        }
    }

    @ViewBuilder
    private func profileList(_ tree: Tree) -> some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    Button {
                        presentPhotoViewer(tree, imageID: tree.primaryImageID ?? tree.imageIDs.first)
                    } label: {
                        MobileTreeImage(tree: tree, style: .hero)
                    }
                    .buttonStyle(.plain)
                    .disabled(tree.imageIDs.isEmpty)
                    .accessibilityLabel("Photo")
                    .accessibilityHint(tree.imageIDs.isEmpty ? "" : "Shows the photo large. Pinch to zoom")

                    Text(MobileTreePresentation.title(for: tree))
                        .font(FaloTypography.pageTitle)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)

                    MobileHealthBadge(status: tree.healthStatus)
                }
                .padding(.vertical, FaloSpacing.small)
                .listRowBackground(BonsaiWorldColors.surface)
                .listRowInsets(EdgeInsets(
                    top: FaloSpacing.medium,
                    leading: FaloSpacing.large,
                    bottom: FaloSpacing.medium,
                    trailing: FaloSpacing.large
                ))
            }

            dueNowSection(tree)
            schedulesSection(tree)

            if let recent = library.work(for: tree.id).first {
                Section("Recent Work") {
                    workRow(recent)
                }
            }

            Section("Identity") {
                profileRow(label: "Bonsai Name", value: MobileTreePresentation.bonsaiNameLine(for: tree))
                profileRow(label: "Botanical", value: MobileTreePresentation.botanicalLine(for: tree))
            }

            Section("Health") {
                NavigationLink(value: MobileRoute.editTree(tree.id)) {
                    HStack {
                        MobileHealthBadge(status: tree.healthStatus)
                        Spacer(minLength: 0)
                        Text("Edit")
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                }
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Health, \(tree.healthStatus.title)")
                .accessibilityHint("Open Edit Tree to change health")
            }

            if let location = library.location(id: tree.locationID) {
                Section("Location") {
                    NavigationLink(value: MobileRoute.location(location.id)) {
                        Text(location.name)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityHint("Open location")
                }
            }

            if let mixID = tree.soilMixID,
               let mixName = library.soilMix(id: mixID)?.name,
               !mixName.isEmpty
            {
                Section("Soil Mix") {
                    NavigationLink(value: MobileRoute.soilMix(mixID)) {
                        Text(mixName)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityHint("Open soil mix")
                }
            }

            Section("Inventory Pot") {
                if let pot = library.pot(linkedToTreeID: tree.id) {
                    NavigationLink(value: MobileRoute.pot(pot.id)) {
                        Text(library.displayName(for: pot))
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityHint("Open inventory pot")
                    Button("Change Inventory Pot") {
                        isAssignPotPresented = true
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Change Inventory Pot")
                    Button("Remove Inventory Pot", role: .destructive) {
                        confirmRemovePot = true
                    }
                    .font(FaloTypography.body)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Remove Inventory Pot")
                } else {
                    Button("Assign Inventory Pot") {
                        isAssignPotPresented = true
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Assign Inventory Pot")
                }
            }

            Section {
                if let date = library.lastRepotDate(for: tree.id) {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text("Last repot")
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        Text(date, style: .date)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Last repot, \(date.formatted(date: .abbreviated, time: .omitted))")
                } else {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text("Last repot")
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        Text("Never")
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Last repot, Never")
                }
            }

            if hasAnyMeasurement(tree) {
                Section("Measurements") {
                    if let height = tree.heightMillimetres {
                        profileRow(label: "Height", value: centimetresLabel(fromMillimetres: height))
                    }
                    if let crown = tree.crownWidthMillimetres {
                        profileRow(label: "Crown Width", value: centimetresLabel(fromMillimetres: crown))
                    }
                    if let nebari = tree.nebariWidthMillimetres {
                        profileRow(label: "Nebari Width", value: centimetresLabel(fromMillimetres: nebari))
                    }
                    if let trunk = tree.trunkDiameterMillimetres {
                        profileRow(label: "Trunk Diameter", value: "\(trunk) mm")
                    }
                }
            }

            Section("Shaping") {
                let inProgress = shapingInProgressSummary(for: tree)
                NavigationLink {
                    TreeShapingView(treeID: tree.id)
                } label: {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text("Shaping")
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        if inProgress.isEmpty {
                            Text("Areas and status")
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        } else {
                            Text(inProgress)
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.statusAttention)
                        }
                    }
                }
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityHint("Open Shaping")
            }

            photosSection(tree)

            workSection(tree)

            if canMoveToMyTrees {
                Section {
                    Button("Move to My Trees") {
                        isShowingMove = true
                    }
                    .font(FaloTypography.body.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Move to My Trees")
                }
            }

            if !trimmed(tree.notes).isEmpty {
                Section("Notes") {
                    Text(tree.notes)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .listRowBackground(BonsaiWorldColors.surface)
                }
            }

            Section {
                Button("Delete Tree", role: .destructive) {
                    confirmDeleteTree = true
                }
                .font(FaloTypography.body)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Delete Tree")
                .accessibilityHint("Permanently removes this tree, its photos, and its work history")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle(MobileTreePresentation.title(for: tree))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: MobileRoute.editTree(tree.id)) {
                    Text("Edit")
                }
                .accessibilityLabel("Edit Tree")
            }
        }
        .sheet(isPresented: $isShowingMove) {
            if let findID = linkedFind?.id {
                MoveYamadoriToMyTreesView(findID: findID) { _ in }
            }
        }
        .sheet(isPresented: $isAssignPotPresented) {
            AssignInventoryPotView(
                treeID: tree.id,
                excludingPotID: library.pot(linkedToTreeID: tree.id)?.id
            )
        }
        .confirmationDialog("Add Photo", isPresented: $isShowingAddPhotoOptions, titleVisibility: .visible) {
            if cameraAvailable {
                Button("Take Photo") { isShowingCamera = true }
            }
            Button("Choose from Photos") { isPhotoPickerPresented = true }
            Button("Cancel", role: .cancel) {}
        }
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $photoPickerItem, matching: .images)
        .onChange(of: photoPickerItem) { _, newItem in
            guard let newItem else { return }
            Task { await importPickedItem(newItem) }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            MobileCameraPicker(
                onImage: { image in
                    isShowingCamera = false
                    importCameraImage(image)
                },
                onCancel: { isShowingCamera = false }
            )
            .ignoresSafeArea()
        }
        .sheet(isPresented: $isShowingAddWork) {
            AddWorkLogView(treeID: tree.id)
        }
        .sheet(item: $workSheet) { request in
            AddWorkLogView(
                treeID: tree.id,
                initialWorkTypeID: request.workTypeID,
                completingTaskID: request.taskID
            )
        }
        .sheet(item: $postponeTask) { task in
            PostponeTaskSheet(task: task)
        }
        .onAppear { loadWorkTypeFilterIfNeeded(for: tree) }
        .onChange(of: workTypeFilter) { _, newValue in
            Self.rememberWorkTypeFilter(newValue, for: tree.id)
        }
        .confirmationDialog(
            "Remove this photo?",
            isPresented: $confirmRemovePhoto,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                if let imageID = photoPendingRemoval {
                    library.removePhoto(fromTree: treeID, imageID: imageID)
                }
                photoPendingRemoval = nil
            }
            Button("Cancel", role: .cancel) {
                photoPendingRemoval = nil
            }
        }
        .confirmationDialog(
            "Delete \(MobileTreePresentation.title(for: tree))?",
            isPresented: $confirmDeleteTree,
            titleVisibility: .visible
        ) {
            Button("Delete Tree", role: .destructive) {
                library.deleteTree(id: treeID)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Photos, work history, and tasks for this tree are removed. This cannot be undone.")
        }
        .confirmationDialog(
            "Remove inventory pot from this tree?",
            isPresented: $confirmRemovePot,
            titleVisibility: .visible
        ) {
            Button("Remove Inventory Pot", role: .destructive) {
                _ = library.unassignCurrentPot(fromTreeID: tree.id)
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private static func workTypeFilterKey(for treeID: UUID) -> String {
        "bonsai.mobile.workTypeFilter.tree.\(treeID.uuidString)"
    }

    private static func rememberedWorkTypeFilter(for treeID: UUID) -> TreeWorkTypeFilter {
        guard let raw = UserDefaults.standard.string(forKey: workTypeFilterKey(for: treeID)) else {
            return .all
        }
        if raw == "all" { return .all }
        guard let id = UUID(uuidString: raw) else { return .all }
        return .type(id)
    }

    private static func rememberWorkTypeFilter(_ filter: TreeWorkTypeFilter, for treeID: UUID) {
        switch filter {
        case .all:
            UserDefaults.standard.set("all", forKey: workTypeFilterKey(for: treeID))
        case .type(let id):
            UserDefaults.standard.set(id.uuidString, forKey: workTypeFilterKey(for: treeID))
        }
    }

    private func loadWorkTypeFilterIfNeeded(for tree: Tree) {
        guard !didLoadWorkFilter else { return }
        let remembered = Self.rememberedWorkTypeFilter(for: tree.id)
        let typeIDs = Set(workTypeIDs(in: library.work(for: tree.id)))
        if case .type(let id) = remembered, !typeIDs.contains(id) {
            workTypeFilter = .all
        } else {
            workTypeFilter = remembered
        }
        didLoadWorkFilter = true
    }

    private func presentPhotoViewer(_ tree: Tree, imageID: UUID?) {
        let pages = tree.imageIDs.compactMap { id -> MobilePhotoPage? in
            guard let data = library.jpegData(for: id), !data.isEmpty else { return nil }
            return MobilePhotoPage(id: id, data: data)
        }
        guard !pages.isEmpty else { return }
        let index = pages.firstIndex { $0.id == imageID } ?? 0
        photoViewer = PhotoViewerRequest(pages: pages, index: index)
    }

    @ViewBuilder
    private func photosSection(_ tree: Tree) -> some View {
        Section("Photos") {
            if tree.imageIDs.isEmpty {
                Text("No photos yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: FaloSpacing.small) {
                        ForEach(tree.imageIDs, id: \.self) { imageID in
                            Button {
                                presentPhotoViewer(tree, imageID: imageID)
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    MobileTreeImage(tree: tree, imageID: imageID, style: .thumbnail)
                                    if tree.primaryImageID == imageID {
                                        Text("Primary")
                                            .font(FaloTypography.caption)
                                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                                            .padding(.horizontal, FaloSpacing.xSmall)
                                            .padding(.vertical, 2)
                                            .background(BonsaiWorldColors.surface.opacity(0.92))
                                            .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
                                            .padding(FaloSpacing.xSmall)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("Set as Primary") {
                                    library.setPrimaryImage(treeID: tree.id, imageID: imageID)
                                }
                                Button("Remove Photo", role: .destructive) {
                                    photoPendingRemoval = imageID
                                    confirmRemovePhoto = true
                                }
                            }
                            .accessibilityLabel(tree.primaryImageID == imageID ? "Primary photo" : "Photo")
                            .accessibilityHint("Shows the photo large. Pinch to zoom. Long press for more options")
                        }
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                }
                .listRowBackground(BonsaiWorldColors.surface)
            }

            Button("Add Photo") {
                isShowingAddPhotoOptions = true
            }
            .font(FaloTypography.body)
            .foregroundStyle(BonsaiWorldColors.accent)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .contentShape(Rectangle())
            .listRowBackground(BonsaiWorldColors.surface)
            .accessibilityLabel("Add Photo")
            .accessibilityHint("Take a photo or choose from Photos")

            if !tree.imageIDs.isEmpty {
                Text("Long press a photo to remove it.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
                    .listRowBackground(BonsaiWorldColors.surface)
            }
        }
    }

    @ViewBuilder
    private func dueNowSection(_ tree: Tree) -> some View {
        let dueItems = library.pendingTasks(forTree: tree.id)
        Section {
            if dueItems.isEmpty {
                Text("Nothing due now.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ForEach(dueItems) { item in
                    dueNowRow(item)
                }
            }
        } header: {
            Text("Due Now")
        } footer: {
            if !dueItems.isEmpty {
                Text("Swipe left to complete. Swipe right to Postpone.")
                    .font(FaloTypography.caption)
            }
        }
    }

    @ViewBuilder
    private func schedulesSection(_ tree: Tree) -> some View {
        let schedules = library.activeSchedules(forTree: tree.id)
        Section("Schedules") {
            if schedules.isEmpty {
                Text("No active schedules.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ForEach(schedules) { schedule in
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text(schedule.title.isEmpty
                             ? CanonicalWorkTypeID.name(for: schedule.workTypeID)
                             : schedule.title)
                            .font(FaloTypography.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        Text("\(CanonicalWorkTypeID.name(for: schedule.workTypeID)) · \(schedule.recurrence.summary)")
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        if !schedule.notes.isEmpty {
                            Text(schedule.notes)
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textTertiary)
                        }
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    private func dueNowRow(_ item: DemoLibrary.MobileTaskItem) -> some View {
        let typeName = CanonicalWorkTypeID.name(for: item.task.workTypeID)
        let title = item.task.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let dueDay = Calendar.current.startOfDay(for: item.task.dueDate)
        let today = Calendar.current.startOfDay(for: .now)
        let dueLabel = dueDay < today ? "Overdue" : "Today"
        return VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(title.isEmpty ? typeName : title)
                .font(FaloTypography.body)
                .fontWeight(.semibold)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            Text("\(typeName) · \(dueLabel)")
                .font(FaloTypography.caption)
                .foregroundStyle(
                    dueLabel == "Overdue"
                        ? BonsaiWorldColors.statusAttention
                        : BonsaiWorldColors.textTertiary
                )
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowBackground(BonsaiWorldColors.surface)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Swipe left to complete, swipe right to postpone")
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Postpone…") {
                postponeTask = item.task
            }
            .tint(BonsaiWorldColors.statusAttention)
            .accessibilityLabel("Postpone")
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Complete") {
                completeDueItem(item)
            }
            .tint(BonsaiWorldColors.accent)
            .accessibilityLabel("Complete \(title.isEmpty ? typeName : title)")
        }
    }

    private func completeDueItem(_ item: DemoLibrary.MobileTaskItem) {
        if item.isInstant {
            _ = library.completeTaskInstantly(id: item.task.id)
        } else {
            workSheet = DueWorkSheetRequest(
                taskID: item.task.id,
                workTypeID: item.task.workTypeID
            )
        }
    }

    @ViewBuilder
    private func workSection(_ tree: Tree) -> some View {
        let records = library.work(for: tree.id)
        let typeIDs = workTypeIDs(in: records)
        let filtered = filteredWork(records)
        Section("Work") {
            if !typeIDs.isEmpty {
                Picker("Type", selection: $workTypeFilter) {
                    Text("All").tag(TreeWorkTypeFilter.all)
                    ForEach(typeIDs, id: \.self) { typeID in
                        Text(CanonicalWorkTypeID.name(for: typeID))
                            .tag(TreeWorkTypeFilter.type(typeID))
                    }
                }
                .accessibilityLabel("Work type filter")
            }

            if records.isEmpty {
                Text("No work recorded yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else if filtered.isEmpty {
                Text("No work matches this type.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ForEach(filtered) { record in
                    workRow(record)
                }
            }

            Button("Add Work") {
                isShowingAddWork = true
            }
            .font(FaloTypography.body)
            .foregroundStyle(BonsaiWorldColors.accent)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .contentShape(Rectangle())
            .listRowBackground(BonsaiWorldColors.surface)
            .accessibilityLabel("Add Work")
            .accessibilityHint("Log work for this tree")
        }
    }

    private func workTypeIDs(in records: [WorkRecord]) -> [UUID] {
        let present = Set(records.map(\.workTypeID))
        return CanonicalWorkTypeID.catalog
            .map(\.id)
            .filter(present.contains)
    }

    private func filteredWork(_ records: [WorkRecord]) -> [WorkRecord] {
        switch workTypeFilter {
        case .all:
            return records
        case .type(let id):
            return records.filter { $0.workTypeID == id }
        }
    }

    @ViewBuilder
    private func workRow(_ record: WorkRecord) -> some View {
        let typeName = CanonicalWorkTypeID.name(for: record.workTypeID)
        let notes = record.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let mixID = record.soilMixID
        let mixName = mixID.flatMap { library.soilMix(id: $0)?.name }
            .flatMap { name -> String? in
                let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmed.isEmpty ? nil : trimmed
            }
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(typeName)
                .font(FaloTypography.body)
                .fontWeight(.semibold)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            Text(record.performedAt, style: .date)
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
            if let mixID, let mixName {
                NavigationLink(value: MobileRoute.soilMix(mixID)) {
                    Text(mixName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }
                .accessibilityHint("Open soil mix")
            }
            if !notes.isEmpty {
                Text(notes)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
        }
        .listRowBackground(BonsaiWorldColors.surface)
    }

    @ViewBuilder
    private func profileRow(label: String, value: String) -> some View {
        if !value.isEmpty {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(label)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                Text(value)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
            }
            .listRowBackground(BonsaiWorldColors.surface)
        }
    }

    private func importPickedItem(_ item: PhotosPickerItem) async {
        photoPickerItem = nil
        guard let jpeg = await MobilePhotoImport.jpeg(from: item) else { return }
        _ = library.addPhoto(
            to: treeID,
            jpegData: jpeg.data,
            width: jpeg.width,
            height: jpeg.height,
            fileName: jpeg.fileName
        )
    }

    private func importCameraImage(_ image: UIImage) {
        guard let jpeg = MobilePhotoImport.jpeg(from: image, fileName: "camera.jpg") else { return }
        _ = library.addPhoto(
            to: treeID,
            jpegData: jpeg.data,
            width: jpeg.width,
            height: jpeg.height,
            fileName: jpeg.fileName
        )
    }

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func hasAnyMeasurement(_ tree: Tree) -> Bool {
        tree.heightMillimetres != nil
            || tree.crownWidthMillimetres != nil
            || tree.nebariWidthMillimetres != nil
            || tree.trunkDiameterMillimetres != nil
    }

    private func centimetresLabel(fromMillimetres mm: Int) -> String {
        let cm = Decimal(mm) / 10
        return "\(cm) cm"
    }

    private func shapingInProgressSummary(for tree: Tree) -> String {
        guard let areas = tree.shaping?.areas else { return "" }
        let titles = ShapingAreaID.allCases.compactMap { area -> String? in
            guard let record = areas[area.rawValue], record.status == .inProgress else { return nil }
            return area.title
        }
        guard !titles.isEmpty else { return "" }
        if titles.count == 1 { return "In Progress · \(titles[0])" }
        return "In Progress · \(titles.count) areas"
    }
}

#Preview {
    NavigationStack {
        TreeProfileView(treeID: DemoLibrary.sampleTrees[0].id)
    }
    .environment(DemoLibrary.preview)
}
