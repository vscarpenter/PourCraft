import SwiftUI

struct RoastSelectionCard: View {
    let roast: Roast
    let isSelected: Bool
    let onSelect: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Circle()
                        .fill(roast.color)
                        .frame(width: 14, height: 14)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(roast.displayName)
                            .font(AppTypography.headline)
                            .foregroundStyle(AppColors.primaryText(for: colorScheme))

                        Text(roast.flavorProfile)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                            .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 2)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 8) {
                        Text(roast.ratioLabel)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AppColors.onAccent(for: colorScheme))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(AppColors.accent(for: colorScheme))
                            )

                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(
                                isSelected
                                    ? AppColors.accent(for: colorScheme)
                                    : AppColors.secondaryText(for: colorScheme)
                            )
                    }
                }

                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(index < roastIntensity ? roast.color : AppColors.background(for: colorScheme))
                            .frame(height: 6)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardFill)
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

    private var roastIntensity: Int {
        switch roast {
        case .light: 1
        case .medium: 2
        case .dark: 3
        }
    }

    private var cardFill: LinearGradient {
        let tintOpacity = colorScheme == .dark ? 0.26 : 0.16
        return LinearGradient(
            colors: [roast.color.opacity(tintOpacity), AppColors.surface(for: colorScheme)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
