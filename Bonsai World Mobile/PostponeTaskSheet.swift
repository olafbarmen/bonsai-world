//
//  PostponeTaskSheet.swift
//  Bonsai World
//
//  Moves one CareTask due date (Mac Postpone labels: Amount, By Days/Weeks).
//

import SwiftUI

enum MobileTaskPostpone {
    static let amounts = 1...7

    enum Unit: String, CaseIterable, Identifiable, Sendable {
        case days
        case weeks

        var id: Self { self }

        var title: String {
            switch self {
            case .days: "Days"
            case .weeks: "Weeks"
            }
        }

        var component: Calendar.Component {
            switch self {
            case .days: .day
            case .weeks: .weekOfYear
            }
        }
    }

    /// Pushes the later of the current due date and today. Count is kept inside 1...7.
    static func date(
        from due: Date,
        now: Date = .now,
        count: Int,
        unit: Unit,
        calendar: Calendar = .current
    ) -> Date {
        let clamped = min(amounts.upperBound, max(amounts.lowerBound, count))
        let base = max(calendar.startOfDay(for: due), calendar.startOfDay(for: now))
        return calendar.date(byAdding: unit.component, value: clamped, to: base) ?? base
    }
}

struct PostponeTaskSheet: View {
    let task: CareTask
    var onFinished: () -> Void = {}

    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    @State private var count = 1
    @State private var unit: MobileTaskPostpone.Unit = .days

    private var dueDate: Date {
        MobileTaskPostpone.date(from: task.dueDate, count: count, unit: unit)
    }

    private var title: String {
        let trimmed = task.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        return CanonicalWorkTypeID.name(for: task.workTypeID)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(title)
                        .font(FaloTypography.body.weight(.semibold))
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    Text("This time only. Repeating rules (for example every few years) stay the same.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }

                Section("Postpone") {
                    Picker("Amount", selection: $count) {
                        ForEach(Array(MobileTaskPostpone.amounts), id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .accessibilityLabel("Amount")

                    Picker("By", selection: $unit) {
                        ForEach(MobileTaskPostpone.Unit.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel("By")

                    LabeledContent("New due date") {
                        Text(dueDate, style: .date)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .navigationTitle("Postpone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    private func save() {
        library.postponeTask(id: task.id, to: dueDate)
        onFinished()
        dismiss()
    }
}

#Preview {
    PostponeTaskSheet(
        task: CareTask(
            title: "Water",
            workTypeID: CanonicalWorkTypeID.watering,
            treeIDs: [UUID()],
            dueDate: .now
        )
    )
    .environment(DemoLibrary.preview)
}
