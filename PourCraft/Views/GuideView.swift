import SwiftUI

/// The Guide tab — the eight-step pour-over method with a live brew timer
/// folded in. Step rows highlight as the timer advances, and the user can
/// also tap any step to expand it independently.
struct GuideView: View {
    let brewModel: BrewModel
    @Bindable var timerModel: BrewTimerModel

    @Environment(\.colorScheme) private var scheme
    @Environment(\.scenePhase) private var scenePhase
    @State private var manuallyExpanded: Int?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SubHeader(
                    kicker: "The Method",
                    subtitle: "Eight steps, in order, by the gram."
                ) {
                    HStack(spacing: 0) {
                        Text("The ")
                        Text("Method")
                            .italic()
                            .foregroundStyle(AppColors.accent(for: scheme))
                        Text(".")
                    }
                }

                RecipeSummaryStrip(brewModel: brewModel)
                    .padding(.horizontal, 24)
                    .padding(.top, 18)

                TimerStrip(timerModel: timerModel, brewModel: brewModel)
                    .padding(.horizontal, 24)
                    .padding(.top, 14)

                StepsSection(
                    brewModel: brewModel,
                    timerModel: timerModel,
                    manuallyExpanded: $manuallyExpanded
                )
                .padding(.top, 24)

                OutroQuote()
                    .padding(.horizontal, 24)
                    .padding(.top, 28)

                Color.clear.frame(height: 24)
            }
        }
        .background(AppColors.background(for: scheme))
        .sensoryFeedback(trigger: timerModel.phase) { oldValue, newValue in
            guard brewModel.hapticsEnabled, oldValue != newValue else { return nil }
            switch newValue {
            case .bloom, .pour, .drawdown: return .impact(weight: .medium)
            case .done: return .success
            case .ready: return nil
            }
        }
        .onAppear {
            syncTimerIfReady()
            timerModel.syncToNow()
        }
        .onChange(of: brewModel.coffeeWeight) { _, _ in syncTimerIfReady() }
        .onChange(of: brewModel.selectedRoast) { _, _ in syncTimerIfReady() }
        .onChange(of: scenePhase) { _, _ in timerModel.syncToNow() }
    }

    private func syncTimerIfReady() {
        guard timerModel.phase == .ready else { return }
        timerModel.configure(
            bloomWater: brewModel.bloomWater,
            remainingWater: brewModel.remainingWater,
            totalWater: brewModel.totalWater
        )
    }
}

// MARK: - Recipe summary strip

private struct RecipeSummaryStrip: View {
    let brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let muted = AppColors.muted(for: scheme)

        VStack(spacing: 0) {
            Rule(color: AppColors.rule(for: scheme))
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Today's Recipe")
                        .font(AppTypography.micro)
                        .tracking(2.5)
                        .textCase(.uppercase)
                        .foregroundStyle(muted)
                    Spacer()
                    Text("\(brewModel.selectedRoast.displayName) · \(brewModel.selectedRoast.ratioLabel)")
                        .font(AppTypography.serifItalic(13))
                        .foregroundStyle(muted)
                }

                HStack(alignment: .top, spacing: 0) {
                    SummaryCell(key: "Coffee", value: "\(brewModel.formattedWeight(brewModel.coffeeWeight))g")
                    SummaryCell(key: "Water", value: "\(brewModel.formattedWeight(brewModel.totalWater))g")
                    SummaryCell(key: "Temp", value: brewModel.temperaturePoint)
                }
            }
            .padding(.vertical, 13)
            Rule(color: AppColors.rule(for: scheme))
        }
    }
}

private struct SummaryCell: View {
    let key: String
    let value: String
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(key)
                .font(AppTypography.micro)
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(AppColors.muted(for: scheme))
            Text(value)
                .font(AppTypography.serif(22, weight: .medium))
                .foregroundStyle(AppColors.ink(for: scheme))
                .kerning(-0.5)
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.snappy, value: value)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Timer strip (live brew timer folded into the guide)

private struct TimerStrip: View {
    @Bindable var timerModel: BrewTimerModel
    let brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        VStack(spacing: 0) {
            Rule(color: AppColors.rule(for: scheme))
            VStack(spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Live timer")
                            .font(AppTypography.micro)
                            .tracking(2.5)
                            .textCase(.uppercase)
                            .foregroundStyle(muted)
                        Text(timerModel.totalElapsedFormatted)
                            .font(AppTypography.serif(34, weight: .medium))
                            .foregroundStyle(ink)
                            .kerning(-1)
                            .monospacedDigit()
                            .contentTransition(.numericText())
                            .animation(.snappy, value: timerModel.elapsedSeconds)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(timerModel.phase.displayName)
                            .font(AppTypography.micro)
                            .tracking(2.5)
                            .textCase(.uppercase)
                            .foregroundStyle(timerModel.phase == .ready ? muted : accent)
                        Text("of \(timerModel.targetTimeFormatted)")
                            .font(AppTypography.serifItalic(13))
                            .foregroundStyle(muted)
                    }
                }

