import SwiftUI

struct BrewResultsView: View {
    let brewModel: BrewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            Text("Brew Guide")
                .font(AppTypography.title)
                .foregroundStyle(AppColors.primaryText(for: colorScheme))

            // Summary cards
            HStack(spacing: 12) {
                summaryCard(
                    label: "Water",
                    value: "\(brewModel.formattedWeight(brewModel.totalWater))g"
                )
                summaryCard(
                    label: "Temp",
                    value: brewModel.temperatureRange
                )
            }

            // Step-by-step guide
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(brewModel.brewSteps.enumerated()), id: \.offset) { index, step in
                    brewStepRow(number: index + 1, text: step)
                }
            }
        }
    }

    private func summaryCard(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText(for: colorScheme))
            Text(value)
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.primaryText(for: colorScheme))
                .contentTransition(.numericText())
                .animation(.snappy, value: value)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.surface(for: colorScheme))
        )
    }

    private func brewStepRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(AppTypography.captionBold)
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(AppColors.accent(for: colorScheme))
                )

            Text(text)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.primaryText(for: colorScheme))
        }
        .padding(.vertical, 4)
    }
}
