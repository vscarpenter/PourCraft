import CoreGraphics
import Testing
@testable import PourCraft

@Suite("RulerScale")
struct RulerScaleTests {
    private let coffee = RulerScale(range: BrewModel.coffeeWeightRange, step: BrewModel.coffeeWeightStep)
    private let water = RulerScale(range: BrewModel.waterRange, step: BrewModel.waterStep)
    private let width: CGFloat = 392  // ruler width on a 6.9-inch iPhone

    @Test("Should draw one tick per step, including both ends")
    func shouldDrawOneTickPerStep() {
        #expect(coffee.tickCount == 51)
        #expect(water.tickCount == 71)
    }

    @Test("Should select exactly the value of whichever tick is tapped")
    func shouldMapEveryTickToItsValue() {
        for scale in [coffee, water] {
            for index in 0..<scale.tickCount {
                let tapped = scale.value(at: scale.x(forTick: index, width: width), width: width)
                #expect(tapped == scale.range.lowerBound + Double(index) * scale.step)
            }
        }
    }

    @Test("Should map the 50 g tick to 50 g")
    func shouldMapFiftyGramTickToFiftyGrams() {
        // The old 51-slot layout drew this tick at 40/51 of the width, which read back as 49 g.
        #expect(coffee.value(at: coffee.x(forTick: 40, width: width), width: width) == 50)
    }

    @Test("Should center the marker on the tick for its value")
    func shouldCenterMarkerOnItsTick() {
        #expect(abs(coffee.x(for: 60, width: width) - coffee.x(forTick: 50, width: width)) < 0.001)
        #expect(abs(water.x(for: 600, width: width) - water.x(forTick: 40, width: width)) < 0.001)
    }

    @Test("Should clamp touches past either end of the ruler")
    func shouldClampTouchesPastTheEnds() {
        #expect(coffee.value(at: -20, width: width) == 10)
        #expect(coffee.value(at: width + 20, width: width) == 60)
    }
}
