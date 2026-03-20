import SwiftUI

struct TimerRingView: View {
    let progress: Double
    let elapsedFormatted: String
    let phase: BrewPhase
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(AppColors.surface(for: colorScheme), lineWidth: 12)

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    phase.ringColor(for: colorScheme),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)

            // Center content
            VStack(spacing: 4) {
                Text(elapsedFormatted)
                    .font(.system(size: 48, weight: .bold, design: .serif))
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: elapsedFormatted)

                Text(phase.displayName)
                    .font(AppTypography.caption)
                    .foregroundStyle(phase.ringColor(for: colorScheme))
                    .textCase(.uppercase)
            }
        }
        .frame(width: 220, height: 220)
        .padding(16)
    }
}
