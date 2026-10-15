//
//  CarePageIntro.swift
//  Bonsai World
//
//  Care page chrome (BO1 / BP): short status always visible when set;
//  fuller Help that can be hidden and remembered per page.
//

import SwiftUI

struct CarePageIntro: View {
    /// Stable key for UserDefaults — e.g. "winter", "watering".
    let pageKey: String
    /// One-line status for daily use (optional).
    var status: String? = nil
    /// Fuller explanation — first visit / annual refresh / on demand.
    let helpBody: String

    @State private var helpHidden: Bool = true

    private var storageKey: String { "falo.care.helpHidden.\(pageKey)" }

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            if let status, !status.isEmpty {
                Text(status)
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if helpHidden {
                HStack {
                    Spacer(minLength: 0)
                    Button("Help") {
                        helpHidden = false
                        persist()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    HStack(alignment: .top, spacing: FaloSpacing.medium) {
                        Text(helpBody)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button("Hide help") {
                            helpHidden = true
                            persist()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .fixedSize()
                    }
                }
                .padding(FaloSpacing.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                        .fill(Color.primary.opacity(0.04))
                )
            }
        }
        .onAppear {
            // Unset key → help visible once (annual / first use). After Hide, stays hidden.
            if UserDefaults.standard.object(forKey: storageKey) == nil {
                helpHidden = false
            } else {
                helpHidden = UserDefaults.standard.bool(forKey: storageKey)
            }
        }
    }

    private func persist() {
        UserDefaults.standard.set(helpHidden, forKey: storageKey)
    }
}

/// Help copy for Care pages — cards, buttons, and how the page fits Tasks / Work.
enum CarePageHelp {
    static let winter = """
        What this page is for
        Prepare seasonal trees for winter: work through checklist steps for many trees at once, and see frost advice when it applies.

        Status line
        Shows whether Winter Care is active (reminder date or cold nights), and that listed trees are still on Summer placement.

        Frost Advice
        Optional tips by Location when frost risk is high. Advice only — it does not create Tasks or change trees.

        Winter Care card
        Pick a step (Wash pot, Clean trunk, Apply diluted lime sulfur, Protect for winter). Trees that still need that step appear in the list. Select several, then Mark Step Done for Selected. Progress is stored on each tree. Completing all steps for a tree removes it from the Winter Care Task in Tasks.

        Placement vs Location
        Placement strategy and Season decide who appears here. Location is where the tree stands now — update Location on the Tree when you physically move it. This checklist does not change Location.

        Also in Tasks
        A Winter Care Task lists trees that still need prep. You can complete trees there or in bulk here.
        """

    static let spring = """
        What this page is for
        Bring seasonal trees back from winter prep: checklist steps for many trees, plus a greenhouse spring check when due.

        Status line
        Shows whether Spring Care is active (reminder date only — no temperature), and that listed trees are still on Winter placement.

        Spring Care card
        Pick a step, select trees that still need it, then mark the step done. Progress lives on each tree. When a tree finishes all steps, it drops off the Spring Care Task in Tasks.

        Greenhouse spring check
        Separate card for greenhouse / cold greenhouse / polytunnel Locations that need a heat and vent check. Mark those Locations done when you have checked them.

        After you move trees
        Update Location on each Tree when they go outdoors. Placement strategy and Season control who appears on this page.

        Also in Tasks
        Spring Care and greenhouse check can appear as Tasks; bulk work is easiest here.
        """

    static let watering = """
        What this page is for
        See watering due from Tasks, register watering as Work, and read weather risks. Missed watering does not stay Overdue (it cannot be done late).

        Buttons
        Add Task… — plan watering in Tasks (same sheet as Tasks → Add Task).
        Water All Due — registers watering for every tree due today when that action is available.
        Register Watering… — pick a tree and log watering Work now.

        Weather
        Heat watch and risk lines by Location. Advisory only — not automatic Tasks.

        Due Today
        Watering Tasks due today. Open a tree or register from the row when shown.

        Recent Watering
        Latest watering Work from history.

        Care recommendations on this page sit alongside Task and Work tracking.
        """

    static let fertilizing = """
        What this page is for
        Three zones: Due now (act on Tasks / Work), Guidance (advice tool), Fertilizer bags (batch track).

        Due now
        Needs Fertilizing lists due fertilizing Tasks. Recent Fertilizing shows latest Work. Add Task… plans in Tasks. Register Fertilizing… logs Work on a tree.

        Guidance
        One card: choose kind, stage, health, season, and growth — the recommendation updates below. Matching Fertilizer Types can start Register. Advice only — not an automatic schedule. Open Fertilizer Guides for deeper reading.

        Fertilizer bags
        Separate batch: set replace interval, Add trees to bags, Mark bags replaced when due. Tasks shows Replace fertilizer bags for due trees. Stop bags removes a tree from the track. Not the same list as Needs Fertilizing.
        """

    static let placement = """
        What this page is for
        Spot placement gaps (wrong season during Winter/Spring Care, missing Location) and log placement-related Work.

        Buttons
        Add Task… — seasonal / placement Task in Tasks.
        Register Placement Work… — log Move, Return Outdoors, Shade, or similar Work on a tree.

        Placement Gaps
        Trees that need a placement decision during active Winter or Spring Care. Open the tree to fix Placement strategy or Season. Seasonal move steps are done in Winter Care / Spring Care checklists.

        Missing Location
        In-care trees with no Location (or a Location no longer in the catalog). Assign Location on the Tree.

        Recent Placement Work
        Recent placement-related Work history.

        Care recommendations on this page sit alongside Task and Work tracking.
        """

    static let repotting = """
        What this page is for
        Act on repotting Tasks and see recent repotting Work. This page does not invent a new schedule by itself — due items come from Tasks (including auto-repot when that is set on the tree).

        Buttons
        Add Task… — plan a repotting Task.
        Register Repotting… — log a repot as Work on a chosen tree.

        Needs Repotting
        Trees with a due repotting Task. I repotted… logs Work and clears that occurrence. Open goes to the Tree. You can Postpone a due date from Tasks without changing the every-N-years rule.

        Recent Repotting
        Latest repotting Work in history.

        This page tracks Tasks and Work only — it does not recommend when to repot beyond what Tasks already shows.
        """

    static let health = """
        What this page is for
        Follow trees that need attention and health-related Tasks / Work.

        Buttons
        Add Task… — health Work Type Task in Tasks.
        Register Health Work… — log health Work on a tree.

        Needs Attention
        Trees marked Needs Attention or Recovering (Tree health). Set Status on the row or open the Tree to change health.

        Health Tasks Due
        Due Tasks with Health Work Types.

        Recent Health Work
        Latest health-related Work.

        This page tracks Tasks and Work only — it does not diagnose the tree for you.
        """

    static let seasonal = """
        What this page is for
        List Seasonal Tasks and recent Seasonal Work. It does not tell you what to do by calendar season.

        Buttons
        Add Task… — Seasonal Work Type Task.
        Register Seasonal Work… — log seasonal Work on a tree.

        Seasonal Tasks Due
        Due items from Tasks with Seasonal Work Types.

        Recent Seasonal Work
        Latest seasonal Work history.

        For winter/spring move checklists, use Winter Care and Spring Care. For the day’s full list, use Tasks.
        """

    static let today = """
        What this page is for
        A short Care overview of tasks due today. It is not the full day workspace.

        Due Today
        Care-related Tasks due today. Complete and manage the full list in Tasks (horizon Today), including bulk Complete selected.

        This page lists today’s Tasks only — no separate Care advice engine here.
        """
}
