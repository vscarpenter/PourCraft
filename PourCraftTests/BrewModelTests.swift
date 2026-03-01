import Testing
@testable import PourCraft

@Suite("BrewModel")
struct BrewModelTests {

    // MARK: - Default State

    @Test("Should default to medium roast, 20g, fahrenheit")
    func shouldDefaultToExpectedState() {
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

    @Test("Should match dark roast spec reference table",
          arguments: [(15.0, 225.0), (20.0, 300.0), (25.0, 375.0), (30.0, 450.0)])
    func shouldCalculateDarkRoastWater(coffeeWeight: Double, expectedWater: Double) {
        let model = BrewModel()
        model.selectedRoast = .dark
        model.coffeeWeight = coffeeWeight
        #expect(model.totalWater == expectedWater)
    }

    @Test("Should match medium roast spec reference table",
          arguments: [(15.0, 240.0), (20.0, 320.0), (25.0, 400.0), (30.0, 480.0)])
    func shouldCalculateMediumRoastWater(coffeeWeight: Double, expectedWater: Double) {
        let model = BrewModel()
        model.selectedRoast = .medium
        model.coffeeWeight = coffeeWeight
        #expect(model.totalWater == expectedWater)
    }

    @Test("Should match light roast spec reference table",
          arguments: [(15.0, 255.0), (20.0, 340.0), (25.0, 425.0), (30.0, 510.0)])
    func shouldCalculateLightRoastWater(coffeeWeight: Double, expectedWater: Double) {
        let model = BrewModel()
        model.selectedRoast = .light
        model.coffeeWeight = coffeeWeight
        #expect(model.totalWater == expectedWater)
    }

    // MARK: - Bloom Water

    @Test("Should calculate bloom water as 2x coffee weight")
    func shouldCalculateBloomWater() {
        let model = BrewModel()
        model.coffeeWeight = 20
        #expect(model.bloomWater == 40)

        model.coffeeWeight = 30
        #expect(model.bloomWater == 60)
    }

    @Test("Should calculate remaining water as total minus bloom")
    func shouldCalculateRemainingWater() {
        let model = BrewModel()
        model.selectedRoast = .medium
        model.coffeeWeight = 20
        // Total: 320, Bloom: 40, Remaining: 280
        #expect(model.remainingWater == 280)
    }

    // MARK: - Weight Clamping

    @Test("Should clamp weight below minimum to 10g")
    func shouldClampToMinimum() {
        let model = BrewModel()
        model.coffeeWeight = 5
        #expect(model.coffeeWeight == 10)
    }

    @Test("Should clamp weight above maximum to 60g")
    func shouldClampToMaximum() {
        let model = BrewModel()
        model.coffeeWeight = 100
        #expect(model.coffeeWeight == 60)
    }

    @Test("Should accept valid weight without clamping")
    func shouldAcceptValidWeight() {
        let model = BrewModel()
        model.coffeeWeight = 35
        #expect(model.coffeeWeight == 35)
    }

    @Test("Should clamp zero to minimum of 10g")
    func shouldClampZeroToMinimum() {
        let model = BrewModel()
        model.coffeeWeight = 0
        #expect(model.coffeeWeight == 10)
    }

    @Test("Should clamp negative values to minimum of 10g")
    func shouldClampNegativeToMinimum() {
        let model = BrewModel()
        model.coffeeWeight = -20
        #expect(model.coffeeWeight == 10)
    }

    @Test("Should accept boundary value of exactly 10g")
    func shouldAcceptExactMinimum() {
        let model = BrewModel()
        model.coffeeWeight = 10
        #expect(model.coffeeWeight == 10)
    }

    @Test("Should accept boundary value of exactly 60g")
    func shouldAcceptExactMaximum() {
        let model = BrewModel()
        model.coffeeWeight = 60
        #expect(model.coffeeWeight == 60)
    }

    // MARK: - Temperature Display

    @Test("Should display fahrenheit temperature range")
    func shouldDisplayFahrenheitRange() {
        let model = BrewModel()
        model.temperatureUnit = .fahrenheit
        #expect(model.temperatureRange.contains("194"))
        #expect(model.temperatureRange.contains("204"))
        #expect(model.temperatureRange.contains("F"))
    }

    @Test("Should display celsius temperature range")
    func shouldDisplayCelsiusRange() {
        let model = BrewModel()
        model.temperatureUnit = .celsius
        #expect(model.temperatureRange.contains("90"))
        #expect(model.temperatureRange.contains("96"))
        #expect(model.temperatureRange.contains("C"))
    }

    // MARK: - Brew Steps

    @Test("Should contain exactly 8 brew steps")
    func shouldContainEightBrewSteps() {
        let model = BrewModel()
        #expect(model.brewSteps.count == 8)
    }

    @Test("Should include dynamic weight values in brew steps")
    func shouldIncludeDynamicWeightsInSteps() {
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

    @Test("Should format whole numbers without decimals")
    func shouldFormatWholeNumbers() {
        let model = BrewModel()
        #expect(model.formattedWeight(320) == "320")
        #expect(model.formattedWeight(20) == "20")
    }

    @Test("Should format fractional numbers with one decimal")
    func shouldFormatFractionalNumbers() {
        let model = BrewModel()
        #expect(model.formattedWeight(320.5) == "320.5")
    }

    @Test("Should format zero as whole number")
    func shouldFormatZero() {
        let model = BrewModel()
        #expect(model.formattedWeight(0) == "0")
    }

    @Test("Should format negative values without crashing")
    func shouldFormatNegativeValues() {
        let model = BrewModel()
        let result = model.formattedWeight(-5)
        #expect(result == "-5")
    }

    @Test("Should format small fractional value with one decimal")
    func shouldFormatSmallFraction() {
        let model = BrewModel()
        #expect(model.formattedWeight(0.5) == "0.5")
    }

    @Test("Should format large values correctly")
    func shouldFormatLargeValues() {
        let model = BrewModel()
        #expect(model.formattedWeight(1000) == "1000")
        #expect(model.formattedWeight(999.9) == "999.9")
    }

    // MARK: - Preference Restoration

    @Test("Should restore valid roast from saved string")
    func shouldRestoreValidRoast() {
        let model = BrewModel()
        model.restorePreferences(savedRoast: "dark", savedTempUnit: "fahrenheit")
        #expect(model.selectedRoast == .dark)
    }

    @Test("Should restore valid temperature unit from saved string")
    func shouldRestoreValidTempUnit() {
        let model = BrewModel()
        model.restorePreferences(savedRoast: "medium", savedTempUnit: "celsius")
        #expect(model.temperatureUnit == .celsius)
    }

    @Test("Should ignore invalid roast string and keep default")
    func shouldIgnoreInvalidRoast() {
        let model = BrewModel()
        let originalRoast = model.selectedRoast
        model.restorePreferences(savedRoast: "extra-dark", savedTempUnit: "fahrenheit")
        #expect(model.selectedRoast == originalRoast)
    }

    @Test("Should ignore invalid temperature unit and keep default")
    func shouldIgnoreInvalidTempUnit() {
        let model = BrewModel()
        let originalUnit = model.temperatureUnit
        model.restorePreferences(savedRoast: "medium", savedTempUnit: "kelvin")
        #expect(model.temperatureUnit == originalUnit)
    }

    @Test("Should ignore empty strings and keep defaults")
    func shouldIgnoreEmptyStrings() {
        let model = BrewModel()
        model.restorePreferences(savedRoast: "", savedTempUnit: "")
        #expect(model.selectedRoast == .medium)
        #expect(model.temperatureUnit == .fahrenheit)
    }

    @Test("Should restore both preferences simultaneously")
    func shouldRestoreBothPreferences() {
        let model = BrewModel()
        model.restorePreferences(savedRoast: "light", savedTempUnit: "celsius")
        #expect(model.selectedRoast == .light)
        #expect(model.temperatureUnit == .celsius)
    }
}
