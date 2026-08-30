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
            DetailLabeledRow(label: "Origin", value: origin)
                .help("Where this tree came from — see Ownership for full acquisition details")
        }
    }
}
