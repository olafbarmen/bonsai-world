//
//  CollectionCareWateringSection.swift
//  Bonsai World
//
//  Collection — watering policy for Manual Collections (Remind / Silent / Auto-watered).
//  Due still lives in Tasks; this only decides which members are reminded.
//

import SwiftUI

struct CollectionCareWateringSection: View {
    @Binding var isCarePolicyCollection: Bool
    @Binding var wateringMode: WateringMode
    @Binding var autoTimesPerDay: Int
    @Binding var heatWatchEnabled: Bool
    var isEditing: Bool

    var body: some View {
        DetailCard(title: "Watering") {
            if isEditing {
                Toggle("Set watering policy for members", isOn: policyToggle)
                    .font(FaloCardTypography.fieldValue)

                Text("Turn this on so trees in this Collection inherit Remind, Silent, or Auto-watered. A tree may have only one watering-policy Collection. Due stays in Tasks.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                if isCarePolicyCollection {
                    Picker("Mode", selection: $wateringMode) {
                        ForEach(WateringMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.menu)

                    Text(wateringMode.help)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)

                    if wateringMode == .auto {
                        Picker("Auto times per day", selection: $autoTimesPerDay) {
                            Text("1×").tag(1)
                            Text("2×").tag(2)
                            Text("3×").tag(3)
                        }
                        .pickerStyle(.menu)
                    }

                    Toggle("Heat watch", isOn: $heatWatchEnabled)
                    Text("Shows Heat watch on Care → Watering when high heat is forecast. Does not change Tasks or frequency.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            } else if isCarePolicyCollection {
                DetailLabeledRow(label: "Policy", value: "On for members")
                DetailLabeledRow(label: "Mode", value: wateringMode.title)
                if wateringMode == .auto {
                    DetailLabeledRow(label: "Auto times / day", value: "\(autoTimesPerDay)×")
                }
                DetailLabeledRow(
                    label: "Heat watch",
                    value: heatWatchEnabled ? "On" : "Off"
                )
                Text(wateringMode.help)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, FaloSpacing.xSmall)
            } else {
                Text("No watering policy. Edit this Collection, turn on “Set watering policy for members”, and choose Remind to show trees in Tasks / Care → Watering Due.")
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.secondary)
            }
        }
    }

    /// Enabling policy defaults Silent → Remind so “turn on reminders” matches intent.
    private var policyToggle: Binding<Bool> {
        Binding(
            get: { isCarePolicyCollection },
            set: { enabled in
                isCarePolicyCollection = enabled
                if enabled, wateringMode == .silent {
                    wateringMode = .remind
                }
            }
        )
    }
}
