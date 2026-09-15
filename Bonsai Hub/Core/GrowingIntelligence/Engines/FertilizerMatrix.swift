//
//  FertilizerMatrix.swift
//  Bonsai World
//
//  Stage × group × season baseline intensities.
//  Growth state and health are applied by FertilizerEngine, not here.
//

import Foundation

enum FertilizerMatrix {
    static func baseline(
        stage: FertilizerStage,
        group: FertilizerTreeGroup,
        season: FertilizerSeason
    ) -> FertilizerIntensity {
        if season == .winter { return .none }
        switch stage {
        case .development: return development(group: group, season: season)
        case .establishment: return establishment(group: group, season: season)
        case .refinement: return refinement(group: group, season: season)
        }
    }

    static func developmentGoal(for group: FertilizerTreeGroup) -> String {
        switch group {
        case .pineSingleFlush: "Strong structural development"
        case .pineDoubleFlush: "Strong growth and controlled second-flush development"
        case .juniper: "Vigorous extension and development"
        case .spruceFir: "Strong but controlled development"
        case .larch: "Rapid structural development"
        case .deciduousDefoliationTolerant: "Build trunk and branches"
        case .deciduousNoDefoliation: "Build structure while maintaining controlled growth"
        }
    }

    private static func development(
        group: FertilizerTreeGroup,
        season: FertilizerSeason
    ) -> FertilizerIntensity {
        switch (group, season) {
        case (.pineSingleFlush, .spring), (.pineDoubleFlush, .spring): .moderate
        case (.pineSingleFlush, .summer), (.pineDoubleFlush, .summer): .higher
        case (.pineSingleFlush, .lateSummer), (.pineDoubleFlush, .lateSummer): .moderate
        case (.pineSingleFlush, .fall), (.pineDoubleFlush, .fall): .low

        case (.juniper, .spring), (.spruceFir, .spring): .moderate
        case (.juniper, .summer), (.spruceFir, .summer): .higher
        case (.juniper, .lateSummer), (.spruceFir, .lateSummer): .moderate
        case (.juniper, .fall), (.spruceFir, .fall): .low

        case (.larch, .spring): .moderateToHigher
        case (.larch, .summer): .higher
        case (.larch, .lateSummer): .lowToModerate
        case (.larch, .fall): .low

        case (.deciduousDefoliationTolerant, .spring): .higher
        case (.deciduousDefoliationTolerant, .summer): .higher
        case (.deciduousDefoliationTolerant, .lateSummer): .moderate
        case (.deciduousDefoliationTolerant, .fall): .low

        case (.deciduousNoDefoliation, .spring): .moderate
        case (.deciduousNoDefoliation, .summer): .higher
        case (.deciduousNoDefoliation, .lateSummer): .moderate
        case (.deciduousNoDefoliation, .fall): .low

        default: .none
        }
    }

    private static func establishment(
        group: FertilizerTreeGroup,
        season: FertilizerSeason
    ) -> FertilizerIntensity {
        switch (group, season) {
        case (_, .spring):
            group == .larch || group.isDeciduous ? .low : .veryCautious
        case (.deciduousDefoliationTolerant, .summer), (.deciduousNoDefoliation, .summer):
            .lowToModerate
        case (_, .summer): .low
        case (_, .lateSummer), (_, .fall): .low
        default: .none
        }
    }

    private static func refinement(
        group: FertilizerTreeGroup,
        season: FertilizerSeason
    ) -> FertilizerIntensity {
        switch (group, season) {
        case (.pineSingleFlush, .spring): .low
        case (.pineSingleFlush, .summer): .low
        case (.pineSingleFlush, .lateSummer): .moderate
        case (.pineSingleFlush, .fall): .low

        case (.pineDoubleFlush, .spring): .low
        case (.pineDoubleFlush, .summer): .low
        case (.pineDoubleFlush, .lateSummer): .low
        case (.pineDoubleFlush, .fall): .low

        case (.juniper, .spring), (.spruceFir, .spring): .low
        case (.juniper, .summer), (.spruceFir, .summer): .lowToModerate
        case (.juniper, .lateSummer), (.spruceFir, .lateSummer): .low
        case (.juniper, .fall), (.spruceFir, .fall): .low

        case (.larch, .spring), (.larch, .summer): .moderate
        case (.larch, .lateSummer), (.larch, .fall): .low

        case (.deciduousDefoliationTolerant, .spring), (.deciduousNoDefoliation, .spring): .low
        case (.deciduousDefoliationTolerant, .summer), (.deciduousNoDefoliation, .summer): .moderate
        case (.deciduousDefoliationTolerant, .lateSummer), (.deciduousNoDefoliation, .lateSummer): .low
        case (.deciduousDefoliationTolerant, .fall), (.deciduousNoDefoliation, .fall): .low

        default: .none
        }
    }
}
