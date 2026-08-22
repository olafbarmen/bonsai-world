//
//  AddMeasurementSheet.swift
//  Bonsai World
//
//  Creates a new dated Tree measurement session (Height / Crown / Nebari / Trunk).
//  Pot dimensions are edited on the Pot Measurements card — never here.
//

import SwiftUI

struct AddMeasurementSheet: View {
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.dismiss) private var dismiss

    let treeID: UUID
    let initial: TreeMeasurementRecord
    var onSave: (TreeMeasurementRecord) -> Void

    @State private var measuredAt: Date
    @State private var heightMillimetres: Int?
    @State private var crownWidthMillimetres: Int?
    @State private var nebariWidthMillimetres: Int?
    @State private var trunkDiameterMillimetres: Int?
    @State private var notes: String

    init(
        treeID: UUID,
        initial: TreeMeasurementRecord,
        onSave: @escaping (TreeMeasurementRecord) -> Void
    ) {
        self.treeID = treeID
        self.initial = initial
        self.onSave = onSave
        _measuredAt = State(initialValue: Date.now)
        _heightMillimetres = State(initialValue: initial.heightMillimetres)
        _crownWidthMillimetres = State(initialValue: initial.crownWidthMillimetres)
        _nebariWidthMillimetres = State(initialValue: initial.nebariWidthMillimetres)
        _trunkDiameterMillimetres = State(initialValue: initial.trunkDiameterMillimetres)
        _notes = State(initialValue: "")
    }

    private var system: MeasurementSystem { appSettings.measurementSystem }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section {
                    DatePicker(
                        "Measurement Date",
                        selection: $measuredAt,
                        displayedComponents: .date
                    )
                }

                Section("Tree") {
                    measurementField("Height", .height, $heightMillimetres)
                    measurementField("Crown Width", .crownWidth, $crownWidthMillimetres)
                    measurementField("Nebari Width", .nebariWidth, $nebariWidthMillimetres)
                    measurementField("Trunk Diameter", .trunkDiameter, $trunkDiameterMillimetres)
                }

                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .formStyle(.grouped)

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Button("Save Measurement") { save() }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
            }
            .padding(FaloSpacing.xLarge)
        }
        .frame(minWidth: 440, minHeight: 420)
        .navigationTitle("Add Measurement")
    }

    private func measurementField(
        _ title: String,
        _ dimension: MeasurementDimension,
        _ value: Binding<Int?>
    ) -> some View {
        let unit = MeasurementService.unitLabel(dimension: dimension, system: system)
        let role = dimension.linearRole ?? .width
        return TextField(
            "\(title) (\(unit))",
            text: Binding(
                get: {
                    MeasurementService.editableNumericString(
                        millimetres: value.wrappedValue,
                        role: role,
                        system: system
                    )
                },
                set: {
                    value.wrappedValue = MeasurementService.millimetres(
                        fromDisplayText: $0,
                        role: role,
                        system: system
                    )
                }
            )
        )
    }

    private func save() {
        // Tree measurements only — pot dimensions stay on the Tree / future Pot entity.
        let record = TreeMeasurementRecord(
            treeID: treeID,
            measuredAt: measuredAt,
            heightMillimetres: heightMillimetres,
            crownWidthMillimetres: crownWidthMillimetres,
            nebariWidthMillimetres: nebariWidthMillimetres,
            trunkDiameterMillimetres: trunkDiameterMillimetres,
            notes: notes
        )
        onSave(record)
        dismiss()
    }
}
