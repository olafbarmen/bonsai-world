//
//  SectionHeader.swift
//  Bonsai World
//
//  Reusable section title for Tree Detail and other Falo forms.
//

import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        DetailSectionHeader(title: title)
    }
}

#Preview {
    SectionHeader(title: "General")
        .padding()
}
