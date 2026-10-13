//
//  YamadoriFindProfileView.swift
//  Bonsai World
//
//  Find profile — code, name, status (Scout/Planned), notes, map, photos, Mark Collected.
//

import PhotosUI
import SwiftUI
import UIKit

struct YamadoriFindProfileView: View {
    @Environment(DemoLibrary.self) private var library

    let findID: UUID
    var onCollectedTree: ((UUID) -> Void)? = nil

    @State private var displayName: String = ""
    @State private var status: YamadoriStatus = .scout
    @State private var speciesEstimate: String = ""
    @State private var notes: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var didLoad = false
    @State private var isShowingCollect = false
    @State private var isShowingMove = false
    @State private var isShowingAddObservation = false
    @State private var confirmAbandon = false
    @State private var confirmArchive = false
    @State private var isShowingAddPhotoOptions = false
    @State private var isPhotoPickerPresented = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var isShowingCamera = false
    @State private var photoPendingRemoval: UUID?
    @State private var confirmRemovePhoto = false

    private var find: YamadoriFind? { library.yamadoriFind(id: findID) }

    private var isUncollected: Bool {
        find?.status.isUncollected == true
    }

    private var editableStatuses: [YamadoriStatus] {
        YamadoriStatus.allCases.filter(\.isUncollected)
    }

    private var canSave: Bool {
        isUncollected && !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var canMarkCollected: Bool {
        find?.status == .planned
    }

    private var canMoveToMyTrees: Bool {
        guard let find, find.status.canTransferToTree else { return false }
        guard let treeID = find.linkedTreeID, let tree = library.tree(id: treeID) else { return false }
        return tree.yamadoriNursery
    }

    private var canAbandon: Bool {
        find?.status.isUncollected == true
    }

    private var canArchive: Bool {
        find?.status == .abandoned
    }

    private var canAddObservation: Bool {
        find?.status != .archived
    }

    var body: some View {
        Group {
            if let find {
                form(find)
            } else {
                ContentUnavailableView("Find not found", systemImage: "leaf.circle")
            }
        }
        .onAppear { loadIfNeeded() }
    }

    private func form(_ find: YamadoriFind) -> some View {
        Form {
            if let heroID = find.primaryImageID ?? find.imageIDs.first {
                Section {
                    MobileAssetImage(imageID: heroID, style: .hero)
                        .listRowInsets(EdgeInsets(
                            top: FaloSpacing.medium,
                            leading: FaloSpacing.large,
                            bottom: FaloSpacing.medium,
                            trailing: FaloSpacing.large
                        ))
                        .listRowBackground(BonsaiWorldColors.surface)
                        .accessibilityLabel("Primary photo")
                }
            }

            Section {
                LabeledContent("Code", value: find.yamadoriCode)
                    .font(FaloTypography.body)

                NavigationLink(value: MobileRoute.yamadoriTrip(find.yamadoriID)) {
                    Text("Open Trip")
                        .font(FaloTypography.body)
                }
                .accessibilityHint("Open the Yamadori trip for this find")

                if isUncollected {
                    TextField("Name", text: $displayName)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Name")

                    Picker("Status", selection: $status) {
                        ForEach(editableStatuses, id: \.self) { value in
                            Text(value.title).tag(value)
                        }
                    }

                    TextField("Species estimate", text: $speciesEstimate)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Species estimate")
                } else {
                    LabeledContent("Name", value: find.displayName.isEmpty ? find.yamadoriCode : find.displayName)
                    LabeledContent("Status", value: find.status.title)
                    if let estimate = find.speciesEstimate, !estimate.isEmpty {
                        LabeledContent("Species estimate", value: estimate)
                    }
                    if let treeID = find.linkedTreeID {
                        NavigationLink(value: MobileRoute.tree(treeID)) {
                            Text("Open Yamadori Tree")
                                .font(FaloTypography.body)
                        }
                    }
                }
            }

            if isUncollected {
                Section("Site") {
                    MobileYamadoriMapCard(
                        latitude: $latitude,
                        longitude: $longitude,
                        primaryTitle: displayName.isEmpty ? find.yamadoriCode : displayName
                    )
                }
            } else if find.hasCoordinates {
                Section("Site") {
                    LabeledContent(
                        "Coordinates",
                        value: String(format: "%.5f, %.5f", find.latitude ?? 0, find.longitude ?? 0)
                    )
                    .font(FaloTypography.caption)
                }
            }

            photosSection(find)

            observationsSection(find)

            if isUncollected {
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 88)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Notes")
                }
            } else if !find.notes.isEmpty {
                Section("Notes") {
                    Text(find.notes)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }
            }

            if canMarkCollected {
                Section {
                    Button("Mark Collected") {
                        isShowingCollect = true
                    }
                    .font(FaloTypography.body.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Mark Collected")
                    .accessibilityHint("Create a Yamadori Tree from this Find")
                }
            }

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
                    .accessibilityHint("Graduate this Yamadori Tree into My Trees")
                }
            }

            if canAbandon {
                Section {
                    Button("Abandon Find", role: .destructive) {
                        confirmAbandon = true
                    }
                    .font(FaloTypography.body)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Abandon Find")
                }
            }

