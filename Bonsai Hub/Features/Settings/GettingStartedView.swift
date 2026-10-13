//
//  GettingStartedView.swift
//  Bonsai World
//
//  Settings → Getting Started — how to use Bonsai World, written for the grower.
//

import SwiftUI

struct GettingStartedView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                intro

                guideSection(
                    title: "What Bonsai World is",
                    paragraphs: [
                        "Bonsai World is your home for the trees you care for. It helps you see what you have, where each tree lives, what needs attention, and what you have already done — without turning care into paperwork.",
                        "Everything starts from your trees. The left sidebar is ordered the way most growers work through a day: first an overview, then today’s work, then the garden, then care, nursery, yamadori, and the things you keep in stock."
                    ]
                )

                guideSection(
                    title: "Dashboard",
                    paragraphs: [
                        "Open Dashboard when you want a quiet overview of the collection. You will see how many trees you have, which tasks are waiting, weather notes for your garden, and reminders such as upcoming repotting.",
                        "Use it as a starting point: glance at what needs attention, then jump into Tasks or a tree when something stands out."
                    ]
                )

                guideSection(
                    title: "Tasks",
                    paragraphs: [
                        "Tasks is your work list over time. Choose Overdue, Today, This Week, This Month, This Year, or Next Year to see what falls in that window.",
                        "Open a task to read the details, mark it done, or undo if you finished it by mistake. Tasks stay linked to the trees and care work they belong to, so the list stays meaningful instead of becoming a pile of loose notes."
                    ]
                )

                guideSection(
                    title: "Garden",
                    paragraphs: [
                        "Garden is where your living collection lives day to day.",
                        "Trees shows My Trees and Former Trees. Add a new tree from scratch, or duplicate an existing tree’s info when you are registering a similar one. Open a tree to edit details (changes save as you go), add photos, assign a pot, and follow its timeline of work and notes.",
                        "Collections let you group trees the way you think about them — for example by style, bench, or a project you are working on. You can build a collection by hand, or use smart collections that gather trees that match rules you set.",
                        "Locations is the map of your gardens and places. Put trees and spots where they actually stand so weather and placement stay connected to real ground."
                    ]
                )

                guideSection(
                    title: "Care",
                    paragraphs: [
                        "Care is guidance for keeping trees healthy. Sidebar order: Watering, Fertilizing, Placement, Winter Care, Spring Care, then Repotting, Health, and Seasonal Care. Watering, Fertilizing, Placement, Winter Care, and Spring Care include recommendation engines; the others track Tasks and Work.",
                        "On each tree, Placement strategy is Always outdoors or Seasonal. Season is Summer or Winter placement. Where the tree stands now is Location. Care → Placement lists gaps (missing Location, Seasonal trees on the wrong season during Winter or Spring Care). Winter Care (date or frost) and Spring Care (date only) are checklists for Seasonal trees — multi-select in Care, also in Tasks. Greenhouse, Cold Greenhouse, and Polytunnel Locations get a spring heat / vent check under Spring Care (date in Settings → Notifications)."
                    ]
                )

                guideSection(
                    title: "Nursery",
                    paragraphs: [
                        "Nursery is for material that is not yet a finished tree in your collection.",
                        "Seeds has two views: Seed Work for the steps you take along the way, and Overview for the batch as a whole. Follow a batch from preparation and stratification through sowing and germination. When seedlings are ready, you can create trees from them so they join My Trees.",
                        "Cuttings and Air Layers work the same idea for those methods: record the piece, move it through its stages, and keep progress in one place."
                    ]
                )

                guideSection(
                    title: "Yamadori",
                    paragraphs: [
                        "Yamadori is for wild-collected material before it becomes part of My Trees.",
                        "Start a trip, record finds, add observations and photos as you learn the tree, and mark a find as collected when you bring it home. When it is ready to join the collection, move it into My Trees — until then it stays in Yamadori so collected material does not get mixed with established trees."
                    ]
                )

                guideSection(
                    title: "Inventory",
                    paragraphs: [
                        "Inventory is your shed and cupboard: pots, soil, fertilizers, wire, tools, chemicals, and consumables.",
                        "Keep stock up to date, assign pots to trees, run a stocktake when you want a clear count, and export a Stock Report to Excel if you need a list outside the app."
                    ]
                )

                guideSection(
                    title: "Media",
                    paragraphs: [
                        "Media holds the pictures of your trees and work. Under Images you can import photos, crop a presentation view without changing the original file, and rotate when needed.",
                        "Documents and Videos are there when you want to keep related files with the library. Browse Images from here, or open a tree’s photos from the tree itself."
                    ]
                )

                guideSection(
                    title: "Knowledge",
                    paragraphs: [
                        "Knowledge is reading and reference while you work — not a separate course outside the app.",
                        "Open the Bonsai Handbook for care topics, Species Library for species profiles, and the fertilizer, soil, and seed stratification guides when you need a refresher. Use it when a tree or nursery step raises a question."
                    ]
                )

                guideSection(
                    title: "Context Tools",
                    paragraphs: [
                        "At the bottom of the left sidebar you will always find Context Tools. This is the place to do something in the area you are in right now.",
                        "The tools change as you move — for example Tree Tools when you are in Garden → Trees. Look here first when you want to add a tree, import photos, or take the next step for the page you have open."
                    ]
                )

                guideSection(
                    title: "Library & Settings",
                    paragraphs: [
                        "Settings is for you and your library: profile name and gardens, regional preferences, appearance, notifications, and reference lists such as pot brands.",
                        "Library Management is where your data lives on this Mac. From here you can see the library folder, make a backup ZIP, restore from a backup, or switch to another library. Keep backup and restore here so everyday care stays in the workspace, not buried in file menus."
                    ]
                )
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 640, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Getting Started")
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("How to find your way around Bonsai World")
                .font(FaloTypography.headline)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            Text("A short guide written for the grower — what each part of the app is for, and how to use it day to day.")
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func guideSection(title: String, paragraphs: [String]) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text(title)
                .font(FaloTypography.headline)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    GettingStartedView()
}
