import SwiftUI

struct TimerView: View {
    let brewModel: BrewModel
    @Bindable var timerModel: BrewTimerModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Brew summary card
                brewSummaryCard

                // Timer ring
                TimerRingView(
                    progress: timerModel.progress,
                    elapsedFormatted: timerModel.totalElapsedFormatted,
                    phase: timerModel.phase
                )

                // Phase instruction
                Text(timerModel.phaseInstruction)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .animation(.snappy, value: timerModel.phase)

                // Bloom countdown (visible during bloom)
                if timerModel.phase == .bloom {
                    Text("\(timerModel.bloomCountdownRemaining)s remaining")
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.bloomOrange)
                        .contentTransition(.numericText())
                        .animation(.snappy, value: timerModel.bloomCountdownRemaining)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                // Target time
                if timerModel.phase != .ready && timerModel.phase != .done {
                    Text("Target: \(timerModel.targetTimeFormatted)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                }

                // Controls
                TimerControlsView(timerModel: timerModel)

                Spacer(minLength: 20)
            }
            .padding(.vertical, 16)
        }
        .background(AppColors.background(for: colorScheme))
        .onAppear {
            syncBrewParameters()
        }
        .onChange(of: brewModel.coffeeWeight) { _, _ in
            syncIfReady()
        }
        .onChange(of: brewModel.selectedRoast) { _, _ in
            syncIfReady()
        }
    }

    // MARK: - Brew Summary Card

    private var brewSummaryCard: some View {
        HStack(spacing: 16) {
            summaryItem(label: "Roast", value: brewModel.selectedRoast.displayName)
            summaryItem(label: "Coffee", value: "\(brewModel.formattedWeight(brewModel.coffeeWeight))g")
            summaryItem(label: "Water", value: "\(brewModel.formattedWeight(brewModel.totalWater))g")
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surface(for: colorScheme))
        )
        .padding(.horizontal, 20)
    }

    private func summaryItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText(for: colorScheme))
            Text(value)
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.primaryText(for: colorScheme))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Sync

    private func syncBrewParameters() {
        timerModel.configure(
            bloomWater: brewModel.bloomWater,
            remainingWater: brewModel.remainingWater,
            totalWater: brewModel.totalWater
        )
    }

    private func syncIfReady() {
        guard timerModel.phase == .ready else { return }
        syncBrewParameters()
    }
}
