//
//  YamadoriFindProfileView.swift
//  Bonsai World
//
//  Find profile — Mac Find fields: botanical pickers, Evaluation, Collection,
//  Recovery, History (read-only), photos, Mark Collected.
//

import PhotosUI
import SwiftUI
import UIKit

struct YamadoriFindProfileView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let findID: UUID
    var onCollectedTree: ((UUID) -> Void)? = nil

    @State private var displayName: String = ""
    @State private var status: YamadoriStatus = .scout
    @State private var genusID: UUID?
    @State private var speciesID: UUID?
    @State private var cultivarID: UUID?
    @State private var notes: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?

    @State private var evaluationTrunk = ""
    @State private var evaluationNebari = ""
    @State private var evaluationMovement = ""
    @State private var evaluationTaper = ""
    @State private var evaluationBranches = ""
    @State private var evaluationHealth = ""
    @State private var evaluationAccessibility = ""
    @State private var evaluationDifficulty = ""
    @State private var evaluationOverall = ""

    @State private var knowsCollectionDate = false
    @State private var collectionDate = Date.now
    @State private var collectionObservations = ""
    @State private var rootNotes = ""
    @State private var transportNotes = ""
    @State private var initialPlacement = ""
    @State private var initialRecoveryNotes = ""

    @State private var recoveryLocationNotes = ""
    @State private var recoveryCareNotes = ""
    @State private var establishmentAssessment = ""

    @State private var genera: [Genus] = []
    @State private var speciesAll: [Species] = []
    @State private var cultivarsAll: [Cultivar] = []

    @State private var didLoad = false
    @State private var isShowingCollect = false
    @State private var isShowingMove = false
    @State private var isShowingAddObservation = false
    @State private var confirmAbandon = false
    @State private var confirmArchive = false
    @State private var confirmDeleteFind = false
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

    private var speciesChoices: [Species] {
        guard let genusID else { return [] }
        return speciesAll
            .filter { $0.genusID == genusID && $0.isActive }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    private var cultivarChoices: [Cultivar] {
        guard let speciesID else { return [] }
        return cultivarsAll
            .filter { $0.speciesID == speciesID && $0.isActive }
            .sorted { $0.sortOrder < $1.sortOrder }
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

            identitySection(find)

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

            evaluationSection(find)
            collectionSection(find)
            recoverySection(find)
            photosSection(find)
            observationsSection(find)
            historySection(find)

            if isUncollected {
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...8)
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

            Section {
                Button("Delete Find", role: .destructive) {
                    confirmDeleteFind = true
                }
                .font(FaloTypography.body)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Delete Find")
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
        .toolbarColorScheme(.light, for: .navigationBar)
        .onChange(of: genusID) { _, _ in
            if let speciesID, !speciesChoices.contains(where: { $0.id == speciesID }) {
                self.speciesID = nil
                self.cultivarID = nil
            }
        }
        .onChange(of: speciesID) { _, _ in
            if let cultivarID, !cultivarChoices.contains(where: { $0.id == cultivarID }) {
                self.cultivarID = nil
            }
        }
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
            "Delete this Find?",
            isPresented: $confirmDeleteFind,
            titleVisibility: .visible
        ) {
            Button("Delete Find", role: .destructive) {
                library.deleteYamadoriFind(id: findID)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes the Find. The trip stays.")
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
    private func identitySection(_ find: YamadoriFind) -> some View {
        Section {
            LabeledContent("Code", value: find.yamadoriCode)
                .font(FaloTypography.body)

            NavigationLink(value: MobileRoute.yamadoriTrip(find.yamadoriID)) {
                Text("Open Trip")
                    .font(FaloTypography.body)
            }
            .accessibilityHint("Open the Yamadori trip for this find")

            if isUncollected {
                TextField("Display Name", text: $displayName)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Display Name")

                Picker("Status", selection: $status) {
                    ForEach(editableStatuses, id: \.self) { value in
                        Text(value.title).tag(value)
                    }
                }

                Picker("Genus", selection: $genusID) {
                    Text("Select Genus").tag(Optional<UUID>.none)
                    ForEach(genera) { genus in
                        Text(genus.name).tag(Optional(genus.id))
                    }
                }
                .accessibilityLabel("Genus")

                Picker("Species", selection: $speciesID) {
                    Text("Select Species").tag(Optional<UUID>.none)
                    ForEach(speciesChoices) { species in
                        Text(species.name).tag(Optional(species.id))
                    }
                }
                .disabled(genusID == nil)
                .accessibilityLabel("Species")

                Picker("Cultivar", selection: $cultivarID) {
                    Text("None").tag(Optional<UUID>.none)
                    ForEach(cultivarChoices) { cultivar in
                        Text(cultivar.name).tag(Optional(cultivar.id))
                    }
                }
                .disabled(speciesID == nil)
                .accessibilityLabel("Cultivar")
            } else {
                LabeledContent("Display Name", value: find.displayName.isEmpty ? find.yamadoriCode : find.displayName)
                LabeledContent("Status", value: find.status.title)
                LabeledContent("Genus", value: genusName(find.genusID))
                LabeledContent("Species", value: speciesName(find.speciesID))
                LabeledContent("Cultivar", value: cultivarName(find.cultivarID))
                if let treeID = find.linkedTreeID {
                    NavigationLink(value: MobileRoute.tree(treeID)) {
                        Text("Open Yamadori Tree")
                            .font(FaloTypography.body)
                    }
                }
            }
        } header: {
            Text("Find")
        }
    }

    @ViewBuilder
    private func evaluationSection(_ find: YamadoriFind) -> some View {
        Section("Evaluation") {
            if isUncollected {
                evaluationField("Trunk", text: $evaluationTrunk)
                evaluationField("Nebari", text: $evaluationNebari)
                evaluationField("Movement", text: $evaluationMovement)
                evaluationField("Taper", text: $evaluationTaper)
                evaluationField("Branches", text: $evaluationBranches)
                evaluationField("Health", text: $evaluationHealth)
                evaluationField("Accessibility", text: $evaluationAccessibility)
                evaluationField("Difficulty", text: $evaluationDifficulty)
                evaluationField("Overall", text: $evaluationOverall)
            } else {
                readOnlyEvaluation("Trunk", find.evaluationTrunk)
                readOnlyEvaluation("Nebari", find.evaluationNebari)
                readOnlyEvaluation("Movement", find.evaluationMovement)
                readOnlyEvaluation("Taper", find.evaluationTaper)
                readOnlyEvaluation("Branches", find.evaluationBranches)
                readOnlyEvaluation("Health", find.evaluationHealth)
                readOnlyEvaluation("Accessibility", find.evaluationAccessibility)
                readOnlyEvaluation("Difficulty", find.evaluationDifficulty)
                readOnlyEvaluation("Overall", find.evaluationOverall)
            }
        }
    }

    @ViewBuilder
    private func collectionSection(_ find: YamadoriFind) -> some View {
        Section("Collection") {
            if isUncollected {
                Toggle("Collection Date", isOn: $knowsCollectionDate)
                if knowsCollectionDate {
                    DatePicker("Date", selection: $collectionDate, displayedComponents: .date)
                }
                evaluationField("Collection Observations", text: $collectionObservations)
                evaluationField("Root Notes", text: $rootNotes)
                evaluationField("Transport Notes", text: $transportNotes)
                evaluationField("Initial Placement", text: $initialPlacement)
                evaluationField("Initial Recovery Notes", text: $initialRecoveryNotes)
            } else {
                if let date = find.collectionDate {
                    LabeledContent("Collection Date", value: date.formatted(date: .abbreviated, time: .omitted))
                }
                readOnlyEvaluation("Collection Observations", find.collectionObservations)
                readOnlyEvaluation("Root Notes", find.rootNotes)
                readOnlyEvaluation("Transport Notes", find.transportNotes)
                readOnlyEvaluation("Initial Placement", find.initialPlacement)
                readOnlyEvaluation("Initial Recovery Notes", find.initialRecoveryNotes)
            }
        }
    }

    @ViewBuilder
    private func recoverySection(_ find: YamadoriFind) -> some View {
        Section("Recovery") {
            if isUncollected {
                evaluationField("Location Notes", text: $recoveryLocationNotes)
                evaluationField("Care Notes", text: $recoveryCareNotes)
                evaluationField("Establishment", text: $establishmentAssessment)
            } else {
                readOnlyEvaluation("Location Notes", find.recoveryLocationNotes)
                readOnlyEvaluation("Care Notes", find.recoveryCareNotes)
                readOnlyEvaluation("Establishment", find.establishmentAssessment)
            }
        }
    }

    private func evaluationField(_ label: String, text: Binding<String>) -> some View {
        TextField(label, text: text, axis: .vertical)
            .lineLimit(1...4)
            .font(FaloTypography.body)
            .foregroundStyle(BonsaiWorldColors.textPrimary)
            .accessibilityLabel(label)
    }

    @ViewBuilder
    private func readOnlyEvaluation(_ label: String, _ value: String) -> some View {
        if !value.isEmpty {
            LabeledContent(label, value: value)
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

    @ViewBuilder
    private func historySection(_ find: YamadoriFind) -> some View {
        let ordered = find.history.sorted { $0.date > $1.date }
        Section("History") {
            if ordered.isEmpty {
                Text("No history yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ForEach(ordered) { entry in
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text(entry.date, format: .dateTime.day().month().year().hour().minute())
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        Text(entry.note.isEmpty ? entry.kind.title : "\(entry.kind.title) — \(entry.note)")
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    private func genusName(_ id: UUID?) -> String {
        guard let id else { return "" }
        return genera.first { $0.id == id }?.name
            ?? GenusPreviewData.all.first { $0.id == id }?.name
            ?? ""
    }

    private func speciesName(_ id: UUID?) -> String {
        guard let id else { return "" }
        return speciesAll.first { $0.id == id }?.name
            ?? SpeciesPreviewData.all.first { $0.id == id }?.name
            ?? ""
    }

    private func cultivarName(_ id: UUID?) -> String {
        guard let id else { return "" }
        return cultivarsAll.first { $0.id == id }?.name
            ?? CultivarPreviewData.all.first { $0.id == id }?.name
            ?? ""
    }

    private func loadIfNeeded() {
        guard !didLoad, let find else { return }
        genera = GenusPreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        speciesAll = SpeciesPreviewData.all
        cultivarsAll = CultivarPreviewData.all

        displayName = find.displayName
        status = find.status.isUncollected ? find.status : .scout
        genusID = find.genusID
        speciesID = find.speciesID
        cultivarID = find.cultivarID
        notes = find.notes
        latitude = find.latitude
        longitude = find.longitude

        evaluationTrunk = find.evaluationTrunk
        evaluationNebari = find.evaluationNebari
        evaluationMovement = find.evaluationMovement
        evaluationTaper = find.evaluationTaper
        evaluationBranches = find.evaluationBranches
        evaluationHealth = find.evaluationHealth
        evaluationAccessibility = find.evaluationAccessibility
        evaluationDifficulty = find.evaluationDifficulty
        evaluationOverall = find.evaluationOverall

        if let date = find.collectionDate {
            knowsCollectionDate = true
            collectionDate = date
        }
        collectionObservations = find.collectionObservations
        rootNotes = find.rootNotes
        transportNotes = find.transportNotes
        initialPlacement = find.initialPlacement
        initialRecoveryNotes = find.initialRecoveryNotes

        recoveryLocationNotes = find.recoveryLocationNotes
        recoveryCareNotes = find.recoveryCareNotes
        establishmentAssessment = find.establishmentAssessment

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
            genusID: genusID,
            speciesID: speciesID,
            cultivarID: cultivarID,
            evaluationTrunk: evaluationTrunk,
            evaluationNebari: evaluationNebari,
            evaluationMovement: evaluationMovement,
            evaluationTaper: evaluationTaper,
            evaluationBranches: evaluationBranches,
            evaluationHealth: evaluationHealth,
            evaluationAccessibility: evaluationAccessibility,
            evaluationDifficulty: evaluationDifficulty,
            evaluationOverall: evaluationOverall,
            collectionDate: knowsCollectionDate ? collectionDate : nil,
            clearCollectionDate: !knowsCollectionDate,
            collectionObservations: collectionObservations,
            rootNotes: rootNotes,
            transportNotes: transportNotes,
            initialPlacement: initialPlacement,
            initialRecoveryNotes: initialRecoveryNotes,
            recoveryLocationNotes: recoveryLocationNotes,
            recoveryCareNotes: recoveryCareNotes,
            establishmentAssessment: establishmentAssessment
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
