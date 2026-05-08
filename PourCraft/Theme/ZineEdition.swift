import Foundation

/// The masthead's editorial chrome: month, vol/issue numbers, and the
/// "by the numbers" stats on the colophon. Randomized once per app launch
/// so the magazine "feels printed" but stays stable while the user is reading.
struct ZineEdition {
    let month: String          // "April"
    let volume: String         // "04"
    let issue: String          // "16"
    let cupsPoured: String     // "04.2M"

    /// One edition computed at launch. Read everywhere via `ZineEdition.current`.
    static let current: ZineEdition = .makeRandomized(now: Date())

    static func makeRandomized(
        now: Date,
        rng: inout some RandomNumberGenerator
    ) -> ZineEdition {
        let cal = Calendar(identifier: .gregorian)
        let monthIndex = cal.component(.month, from: now) // 1...12
        let monthName = DateFormatter().monthSymbols[monthIndex - 1]

        let volume = String(format: "%02d", Int.random(in: 1...12, using: &rng))
        let issue = String(format: "%02d", Int.random(in: 1...48, using: &rng))

        // Editorial vanity number: between 1.0M and 9.9M.
        let millions = Double.random(in: 1.0...9.9, using: &rng)
        let cupsPoured = String(format: "%04.1fM", millions)

        return ZineEdition(
            month: monthName,
            volume: volume,
            issue: issue,
            cupsPoured: cupsPoured
        )
    }

    static func makeRandomized(now: Date) -> ZineEdition {
        var rng = SystemRandomNumberGenerator()
        return makeRandomized(now: now, rng: &rng)
    }
}
