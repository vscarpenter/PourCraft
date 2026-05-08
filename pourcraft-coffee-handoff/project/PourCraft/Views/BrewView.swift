import SwiftUI

struct BrewView: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Roast selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Roast")
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.primaryText(for: colorScheme))

                    ForEach(Roast.allCases) { roast in
                        RoastSelectionCard(
                            roast: roast,
                            isSelected: brewModel.selectedRoast == roast
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                brewModel.selectedRoast = roast
                            }
                        }
                    }
                }

                // Coffee weight input
                CoffeeWeightInput(brewModel: brewModel)

                // Temperature toggle
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 12) {
                        Text("Temperature Unit")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.secondaryText(for: colorScheme))

                        Spacer(minLength: 12)

                        temperaturePicker
                            .frame(maxWidth: 160)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Temperature Unit")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.secondaryText(for: colorScheme))

                        temperaturePicker
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.surface(for: colorScheme))
                )

                // Brew results
                BrewResultsView(brewModel: brewModel)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppColors.background(for: colorScheme))
    }

    private var temperaturePicker: some View {
        Picker("Temperature Unit", selection: $brewModel.temperatureUnit) {
            ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                Text(unit.label).tag(unit)
            }
        }
        .pickerStyle(.segmented)
        .tint(AppColors.controlTint(for: colorScheme))
    }
}
