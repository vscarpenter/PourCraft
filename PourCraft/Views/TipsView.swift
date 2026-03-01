import SwiftUI

struct TipsView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Pro Tips")
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))

                Text("Tap any tip to learn more")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText(for: colorScheme))

                ForEach(BrewTip.allTips) { tip in
                    TipCard(tip: tip)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppColors.background(for: colorScheme))
    }
}
