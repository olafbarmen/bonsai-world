//
//  TreeWateringPolicySection.swift
//  Bonsai World
//
//  Tree Edit — inherited Care Collection policy + optional override.
//

import SwiftUI

struct TreeWateringPolicySection: View {
    let effective: EffectiveWateringPolicy
    let carePolicyCollections: [Collection]
    @Binding var carePolicyCollectionID: UUID?
    @Binding var wateringModeOverride: WateringMode?
    @Binding var autoTimesPerDayOverride: Int?
    var isEditing: Bool

    private var usesOverride: Bool {
        wateringModeOverride != nil
    }

    var body: some View {
        DetailCard(title: "Watering") {
            if isEditing {
                Picker("Watering policy Collection", selection: $carePolicyCollectionID) {
                    Text("None (default Silent)").tag(UUID?.none)
                    ForEach(carePolicyCollections) { collection in
                        Text(collection.name).tag(Optional(collection.id))
                    }
                }
                .pickerStyle(.menu)

                Toggle("Override Collection policy", isOn: overrideToggle)

                if usesOverride, let modeBinding = overrideModeBinding {
                    Picker("Mode", selection: modeBinding) {
                        ForEach(WateringMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.menu)

                    if wateringModeOverride == .auto {
                        Picker("Auto times per day", selection: autoTimesBinding) {
                            Text("1×").tag(1)
                            Text("2×").tag(2)
                            Text("3×").tag(3)
                        }
                        .pickerStyle(.menu)
                    }
                }

                Divider()
                summaryRows
            } else {
                summaryRows
            }
        }
    }

    @ViewBuilder
    private var summaryRows: some View {
        DetailLabeledRow(label: "Effective mode", value: effective.mode.title)
        if let times = effective.autoTimesPerDay {
            DetailLabeledRow(label: "Auto times / day", value: "\(times)×")
        }
        DetailLabeledRow(label: "Source", value: effective.sourceLabel)
    }

    private var overrideToggle: Binding<Bool> {
        Binding(
            get: { usesOverride },
            set: { enabled in
                if enabled {
                    wateringModeOverride = effective.mode == .silent && carePolicyCollectionID == nil
                        ? .remind
                        : effective.mode
                    if wateringModeOverride == .auto {
                        autoTimesPerDayOverride = effective.autoTimesPerDay ?? 1
                    }
                } else {
                    wateringModeOverride = nil
                    autoTimesPerDayOverride = nil
                }
            }
        )
    }

    private var overrideModeBinding: Binding<WateringMode>? {
        Binding(
            get: { wateringModeOverride ?? .silent },
            set: { newValue in
                wateringModeOverride = newValue
                if newValue == .auto {
                    autoTimesPerDayOverride = TreeWateringPolicyResolver.clampedTimes(
                        autoTimesPerDayOverride ?? 1
                    )
                } else {
                    autoTimesPerDayOverride = nil
                }
            }
        )
    }

    private var autoTimesBinding: Binding<Int> {
        Binding(
            get: { TreeWateringPolicyResolver.clampedTimes(autoTimesPerDayOverride ?? 1) },
            set: { autoTimesPerDayOverride = TreeWateringPolicyResolver.clampedTimes($0) }
        )
    }
}
