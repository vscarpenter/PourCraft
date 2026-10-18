import Foundation
import Testing
@testable import PourCraft

@Suite("Water-first mode")
struct WaterFirstModeTests {

    // MARK: - Inverse reference table
    // Dose = water ÷ ratio, rounded to 0.1 g.
    // | Roast  | Ratio | 300g | 450g | 600g | 900g |
    // | Dark   | 1:15  | 20   | 30   | 40   | 60   |
    // | Medium | 1:16  | 18.8 | 28.1 | 37.5 | 56.3 |
    // | Light  | 1:17  | 17.6 | 26.5 | 35.3 | 52.9 |

    @Test("Should derive the dark roast dose from water",
          arguments: [(300.0, 20.0), (450.0, 30.0), (600.0, 40.0), (900.0, 60.0)])
    func shouldDeriveDarkRoastDose(water: Double, expectedDose: Double) {
        #expect(waterFirst(.dark, water: water).coffeeWeight == expectedDose)
    }

    @Test("Should derive the medium roast dose from water",
          arguments: [(300.0, 18.8), (450.0, 28.1), (600.0, 37.5), (900.0, 56.3)])
    func shouldDeriveMediumRoastDose(water: Double, expectedDose: Double) {
        #expect(waterFirst(.medium, water: water).coffeeWeight == expectedDose)
    }

    @Test("Should derive the light roast dose from water",
          arguments: [(300.0, 17.6), (450.0, 26.5), (600.0, 35.3), (900.0, 52.9)])
    func shouldDeriveLightRoastDose(water: Double, expectedDose: Double) {
        #expect(waterFirst(.light, water: water).coffeeWeight == expectedDose)
    }

    @Test("Should use the water target as total water")
    func shouldUseWaterTargetAsTotalWater() {
        #expect(waterFirst(.medium, water: 600).totalWater == 600)
    }

    @Test("Should split the water so bloom and remaining add up to the total")
    func shouldSplitWaterIntoWholeGramPours() {
        let model = waterFirst(.light, water: 600)
        #expect(model.bloomWater == 71)  // 2 × 35.3 g, rounded
        #expect(model.remainingWater == 529)
        #expect(model.bloomWater + model.remainingWater == model.totalWater)
    }

    @Test("Should keep the water fixed and update the dose when the roast changes")
    func shouldKeepWaterFixedAcrossRoastChanges() {
        let model = waterFirst(.medium, water: 600)
        model.selectedRoast = .dark
        #expect(model.totalWater == 600)
        #expect(model.coffeeWeight == 40)
    }

    // MARK: - Water range

    @Test("Should clamp water to 200–900 g")
    func shouldClampWaterTarget() {
        let model = BrewModel()
        model.waterTarget = 50
        #expect(model.waterTarget == 200)
        model.waterTarget = 5_000
        #expect(model.waterTarget == 900)
    }

    @Test("Should keep water on the 10 g grid")
    func shouldSnapWaterToTenGramSteps() {
        let model = BrewModel()
        model.waterTarget = 604
        #expect(model.waterTarget == 600)
        model.waterTarget = 606
        #expect(model.waterTarget == 610)
    }

    @Test("Should keep every derived dose inside the 10–60 g coffee range",
          arguments: Roast.allCases)
    func shouldKeepDerivedDoseInsideCoffeeRange(roast: Roast) {
        for water in [BrewModel.waterRange.lowerBound, BrewModel.waterRange.upperBound] {
            let dose = waterFirst(roast, water: water).coffeeWeight
            #expect(BrewModel.coffeeWeightRange.contains(dose))
        }
    }

    // MARK: - Switching modes

    @Test("Should start water mode at the water the current dose calls for")
    func shouldSeedWaterFromCurrentTotal() {
        let model = BrewModel()  // 20 g of medium calls for 320 g
        model.anchor = .water
        #expect(model.waterTarget == 320)
        #expect(model.coffeeWeight == 20)
    }

    @Test("Should round seeded water to the nearest 10 g")
    func shouldSnapSeededWater() {
        let model = BrewModel()
        model.coffeeWeight = 21  // 336 g at 1:16
        model.anchor = .water
        #expect(model.waterTarget == 340)
    }

    @Test("Should clamp seeded water when the dose calls for more than 900 g")
    func shouldClampSeededWater() {
        let model = BrewModel()
        model.selectedRoast = .light
        model.coffeeWeight = 60  // 1,020 g at 1:17
        model.anchor = .water
        #expect(model.waterTarget == 900)
    }

    @Test("Should return to coffee mode at the derived dose rounded to a whole gram")
    func shouldSeedDoseWhenSwitchingBack() {
        let model = waterFirst(.medium, water: 600)  // 37.5 g
        model.anchor = .coffee
        #expect(model.coffeeWeight == 38)
        #expect(model.totalWater == 608)
    }