            if canArchive {
                Section {
                    Button("Archive Find", role: .destructive) {
                        confirmArchive = true
                    }
                    .font(FaloTypography.body)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Archive Find")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(find.yamadoriCode)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isUncollected {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
        }
        .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $isShowingCollect) {
            MarkYamadoriCollectedView(findID: findID) { treeID in
                onCollectedTree?(treeID)
            }
        }
        .sheet(isPresented: $isShowingMove) {
            MoveYamadoriToMyTreesView(findID: findID) { treeID in
                onCollectedTree?(treeID)
            }
        }
        .sheet(isPresented: $isShowingAddObservation) {
            NewYamadoriObservationView(findID: findID)
        }
        .confirmationDialog(
            "Abandon this Find?",
            isPresented: $confirmAbandon,
            titleVisibility: .visible
        ) {
            Button("Abandon", role: .destructive) {
                _ = library.setYamadoriFindStatus(findID: findID, to: .abandoned)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Closes the Find without collecting. You can Archive it later.")
        }
        .confirmationDialog(
            "Archive this Find?",
            isPresented: $confirmArchive,
            titleVisibility: .visible
        ) {
            Button("Archive", role: .destructive) {
                _ = library.setYamadoriFindStatus(findID: findID, to: .archived)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Moves the abandoned Find to history.")
        }
        .confirmationDialog(
            "Remove this photo?",
            isPresented: $confirmRemovePhoto,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                if let imageID = photoPendingRemoval {
                    library.removePhoto(fromFind: findID, imageID: imageID)
                }
                photoPendingRemoval = nil
            }
            Button("Cancel", role: .cancel) {
                photoPendingRemoval = nil
            }
        }
        .confirmationDialog("Add Photo", isPresented: $isShowingAddPhotoOptions, titleVisibility: .visible) {
            if MobilePhotoImport.isCameraAvailable {
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
    }

    @ViewBuilder
    private func photosSection(_ find: YamadoriFind) -> some View {
        Section("Photos") {
            if find.imageIDs.isEmpty {
                Text("No photos yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: FaloSpacing.small) {
                        ForEach(find.imageIDs, id: \.self) { imageID in
                            Button {
                                library.setPrimaryImage(findID: find.id, imageID: imageID)
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    MobileAssetImage(imageID: imageID)
                                    if find.primaryImageID == imageID {
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
                                    library.setPrimaryImage(findID: find.id, imageID: imageID)
                                }
                                Button("Remove Photo", role: .destructive) {
                                    photoPendingRemoval = imageID
                                    confirmRemovePhoto = true
                                }
                            }
                            .accessibilityLabel(find.primaryImageID == imageID ? "Primary photo" : "Set as primary photo")
                            .accessibilityHint("Long press for more options")
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

            if !find.imageIDs.isEmpty {
                Text("Long press a photo to remove it.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
                    .listRowBackground(BonsaiWorldColors.surface)
            }
        }
    }

    @ViewBuilder
    private func observationsSection(_ find: YamadoriFind) -> some View {
        let ordered = find.observations.sorted { $0.date > $1.date }
        Section("Observations") {
            if ordered.isEmpty {
                Text("No observations yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ForEach(ordered) { observation in
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text(observation.date, format: .dateTime.day().month().year().hour().minute())
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        Text(observation.text)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityElement(children: .combine)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete", role: .destructive) {
                            library.removeYamadoriObservation(findID: find.id, observationID: observation.id)
                        }
                        .accessibilityLabel("Delete Observation")
                    }
                }
            }

            if canAddObservation {
                Button("Add Observation") {
                    isShowingAddObservation = true
                }
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.accent)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Add Observation")
            }
        }
    }

    private func loadIfNeeded() {
        guard !didLoad, let find else { return }
        displayName = find.displayName
        status = find.status.isUncollected ? find.status : .scout
        speciesEstimate = find.speciesEstimate ?? ""
        notes = find.notes
        latitude = find.latitude
        longitude = find.longitude
        didLoad = true
    }

    private func save() {
        library.updateYamadoriFind(
            id: findID,
            displayName: displayName,
            status: status,
            notes: notes,
            latitude: latitude,
            longitude: longitude,
            speciesEstimate: speciesEstimate
        )
    }

    private func importPickedItem(_ item: PhotosPickerItem) async {
        photoPickerItem = nil
        guard let jpeg = await MobilePhotoImport.jpeg(from: item) else { return }
        _ = library.addPhoto(
            toFind: findID,
            jpegData: jpeg.data,
            width: jpeg.width,
            height: jpeg.height,
            fileName: jpeg.fileName
        )
    }

    private func importCameraImage(_ image: UIImage) {
        guard let jpeg = MobilePhotoImport.jpeg(from: image, fileName: "camera.jpg") else { return }
        _ = library.addPhoto(
            toFind: findID,
            jpegData: jpeg.data,
            width: jpeg.width,
            height: jpeg.height,
            fileName: jpeg.fileName
        )
    }
}

#Preview {
    NavigationStack {
        YamadoriFindProfileView(findID: UUID())
    }
    .environment(DemoLibrary.preview)
}
