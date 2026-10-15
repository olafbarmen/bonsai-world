//
//  CareWorkspaceView.swift
//  Bonsai World
//
//  Care module shell (BV1) — one sidebar destination; page picker on-page.
//

import SwiftUI

struct CareWorkspaceView: View {
    @Environment(AppState.self) private var appState

    private var page: CarePage { appState.carePage }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            carePagePicker
            Group {
                switch page {
                case .watering: CareWateringView()
                case .fertilizing: CareFertilizingView()
                case .placement: CarePlacementView()
                case .winter: CareWinterView()
                case .spring: CareSpringView()
                case .repotting: CareRepottingView()
                case .health: CareHealthView()
                case .seasonal: CareSeasonalView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Care")
    }

    private var carePagePicker: some View {
        @Bindable var appState = appState
        return HStack(spacing: FaloSpacing.medium) {
            Picker("Care page", selection: $appState.carePage) {
                ForEach(CarePage.primaryPickerCases) { value in
                    Text(value.title).tag(value)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 520)
            .labelsHidden()

            Menu {
                Button("Repotting") { appState.carePage = .repotting }
                Button("Health") { appState.carePage = .health }
                Button("Seasonal Care") { appState.carePage = .seasonal }
            } label: {
                HStack(spacing: 4) {
                    Text(appState.carePage.isPrimaryPickerCase ? "More" : appState.carePage.title)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 9, weight: .semibold))
                }
                .font(FaloTypography.caption)
                .foregroundStyle(
                    appState.carePage.isPrimaryPickerCase
                        ? .secondary
                        : Color.accentColor
                )
            }
            .menuStyle(.borderlessButton)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, FaloSpacing.xLarge)
        .padding(.top, FaloSpacing.medium)
        .padding(.bottom, FaloSpacing.small)
        .background(BonsaiWorldColors.canvas)
    }
}
