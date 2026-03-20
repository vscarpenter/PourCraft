import Foundation
import Observation
import SwiftUI

// MARK: - BrewPhase

enum BrewPhase: String, CaseIterable {
    case ready
    case bloom
    case pour
    case drawdown
    case done

    var displayName: String {
        switch self {
        case .ready: "Ready"
        case .bloom: "Bloom"
        case .pour: "Pour"
        case .drawdown: "Drawdown"
        case .done: "Done"
        }
    }

    /// Ring color for each phase, adapting to color scheme.
    func ringColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .ready: AppColors.secondaryText(for: colorScheme)
        case .bloom: AppColors.bloomOrange
        case .pour: AppColors.accent(for: colorScheme)
        case .drawdown: AppColors.sageBrew
        case .done: AppColors.sageBrew
        }
    }
}

// MARK: - BrewTimerModel

@Observable
final class BrewTimerModel {
    // MARK: - Constants

    static let bloomDurationSeconds = 30
    static let targetBrewSeconds = 210 // 3:30

    // MARK: - Configuration (set from BrewModel before starting)

    private var _bloomWaterAmount: Double = 40
    private var _remainingWaterAmount: Double = 280
    private var _totalWaterAmount: Double = 320

    var bloomWaterAmount: Double { _bloomWaterAmount }
    var remainingWaterAmount: Double { _remainingWaterAmount }
    var totalWaterAmount: Double { _totalWaterAmount }

    // MARK: - Timer State (private backing stores for @Observable safety)

    private var _phase: BrewPhase = .ready
    var phase: BrewPhase { _phase }

    private var _elapsedSeconds: Int = 0
    var elapsedSeconds: Int { _elapsedSeconds }

    private var _isRunning: Bool = false
    var isRunning: Bool { _isRunning }

    private var timer: Timer?

    // MARK: - Computed Properties

    var bloomCountdownRemaining: Int {
        max(0, Self.bloomDurationSeconds - elapsedSeconds)
    }

    /// Seconds at which the pour phase ends and drawdown begins.
    /// Pour gets ~60% of the post-bloom time.
    var pourEndSeconds: Int {
        let pourDuration = Int(Double(Self.targetBrewSeconds - Self.bloomDurationSeconds) * 0.6)
        return Self.bloomDurationSeconds + pourDuration
    }

    var progress: Double {
        guard Self.targetBrewSeconds > 0 else { return 0 }
        return min(1.0, Double(elapsedSeconds) / Double(Self.targetBrewSeconds))
    }

    var totalElapsedFormatted: String {
        formatTime(elapsedSeconds)
    }

    var targetTimeFormatted: String {
        formatTime(Self.targetBrewSeconds)
    }

    var phaseInstruction: String {
        switch phase {
        case .ready:
            "Tap Start when ready to brew"
        case .bloom:
            "Pour \(formattedWeight(bloomWaterAmount))g over grounds, then wait"
        case .pour:
            "Slowly pour \(formattedWeight(remainingWaterAmount))g in a spiral"
        case .drawdown:
            "Wait for water to drain through"
        case .done:
            "Your brew is ready!"
        }
    }

    // MARK: - Actions

    func configure(bloomWater: Double, remainingWater: Double, totalWater: Double) {
        _bloomWaterAmount = bloomWater
        _remainingWaterAmount = remainingWater
        _totalWaterAmount = totalWater
    }

    func start() {
        guard phase == .ready else { return }
        _phase = .bloom
        _isRunning = true
        startTimer()
    }

    func togglePause() {
        guard phase != .ready, phase != .done else { return }
        _isRunning.toggle()
        if _isRunning {
            startTimer()
        } else {
            stopTimer()
        }
    }

    func reset() {
        stopTimer()
        _elapsedSeconds = 0
        _phase = .ready
        _isRunning = false
    }

    /// Advances the timer by one second. Public for deterministic testing.
    func tick() {
        _elapsedSeconds += 1
        updatePhase()
    }

    // MARK: - Private

    private func updatePhase() {
        switch phase {
        case .bloom:
            if elapsedSeconds >= Self.bloomDurationSeconds {
                _phase = .pour
            }
        case .pour:
            if elapsedSeconds >= pourEndSeconds {
                _phase = .drawdown
            }
        case .drawdown:
            if elapsedSeconds >= Self.targetBrewSeconds {
                _phase = .done
                _isRunning = false
                stopTimer()
            }
        default:
            break
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func formattedWeight(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", value)
            : String(format: "%.1f", value)
    }
}
