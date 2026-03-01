import Foundation
import Testing
@testable import PourCraft

@Suite("Roast")
struct RoastTests {

    @Test("Should contain exactly three roast cases")
    func shouldContainThreeRoastCases() {
        let cases = Roast.allCases
        #expect(cases.count == 3)
        #expect(cases.contains(.light))
        #expect(cases.contains(.medium))
        #expect(cases.contains(.dark))
    }

    @Test("Should have ratios matching spec values")
    func shouldHaveCorrectRatios() {
        #expect(Roast.light.ratio == 17)
        #expect(Roast.medium.ratio == 16)
        #expect(Roast.dark.ratio == 15)
    }

    @Test("Should format ratio labels as 1:N")
    func shouldFormatRatioLabels() {
        #expect(Roast.light.ratioLabel == "1:17")
        #expect(Roast.medium.ratioLabel == "1:16")
        #expect(Roast.dark.ratioLabel == "1:15")
    }

    @Test("Should survive Codable round-trip for all cases")
    func shouldSurviveCodableRoundTrip() throws {
        for roast in Roast.allCases {
            let data = try JSONEncoder().encode(roast)
            let decoded = try JSONDecoder().decode(Roast.self, from: data)
            #expect(decoded == roast)
        }
    }

    @Test("Should have non-empty flavor profile for each roast")
    func shouldHaveNonEmptyFlavorProfiles() {
        for roast in Roast.allCases {
            #expect(!roast.flavorProfile.isEmpty)
        }
    }

    @Test("Should have correct display names")
    func shouldHaveCorrectDisplayNames() {
        #expect(Roast.light.displayName == "Light")
        #expect(Roast.medium.displayName == "Medium")
        #expect(Roast.dark.displayName == "Dark")
    }
}
