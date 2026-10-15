//
//  MediaLibraryWorkspaceView.swift
//  Bonsai World
//
//  Media → Documents / Videos / Notes / Audio (v1).
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct MediaLibraryWorkspaceView: View {
    let kind: MediaLibraryKind

    @Environment(AppState.self) private var appState
    @Environment(MediaLibraryService.self) private var service
    @Environment(StorageService.self) private var storage

    @State private var isCreatePresented = false
    @State private var importErrorMessage: String?

    private var selectedID: UUID? {
        appState.selectedMediaLibraryItemID(for: kind)
    }

    var body: some View {
        Group {
            if let selectedID, let item = service.item(id: selectedID), item.kind == kind {
                MediaLibraryDetailView(kind: kind, itemID: selectedID)
            } else {
                MediaLibraryListView(kind: kind, isCreatePresented: $isCreatePresented)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle(kind.title)
        .sheet(isPresented: $isCreatePresented) {
            NewMediaLibraryItemView(kind: kind)
        }
        .alert("Could not add \(kind.singularTitle.lowercased())", isPresented: Binding(
            get: { importErrorMessage != nil },
            set: { if !$0 { importErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(importErrorMessage ?? "")
        }
        .onAppear { consumeWantsNewMediaItem() }
        .onChange(of: appState.wantsNewMediaLibraryKind) { _, pending in
            guard pending == kind else { return }
            consumeWantsNewMediaItem()
        }
    }

    private func consumeWantsNewMediaItem() {
        guard appState.wantsNewMediaLibraryKind == kind else { return }
        appState.wantsNewMediaLibraryKind = nil
        if kind.requiresImportedFile {
            Task { await importFileAndCreate() }
        } else {
            isCreatePresented = true
        }
    }

    /// Finder → copy into library package → catalog row (CH1, Video / Document).
    private func importFileAndCreate() async {
        guard let url = await ImportFilePanel.chooseFile(
            contentTypes: kind.importContentTypes,
            prompt: "Add \(kind.singularTitle)"
        ) else { return }

        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess { url.stopAccessingSecurityScopedResource() }
        }

        do {
            let data = try Data(contentsOf: url)
            guard !data.isEmpty else {
                importErrorMessage = "The selected file is empty."
                return
            }
            let ext = url.pathExtension.trimmingCharacters(in: .whitespacesAndNewlines)
            let safeExt = ext.isEmpty ? "bin" : ext.lowercased()
            let id = UUID()
            let relativePath = "\(LibraryPackageLayout.documents)/\(kind.importFolderName)/\(id.uuidString).\(safeExt)"
            try storage.savePackageFile(relativePath: relativePath, data: data)

            let title = url.deletingPathExtension().lastPathComponent
                .trimmingCharacters(in: .whitespacesAndNewlines)
            do {
                let item = try service.create(
                    MediaLibraryCreateDraft(
                        id: id,
                        kind: kind,
                        title: title.isEmpty ? kind.singularTitle : title,
                        notes: "",
                        relativePath: relativePath
                    )
                )
                appState.setSelectedMediaLibraryItemID(item.id, for: kind)
            } catch {
                try? storage.deletePackageFile(relativePath: relativePath)
                throw error
            }
        } catch {
            importErrorMessage = error.localizedDescription
        }
    }
}

struct MediaLibraryListView: View {
    let kind: MediaLibraryKind
    @Binding var isCreatePresented: Bool

    @Environment(AppState.self) private var appState
    @Environment(MediaLibraryService.self) private var service

    private var items: [MediaLibraryItem] {
        service.items(kind: kind)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(kind.title)
                        .font(FaloTypography.headline)
                    Text("\(items.count) \(kind.title.lowercased()) · \(kind.fileTypesHelp)")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                DetailCard(title: kind.title) {
                    if items.isEmpty {
                        Text("No \(kind.title.lowercased()) yet. Add one to start.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(items) { item in
                            Button {
                                appState.setSelectedMediaLibraryItemID(item.id, for: kind)
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(FaloCardTypography.fieldValue)
                                        .foregroundStyle(.primary)
                                    if !item.notes.isEmpty {
                                        Text(item.notes)
                                            .font(FaloTypography.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, FaloSpacing.xSmall)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        // Add — Context Tools
    }
}

struct MediaLibraryDetailView: View {
    let kind: MediaLibraryKind
    let itemID: UUID

    @Environment(AppState.self) private var appState
    @Environment(MediaLibraryService.self) private var service
    @Environment(StorageService.self) private var storage

    @State private var notesDraft = ""
    @State private var errorMessage: String?

    private var item: MediaLibraryItem? { service.item(id: itemID) }

    var body: some View {
        Group {
            if let item {
                ScrollView {
                    VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                        HStack {
                            Button("All \(kind.title)") {
                                appState.setSelectedMediaLibraryItemID(nil, for: kind)
                            }
                            .buttonStyle(.borderless)
                            Spacer()
                            Button("Delete", role: .destructive) {
                                if let relativePath = item.relativePath, !relativePath.isEmpty {
                                    try? storage.deletePackageFile(relativePath: relativePath)
                                }
                                try? service.delete(id: item.id)
                                appState.setSelectedMediaLibraryItemID(nil, for: kind)
                            }
                            .buttonStyle(.borderless)
                        }
                        VStack(alignment: .leading, spacing: FaloSpacing.small) {
                            Text(item.title)
                                .font(FaloTypography.pageTitle)
                            if let relativePath = item.relativePath, !relativePath.isEmpty {
                                Text(relativePath)
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        DetailCard(title: "Notes") {
                            TextField("Notes", text: $notesDraft, axis: .vertical)
                                .lineLimit(4...10)
                            Button("Save Notes") {
                                do {
                                    _ = try service.updateNotes(id: item.id, notes: notesDraft)
                                } catch {
                                    errorMessage = error.localizedDescription
                                }
                            }
                        }
                    }
                    .padding(FaloSpacing.xLarge)
                    .frame(maxWidth: 900, alignment: .leading)
                }
                .faloScrollSurface()
                .onAppear { notesDraft = item.notes }
            } else {
                ContentUnavailableView("Not found", systemImage: kind.systemImage)
            }
        }
        .alert("Could not update", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

/// Notes (and Audio stub) — title/notes only. Video / Document use Finder import instead.
struct NewMediaLibraryItemView: View {
    let kind: MediaLibraryKind

    @Environment(\.dismiss) private var dismiss
    @Environment(MediaLibraryService.self) private var service
    @Environment(AppState.self) private var appState

    @State private var title = ""
    @State private var notes = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                if let errorMessage {
                    Section { Text(errorMessage).foregroundStyle(.red) }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Add \(kind.singularTitle)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .frame(minWidth: 420, minHeight: 320)
    }

    private func create() {
        do {
            let item = try service.create(
                MediaLibraryCreateDraft(kind: kind, title: title, notes: notes, relativePath: nil)
            )
            appState.setSelectedMediaLibraryItemID(item.id, for: kind)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