    @Test("Should return to the same dose after a round trip through water mode")
    func shouldRoundTripBetweenModes() {
        let model = BrewModel()
        model.selectedRoast = .light
        model.coffeeWeight = 23  // 391 g, seeded as 390 g
        model.anchor = .water
        model.anchor = .coffee
        #expect(model.coffeeWeight == 23)
    }

    // MARK: - Morning preset

    @Test("Should capture mode, roast, and water for a water-first preset")
    func shouldCaptureWaterFirstPreset() {
        let model = waterFirst(.light, water: 600)
        #expect(model.currentPreset == BrewPreset(roast: .light, anchor: .water, amount: 600))
    }

    @Test("Should capture the dose for a coffee-first preset")
    func shouldCaptureCoffeeFirstPreset() {
        let model = BrewModel()
        model.coffeeWeight = 25
        #expect(model.currentPreset == BrewPreset(roast: .medium, anchor: .coffee, amount: 25))
    }

    @Test("Should restore a water-first morning preset")
    func shouldRestoreWaterFirstPreset() {
        let model = BrewModel()
        model.restorePreferences(
            savedRoast: "medium",
            savedTempUnit: "fahrenheit",
            savedPresetRoast: "light",
            savedPresetAnchor: "water",
            savedPresetWater: 600
        )
        #expect(model.anchor == .water)
        #expect(model.selectedRoast == .light)
        #expect(model.waterTarget == 600)
        #expect(model.coffeeWeight == 35.3)
    }

    @Test("Should load a preset saved before water mode as coffee-first")
    func shouldLoadLegacyPresetAsCoffeeFirst() {
        let model = BrewModel()
        model.restorePreferences(
            savedRoast: "medium",
            savedTempUnit: "fahrenheit",
            savedAnchor: "water",
            savedPresetRoast: "dark",
            savedPresetWeight: 25
        )
        #expect(model.anchor == .coffee)
        #expect(model.selectedRoast == .dark)
        #expect(model.coffeeWeight == 25)
    }

    @Test("Should restore the last-used mode when no preset is saved")
    func shouldRestoreLastUsedMode() {
        let model = BrewModel()
        model.restorePreferences(savedRoast: "medium", savedTempUnit: "fahrenheit", savedAnchor: "water")
        #expect(model.anchor == .water)
        #expect(model.waterTarget == 320)
    }

    @Test("Should ignore an unrecognized saved mode")
    func shouldIgnoreInvalidSavedMode() {
        let model = BrewModel()
        model.restorePreferences(savedRoast: "medium", savedTempUnit: "fahrenheit", savedAnchor: "tea")
        #expect(model.anchor == .coffee)
    }

    @Test("Should rebuild a saved preset from its stored values")
    func shouldRebuildStoredPreset() {
        #expect(
            BrewPreset(storedRoast: "light", storedAnchor: "water", coffeeGrams: 0, waterGrams: 600)
                == BrewPreset(roast: .light, anchor: .water, amount: 600)
        )
        #expect(
            BrewPreset(storedRoast: "dark", storedAnchor: "", coffeeGrams: 18, waterGrams: 0)
                == BrewPreset(roast: .dark, anchor: .coffee, amount: 18)
        )
        #expect(BrewPreset(storedRoast: "", storedAnchor: "", coffeeGrams: 0, waterGrams: 0) == nil)
    }

    @Test("Should match presets only when mode, roast, and amount agree")
    func shouldMatchPresetsOnModeRoastAndAmount() {
        let preset = BrewPreset(roast: .light, anchor: .water, amount: 600)
        #expect(preset.matches(BrewPreset(roast: .light, anchor: .water, amount: 600)))
        #expect(!preset.matches(BrewPreset(roast: .light, anchor: .coffee, amount: 600)))
        #expect(!preset.matches(BrewPreset(roast: .dark, anchor: .water, amount: 600)))
        #expect(!preset.matches(BrewPreset(roast: .light, anchor: .water, amount: 610)))
    }

    @Test("Should tell apart doses a few tenths of a gram apart")
    func shouldDistinguishNearbyFractionalDoses() {
        let preset = BrewPreset(roast: .medium, anchor: .coffee, amount: 35.3)
        #expect(!preset.matches(BrewPreset(roast: .medium, anchor: .coffee, amount: 35.9)))
    }

    // MARK: - Guide

    @Test("Should carry the derived dose and pours into the guide steps")
    func shouldEmbedDerivedValuesInGuideSteps() {
        let steps = BrewStep.steps(for: waterFirst(.light, water: 600))
        #expect(steps[2].meta.contains("\(BrewModel.formattedGrams(35.3))g"))  // grounds
        #expect(steps[3].meta.contains("71g"))   // bloom
        #expect(steps[5].meta.contains("529g"))  // spiral pour
    }

    // MARK: - Helpers

    private func waterFirst(_ roast: Roast, water: Double) -> BrewModel {
        let model = BrewModel()
        model.selectedRoast = roast
        model.anchor = .water
        model.waterTarget = water
        return model
    }
}
