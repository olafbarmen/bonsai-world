//
//  IdentitySection.swift
//  Bonsai World
//
//  Tree Detail — Identity card (botanical classification included).
//

import SwiftUI

struct IdentitySection: View {
    let bonsaiName: String
    let botanicalName: String
    @Binding var nickname: String
    let genusName: String
    let speciesName: String
    let cultivarName: String
    /// Acquisition origin glance (method or source) — full ownership remains in Ownership.
    let origin: String
    @Binding var propagation: TreePropagation?
    let propagationTitle: String
    @Binding var countryOfOrigin: String
    /// Estimated origin calendar year (canonical). Age is derived.
    @Binding var originYear: Int?
    var isEditing: Bool

    var body: some View {
        DetailCard(title: "Identity") {
            DetailLabeledRow(
                label: "Bonsai Name",
                value: bonsaiName,
                monospaced: true
            )
            .help("Permanent registry identity — set when the tree was created")

            DetailLabeledRow(label: "Botanical Name", value: botanicalName)
                .help("Permanent botanical identity — set when the tree was created")

            if isEditing {
                DetailEditableTextRow(
                    label: "Nickname",
                    text: $nickname,
                    help: "Optional personal name for this tree"
                )
            } else {
                DetailLabeledRow(label: "Nickname", value: nickname)
            }

            DetailLabeledRow(label: "Genus", value: genusName)
                .help("Permanent identity — set when the tree was created")
            DetailLabeledRow(label: "Species", value: speciesName)
                .help("Permanent identity — set when the tree was created")
            DetailLabeledRow(label: "Cultivar", value: cultivarName)
                .help("Permanent identity — set when the tree was created")

            if isEditing {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Propagation")
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)
                    Picker("Propagation", selection: $propagation) {
                        Text("Select Propagation").tag(Optional<TreePropagation>.none)
                        ForEach(TreePropagation.allCases) { value in
                            Text(value.title).tag(Optional(value))
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .font(FaloCardTypography.fieldValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .help("How this tree began")
            } else {
                DetailLabeledRow(label: "Propagation", value: propagationTitle)
                    .help("How this tree began")
            }

            DetailLabeledRow(label: "Origin", value: origin)
                .help("Where this tree came from — see Ownership for full acquisition details")

            if isEditing {
                DetailEditableTextRow(
                    label: "Country of Origin",
                    text: $countryOfOrigin,
                    help: "Country this tree came from"
                )
            } else {
                DetailLabeledRow(label: "Country of Origin", value: countryOfOrigin)
            }

            if isEditing {
                DetailEditableTextRow(
                    label: "Origin Year",
                    text: originYearTextBinding,
                    help: "Estimated calendar year the tree began. Age updates from this at New Year."
                )
                DetailEditableTextRow(
                    label: "Age",
                    text: ageTextBinding,
                    help: "Whole years from Origin Year. Enter age to set Origin Year."
                )
            } else {
                DetailLabeledRow(
                    label: "Origin Year",
                    value: originYear.map(String.init) ?? ""
                )
                .help("Estimated calendar year the tree began")
                DetailLabeledRow(
                    label: "Age",
                    value: ageDisplayValue
                )
                .help("Whole years from Origin Year — updates at New Year")
            }
        }
    }

    private var ageDisplayValue: String {
        guard let age = Tree.ageInWholeYears(originYear: originYear) else { return "" }
        return age == 1 ? "1 year" : "\(age) years"
    }

    private var originYearTextBinding: Binding<String> {
        Binding(
            get: { originYear.map(String.init) ?? "" },
            set: { newValue in
                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    originYear = nil
                    return
                }
                guard let year = Int(trimmed) else { return }
                if let sanitized = Tree.sanitizedOriginYear(year) {
                    originYear = sanitized
                }
            }
        )
    }

    private var ageTextBinding: Binding<String> {
        Binding(
            get: {
                guard let age = Tree.ageInWholeYears(originYear: originYear) else { return "" }
                return String(age)
            },
            set: { newValue in
                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    originYear = nil
                    return
                }
                guard let age = Int(trimmed) else { return }
                if let year = Tree.originYear(fromAge: age) {
                    originYear = year
                }
            }
        )
    }
}
