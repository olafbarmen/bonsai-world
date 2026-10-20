//
//  TreeShapingView.swift
//  Bonsai World
//
//  Field Shaping — areas with status + nextAction (Mac Tree Detail → Shaping).
//

import SwiftUI

struct TreeShapingView: View {
    @Environment(DemoLibrary.self) private var library
    let treeID: UUID

    @State private var shaping: TreeShaping = .empty
    @State private var editingArea: ShapingAreaID?

    private var tree: Tree? { library.tree(id: treeID) }

    var body: some View {
        Group {
            if tree != nil {
                List {
                    ForEach(ShapingAreaGroup.allCases) { group in
                        Section(group.title) {
                            ForEach(group.areas) { area in
                                areaRow(area)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(BonsaiWorldColors.canvas)
                .navigationTitle("Shaping")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear { shaping = library.shaping(for: treeID) }
                .sheet(item: $editingArea) { area in
                    NavigationStack {
                        TreeShapingAreaEditView(
                            area: area,
                            record: shaping.record(for: area)
                        ) { updated in
                            library.updateShapingArea(treeID: treeID, area: area, record: updated)
                            shaping = library.shaping(for: treeID)
                        }
                    }
                }
            } else {
                ContentUnavailableView("Tree not found", systemImage: "leaf")
            }
        }
    }

    private func areaRow(_ area: ShapingAreaID) -> some View {
        let record = shaping.record(for: area)
        let next = record.nextAction.trimmingCharacters(in: .whitespacesAndNewlines)
        return Button {
            editingArea = area
        } label: {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                HStack {
                    Text(area.title)
                        .font(FaloTypography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    Spacer(minLength: 0)
                    Text(record.status.title)
                        .font(FaloTypography.caption)
                        .foregroundStyle(
                            record.status == .inProgress
                                ? BonsaiWorldColors.statusAttention
                                : BonsaiWorldColors.textSecondary
                        )
                }
                if !next.isEmpty {
                    Text(next)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical, FaloSpacing.xSmall)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(BonsaiWorldColors.surface)
        .accessibilityLabel("\(area.title), \(record.status.title)")
        .accessibilityHint(next.isEmpty ? "Edit shaping area" : next)
    }
}

struct TreeShapingAreaEditView: View {
    @Environment(\.dismiss) private var dismiss

    let area: ShapingAreaID
    let onSave: (ShapingAreaRecord) -> Void

    @State private var draft: ShapingAreaRecord

    init(
        area: ShapingAreaID,
        record: ShapingAreaRecord,
        onSave: @escaping (ShapingAreaRecord) -> Void
    ) {
        self.area = area
        self.onSave = onSave
        _draft = State(initialValue: record)
    }

    var body: some View {
        Form {
            Section {
                Picker("Status", selection: $draft.status) {
                    ForEach(ShapingAreaStatus.allCases) { value in
                        Text(value.title).tag(value)
                    }
                }
                .accessibilityLabel("Status")
                TextField("Next Action", text: $draft.nextAction, axis: .vertical)
                    .lineLimit(2...4)
                    .accessibilityLabel("Next Action")
            }

            Section("Observation") {
                TextField("Observation", text: $draft.observation, axis: .vertical)
                    .lineLimit(3...8)
                    .accessibilityLabel("Observation")
            }

            Section("Development Plan") {
                TextField("Development Plan", text: $draft.developmentPlan, axis: .vertical)
                    .lineLimit(3...8)
                    .accessibilityLabel("Development Plan")
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle(area.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave(draft)
                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
        .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .tint(BonsaiWorldColors.accent)
        .preferredColorScheme(.light)
    }
}
