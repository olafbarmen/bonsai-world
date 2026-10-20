//
//  MobileGettingStartedView.swift
//  Bonsai World
//
//  Settings → Getting Started — same section themes as Mac, wording for the phone.
//

import SwiftUI

struct MobileGettingStartedView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                intro

                guideSection(
                    title: "What Bonsai World is",
                    paragraphs: [
                        "Bonsai World is your home for the trees you care for. It helps you see what you have, where each tree lives, what needs attention, and what you have already done — without turning care into paperwork.",
                        "On iPhone, Home is the starting point: Attention and Tasks, then Field worlds (Trees, Yamadori, Seeds, and the rest), Knowledge, and Places."
                    ]
                )

                guideSection(
                    title: "Home",
                    paragraphs: [
                        "Open Home when you want a quiet overview of the collection. You will see which trees need attention, shaping still in progress, and a summary of Tasks.",
                        "Use it as a starting point: glance at what needs attention, then open Tasks or a tree when something stands out."
                    ]
                )

                guideSection(
                    title: "Tasks",
                    paragraphs: [
                        "Tasks is your work list over time. Open the Tasks tab for overdue and today, then browse what falls later.",
                        "Open a task to read the details, mark it done, or postpone if needed. Tasks stay linked to the trees and care work they belong to."
                    ]
                )

                guideSection(
                    title: "Garden",
                    paragraphs: [
                        "Garden is where your living collection lives day to day.",
                        "My Trees holds the trees you care for. Open a tree to edit details, add photos, assign a pot, and follow its timeline of work and notes.",
                        "Collections let you group trees the way you think about them — for example by style, bench, or a project. Locations and Gardens map where trees and spots actually stand."
                    ]
                )

                guideSection(
                    title: "Care",
                    paragraphs: [
                        "Care guidance lives in Knowledge and on each tree. Schedules and Tasks keep watering, fertilizing, and other routines on track.",
                        "On each tree, Placement and Location say where it stands. Work history records what you have already done."
                    ]
                )

                guideSection(
                    title: "Nursery",
                    paragraphs: [
                        "Nursery is for material that is not yet a finished tree in your collection.",
                        "Seeds follows a batch from preparation and stratification through sowing and germination. Cuttings and Air Layers work the same idea for those methods. When ready, create trees so they join My Trees."
                    ]
                )

                guideSection(
                    title: "Yamadori",
                    paragraphs: [
                        "Yamadori is for wild-collected material before it becomes part of My Trees.",
                        "Start a trip, record finds, add observations and photos, and mark a find as collected when you bring it home. When it is ready, move it into My Trees — until then it stays in Yamadori."
                    ]
                )

                guideSection(
                    title: "Inventory",
                    paragraphs: [
                        "Inventory is your shed and cupboard: pots, soil, fertilizers, wire, tools, chemicals, and consumables.",
                        "Keep stock up to date and assign pots to trees from the tree or from Pots."
                    ]
                )

                guideSection(
                    title: "Media",
                    paragraphs: [
                        "Images browses every photo in your library. You can also open a tree’s photos from the tree itself.",
                        "Work lists recent work across trees so care history is easy to scan without opening each profile."
                    ]
                )

                guideSection(
                    title: "Knowledge",
                    paragraphs: [
                        "Knowledge is reading and reference while you work — not a separate course outside the app.",
                        "Open the Bonsai Handbook for care topics, Species Library for species profiles, and the fertilizer, soil, and seed stratification guides when you need a refresher."
                    ]
                )

                guideSection(
                    title: "Library Management",
                    paragraphs: [
                        "Settings holds your profile name, regional preferences, notifications, and Library Management.",
                        "Library Management is where your data lives on this iPhone — iCloud with Mac when you choose it, or a library kept on this device. Export a ZIP backup, import a package, clear photos, or reset to demo from here."
                    ]
                )
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(BonsaiWorldColors.canvas)
        .navigationTitle("Getting Started")
        .navigationBarTitleDisplayMode(.inline)
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
    NavigationStack {
        MobileGettingStartedView()
    }
}
