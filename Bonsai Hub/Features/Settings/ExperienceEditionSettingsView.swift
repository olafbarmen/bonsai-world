//
//  ExperienceEditionSettingsView.swift
//  Bonsai World
//
//  Settings → Experience — Essentials / Practice / Complete.
//

import SwiftUI

struct ExperienceEditionSettingsView: View {
    @Environment(AppSettings.self) private var appSettings

    /// Planning matrix only — not persisted, does not drive gating.
    @State private var membership = ExperiencePlanningCatalog.defaultMembership()

    var body: some View {
        @Bindable var appSettings = appSettings

        Form {
            Section {
                Picker("Edition", selection: $appSettings.experienceEdition) {
                    ForEach(ExperienceEdition.allCases) { edition in
                        Text(edition.menuTitle).tag(edition)
                    }
                }
                .pickerStyle(.inline)

                Text(appSettings.experienceEdition.help)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)

                planningMatrix
                    .padding(.top, FaloSpacing.medium)
            } header: {
                Text("Experience")
            } footer: {
                Text("One library for every edition. Switching only changes which tools and details you see — never your data. The matrix is for planning only: a check means that edition includes the menu package and its extended functions. Checkboxes are not saved and do not change what the app shows yet. Complete starts fully checked; Essentials and Practice start empty.")
            }
        }
        .formStyle(.grouped)
        .faloScrollSurface()
        .bonsaiWorkspaceNavigationTitle("Experience")
    }

    private var planningMatrix: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            matrixHeader

            ForEach(ExperiencePlanningGroup.allCases) { group in
                let rows = ExperiencePlanningCatalog.rows.filter { $0.group == group }
                if !rows.isEmpty {
                    VStack(alignment: .leading, spacing: FaloSpacing.small) {
                        Text(group.title)
                            .font(FaloTypography.caption.weight(.semibold))
                            .foregroundStyle(BonsaiWorldColors.textSecondary)

                        ForEach(rows) { row in
                            matrixRow(row)
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var matrixHeader: some View {
        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
            Text("Menu / package")
                .font(FaloTypography.caption.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(ExperienceEdition.allCases) { edition in
                Text(edition.menuTitle)
                    .font(FaloTypography.caption.weight(.semibold))
                    .frame(width: Self.editionColumnWidth)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private func matrixRow(_ row: ExperiencePlanningRow) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.small) {
            Text(row.title)
                .font(FaloTypography.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(ExperienceEdition.allCases) { edition in
                Toggle(edition.menuTitle, isOn: binding(rowID: row.id, edition: edition))
                    .labelsHidden()
                    .toggleStyle(.checkbox)
                    .frame(width: Self.editionColumnWidth)
                    .help("\(row.title) in \(edition.menuTitle)")
            }
        }
    }

    private static let editionColumnWidth: CGFloat = 88

    private func binding(rowID: String, edition: ExperienceEdition) -> Binding<Bool> {
        Binding(
            get: { membership[rowID, default: []].contains(edition) },
            set: { isOn in
                var set = membership[rowID, default: []]
                if isOn {
                    set.insert(edition)
                } else {
                    set.remove(edition)
                }
                membership[rowID] = set
            }
        )
    }
}

#Preview {
    ExperienceEditionSettingsView()
        .environment(AppSettings())
}
