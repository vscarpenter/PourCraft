import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 40)

                // App icon placeholder
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(AppColors.accent(for: colorScheme))

                VStack(spacing: 4) {
                    Text("PourCraft")
                        .font(AppTypography.largeTitle)
                        .foregroundStyle(AppColors.primaryText(for: colorScheme))

                    Text("Perfect Pour-Over, Every Time")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                }

                Text("Version 1.0.0")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText(for: colorScheme))

                VStack(alignment: .leading, spacing: 12) {
                    aboutRow(
                        icon: "info.circle",
                        text: "PourCraft helps you calculate the ideal coffee-to-water ratio for pour-over brewing."
                    )
                    aboutRow(
                        icon: "scalemass",
                        text: "Supports light, medium, and dark roast profiles with industry-standard ratios."
                    )
                    aboutRow(
                        icon: "heart.fill",
                        text: "Built with love for better mornings."
                    )
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.surface(for: colorScheme))
                )

                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .background(AppColors.background(for: colorScheme))
    }

    private func aboutRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(AppColors.accent(for: colorScheme))
                .frame(width: 24)
            Text(text)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.primaryText(for: colorScheme))
        }
    }
}
