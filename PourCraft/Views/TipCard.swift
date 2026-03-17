import SwiftUI

struct TipCard: View {
    let tip: BrewTip
    @State private var isExpanded = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: tip.iconName)
                        .font(.title3)
                        .foregroundStyle(AppColors.accent(for: colorScheme))
                        .frame(width: 32)

                    Text(tip.title)
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.primaryText(for: colorScheme))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider()
                    .overlay(AppColors.background(for: colorScheme))

                Text(tip.body)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
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
    }
}
