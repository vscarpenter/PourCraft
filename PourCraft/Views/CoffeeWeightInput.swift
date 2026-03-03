import SwiftUI

struct CoffeeWeightInput: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(spacing: 16) {
            // Weight display
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    weightValue
                    Text("grams")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                }

                VStack(alignment: .leading, spacing: 4) {
                    weightValue
                    Text("grams")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                }
            }

            // Stepper
            Stepper(
                "Coffee Weight",
                value: $brewModel.coffeeWeight,
                in: 10...60,
                step: 1
            )
            .labelsHidden()
            .tint(AppColors.controlTint(for: colorScheme))

            // Ratio display
            Text("Ratio: \(brewModel.selectedRoast.ratioLabel)")
                .font(AppTypography.captionBold)
                .foregroundStyle(AppColors.secondaryText(for: colorScheme))

            // Water summary
            LazyVGrid(columns: waterSummaryColumns, spacing: 12) {
                waterLabel(
                    title: "Total Water",
                    value: brewModel.formattedWeight(brewModel.totalWater)
                )
                waterLabel(
                    title: "Bloom",
                    value: brewModel.formattedWeight(brewModel.bloomWater)
                )
                waterLabel(
                    title: "Remaining",
                    value: brewModel.formattedWeight(brewModel.remainingWater)
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surface(for: colorScheme))
        )
    }

    private func waterLabel(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText(for: colorScheme))
            Text("\(value)g")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.primaryText(for: colorScheme))
                .contentTransition(.numericText())
                .animation(.snappy, value: value)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.background(for: colorScheme))
        )
    }

    private var weightValue: some View {
        Text(brewModel.formattedWeight(brewModel.coffeeWeight))
            .font(AppTypography.largeTitle)
            .foregroundStyle(AppColors.primaryText(for: colorScheme))
            .contentTransition(.numericText())
            .animation(.snappy, value: brewModel.coffeeWeight)
    }

    private var waterSummaryColumns: [GridItem] {
        if dynamicTypeSize.isAccessibilitySize {
            [GridItem(.flexible())]
        } else {
            [GridItem(.adaptive(minimum: 96), spacing: 12)]
        }
    }
}
