//
//  WorkspaceSegmentPickerChrome.swift
//  Bonsai World
//
//  Shared chrome for Trees list (My Trees / Former Trees) and Tree Detail
//  (Overview / Shaping) — same inset, air, and fixed segment width.
//

import SwiftUI

struct WorkspaceSegmentPickerChrome<Selection: Hashable>: View {
    let title: String
    @Binding var selection: Selection
    private let options: [(label: String, value: Selection)]

    init(
        title: String,
        selection: Binding<Selection>,
        options: [(label: String, value: Selection)]
    ) {
        self.title = title
        self._selection = selection
        self.options = options
    }

    var body: some View {
        HStack {
            Picker(title, selection: $selection) {
                ForEach(options, id: \.value) { option in
                    Text(option.label).tag(option.value)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: Self.segmentWidth)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, FaloSpacing.xLarge)
        .padding(.top, FaloSpacing.medium)
        .padding(.bottom, FaloSpacing.medium)
    }

    /// Fixed width so list and detail pickers match (maxWidth alone sizes to text).
    static var segmentWidth: CGFloat { 280 }
}
