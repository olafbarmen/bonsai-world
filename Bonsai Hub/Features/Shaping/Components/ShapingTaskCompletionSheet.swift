//
//  ShapingTaskCompletionSheet.swift
//  Bonsai World
//
//  Records what was actually done when completing a Shaping-linked Task.
//

import SwiftUI

struct ShapingTaskCompletionSheet: View {
    let task: CareTask
    let treeID: UUID
    var onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService
    @Environment(ImageImportService.self) private var imageImportService
    @Environment(ImageService.self) private var imageService

    @State private var performedAt = Date.now
    @State private var description = ""
    @State private var imageIDs: [UUID] = []
    @State private var isImporting = false
    @State private var errorMessage: String?

    private var areaTitle: String {
        guard let raw = task.shapingAreaID, let area = ShapingAreaID(rawValue: raw) else {
            return "Shaping"
        }
        return area.title
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    Text(task.title)
                    if !task.notes.isEmpty {
                        Text(task.notes)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Shaping Area") {
                    Text(areaTitle)
                }

                Section("When") {
                    DatePicker("Date", selection: $performedAt, displayedComponents: .date)
                }

                Section("What was done?") {
                    TextEditor(text: $description)
                        .font(FaloCardTypography.fieldValue)
                        .frame(minHeight: 100)
                }

                Section("Photos") {
                    if !imageIDs.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: FaloSpacing.small) {
                                ForEach(imageIDs, id: \.self) { imageID in
                                    TreeListThumbnail(imageID: imageID, imageService: imageService)
                                }
                            }
                        }
                    }
                    Button {
                        Task { await addPhoto() }
                    } label: {
                        Label("Add Photo", systemImage: "plus")
                    }
                    .disabled(isImporting)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Complete Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save & Complete") { complete() }
                        .disabled(description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert("Couldn't Complete Task", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .frame(minWidth: 460, minHeight: 480)
        .onAppear {
            if description.isEmpty {
                description = task.notes
            }
        }
    }

    private func complete() {
        do {
            _ = try taskService.completeShapingTask(
                task,
                treeID: treeID,
                description: description,
                performedAt: performedAt,
                imageIDs: imageIDs
            )
            onComplete()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func addPhoto() async {
        isImporting = true
        defer { isImporting = false }
        do {
            let asset = try await imageImportService.importGalleryImageFromFinder()
            guard !imageIDs.contains(asset.id) else { return }
            imageIDs.append(asset.id)
        } catch {
            return
        }
    }
}
