//
//  TreeProfileView.swift
//  Bonsai World
//

import SwiftUI

struct TreeProfileView: View {
    @Environment(DemoLibrary.self) private var library
    let treeID: UUID

    @State private var isAddingWork = false

    private var tree: Tree? { library.tree(id: treeID) }
    private var workRecords: [WorkRecord] { library.work(for: treeID) }

    var body: some View {
        Group {
            if let tree {
                List {
                    Section("Profile") {
                        LabeledContent("Name", value: tree.displayTitle)
                        if !tree.botanicalName.isEmpty {
                            LabeledContent("Botanical", value: tree.botanicalName)
                        }
                        if !tree.bonsaiName.isEmpty {
                            LabeledContent("Bonsai Name", value: tree.bonsaiName)
                        }
                        LabeledContent("Health", value: tree.healthStatus.title)
                    }

                    if !tree.notes.isEmpty {
                        Section("Notes") {
                            Text(tree.notes)
                        }
                    }

                    Section("Work Log") {
                        if workRecords.isEmpty {
                            Text("No work recorded yet.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(workRecords) { record in
                                WorkLogRow(record: record)
                            }
                        }
                    }
                }
                .navigationTitle(tree.displayTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Add Work") {
                            isAddingWork = true
                        }
                    }
                }
                .sheet(isPresented: $isAddingWork) {
                    AddWorkLogView(treeID: treeID)
                }
            } else {
                ContentUnavailableView("Tree not found", systemImage: "leaf")
            }
        }
    }
}

private struct WorkLogRow: View {
    let record: WorkRecord

    private var dateText: String {
        record.performedAt.formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(DemoWorkTypes.name(for: record.workTypeID))
                    .font(.body.weight(.medium))
                Spacer()
                Text(dateText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if !record.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(record.notes)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        TreeProfileView(treeID: DemoLibrary.sampleTrees[0].id)
    }
    .environment(DemoLibrary())
}
