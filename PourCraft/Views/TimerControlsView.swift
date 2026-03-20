import SwiftUI

struct TimerControlsView: View {
    let timerModel: BrewTimerModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 16) {
            // Reset button (visible when not in ready state)
            if timerModel.phase != .ready {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        timerModel.reset()
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

            // Primary button: Start / Pause / Resume
            if timerModel.phase != .done {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if timerModel.phase == .ready {
                            timerModel.start()
                        } else {
                            timerModel.togglePause()
                        }
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
        .padding(.horizontal, 20)
    }

    private var primaryButtonLabel: String {
        switch timerModel.phase {
        case .ready: "Start Brew"
        case .bloom, .pour, .drawdown: timerModel.isRunning ? "Pause" : "Resume"
        case .done: ""
        }
    }
}
