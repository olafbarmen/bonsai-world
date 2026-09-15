//
//  SeedWorkView.swift
//  Bonsai World
//
//  Nursery → Seeds → Seed Work — action-oriented batch dashboard.
//  Left: due / upcoming / active. Right: stratification tips + Knowledge link.
//

import SwiftUI

struct SeedWorkView: View {
    @Environment(AppState.self) private var appState
    @Environment(SeedBatchService.self) private var seedBatchService

    @State private var isCreatePresented = false

    private var active: [SeedBatch] {
        seedBatchService.activeBatches
    }

    /// Early workflow first: planned → stratifying → ready to sow, then sown onward.
    private var activeOrderedForWork: [SeedBatch] {
        let order: [SeedBatchStage] = [
            .planned, .stratifying, .readyToSow, .sown, .germinating, .seedling, .developing
        ]
        return active.sorted { lhs, rhs in
            let li = order.firstIndex(of: lhs.stage) ?? order.count
            let ri = order.firstIndex(of: rhs.stage) ?? order.count
            if li != ri { return li < ri }
            return lhs.botanicalName.localizedCaseInsensitiveCompare(rhs.botanicalName) == .orderedAscending
        }
    }

    private var dueToday: [CareTask] {
        seedBatchService.dueTodayTasks()
    }

    private var upcoming: [CareTask] {
        seedBatchService.upcomingTasks()
    }

    var body: some View {
        Group {
            if let batchID = appState.selectedSeedBatchID,
               seedBatchService.batch(id: batchID) != nil {
                SeedBatchDetailView(batchID: batchID)
            } else {
                dashboard
            }
        }
        .sheet(isPresented: $isCreatePresented) {
            NewSeedBatchView()
        }
        .onAppear { consumeWantsNewSeedBatch() }
        .onChange(of: appState.wantsNewSeedBatch) { _, wants in
            guard wants else { return }
            consumeWantsNewSeedBatch()
        }
    }

    private func consumeWantsNewSeedBatch() {
        guard appState.wantsNewSeedBatch else { return }
        isCreatePresented = true
        appState.wantsNewSeedBatch = false
    }

    private var dashboard: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                header
                CareTwoColumnLayout {
                    dueSection
                    upcomingSection
                    activeSection
                } secondary: {
                    stratificationTipsCard
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 1100, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("Seed Work")
                .font(FaloTypography.headline)
            Text("\(active.count) active · \(active.filter { $0.stage == .stratifying }.count) stratifying · \(active.filter { $0.stage == .germinating || $0.stage == .sown }.count) germinating")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var dueSection: some View {
        DetailCard(title: "Due Today") {
            if dueToday.isEmpty {
                Text("Nothing due today.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(dueToday) { task in
                    taskRow(task)
                }
            }
        }
    }

    private var upcomingSection: some View {
        DetailCard(title: "Upcoming") {
            if upcoming.isEmpty {
                Text("No upcoming seed tasks.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(upcoming.prefix(8)) { task in
                    taskRow(task)
                }
            }
        }
    }

    private var activeSection: some View {
        DetailCard(title: "Active Batches") {
            if activeOrderedForWork.isEmpty {
                Text("No active seed batches. Create a batch to start.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(activeOrderedForWork) { batch in
                    Button {
                        appState.selectedSeedBatchID = batch.id
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(batch.botanicalName)
                                .font(FaloCardTypography.fieldValue)
                                .foregroundStyle(.primary)
                            Text("\(batch.initialSeedCount) seeds · \(batch.stage.title) · \(batch.batchCode)")
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                            if let phase = batch.currentPhase, batch.stage == .stratifying {
                                Text(phaseProgress(phase))
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, FaloSpacing.xSmall)
                    }
                    .buttonStyle(.plain)
                    Divider()
                }
            }
        }
    }

    private var stratificationTipsCard: some View {
        DetailCard(title: "Stratification tips") {
            Text(SeedStratificationKnowledge.openingQuestion)
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)

            ForEach(SeedStratificationKnowledge.workflowSteps.prefix(4)) { step in
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(step.id). \(step.title)")
                        .font(FaloCardTypography.fieldValue)
                    Text(step.note)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }

            Text(SeedStratificationKnowledge.whatIsStratification.first ?? "")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .padding(.top, FaloSpacing.xSmall)

            Button("Open Seed Stratification") {
                appState.selectSection(.knowledgeSeedStratification)
            }
            .buttonStyle(.bordered)
            .padding(.top, FaloSpacing.small)
        }
    }

    private func taskRow(_ task: CareTask) -> some View {
        Button {
            if let id = task.seedBatchIDs.first {
                appState.selectedSeedBatchID = id
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.primary)
                    Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, FaloSpacing.xSmall)
        }
        .buttonStyle(.plain)
    }

    private func phaseProgress(_ phase: SeedBatchTreatmentPhase) -> String {
        guard let start = phase.startedAt, let days = phase.selectedDurationDays else {
            return phase.phaseType.title
        }
        let elapsed = Calendar.current.dateComponents([.day], from: start, to: .now).day ?? 0
        return "\(phase.phaseType.title) · Day \(max(elapsed, 0)) / \(days)"
    }
}
