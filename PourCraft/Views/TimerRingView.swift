import SwiftUI

struct TimerRingView: View {
    let progress: Double
    let elapsedFormatted: String
    let phase: BrewPhase
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

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
                    .font(.system(size: timerFontSize, weight: .bold, design: .serif))
                    .monospacedDigit()
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: elapsedFormatted)
                    .minimumScaleFactor(0.65)

                Text(phase.displayName)
                    .font(AppTypography.caption)
                    .foregroundStyle(phase.ringColor(for: colorScheme))
                    .textCase(.uppercase)
            }
        }
        .frame(width: ringDiameter, height: ringDiameter)
        .padding(16)
    }

    private var ringDiameter: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 180 : 220
    }

    private var timerFontSize: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 40 : 48
    }
}
