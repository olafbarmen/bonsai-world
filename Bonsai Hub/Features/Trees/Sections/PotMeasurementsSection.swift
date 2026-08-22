//
//  PotMeasurementsSection.swift
//  Bonsai World
//
//  Current pot dimensions for a Tree — edited in Edit Mode, Auto Saved on the Tree.
//  Not part of Tree Measurement History. Ready to move onto a future Pot entity.
//

import SwiftUI

struct PotMeasurementsSection: View {
    @Environment(AppSettings.self) private var appSettings

    @Binding var potLengthMillimetres: Int?
    @Binding var potWidthMillimetres: Int?
    @Binding var potHeightMillimetres: Int?
    @Binding var potDiameterMillimetres: Int?

    var isEditing: Bool

    private var system: MeasurementSystem { appSettings.measurementSystem }

    var body: some View {
        DetailCard(title: "Pot Measurements") {
            measurementRow(title: "Pot Length", dimension: .potLength, value: $potLengthMillimetres)
            measurementRow(title: "Pot Width", dimension: .potWidth, value: $potWidthMillimetres)
            measurementRow(title: "Pot Height", dimension: .potHeight, value: $potHeightMillimetres)
            measurementRow(title: "Pot Diameter", dimension: .potDiameter, value: $potDiameterMillimetres)
        }
    }

    @ViewBuilder
    private func measurementRow(
        title: String,
        dimension: MeasurementDimension,
        value: Binding<Int?>
    ) -> some View {
        let unit = MeasurementService.unitLabel(dimension: dimension, system: system)
        let role = dimension.linearRole ?? .width

        if isEditing {
            DetailEditableTextRow(
                label: "\(title) (\(unit))",
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
                ),
                help: "Current pot size on this tree. Stored in millimetres — not part of Measurement History."
            )
        } else {
            DetailLabeledRow(
                label: title,
                value: MeasurementService.string(
                    millimetres: value.wrappedValue,
                    dimension: dimension,
                    system: system
                )
            )
        }
    }
}
