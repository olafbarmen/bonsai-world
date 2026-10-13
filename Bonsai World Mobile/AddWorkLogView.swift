//
//  AddWorkLogView.swift
//  Bonsai World
//
//  Field Add Work — canonical WorkRecord + CanonicalWorkTypeID.
//  Optional completingTaskID marks a CareTask completed after Save.
//  Repotting can set the Tree's Soil Mix.
//

import SwiftUI

struct AddWorkLogView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let treeID: UUID
    var initialWorkTypeID: UUID = CanonicalWorkTypeID.watering
    var completingTaskID: UUID? = nil

    @State private var workTypeID: UUID = CanonicalWorkTypeID.watering
    @State private var performedAt: Date = .now
    @State private var notes: String = ""
    @State private var soilMixID: UUID?
    @State private var didLoadInitial = false

    private var isRepotting: Bool {
        workTypeID == CanonicalWorkTypeID.repotting
    }

    var body: some View {
        NavigationStack {
            formContent
                .scrollContentBackground(.hidden)
                .background(BonsaiWorldColors.canvas)
                .scrollDismissesKeyboard(.interactively)
                .navigationTitle("Add Work")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { formToolbar }
                .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear(perform: loadInitialIfNeeded)
        }
    }

    private var formContent: some View {
        Form {
            workTypeSection
            if isRepotting, !library.orderedSoilMixes.isEmpty {
                soilMixSection
            }
            notesSection
        }
    }

    private var workTypeSection: some View {
        Section {
            Picker("Work Type", selection: $workTypeID) {
                ForEach(CanonicalWorkTypeID.catalog) { type in
                    Text(type.name).tag(type.id)
                }
            }
            DatePicker("Date", selection: $performedAt, displayedComponents: .date)
        } footer: {
            Text("Defaults to Today.")
                .font(FaloTypography.caption)
        }
    }

    private var soilMixSection: some View {
        Section("Soil Mix") {
            Picker("Soil Mix", selection: $soilMixID) {
                Text("None").tag(Optional<UUID>.none)
                ForEach(library.orderedSoilMixes) { mix in
                    Text(mix.name).tag(Optional(mix.id))
                }
            }
            .accessibilityLabel("Soil Mix")
        }
    }

    private var notesSection: some View {
        Section {
            TextEditor(text: $notes)
                .frame(minHeight: 88)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityLabel("Notes")
        } header: {
            Text("Notes")
        } footer: {
            Text("Optional notes for this work.")
                .font(FaloTypography.caption)
        }
    }

    @ToolbarContentBuilder
    private var formToolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") { save() }
                .fontWeight(.semibold)
        }
    }

    private static let rememberedWorkTypeKey = "bonsai.mobile.lastWorkTypeID"
    private static let rememberedWorkTypePerTreePrefix = "bonsai.mobile.lastWorkTypeID.tree."

    private static var rememberedWorkTypeID: UUID? {
        guard let raw = UserDefaults.standard.string(forKey: rememberedWorkTypeKey) else { return nil }
        return UUID(uuidString: raw)
    }

    private static func rememberedWorkTypeID(for treeID: UUID) -> UUID? {
        let key = rememberedWorkTypePerTreePrefix + treeID.uuidString
        guard let raw = UserDefaults.standard.string(forKey: key) else { return nil }
        return UUID(uuidString: raw)
    }

    private static func rememberWorkTypeID(_ id: UUID, for treeID: UUID) {
        UserDefaults.standard.set(id.uuidString, forKey: rememberedWorkTypeKey)
        UserDefaults.standard.set(id.uuidString, forKey: rememberedWorkTypePerTreePrefix + treeID.uuidString)
    }

    private func loadInitialIfNeeded() {
        guard !didLoadInitial else { return }
        if completingTaskID != nil {
            workTypeID = initialWorkTypeID
        } else if let remembered = Self.rememberedWorkTypeID(for: treeID) {
            workTypeID = remembered
        } else if let remembered = Self.rememberedWorkTypeID {
            workTypeID = remembered
        } else {
            workTypeID = initialWorkTypeID
        }
        soilMixID = library.tree(id: treeID)?.soilMixID
        didLoadInitial = true
    }

    private func save() {
        let applySoil = isRepotting && !library.orderedSoilMixes.isEmpty
        let record = library.addWork(
            treeID: treeID,
            workTypeID: workTypeID,
            performedAt: performedAt,
            notes: notes,
            scheduleID: completingTaskID,
            soilMixID: applySoil ? soilMixID : nil,
            applySoilMix: applySoil
        )
        Self.rememberWorkTypeID(workTypeID, for: treeID)
        if let completingTaskID {
            library.completeTask(id: completingTaskID, resultingWorkRecordID: record.id)
        }
        dismiss()
    }
}

#Preview {
    AddWorkLogView(treeID: DemoLibrary.sampleTrees[0].id)
        .environment(DemoLibrary.preview)
}
