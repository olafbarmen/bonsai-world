//
//  NewTreeOptionalMeasurementsSection.swift
//  Bonsai World
//
//  Progressive disclosure for optional Tree measurements during New Tree creation.
//  Pot dimensions are not included — they belong on the Pot card / future Pot entity.
//

import SwiftUI

struct NewTreeOptionalMeasurementsSection: View {
    @Environment(AppSettings.self) private var appSettings

    @Binding var isExpanded: Bool
    @Binding var measuredAt: Date
    @Binding var heightMillimetres: Int?
    @Binding var crownWidthMillimetres: Int?
    @Binding var nebariWidthMillimetres: Int?
    @Binding var trunkDiameterMillimetres: Int?

    private var system: MeasurementSystem { appSettings.measurementSystem }

    var body: some View {
        Section {
            DisclosureGroup(isExpanded: $isExpanded) {
                DatePicker(
                    "Measurement Date",
                    selection: $measuredAt,
                    displayedComponents: .date
                )

                measurementField("Height", .height, $heightMillimetres)
                measurementField("Crown Width", .crownWidth, $crownWidthMillimetres)
                measurementField("Nebari Width", .nebariWidth, $nebariWidthMillimetres)
                measurementField("Trunk Diameter", .trunkDiameter, $trunkDiameterMillimetres)
            } label: {
                Text("Measurements (Optional)")
            }
        } footer: {
            Text("Optional. Entered values become the first Tree Measurement when you create the tree.")
                .font(FaloTypography.caption)
        }
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
}
