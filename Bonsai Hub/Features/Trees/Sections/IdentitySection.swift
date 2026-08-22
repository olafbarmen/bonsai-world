//
//  IdentitySection.swift
//  Bonsai World
//
//  Tree Detail — Identity card (Falo DetailCard pattern).
//

import SwiftUI

struct IdentitySection: View {
    let bonsaiName: String
    let botanicalName: String
    @Binding var nickname: String
    var isEditing: Bool

    var body: some View {
        DetailCard(title: "Identity") {
            if isEditing {
                DetailEditableTextRow(
                    label: "Nickname",
                    text: $nickname,
                    help: "Optional personal name for this tree"
                )
            } else {
                DetailLabeledRow(label: "Nickname", value: nickname)
            }

            DetailLabeledRow(label: "Botanical Name", value: botanicalName)
                .help("Permanent botanical identity — set when the tree was created")

            DetailLabeledRow(
                label: "Bonsai Name",
                value: bonsaiName,
                monospaced: true
            )
            .help("Permanent registry identity — set when the tree was created")
        }
    }
}
