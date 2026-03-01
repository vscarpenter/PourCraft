import Foundation
import Testing
@testable import PourCraft

@Suite("Roast")
struct RoastTests {

    @Test("All roast cases exist")
    func allCases() {
        let cases = Roast.allCases
        #expect(cases.count == 3)
        #expect(cases.contains(.light))
        #expect(cases.contains(.medium))
        #expect(cases.contains(.dark))
    }

    @Test("Ratios match spec values")
    func ratios() {
        #expect(Roast.light.ratio == 17)
        #expect(Roast.medium.ratio == 16)
        #expect(Roast.dark.ratio == 15)
    }

    @Test("Ratio labels formatted correctly")
    func ratioLabels() {
        #expect(Roast.light.ratioLabel == "1:17")
        #expect(Roast.medium.ratioLabel == "1:16")
        #expect(Roast.dark.ratioLabel == "1:15")
    }

    @Test("Codable round-trip preserves value")
    func codableRoundTrip() throws {
        for roast in Roast.allCases {
            let data = try JSONEncoder().encode(roast)
            let decoded = try JSONDecoder().decode(Roast.self, from: data)
            #expect(decoded == roast)
        }
    }

    @Test("Each roast has a non-empty flavor profile")
    func flavorProfiles() {
        for roast in Roast.allCases {
            #expect(!roast.flavorProfile.isEmpty)
        }
    }

    @Test("Each roast has a display name")
    func displayNames() {
        #expect(Roast.light.displayName == "Light")
        #expect(Roast.medium.displayName == "Medium")
        #expect(Roast.dark.displayName == "Dark")
    }
}
