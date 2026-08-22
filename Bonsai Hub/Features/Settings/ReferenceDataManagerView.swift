//
//  ReferenceDataManagerView.swift
//  Bonsai World
//
//  Settings → Reference Data — manage reference vocabularies in memory.
//  Botanical taxonomy uses Botanical Library (hierarchical); other lists stay flat.
//

import SwiftUI

struct ReferenceDataManagerView: View {
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(UserProfileStore.self) private var profile

    @State private var selectedCategory: ReferenceDataCategory = .botanicalLibrary
    @State private var selectedItemID: UUID?
    @State private var editorDraft: ReferenceDataDraft?
    @State private var soilMixDraft: SoilMixDraft?
    @State private var workTypeDraft: WorkTypeDraft?
    @State private var locationDraft: LocationReferenceDraft?
    @State private var pendingDeleteID: UUID?

    private var records: [ReferenceDataRecord] {
        _ = manager.revision
        return manager.records(in: selectedCategory)
    }

    private var selectedRecord: ReferenceDataRecord? {
        guard let selectedItemID else { return nil }
        return records.first { $0.id == selectedItemID }
    }

    private var showsBotanicalLibrary: Bool {
        selectedCategory == .botanicalLibrary
    }

    var body: some View {
        HSplitView {
            categorySidebar
                .frame(minWidth: 180, idealWidth: 200, maxWidth: 260)

            Group {
                if showsBotanicalLibrary {
                    BotanicalLibraryView()
                } else {
                    itemList
                }
            }
            .frame(minWidth: 360)
        }
        .navigationTitle("Reference Data")
        .sheet(item: $editorDraft) { draft in
            ReferenceDataEditorSheet(category: selectedCategory, draft: draft)
        }
        .sheet(item: $soilMixDraft) { draft in
            SoilMixEditorSheet(draft: draft)
        }
        .sheet(item: $workTypeDraft) { draft in
            WorkTypeEditorSheet(draft: draft)
        }
        .sheet(item: $locationDraft) { draft in
            LocationReferenceEditorSheet(draft: draft)
        }
        .confirmationDialog(
            "Delete \(selectedCategory.title)?",
            isPresented: Binding(
                get: { pendingDeleteID != nil },
                set: { if !$0 { pendingDeleteID = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let id = pendingDeleteID {
                    manager.delete(id, in: selectedCategory)
                    if selectedItemID == id {
                        selectedItemID = nil
                    }
                }
                pendingDeleteID = nil
            }
            Button("Cancel", role: .cancel) {
                pendingDeleteID = nil
            }
        } message: {
            if let record = selectedRecord {
                Text("“\(record.name)” will be removed from this session. This cannot be undone.")
            } else {
                Text("This item will be removed from this session.")
            }
        }
        .onChange(of: selectedCategory) { _, _ in
            selectedItemID = nil
        }
    }

    // MARK: - Category sidebar

    private var categorySidebar: some View {
        List(selection: $selectedCategory) {
            ForEach(ReferenceDataCategoryGroup.allCases) { group in
                Section(group.title) {
                    ForEach(group.categories) { category in
                        Text(category.title)
                            .tag(category)
                    }
                }
            }
        }
        .faloScrollSurface()
        .listStyle(.sidebar)
    }

    // MARK: - Flat item list

    private var itemList: some View {
        VStack(spacing: 0) {
            List(selection: $selectedItemID) {
                ForEach(records) { record in
                    ReferenceDataItemRow(record: record) { isActive in
                        manager.setActive(record.id, in: selectedCategory, isActive: isActive)
                    }
                    .tag(record.id)
                    .contextMenu {
                        Button("Edit…") {
                            presentEdit(record)
                        }
                        Button("Delete…", role: .destructive) {
                            pendingDeleteID = record.id
                        }
                    }
                }
            }
            .faloScrollSurface()
            .overlay {
                if records.isEmpty {
                    ContentUnavailableView(
                        "No \(selectedCategory.title)",
                        systemImage: "list.bullet",
                        description: Text("Add an item to get started.")
                    )
                }
            }

            Divider()

            HStack(spacing: FaloSpacing.small) {
                Button {
                    presentAdd()
                } label: {
                    Label("Add", systemImage: "plus")
                }

                Button {
                    if let record = selectedRecord {
                        presentEdit(record)
                    }
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .disabled(selectedRecord == nil)

                Button(role: .destructive) {
                    if let id = selectedItemID {
                        pendingDeleteID = id
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selectedItemID == nil)

                Spacer()

                Text("\(records.count) items")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
            .padding(.horizontal, FaloSpacing.medium)
            .padding(.vertical, FaloSpacing.small)
            .background(.bar)
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    presentAdd()
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .help("Add \(selectedCategory.title)")

                Button {
                    if let record = selectedRecord {
                        presentEdit(record)
                    }
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .disabled(selectedRecord == nil)
                .help("Edit selected item")

                Button {
                    if let id = selectedItemID {
                        pendingDeleteID = id
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selectedItemID == nil)
                .help("Delete selected item")
            }
        }
    }

    // MARK: - Actions

    private func presentAdd() {
        if selectedCategory == .soilMixes {
            soilMixDraft = manager.blankSoilMixDraft()
        } else if selectedCategory == .workTypes {
            workTypeDraft = manager.blankWorkTypeDraft()
        } else if selectedCategory == .locations {
            locationDraft = manager.blankLocationDraft(gardenID: profile.defaultGarden?.id)
        } else {
            editorDraft = .blank(
                sortOrder: manager.nextSortOrder(in: selectedCategory),
                parentID: nil
            )
        }
    }

    private func presentEdit(_ record: ReferenceDataRecord) {
        if selectedCategory == .soilMixes {
            soilMixDraft = manager.soilMixDraft(for: record.id)
        } else if selectedCategory == .workTypes {
            workTypeDraft = manager.workTypeDraft(for: record.id)
        } else if selectedCategory == .locations {
            locationDraft = manager.locationDraft(for: record.id)
        } else {
            editorDraft = manager.draft(from: record)
        }
    }
}

#Preview {
    let store = ReferencePreviewData()
    return ReferenceDataManagerView()
        .environment(ReferenceDataManager(store: store))
        .environment(BotanicalService(store: store))
        .frame(width: 800, height: 560)
}
