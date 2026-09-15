//
//  SoilStocktakeView.swift
//  Bonsai World
//
//  Periodic physical count. Actual becomes the new estimated baseline.
//  Does not record every scoop between stocktakes.
//

import SwiftUI

struct SoilStocktakeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SoilStockService.self) private var soilStock
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var actuals: [UUID: Double] = [:]
    @State private var errorMessage: String?
    @State private var frequency: SoilStocktakeFrequency = .monthly
    @State private var customDays = 30

    var body: some View {
        NavigationStack {
            Form {
                Section("Frequency") {
                    Picker("Stocktake frequency", selection: $frequency) {
                        ForEach(SoilStocktakeFrequency.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    if frequency == .custom {
                        TextField("Interval (days)", value: $customDays, format: .number)
                    }
                    Text("Default is monthly. The app does not deduct stock when you mix or repot.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Count") {
                    if soilStock.items.isEmpty {
                        Text("Add soil stock first.")
                    } else {
                        ForEach(soilStock.items) { item in
                            let name = referenceData.soilComponent(id: item.componentID)?.name ?? "Material"
                            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                                Text("\(name) · \(item.grainSize.displayTitle)")
                                    .font(FaloCardTypography.fieldValue)
                                Text("Estimated \(SoilVolumeFormat.liters(item.estimatedVolumeLiters))")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                                TextField(
                                    "Actual (L)",
                                    value: Binding(
                                        get: { actuals[item.id] ?? item.estimatedVolumeLiters },
                                        set: { actuals[item.id] = $0 }
                                    ),
                                    format: .number
                                )
                                let actual = actuals[item.id] ?? item.estimatedVolumeLiters
                                Text("Difference \(SoilVolumeFormat.signedLiters(actual - item.estimatedVolumeLiters))")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, FaloSpacing.xSmall)
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle("Stocktake")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adjust inventory") { confirm() }
                        .disabled(soilStock.items.isEmpty)
                }
            }
            .onAppear {
                frequency = soilStock.preferences.stocktakeFrequency
                customDays = soilStock.preferences.customStocktakeIntervalDays
                for item in soilStock.items {
                    actuals[item.id] = item.estimatedVolumeLiters
                }
            }
            .alert("Could Not Complete Stocktake", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .frame(minWidth: 480, minHeight: 560)
    }

    private func confirm() {
        do {
            var prefs = soilStock.preferences
            prefs.stocktakeFrequency = frequency
            prefs.customStocktakeIntervalDays = customDays
            try soilStock.updatePreferences(prefs)
            try soilStock.confirmStocktakeSession(actuals)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
