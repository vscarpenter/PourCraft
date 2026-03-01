import SwiftUI

struct CoffeeWeightInput: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 16) {
            // Weight display
            HStack(alignment: .firstTextBaseline) {
                Text(brewModel.formattedWeight(brewModel.coffeeWeight))
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: brewModel.coffeeWeight)

                Text("grams")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText(for: colorScheme))
            }

            // Stepper
            Stepper(
                "Coffee Weight",
                value: $brewModel.coffeeWeight,
                in: 10...60,
                step: 1
            )
            .labelsHidden()
            .tint(AppColors.accent(for: colorScheme))

            // Ratio display
            Text("Ratio: \(brewModel.selectedRoast.ratioLabel)")
                .font(AppTypography.captionBold)
                .foregroundStyle(AppColors.accent(for: colorScheme))

            // Water summary
            HStack(spacing: 24) {
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
        VStack(spacing: 4) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText(for: colorScheme))
            Text("\(value)g")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.primaryText(for: colorScheme))
                .contentTransition(.numericText())
                .animation(.snappy, value: value)
        }
    }
}
