//
//  NewTaskView.swift
//  Bonsai World
//
//  Field New Task — one Tree, Work Type, Due, Title (from Work Type), Notes.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var workTypeID: UUID = CanonicalWorkTypeID.watering
    @State private var treeID: UUID?
    @State private var dueDate: Date = .now
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var didLoadInitial = false

    private var treeOptions: [Tree] {
        library.myTrees.sorted {
            MobileTreePresentation.title(for: $0)
                .localizedStandardCompare(MobileTreePresentation.title(for: $1)) == .orderedAscending
        }
    }

    private var canSave: Bool {
        treeID != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Work Type", selection: $workTypeID) {
                        ForEach(CanonicalWorkTypeID.catalog) { type in
                            Text(type.name).tag(type.id)
                        }
                    }
                    .onChange(of: workTypeID) { _, newValue in
                        title = CanonicalWorkTypeID.name(for: newValue)
                    }

                    Picker("Tree", selection: $treeID) {
                        Text("Select Tree").tag(Optional<UUID>.none)
                        ForEach(treeOptions) { tree in
                            Text(MobileTreePresentation.title(for: tree)).tag(Optional(tree.id))
                        }
                    }

                    DatePicker("Due", selection: $dueDate, displayedComponents: .date)

                    HStack(spacing: FaloSpacing.medium) {
                        Button("Today") {
                            dueDate = Calendar.current.startOfDay(for: .now)
                        }
                        .font(FaloTypography.body.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Due today")

                        Button("Tomorrow") {
                            dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now)) ?? .now
                        }
                        .font(FaloTypography.body.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Due tomorrow")
                    }

                    TextField("Task title", text: $title)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Task title")
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 88)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Notes")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .onAppear {
                guard !didLoadInitial else { return }
                if let remembered = Self.rememberedWorkTypeID {
                    workTypeID = remembered
                }
                title = CanonicalWorkTypeID.name(for: workTypeID)
                if treeID == nil {
                    if let rememberedTree = Self.rememberedTreeID,
                       treeOptions.contains(where: { $0.id == rememberedTree }) {
                        treeID = rememberedTree
                    } else {
                        treeID = treeOptions.first?.id
                    }
                }
                didLoadInitial = true
            }
        }
    }

    private static let rememberedWorkTypeKey = "bonsai.mobile.lastWorkTypeID"
    private static let rememberedTreeKey = "bonsai.mobile.lastTreeID"

    private static var rememberedWorkTypeID: UUID? {
        guard let raw = UserDefaults.standard.string(forKey: rememberedWorkTypeKey) else { return nil }
        return UUID(uuidString: raw)
    }

    private static func rememberWorkTypeID(_ id: UUID) {
        UserDefaults.standard.set(id.uuidString, forKey: rememberedWorkTypeKey)
    }

    private static var rememberedTreeID: UUID? {
        guard let raw = UserDefaults.standard.string(forKey: rememberedTreeKey) else { return nil }
        return UUID(uuidString: raw)
    }

    private static func rememberTreeID(_ id: UUID) {
        UserDefaults.standard.set(id.uuidString, forKey: rememberedTreeKey)
    }

    private func save() {
        guard let treeID else { return }
        guard let task = library.addTask(
            title: title,
            workTypeID: workTypeID,
            treeID: treeID,
            dueDate: dueDate,
            notes: notes
        ) else { return }
        Self.rememberWorkTypeID(workTypeID)
        Self.rememberTreeID(treeID)
        onCreated(task.id)
        dismiss()
    }
}

#Preview {
    NewTaskView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
