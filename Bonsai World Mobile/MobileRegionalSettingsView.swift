//
//  MobileRegionalSettingsView.swift
//  Bonsai World
//
//  Settings → Regional Settings — measurement + currency (Mac titles).
//

import SwiftUI

struct MobileRegionalSettingsView: View {
    @Bindable private var prefs = MobileRegionalPreferences.shared

    var body: some View {
        Form {
            Section {
                Picker("Currency", selection: $prefs.currency) {
                    ForEach(MobileAppCurrency.allCases) { currency in
                        Text(currency.menuTitle).tag(currency)
                    }
                }
            } header: {
                Text("Currency")
            } footer: {
                Text("Changing currency updates how prices are shown. It does not convert amounts.")
                    .font(FaloTypography.caption)
            }

            Section {
                Picker("Measurement System", selection: $prefs.measurementSystem) {
                    ForEach(MobileMeasurementSystem.allCases) { system in
                        Text(system.menuTitle).tag(system)
                    }
                }
            } header: {
                Text("Units")
            } footer: {
                Text("Measurement values are stored in millimetres.")
                    .font(FaloTypography.caption)
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle("Regional Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MobileRegionalSettingsView()
    }
}
