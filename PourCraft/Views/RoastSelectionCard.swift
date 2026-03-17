import SwiftUI

struct RoastSelectionCard: View {
    let roast: Roast
    let isSelected: Bool
    let onSelect: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(roast.color)
                        .frame(width: 12, height: 12)
                    Text(roast.displayName)
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.primaryText(for: colorScheme))
                    Spacer()
                    Text(roast.ratioLabel)
                        .font(AppTypography.captionBold)
                        .foregroundStyle(AppColors.accent(for: colorScheme))
                }

                Text(roast.flavorProfile)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.surface(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? AppColors.accent(for: colorScheme) : .clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(
                color: isSelected ? AppColors.accent(for: colorScheme).opacity(0.3) : .clear,
                radius: 8,
                y: 4
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
