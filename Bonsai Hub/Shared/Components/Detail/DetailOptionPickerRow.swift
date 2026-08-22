//
//  DetailOptionPickerRow.swift
//  Bonsai World
//
//  Native optional-UUID picker row for Falo Detail Edit Mode.
//  Typography: Falo Card Typography Standard v1.
//

import SwiftUI

struct DetailOptionPickerRow: View {
    let label: String
    @Binding var selection: UUID?
    var placeholder: String
    let options: [DetailPickerOption]

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)

            Picker(label, selection: $selection) {
                Text(placeholder).tag(Optional<UUID>.none)
                ForEach(options) { item in
                    Text(item.name).tag(Optional(item.id))
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .font(FaloCardTypography.fieldValue)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .contain)
    }

    static func displayName(for id: UUID?, in options: [DetailPickerOption]) -> String {
        guard let id else { return "" }
        return options.first { $0.id == id }?.name ?? ""
    }
}

#Preview {
    DetailOptionPickerRow(
        label: "Style",
        selection: .constant(nil),
        placeholder: "Select Style",
        options: [DetailPickerOption(id: UUID(), name: "Informal Upright")]
    )
    .padding()
}
