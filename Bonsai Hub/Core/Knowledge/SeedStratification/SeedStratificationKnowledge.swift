//
//  SeedStratificationKnowledge.swift
//  Bonsai World
//
//  Educational copy for Seed Stratification knowledge UI.
//  Cautious horticultural language — no species-specific invented values.
//

import Foundation

enum SeedStratificationKnowledge {
    static let chapterTitle = "Seed Stratification"
    static let openingQuestion = "I have seeds. What do I need to do to get them to germinate?"

    static let introduction: [String] = [
        "Many bonsai species produce seeds that do not germinate immediately, even when moisture and warmth look right. That delay is often dormancy — a natural pause that protects the seed until conditions are more favorable.",
        "Stratification is a controlled treatment that simulates the environmental cues some seeds experience in nature, usually involving moisture and temperature over time. Requirements vary widely between species, and sometimes between seed lots of the same species.",
        "Use this guide to understand the principles. Species-specific ranges will come from the Seed Stratification database in Settings when that catalog is available — not from guesswork on this page."
    ]

    static let whatIsStratification: [String] = [
        "Stratification is a deliberate treatment designed to overcome dormancy and prepare seed for germination. It is not the same as sowing, and it is not a guarantee of germination.",
        "In practice you control moisture, temperature, and duration so the seed receives the cues it needs. When the required treatment is complete, you move the seed into suitable germination conditions and watch carefully.",
        "Some seeds need little or no stratification. Others need cold moist treatment, a warm phase, sequential warm-then-cold treatment, scarification of a hard seed coat, or a combination of steps. The species profile — when present — tells you which path applies."
    ]

    struct TreatmentCard: Identifiable, Hashable, Sendable {
        var id: StratificationMethod { method }
        var method: StratificationMethod
        var summary: String
        var detail: String
    }

    static let treatmentCards: [TreatmentCard] = [
        TreatmentCard(
            method: .none,
            summary: "Sow when germination conditions are suitable.",
            detail: "Some seeds have little or no dormancy and can be sown directly once moisture, temperature, and hygiene are appropriate. Absence of stratification does not mean care is optional — it means the dormancy barrier is not the main obstacle."
        ),
        TreatmentCard(
            method: .coldMoist,
            summary: "Moist medium + cold temperature + defined duration.",
            detail: "A common approach for many temperate species. Keep the medium moist, not saturated; hold a cool temperature band appropriate to the species; and continue for the recommended duration range before moving to germination conditions."
        ),
        TreatmentCard(
            method: .warm,
            summary: "Warm, moist period before germination or before cold.",
            detail: "Warm stratification uses a mild warm, moist phase. Some species use it alone; others need it before a subsequent cold treatment. Exact temperatures and durations belong on the species profile."
        ),
        TreatmentCard(
            method: .warmThenCold,
            summary: "Sequential warm phase, then cold phase.",
            detail: "Complex dormancy may require ordered steps: complete a warm moist phase, then a cold moist phase, then germination conditions. Skipping or reversing steps can reduce success."
        ),
        TreatmentCard(
            method: .scarification,
            summary: "Address a physical seed-coat barrier.",
            detail: "Scarification is not stratification. It softens or abrades a hard seed coat so water and gases can enter. Methods are species-specific; general chemical procedures are not recommended here."
        ),
        TreatmentCard(
            method: .combined,
            summary: "Ordered multi-step sequences when required.",
            detail: "A profile may list a sequence such as scarification → warm → cold → germination. Not every species needs every step. Follow the sequence on the species record when one exists."
        )
    ]

    struct WorkflowStep: Identifiable, Hashable, Sendable {
        var id: Int
        var title: String
        var note: String
    }

    static let workflowSteps: [WorkflowStep] = [
        WorkflowStep(id: 1, title: "Identify species", note: "Match the seed to a botanical identity before choosing a treatment."),
        WorkflowStep(id: 2, title: "Check seed condition", note: "Look for freshness, damage, mold, and storage history when known."),
        WorkflowStep(id: 3, title: "Determine dormancy / treatment", note: "Use the species profile when available; otherwise research carefully."),
        WorkflowStep(id: 4, title: "Prepare medium", note: "Choose a clean, moisture-retaining medium and containers."),
        WorkflowStep(id: 5, title: "Hydrate seeds if required", note: "Some lots benefit from soaking; follow species guidance."),
        WorkflowStep(id: 6, title: "Begin treatment", note: "Start the prescribed warm, cold, or scarification step."),
        WorkflowStep(id: 7, title: "Monitor periodically", note: "Check moisture, mold, and premature germination without over-handling."),
        WorkflowStep(id: 8, title: "Complete required treatment", note: "Stay within the recommended duration range for that species."),
        WorkflowStep(id: 9, title: "Move to germination conditions", note: "Provide suitable warmth, light, and moisture for emergence."),
        WorkflowStep(id: 10, title: "Record germination", note: "Note dates and outcomes so future lots improve.")
    ]

