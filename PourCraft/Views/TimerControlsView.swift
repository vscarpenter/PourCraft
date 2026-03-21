import SwiftUI

struct TimerControlsView: View {
    let timerModel: BrewTimerModel
    let onReset: () -> Void
    let onPrimaryAction: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ViewThatFits(in: .horizontal) {
            horizontalControls
            verticalControls
        }
        .padding(.horizontal, 20)
    }

    private var horizontalControls: some View {
        HStack(spacing: 16) {
            resetButton
            primaryButton
        }
    }

    private var verticalControls: some View {
        VStack(spacing: 12) {
            resetButton
            primaryButton
        }
    }

    @ViewBuilder
    private var resetButton: some View {
        if timerModel.phase != .ready {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    onReset()
                }
            } label: {
                Text("Reset")
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .stroke(AppColors.secondaryText(for: colorScheme), lineWidth: 1.5)
                    )
            }
        }
    }

    @ViewBuilder
    private var primaryButton: some View {
        if timerModel.phase != .done {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    onPrimaryAction()
                }
            } label: {
                Text(primaryButtonLabel)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.onAccent(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(AppColors.accent(for: colorScheme))
                    )
            }
        }
    }

    private var primaryButtonLabel: String {
        switch timerModel.phase {
        case .ready: "Start Brew"
        case .bloom, .pour, .drawdown: timerModel.isRunning ? "Pause" : "Resume"
        case .done: ""
        }
    }
}