                // Progress rule
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(AppColors.rule(for: scheme))
                            .frame(height: 2)
                        Rectangle()
                            .fill(accent)
                            .frame(width: max(0, geo.size.width * timerModel.progress), height: 2)
                            .animation(.linear(duration: 1), value: timerModel.progress)
                    }
                }
                .frame(height: 2)

                HStack(spacing: 12) {
                    if timerModel.phase != .ready {
                        Button("Reset") {
                            withAnimation(.snappy) { handleReset() }
                        }
                        .buttonStyle(GhostButtonStyle())
                    }
                    Button(primaryLabel) {
                        withAnimation(.snappy) { handlePrimary() }
                    }
                    .buttonStyle(SolidButtonStyle())
                    .disabled(timerModel.phase == .done)
                }
            }
            .padding(.vertical, 14)
            Rule(color: AppColors.rule(for: scheme))
        }
    }

    private var primaryLabel: String {
        switch timerModel.phase {
        case .ready: "Start brew"
        case .bloom, .pour, .drawdown: timerModel.isRunning ? "Pause" : "Resume"
        case .done: "Brew complete"
        }
    }

    private func handlePrimary() {
        if timerModel.phase == .ready {
            timerModel.configure(
                bloomWater: brewModel.bloomWater,
                remainingWater: brewModel.remainingWater,
                totalWater: brewModel.totalWater
            )
            timerModel.start()
        } else {
            timerModel.togglePause()
        }
    }

    private func handleReset() {
        timerModel.reset()
        timerModel.configure(
            bloomWater: brewModel.bloomWater,
            remainingWater: brewModel.remainingWater,
            totalWater: brewModel.totalWater
        )
    }
}

private struct SolidButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme

    func makeBody(configuration: Configuration) -> some View {
        let accent = AppColors.accent(for: scheme)
        let onAccent = AppColors.onAccent(for: scheme)

        configuration.label
            .font(AppTypography.serif(15, weight: .medium))
            .foregroundStyle(onAccent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Rectangle().fill(accent))
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}

private struct GhostButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme

    func makeBody(configuration: Configuration) -> some View {
        let ink = AppColors.ink(for: scheme)

        configuration.label
            .font(AppTypography.serif(15, weight: .medium))
            .foregroundStyle(ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .overlay(Rectangle().stroke(ink, lineWidth: 1))
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}

// MARK: - Steps section

private struct StepsSection: View {
    let brewModel: BrewModel
    let timerModel: BrewTimerModel
    @Binding var manuallyExpanded: Int?
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let steps = BrewStep.steps(for: brewModel)

        VStack(spacing: 0) {
            HStack {
                SectionHeader(number: "01\u{2013}08", kicker: "Tap a step")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(steps) { step in
                    StepRow(
                        step: step,
                        active: isActive(step: step),
                        onTap: { toggle(step: step) }
                    )
                }
            }
            .padding(.horizontal, 24)
        }
    }

    private func isActive(step: BrewStep) -> Bool {
        if let manuallyExpanded {
            return manuallyExpanded == step.id
        }
        guard brewModel.autoAdvanceSteps else { return false }
        return timerActiveStepId == step.id
    }

    /// The step id matching the timer's current phase, or nil for `.ready`.
    private var timerActiveStepId: Int? {
        switch timerModel.phase {
        case .ready: nil
        case .bloom: 4
        case .pour: 6
        case .drawdown: 7
        case .done: 8
        }
    }

    private func toggle(step: BrewStep) {
        let active = isActive(step: step)
        manuallyExpanded = active ? -1 : step.id
    }
}

private struct StepRow: View {
    let step: BrewStep
    let active: Bool
    let onTap: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        Button(action: onTap) {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Rectangle()
                        .fill(active ? accent : .clear)
                        .frame(width: 3)

                    HStack(alignment: .top, spacing: 14) {
                        Text(step.numberLabel)
                            .font(AppTypography.serif(36, weight: .regular))
                            .foregroundStyle(active ? accent : ink)
                            .kerning(-1.5)
                            .frame(width: 44, alignment: .leading)
                            .animation(.snappy, value: active)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 10) {
                                InkIconView(
                                    icon: step.icon, size: 18,
                                    color: active ? accent : ink, strokeWidth: 1.4
                                )
                                Text(step.title)
                                    .font(AppTypography.serif(18, weight: .medium))
                                    .foregroundStyle(ink)
                                    .kerning(-0.3)
                            }
                            Text(step.meta)
                                .font(AppTypography.micro)
                                .tracking(2)
                                .textCase(.uppercase)
                                .foregroundStyle(muted)
                                .padding(.bottom, 2)
                            Text(step.body)
                                .font(AppTypography.serif(14))
                                .foregroundStyle(ink)
                                .opacity(active ? 1 : 0.85)
                                .lineLimit(active ? nil : 1)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .animation(.snappy, value: active)
                        }

                        InkIconView(
                            icon: .chevron, size: 14,
                            color: muted, strokeWidth: 1.6
                        )
                        .rotationEffect(.degrees(active ? 90 : 0))
                        .padding(.top, 10)
                        .animation(.snappy, value: active)
                    }
                    .padding(.leading, 11)
                    .padding(.vertical, 14)
                    .padding(.trailing, 0)
                }
                .background(active ? AppColors.chip(for: scheme) : .clear)
                Rule(color: AppColors.rule(for: scheme))
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Outro

private struct OutroQuote: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 6) {
            Rule(color: AppColors.rule(for: scheme))
                .padding(.bottom, 16)
            Text("\u{201C}The pour is half the cup.\u{201D}")
                .font(AppTypography.serifItalic(14))
                .foregroundStyle(AppColors.muted(for: scheme))
            Text("\u{2014} attributed")
                .font(AppTypography.micro)
                .tracking(3)
                .textCase(.uppercase)
                .foregroundStyle(AppColors.muted(for: scheme))
        }
        .frame(maxWidth: .infinity)
    }
}
