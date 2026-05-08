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
        #expect(Set(ids).count == ids.count)
    }

    @Test("Should have sequential numbers from 1 through 8")
    func shouldHaveSequentialNumbers() {
        let numbers = BrewTip.allTips.map(\.number).sorted()
        #expect(numbers == Array(1...8))
    }

    @Test("Should have non-empty title, dek, category, and pull quote on every tip")
    func shouldHaveRequiredEditorialFields() {
        for tip in BrewTip.allTips {
            #expect(!tip.title.isEmpty, "Tip \(tip.id) has empty title")
            #expect(!tip.dek.isEmpty, "Tip \(tip.id) has empty dek")
            #expect(!tip.category.isEmpty, "Tip \(tip.id) has empty category")
            #expect(!tip.pullQuote.isEmpty, "Tip \(tip.id) has empty pull quote")
        }
    }

    @Test("Should have at least three body paragraphs per tip")
    func shouldHaveSubstantialBody() {
        for tip in BrewTip.allTips {
            #expect(tip.body.count >= 3, "Tip \(tip.id) has only \(tip.body.count) paragraphs")
            for paragraph in tip.body {
                #expect(!paragraph.isEmpty, "Tip \(tip.id) has empty paragraph")
            }
        }
    }

    @Test("Should have at least one reference per tip")
    func shouldHaveAtLeastOneReference() {
        for tip in BrewTip.allTips {
            #expect(tip.references.count >= 1, "Tip \(tip.id) has no references")
            for ref in tip.references {
                #expect(!ref.key.isEmpty)
                #expect(!ref.value.isEmpty)
            }
        }
    }

    @Test("Should format number labels as zero-padded two-digit strings")
    func shouldFormatNumberLabels() {
        #expect(BrewTip.allTips[0].numberLabel == "01")
        #expect(BrewTip.allTips[7].numberLabel == "08")
    }

    @Test("Should look up a tip by id, falling back to first when missing")
    func shouldLookUpById() {
        #expect(BrewTip.tip(id: "grind").number == 1)
        #expect(BrewTip.tip(id: "does-not-exist").id == BrewTip.allTips[0].id)
    }

    @Test("Should wrap nextTip from #8 back to #1")
    func shouldWrapNextTip() {
        #expect(BrewTip.tip(id: "grind").nextTip.number == 2)
        #expect(BrewTip.tip(id: "taste").nextTip.number == 1)
    }
}
