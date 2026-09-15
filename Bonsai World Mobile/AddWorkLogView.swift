//
//  AddWorkLogView.swift
//  Bonsai World
//

import SwiftUI

struct AddWorkLogView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let treeID: UUID

    @State private var workTypeID: UUID = DemoWorkTypes.watering.id
    @State private var performedAt: Date = .now
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Work") {
                    Picker("Type", selection: $workTypeID) {
                        ForEach(DemoWorkTypes.all) { type in
                            Text(type.name).tag(type.id)
                        }
                    }
                    DatePicker("Date", selection: $performedAt, displayedComponents: .date)
                }

                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Work")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        library.addWork(
                            treeID: treeID,
                            workTypeID: workTypeID,
                            performedAt: performedAt,
                            notes: notes
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddWorkLogView(treeID: DemoLibrary.sampleTrees[0].id)
        .environment(DemoLibrary())
}
