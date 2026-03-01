import SwiftUI

struct BrewView: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                Text("PourCraft")
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))

                // Roast selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Roast")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))

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
                HStack {
                    Text("Temperature")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                    Spacer()
                    Picker("Temperature Unit", selection: $brewModel.temperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                            Text(unit.label).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 120)
                }

                // Brew results
                BrewResultsView(brewModel: brewModel)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppColors.background(for: colorScheme))
    }
}
