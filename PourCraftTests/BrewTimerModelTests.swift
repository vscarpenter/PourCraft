import Testing
@testable import PourCraft

@Suite("BrewTimerModel")
struct BrewTimerModelTests {
    // MARK: - Default State

    @Test("Should default to ready phase")
    func shouldDefaultToReadyPhase() {
        let model = BrewTimerModel()
        #expect(model.phase == .ready)
    }

    @Test("Should default to not running")
    func shouldDefaultToNotRunning() {
        let model = BrewTimerModel()
        #expect(!model.isRunning)
    }

    @Test("Should default to zero elapsed seconds")
    func shouldDefaultToZeroElapsed() {
        let model = BrewTimerModel()
        #expect(model.elapsedSeconds == 0)
    }

    // MARK: - Configuration

    @Test("Should store configured water amounts")
    func shouldStoreConfiguredAmounts() {
        let model = BrewTimerModel()
        model.configure(bloomWater: 50, remainingWater: 350, totalWater: 400)
        #expect(model.bloomWaterAmount == 50)
        #expect(model.remainingWaterAmount == 350)
        #expect(model.totalWaterAmount == 400)
    }

    // MARK: - Start

    @Test("Should transition to bloom phase on start")
    func shouldTransitionToBloomOnStart() {
        let model = BrewTimerModel()
        model.start()
        #expect(model.phase == .bloom)
    }

    @Test("Should set isRunning to true on start")
    func shouldBeRunningAfterStart() {
        let model = BrewTimerModel()
        model.start()
        #expect(model.isRunning)
    }

    @Test("Should not start if not in ready phase")
    func shouldNotStartIfNotReady() {
        let model = BrewTimerModel()
        model.start()
        #expect(model.phase == .bloom)
        // Try starting again — should stay in bloom
        model.start()
        #expect(model.phase == .bloom)
    }

    // MARK: - Phase Transitions

    @Test("Should remain in bloom before 30 seconds")
    func shouldRemainInBloomBefore30() {
        let model = BrewTimerModel()
        model.start()
        for _ in 0..<29 {
            model.tick()
        }
        #expect(model.phase == .bloom)
        #expect(model.elapsedSeconds == 29)
    }

    @Test("Should transition from bloom to pour at 30 seconds")
    func shouldTransitionToBloomAtThirty() {
        let model = BrewTimerModel()
        model.start()
        for _ in 0..<30 {
            model.tick()
        }
        #expect(model.phase == .pour)
    }

    @Test("Should transition from pour to drawdown at pour end time")
    func shouldTransitionToDrawdown() {
        let model = BrewTimerModel()
        model.start()
        let pourEnd = model.pourEndSeconds
        for _ in 0..<pourEnd {
            model.tick()
        }
        #expect(model.phase == .drawdown)
    }

    @Test("Should transition from drawdown to done at target time")
    func shouldTransitionToDone() {
        let model = BrewTimerModel()
        model.start()
        for _ in 0..<BrewTimerModel.targetBrewSeconds {
            model.tick()
        }
        #expect(model.phase == .done)
    }

    @Test("Should stop running when done")
    func shouldStopRunningWhenDone() {
        let model = BrewTimerModel()
        model.start()
        for _ in 0..<BrewTimerModel.targetBrewSeconds {
            model.tick()
        }
        #expect(!model.isRunning)
    }

    // MARK: - Pause / Resume

    @Test("Should pause when running")
    func shouldPauseWhenRunning() {
        let model = BrewTimerModel()
        model.start()
        model.togglePause()
        #expect(!model.isRunning)
    }

    @Test("Should resume when paused")
    func shouldResumeWhenPaused() {
        let model = BrewTimerModel()
        model.start()
        model.togglePause()
        model.togglePause()
        #expect(model.isRunning)
    }

    @Test("Should not toggle pause in ready phase")
    func shouldNotTogglePauseInReady() {
        let model = BrewTimerModel()
        model.togglePause()
        #expect(!model.isRunning)
    }

