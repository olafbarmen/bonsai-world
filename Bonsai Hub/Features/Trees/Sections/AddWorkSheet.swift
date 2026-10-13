//
//  AddWorkSheet.swift
//  Bonsai World
//
//  Registers a completed Work entry on one Tree (Context Tools → Add Work).
//  Batch (multiple trees) and scheduling stay reserved for the future Work module.
//  Wiring work offers a follow-up Task to check / remove the wire.
//

import SwiftUI

struct AddWorkSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(WorkService.self) private var workService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ReferenceDataManager.self) private var referenceDataManager

    let treeID: UUID
    /// Pre-selects a Work Type, e.g. when completing a Task that needs the full form.
    var initialWorkTypeID: UUID?
    /// Pre-selects a Fertilizer Type when registering fertilizing Work from Care.
    var initialFertilizerTypeID: UUID?
    /// Links the resulting WorkRecord back to the Task that generated it (Blueprint §5.9).
    var scheduleID: UUID?
    var onSave: (WorkRecord) -> Void = { _ in }

    @State private var workTypeID: UUID?
    @State private var performedAt: Date = .now
    @State private var notes: String = ""
    @State private var fertilizerTypeID: UUID?
    @State private var errorMessage: String?
    @State private var newFertilizerDraft: FertilizerTypeDraft?
    @State private var wireCheckPrompt: WireCheckPrompt?

    init(
        treeID: UUID,
        initialWorkTypeID: UUID? = nil,
        initialFertilizerTypeID: UUID? = nil,
        scheduleID: UUID? = nil,
        onSave: @escaping (WorkRecord) -> Void = { _ in }
    ) {
        self.treeID = treeID
        self.initialWorkTypeID = initialWorkTypeID
        self.initialFertilizerTypeID = initialFertilizerTypeID
        self.scheduleID = scheduleID
        self.onSave = onSave
        _workTypeID = State(initialValue: initialWorkTypeID)
        _fertilizerTypeID = State(initialValue: initialFertilizerTypeID)
    }

    private var selectedWorkType: WorkType? {
        workTypeID.flatMap { workService.workType(id: $0) }
    }

    private var requiresFertilizer: Bool {
        selectedWorkType?.behaviour.requiresFertilizer ?? false
    }

    private var isWiringWork: Bool {
        guard let workTypeID else { return false }
        if workTypeID == CanonicalWorkTypeID.wiring { return true }
        return selectedWorkType?.name.caseInsensitiveCompare("Wiring") == .orderedSame
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section {
                    Picker("Work Type", selection: $workTypeID) {
                        Text("Choose…").tag(UUID?.none)
                        ForEach(WorkTypeCategory.allCases) { category in
                            let types = workService.workTypes(in: category)
                            if !types.isEmpty {
                                Section(category.title) {
                                    ForEach(types) { type in
                                        Text(type.name).tag(Optional(type.id))
                                    }
                                }
                            }
                        }
                    }

                    DatePicker("Date", selection: $performedAt, displayedComponents: [.date])
                }

                if requiresFertilizer {
                    Section {
                        HStack {
                            Picker("Fertilizer", selection: $fertilizerTypeID) {
                                Text("Choose…").tag(UUID?.none)
                                ForEach(referenceData.fertilizerTypes) { fertilizer in
                                    Text("\(fertilizer.displayName) — \(fertilizer.classificationSummary)")
                                        .tag(Optional(fertilizer.id))
                                }
                            }

                            Button {
                                newFertilizerDraft = referenceDataManager.blankFertilizerTypeDraft()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .buttonStyle(.borderless)
                            .help("Add a new fertilizer product")
                        }
                    }
                }

                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.statusCritical)
                    }
                }
            }
            .formStyle(.grouped)

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Button("Save Work") { save() }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
                    .disabled(workTypeID == nil)
            }
            .padding(FaloSpacing.xLarge)
        }
        .frame(minWidth: 440, minHeight: 380)
        .navigationTitle("Add Work")
        .sheet(item: $newFertilizerDraft) { draft in
            FertilizerTypeEditorSheet(draft: draft) { created in
                fertilizerTypeID = created.id
            }
        }
        .sheet(item: $wireCheckPrompt) { prompt in
            WireCheckReminderSheet(
                treeID: prompt.treeID,
                wiredOn: prompt.wiredOn
            ) {
                dismiss()
            }
        }
    }

    private func save() {
        guard let workTypeID else { return }
        do {
            let record = try workService.registerWork(
                workTypeID: workTypeID,
                treeIDs: [treeID],
                performedAt: performedAt,
                notes: notes,
                fertilizerTypeID: requiresFertilizer ? fertilizerTypeID : nil,
                scheduleID: scheduleID
            )
            onSave(record)
            if isWiringWork {
                wireCheckPrompt = WireCheckPrompt(treeID: treeID, wiredOn: performedAt)
            } else {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct WireCheckPrompt: Identifiable {
    let id = UUID()
    let treeID: UUID
    let wiredOn: Date
}
