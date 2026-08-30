//
//  PotSection.swift
//  Bonsai World
//
//  Current pot on this tree — type, profile, and dimensions.
//  Not part of Tree Measurement History.
//

import SwiftUI

struct PotSection: View {
    @Environment(AppSettings.self) private var appSettings

    @Binding var potTypeID: UUID?
    @Binding var potLengthMillimetres: Int?
    @Binding var potWidthMillimetres: Int?
    @Binding var potHeightMillimetres: Int?
    @Binding var potDiameterMillimetres: Int?

    let potTypes: [DetailPickerOption]
    var isEditing: Bool

    private var system: MeasurementSystem { appSettings.measurementSystem }

    var body: some View {
        DetailCard(title: "Pot") {
            if isEditing {
                DetailOptionPickerRow(
                    label: "Current Pot",
                    selection: $potTypeID,
                    placeholder: "Select Pot",
                    options: potTypes
                )
            } else {
                DetailLabeledRow(
                    label: "Current Pot",
                    value: DetailOptionPickerRow.displayName(for: potTypeID, in: potTypes)
                )
            }

            DetailLabeledRow(label: "Material", value: "")
            DetailLabeledRow(label: "Colour", value: "")
            DetailLabeledRow(label: "Shape", value: "")

            dimensionsBlock

            DetailLabeledRow(label: "Last Repotted", value: "")
        }
    }

    @ViewBuilder
    private var dimensionsBlock: some View {
        if isEditing {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text("Dimensions")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                dimensionEditRow(title: "Length", dimension: .potLength, value: $potLengthMillimetres)
                dimensionEditRow(title: "Width", dimension: .potWidth, value: $potWidthMillimetres)
                dimensionEditRow(title: "Height", dimension: .potHeight, value: $potHeightMillimetres)
                dimensionEditRow(title: "Diameter", dimension: .potDiameter, value: $potDiameterMillimetres)
            }
        } else {
            DetailLabeledRow(label: "Dimensions", value: dimensionsSummary)
        }
    }

    private var dimensionsSummary: String {
        let segments: [(String, Int?)] = [
            ("L", potLengthMillimetres),
            ("W", potWidthMillimetres),
            ("H", potHeightMillimetres),
            ("D", potDiameterMillimetres)
        ]
        let formatted = segments.compactMap { label, millimetres -> String? in
            guard millimetres != nil else { return nil }
            let dimension: MeasurementDimension = switch label {
            case "L": .potLength
            case "W": .potWidth
            case "H": .potHeight
            default: .potDiameter
            }
            let value = MeasurementService.string(
                millimetres: millimetres,
                dimension: dimension,
                system: system,
                empty: ""
            )
            guard !value.isEmpty else { return nil }
            return "\(label) \(value)"
        }
        return formatted.joined(separator: " · ")
    }

    @ViewBuilder
    private func dimensionEditRow(
        title: String,
        dimension: MeasurementDimension,
        value: Binding<Int?>
    ) -> some View {
        let unit = MeasurementService.unitLabel(dimension: dimension, system: system)
        let role = dimension.linearRole ?? .width

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
            help: "Current pot footprint on this tree. Stored in millimetres."
        )
    }
}