    static let coldMediumIntro = "Use a clean, moisture-retaining propagation medium. The goal is moist, not saturated — excess water encourages rot and mold."

    static let coldMediumExamples = [
        "Vermiculite",
        "Clean sand",
        "Peat-based medium",
        "Other suitable moisture-retaining propagation media"
    ]

    static let coldTemperatureCopy = [
        "Many temperate species are treated in a cool band often described around approximately 1–5 °C. That is a common reference range in horticultural practice — not a universal rule for every species.",
        "The authoritative temperature band must come from the species stratification profile once the database is connected. Until then, treat any number on this page as educational context only."
    ]

    static let coldDurationCopy = [
        "Duration is species-dependent and can range considerably. Profiles should store minimum and maximum days (for example 60–120), not a single false-precision number.",
        "When both bounds exist, Bonsai Hub can later show the recommended range and optionally a suggested starting midpoint — always secondary to the range."
    ]

    static let coldMonitoring = [
        "Check moisture — keep moist, not waterlogged.",
        "Check for mold and improve hygiene if needed.",
        "Watch for premature germination and respond promptly.",
        "Remove damaged or rotting material.",
        "Maintain appropriate moisture between checks.",
        "Avoid unnecessary disturbance of healthy seed."
    ]

    static let warmThenColdCopy: [String] = [
        "Some species have dormancy that responds poorly to cold alone. A warm moist phase first can allow internal development or other cues, after which a cold phase completes the preparation for germination.",
        "Conceptual flow: Warm phase → Cold phase → Germination conditions. Which species follow this path is determined by the future species database — this knowledge page does not invent examples."
    ]

    static let scarificationCopy: [String] = [
        "Scarification addresses a physical barrier of the seed coat. It is separate from temperature-based stratification, though both may appear in one treatment sequence.",
        "Approaches may include careful mechanical abrasion, soaking, or other species-specific pretreatments documented on the profile.",
        "Dangerous chemical treatments are not presented as a general user procedure. If chemical scarification is supported later, it must appear as an advanced, species-specific step with clear safety information."
    ]

    struct MistakeCard: Identifiable, Hashable, Sendable {
        var id: String
        var title: String
        var detail: String
    }

    static let commonMistakes: [MistakeCard] = [
        MistakeCard(id: "wet", title: "Excessive moisture", detail: "Saturated medium invites mold and rot."),
        MistakeCard(id: "dry", title: "Allowing the medium to dry out", detail: "Seeds in moist stratification need steady moisture."),
        MistakeCard(id: "temp", title: "Incorrect temperature", detail: "Too warm or too cold for the intended phase reduces effectiveness."),
        MistakeCard(id: "duration", title: "Incorrect treatment duration", detail: "Stopping early or extending far beyond guidance can both fail."),
        MistakeCard(id: "hygiene", title: "Poor hygiene", detail: "Dirty tools and media increase losses."),
        MistakeCard(id: "early", title: "Ignoring early germination", detail: "Seedlings in cold storage need timely attention."),
        MistakeCard(id: "same", title: "Assuming every species is alike", detail: "Treatments differ; one recipe does not fit all."),
        MistakeCard(
            id: "absolute",
            title: "Treating a recommendation as an absolute rule",
            detail: "Published requirements are often ranges. Seed lots can behave differently. Use judgment and records."
        )
    ]

    static let speciesSelectorPlaceholder =
        "Search and select a species to see its stratification profile from the centralized Seed Stratification database."

    static let startActionPlaceholder =
        "Start Stratification will connect to Propagation / batch tracking in a later task."

    static let educationalColdGlanceTemperature = "often ~1–5 °C (species-dependent)"
    static let educationalColdGlanceDuration = "species range (e.g. weeks to months)"
}
