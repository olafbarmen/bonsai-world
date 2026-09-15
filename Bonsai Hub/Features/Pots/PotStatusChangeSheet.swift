//
//  PotStatusChangeSheet.swift
//  Bonsai World
//
//  Small capture sheet for Sold / Broken / Retired — each sets a date, an optional
//  detail field, and notes, then hands off to the matching PotService lifecycle call.
//

import SwiftUI

enum PotStatusChangeKind: Hashable, Identifiable {
    var id: Self { self }

    case sold
    case broken
    case retired

    var title: String {
        switch self {
        case .sold: "Mark Sold"
        case .broken: "Mark Broken"
        case .retired: "Mark Retired"
        }
    }

    var dateLabel: String {
        switch self {
        case .sold: "Sale Date"
        case .broken: "Broken Date"
        case .retired: "Retired Date"
        }
    }

    var detailLabel: String? {
        switch self {
        case .sold: "Buyer"
        case .broken: "Reason"
        case .retired: nil
        }
    }
}

struct PotStatusChangeSheet: View {
    @Environment(\.dismiss) private var dismiss

    let kind: PotStatusChangeKind
    var onConfirm: (_ date: Date, _ detail: String, _ price: Decimal?, _ notes: String) -> Void

    @State private var date = Date.now
    @State private var detail = ""
    @State private var priceText = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                DatePicker(kind.dateLabel, selection: $date, displayedComponents: .date)

                if let detailLabel = kind.detailLabel {
                    TextField(detailLabel, text: $detail)
                }

                if kind == .sold {
                    TextField("Sale Price", text: $priceText)
                        .help("Numeric amount only.")
                }

                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(2...4)
            }
            .formStyle(.grouped)
            .navigationTitle(kind.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") {
                        onConfirm(date, detail, CurrencyFormatting.parseAmount(priceText), notes)
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 380, minHeight: 280)
    }
}
