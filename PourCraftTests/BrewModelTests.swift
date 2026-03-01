import Testing
@testable import PourCraft

@Suite("BrewModel")
struct BrewModelTests {

    // MARK: - Default State

    @Test("Default state uses medium roast, 20g, fahrenheit")
    func defaultState() {
        let model = BrewModel()
        #expect(model.selectedRoast == .medium)
        #expect(model.coffeeWeight == 20)
        #expect(model.temperatureUnit == .fahrenheit)
    }

    // MARK: - Reference Table (from spec)
    // | Roast  | Ratio | 15g  | 20g  | 25g  | 30g  |
    // | Dark   | 1:15  | 225g | 300g | 375g | 450g |
    // | Medium | 1:16  | 240g | 320g | 400g | 480g |
    // | Light  | 1:17  | 255g | 340g | 425g | 510g |

    @Test("Dark roast water calculations match spec reference table",
          arguments: [(15.0, 225.0), (20.0, 300.0), (25.0, 375.0), (30.0, 450.0)])
    func darkRoastWater(coffeeWeight: Double, expectedWater: Double) {
        let model = BrewModel()
        model.selectedRoast = .dark
        model.coffeeWeight = coffeeWeight
        #expect(model.totalWater == expectedWater)
    }

    @Test("Medium roast water calculations match spec reference table",
          arguments: [(15.0, 240.0), (20.0, 320.0), (25.0, 400.0), (30.0, 480.0)])
    func mediumRoastWater(coffeeWeight: Double, expectedWater: Double) {
        let model = BrewModel()
        model.selectedRoast = .medium
        model.coffeeWeight = coffeeWeight
        #expect(model.totalWater == expectedWater)
    }

    @Test("Light roast water calculations match spec reference table",
          arguments: [(15.0, 255.0), (20.0, 340.0), (25.0, 425.0), (30.0, 510.0)])
    func lightRoastWater(coffeeWeight: Double, expectedWater: Double) {
        let model = BrewModel()
        model.selectedRoast = .light
        model.coffeeWeight = coffeeWeight
        #expect(model.totalWater == expectedWater)
    }

    // MARK: - Bloom Water

    @Test("Bloom water is always 2x coffee weight")
    func bloomWater() {
        let model = BrewModel()
        model.coffeeWeight = 20
        #expect(model.bloomWater == 40)

        model.coffeeWeight = 30
        #expect(model.bloomWater == 60)
    }

    @Test("Remaining water equals total minus bloom")
    func remainingWater() {
        let model = BrewModel()
        model.selectedRoast = .medium
        model.coffeeWeight = 20
        // Total: 320, Bloom: 40, Remaining: 280
        #expect(model.remainingWater == 280)
    }

    // MARK: - Weight Clamping

    @Test("Coffee weight clamps to minimum of 10g")
    func clampsToMinimum() {
        let model = BrewModel()
        model.coffeeWeight = 5
        #expect(model.coffeeWeight == 10)
    }

    @Test("Coffee weight clamps to maximum of 60g")
    func clampsToMaximum() {
        let model = BrewModel()
        model.coffeeWeight = 100
        #expect(model.coffeeWeight == 60)
    }

    @Test("Coffee weight accepts valid values without clamping")
    func validWeightUnchanged() {
        let model = BrewModel()
        model.coffeeWeight = 35
        #expect(model.coffeeWeight == 35)
    }

    // MARK: - Temperature Display

    @Test("Temperature range displays correctly for fahrenheit")
    func fahrenheitRange() {
        let model = BrewModel()
        model.temperatureUnit = .fahrenheit
        #expect(model.temperatureRange.contains("194"))
        #expect(model.temperatureRange.contains("204"))
        #expect(model.temperatureRange.contains("F"))
    }

    @Test("Temperature range displays correctly for celsius")
    func celsiusRange() {
        let model = BrewModel()
        model.temperatureUnit = .celsius
        #expect(model.temperatureRange.contains("90"))
        #expect(model.temperatureRange.contains("96"))
        #expect(model.temperatureRange.contains("C"))
    }

    // MARK: - Brew Steps

    @Test("Brew steps contain 8 steps")
    func brewStepCount() {
        let model = BrewModel()
        #expect(model.brewSteps.count == 8)
    }

    @Test("Brew steps include dynamic weight values")
    func brewStepsDynamicValues() {
        let model = BrewModel()
        model.coffeeWeight = 25
        model.selectedRoast = .medium
        // Total: 400g, Bloom: 50g, Remaining: 350g
        let steps = model.brewSteps
        #expect(steps[2].contains("25g"))   // coffee weight
        #expect(steps[3].contains("50g"))   // bloom water
        #expect(steps[5].contains("350g"))  // remaining water
    }

    // MARK: - Weight Formatting

    @Test("Whole numbers format without decimals")
    func wholeNumberFormatting() {
        let model = BrewModel()
        #expect(model.formattedWeight(320) == "320")
        #expect(model.formattedWeight(20) == "20")
    }

    @Test("Fractional numbers format with one decimal")
    func fractionalFormatting() {
        let model = BrewModel()
        #expect(model.formattedWeight(320.5) == "320.5")
    }
}