    @Test("Should not toggle pause in done phase")
    func shouldNotTogglePauseInDone() {
        let model = BrewTimerModel()
        model.start()
        for _ in 0..<BrewTimerModel.targetBrewSeconds {
            model.tick()
        }
        #expect(model.phase == .done)
        model.togglePause()
        #expect(!model.isRunning)
    }

    // MARK: - Reset

    @Test("Should reset to ready phase")
    func shouldResetToReady() {
        let model = BrewTimerModel()
        model.start()
        for _ in 0..<10 { model.tick() }
        model.reset()
        #expect(model.phase == .ready)
    }

    @Test("Should reset elapsed seconds to zero")
    func shouldResetElapsedToZero() {
        let model = BrewTimerModel()
        model.start()
        for _ in 0..<10 { model.tick() }
        model.reset()
        #expect(model.elapsedSeconds == 0)
    }

    @Test("Should stop running on reset")
    func shouldStopRunningOnReset() {
        let model = BrewTimerModel()
        model.start()
        model.reset()
        #expect(!model.isRunning)
    }

    // MARK: - Computed Properties

    @Test("Should format elapsed time as M:SS")
    func shouldFormatTime() {
        let model = BrewTimerModel()
        #expect(model.formatTime(0) == "0:00")
        #expect(model.formatTime(30) == "0:30")
        #expect(model.formatTime(90) == "1:30")
        #expect(model.formatTime(210) == "3:30")
        #expect(model.formatTime(65) == "1:05")
    }

    @Test("Should calculate bloom countdown remaining")
    func shouldCalculateBloomCountdown() {
        let model = BrewTimerModel()
        model.start()
        #expect(model.bloomCountdownRemaining == 30)
        for _ in 0..<10 { model.tick() }
        #expect(model.bloomCountdownRemaining == 20)
        for _ in 0..<25 { model.tick() }
        #expect(model.bloomCountdownRemaining == 0)
    }

    @Test("Should calculate progress as fraction of target time")
    func shouldCalculateProgress() {
        let model = BrewTimerModel()
        #expect(model.progress == 0.0)
        model.start()
        for _ in 0..<105 { model.tick() }
        #expect(model.progress == 0.5)
    }

    @Test("Should cap progress at 1.0")
    func shouldCapProgressAtOne() {
        let model = BrewTimerModel()
        model.start()
        // Tick past target time
        for _ in 0..<250 { model.tick() }
        #expect(model.progress == 1.0)
    }

    @Test("Should return correct phase instruction for each phase",
          arguments: BrewPhase.allCases)
    func shouldReturnPhaseInstruction(phase: BrewPhase) {
        let model = BrewTimerModel()

        // Drive to the target phase
        switch phase {
        case .ready:
            break
        case .bloom:
            model.start()
        case .pour:
            model.start()
            for _ in 0..<BrewTimerModel.bloomDurationSeconds { model.tick() }
        case .drawdown:
            model.start()
            for _ in 0..<model.pourEndSeconds { model.tick() }
        case .done:
            model.start()
            for _ in 0..<BrewTimerModel.targetBrewSeconds { model.tick() }
        }

        #expect(model.phase == phase)
        #expect(!model.phaseInstruction.isEmpty)
    }

    // MARK: - Tick

    @Test("Should increment elapsed seconds on tick")
    func shouldIncrementOnTick() {
        let model = BrewTimerModel()
        model.start()
        model.tick()
        #expect(model.elapsedSeconds == 1)
        model.tick()
        #expect(model.elapsedSeconds == 2)
    }

    // MARK: - Pour End Seconds

    @Test("Should calculate pour end seconds as bloom + 60% of remaining time")
    func shouldCalculatePourEndSeconds() {
        let model = BrewTimerModel()
        let postBloom = BrewTimerModel.targetBrewSeconds - BrewTimerModel.bloomDurationSeconds
        let expected = BrewTimerModel.bloomDurationSeconds + Int(Double(postBloom) * 0.6)
        #expect(model.pourEndSeconds == expected)
    }
}
