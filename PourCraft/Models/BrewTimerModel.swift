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

    private let nowProvider: () -> Date
    private var timer: Timer?
    private var elapsedBeforeActiveRunSeconds = 0
    private var activeRunStartedAt: Date?

    init(nowProvider: @escaping () -> Date = Date.init) {
        self.nowProvider = nowProvider
    }

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
        _elapsedSeconds = 0
        elapsedBeforeActiveRunSeconds = 0
        activeRunStartedAt = nowProvider()
        _phase = .bloom
        _isRunning = true
        startTimer()
    }

    func togglePause() {
        guard phase != .ready, phase != .done else { return }
        if _isRunning {
            syncToNow()
            _isRunning = false
            elapsedBeforeActiveRunSeconds = _elapsedSeconds
            activeRunStartedAt = nil
            stopTimer()
        } else {
            elapsedBeforeActiveRunSeconds = _elapsedSeconds
            activeRunStartedAt = nowProvider()
            _isRunning = true
            startTimer()
        }
    }

    func reset() {
        stopTimer()
        _elapsedSeconds = 0
        _phase = .ready
        _isRunning = false
        elapsedBeforeActiveRunSeconds = 0
        activeRunStartedAt = nil
    }

    /// Advances the timer by one second. Public for deterministic testing.
    func tick() {
        advanceElapsed(to: elapsedSeconds + 1, rebaseline: true)
    }

    /// Reconciles elapsed time against the wall clock.
    func syncToNow() {
        guard isRunning, let activeRunStartedAt else { return }

        let elapsedSinceResume = max(0, Int(nowProvider().timeIntervalSince(activeRunStartedAt)))
        advanceElapsed(to: elapsedBeforeActiveRunSeconds + elapsedSinceResume, rebaseline: false)
    }

    // MARK: - Private

    private func advanceElapsed(to newValue: Int, rebaseline: Bool) {
        _elapsedSeconds = min(Self.targetBrewSeconds, max(0, newValue))

        if rebaseline, isRunning {
            elapsedBeforeActiveRunSeconds = _elapsedSeconds
            activeRunStartedAt = nowProvider()
        }

        updatePhase()

        if !isRunning {
            elapsedBeforeActiveRunSeconds = _elapsedSeconds
            activeRunStartedAt = nil
        }
    }

    private func updatePhase() {
        guard phase != .ready else { return }

        if elapsedSeconds >= Self.targetBrewSeconds {
            _phase = .done
            _isRunning = false
            stopTimer()
        } else if elapsedSeconds >= pourEndSeconds {
            _phase = .drawdown
        } else if elapsedSeconds >= Self.bloomDurationSeconds {
            _phase = .pour
        } else {
            _phase = .bloom
        }
    }

    private func startTimer() {
        stopTimer()

        let timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.syncToNow()
        }
        timer.tolerance = 0.1
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
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
