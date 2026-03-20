import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(AppColors.accent(for: colorScheme))
                    .frame(width: 88, height: 88)
                    .background(
                        Circle()
                            .fill(AppColors.surface(for: colorScheme))
                    )

                VStack(spacing: 4) {
                    Text("PourCraft")
                        .font(AppTypography.largeTitle)
                        .foregroundStyle(AppColors.primaryText(for: colorScheme))

                    Text("Perfect Pour-Over, Every Time")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                }

                Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(AppColors.surface(for: colorScheme))
                    )

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
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.background(for: colorScheme), lineWidth: 1)
                )
                .shadow(
                    color: colorScheme == .dark ? .black.opacity(0.2) : .black.opacity(0.05),
                    radius: 6,
                    y: 2
                )

                HStack(spacing: 0) {
                    Text("Crafted by ")
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                    Link("Vinny Carpenter", destination: URL(string: "https://vinny.dev/")!)
                        .foregroundStyle(AppColors.controlTint(for: colorScheme))
                }
                .font(AppTypography.caption)
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
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
