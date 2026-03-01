import Testing
@testable import PourCraft

@Suite("BrewTip")
struct BrewTipTests {

    @Test("Should contain exactly 8 tips")
    func shouldContainEightTips() {
        #expect(BrewTip.allTips.count == 8)
    }

    @Test("Should have unique IDs across all tips")
    func shouldHaveUniqueIds() {
        let ids = BrewTip.allTips.map(\.id)
        let uniqueIds = Set(ids)
        #expect(uniqueIds.count == ids.count)
    }

    @Test("Should have non-empty titles for all tips")
    func shouldHaveNonEmptyTitles() {
        for tip in BrewTip.allTips {
            #expect(!tip.title.isEmpty, "Tip \(tip.id) has empty title")
        }
    }

    @Test("Should have non-empty body text for all tips")
    func shouldHaveNonEmptyBodies() {
        for tip in BrewTip.allTips {
            #expect(!tip.body.isEmpty, "Tip \(tip.id) has empty body")
        }
    }

    @Test("Should have non-empty icon names for all tips")
    func shouldHaveNonEmptyIconNames() {
        for tip in BrewTip.allTips {
            #expect(!tip.iconName.isEmpty, "Tip \(tip.id) has empty iconName")
        }
    }

    @Test("Should have sequential IDs starting from 1")
    func shouldHaveSequentialIds() {
        let ids = BrewTip.allTips.map(\.id).sorted()
        let expected = Array(1...BrewTip.allTips.count)
        #expect(ids == expected)
    }
}
