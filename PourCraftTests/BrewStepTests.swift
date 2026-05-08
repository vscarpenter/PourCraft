import Testing
@testable import PourCraft

@Suite("BrewStep")
struct BrewStepTests {

    @Test("Should produce exactly 8 steps")
    func shouldProduceEightSteps() {
        let model = BrewModel()
        #expect(BrewStep.steps(for: model).count == 8)
    }

    @Test("Should number steps sequentially 1 through 8")
    func shouldNumberSequentially() {
        let model = BrewModel()
        let ids = BrewStep.steps(for: model).map(\.id)
        #expect(ids == Array(1...8))
    }

    @Test("Should embed coffee weight in step 3 meta and body")
    func shouldEmbedCoffeeWeight() {
        let model = BrewModel()
        model.coffeeWeight = 25
        let steps = BrewStep.steps(for: model)
        #expect(steps[2].meta.contains("25g"))
        #expect(String(steps[2].body.characters).contains("25g"))
    }

    @Test("Should embed bloom and remaining water in pour-related steps")
    func shouldEmbedPourWeights() {
        let model = BrewModel()
        model.selectedRoast = .medium
        model.coffeeWeight = 20
        // Total 320, Bloom 40, Remaining 280
        let steps = BrewStep.steps(for: model)
        #expect(steps[3].meta.contains("40g"))   // Bloom
        #expect(steps[5].meta.contains("280g"))  // Spiral pour
    }

    @Test("Should map step ids 4–8 to the corresponding timer phases")
    func shouldMapToTimerPhases() {
        let model = BrewModel()
        let steps = BrewStep.steps(for: model)
        #expect(steps[3].phase == .bloom)     // step 4
        #expect(steps[5].phase == .pour)      // step 6
        #expect(steps[6].phase == .drawdown)  // step 7
        #expect(steps[7].phase == .done)      // step 8
    }

    @Test("Should leave setup steps (1–3) without a timer phase")
    func shouldLeaveSetupStepsPhaseless() {
        let model = BrewModel()
        let steps = BrewStep.steps(for: model)
        #expect(steps[0].phase == nil)
        #expect(steps[1].phase == nil)
        #expect(steps[2].phase == nil)
    }

    @Test("Should format step numbers as zero-padded two-digit strings")
    func shouldFormatNumberLabels() {
        let model = BrewModel()
        let steps = BrewStep.steps(for: model)
        #expect(steps[0].numberLabel == "01")
        #expect(steps[7].numberLabel == "08")
    }
}
