import Foundation
import Testing
@testable import PourCraft

@Suite("ZineEdition")
struct ZineEditionTests {

    /// A deterministic RNG so randomization can be exercised in tests.
    private struct SeededRNG: RandomNumberGenerator {
        var state: UInt64
        mutating func next() -> UInt64 {
            // xorshift64
            state ^= state << 13
            state ^= state >> 7
            state ^= state << 17
            return state
        }
    }

    @Test("Should derive month name from the supplied date")
    func shouldDeriveMonthName() {
        var rng = SeededRNG(state: 1)
        let april = DateComponents(calendar: .init(identifier: .gregorian),
                                   year: 2026, month: 4, day: 15).date!
        let edition = ZineEdition.makeRandomized(now: april, rng: &rng)
        #expect(edition.month == "April")
    }

    @Test("Should pad volume and issue to two digits")
    func shouldPadVolumeAndIssue() {
        var rng = SeededRNG(state: 42)
        let edition = ZineEdition.makeRandomized(now: Date(), rng: &rng)
        #expect(edition.volume.count == 2)
        #expect(edition.issue.count == 2)
        #expect(Int(edition.volume) != nil)
        #expect(Int(edition.issue) != nil)
    }

    @Test("Should format cups poured as N.NM")
    func shouldFormatCupsPoured() {
        var rng = SeededRNG(state: 99)
        let edition = ZineEdition.makeRandomized(now: Date(), rng: &rng)
        #expect(edition.cupsPoured.hasSuffix("M"))
        let numericPart = String(edition.cupsPoured.dropLast())
        #expect(Double(numericPart) != nil)
    }

    @Test("Should be deterministic for a given seed")
    func shouldBeDeterministicForSeed() {
        var rngA = SeededRNG(state: 7)
        var rngB = SeededRNG(state: 7)
        let now = Date(timeIntervalSinceReferenceDate: 0)
        let a = ZineEdition.makeRandomized(now: now, rng: &rngA)
        let b = ZineEdition.makeRandomized(now: now, rng: &rngB)
        #expect(a.volume == b.volume)
        #expect(a.issue == b.issue)
        #expect(a.cupsPoured == b.cupsPoured)
    }

    @Test("Should expose a stable .current edition for the running app")
    func shouldExposeStableCurrent() {
        let first = ZineEdition.current
        let second = ZineEdition.current
        #expect(first.month == second.month)
        #expect(first.volume == second.volume)
        #expect(first.issue == second.issue)
        #expect(first.cupsPoured == second.cupsPoured)
    }
}
