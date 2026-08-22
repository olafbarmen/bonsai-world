//
//  ClassificationSection.swift
//  Bonsai World
//
//  Tree Detail — botanical Classification (always read-only after create).
//  Empty cultivar (and other blanks) are rendered by DetailLabeledRow via FaloDisplayValue.
//

import SwiftUI

struct ClassificationSection: View {
    let genusName: String
    let speciesName: String
    let cultivarName: String

    var body: some View {
        DetailCard(title: "Classification") {
            DetailLabeledRow(label: "Genus", value: genusName)
                .help("Permanent identity — set when the tree was created")
            DetailLabeledRow(label: "Species", value: speciesName)
                .help("Permanent identity — set when the tree was created")
            // Empty values: DetailLabeledRow → FaloDisplayValue (no emptyDisplay argument needed).
            DetailLabeledRow(label: "Cultivar", value: cultivarName)
                .help("Permanent identity — set when the tree was created")
        }
    }
}
