import Foundation

/// One step in the eight-step pour-over guide. Generated from a BrewModel
/// snapshot so the displayed grams/temperatures stay in sync with the
/// calculator the user just set on the Brew tab.
struct BrewStep: Identifiable, Hashable {
    let id: Int
    let icon: InkIcon
    let title: String
    /// The little tracked-uppercase label under the title (grams, time, temp).
    let meta: String
    /// Body copy, displayed when the step is expanded.
    let body: AttributedString
    /// Which timer phase this step represents, if any.
    let phase: BrewPhase?

    var numberLabel: String { String(format: "%02d", id) }

    /// Build the eight steps from the calculator state.
    static func steps(for brew: BrewModel) -> [BrewStep] {
        let weight = brew.formattedWeight(brew.coffeeWeight)
        let bloom = brew.formattedWeight(brew.bloomWater)
        let remaining = brew.formattedWeight(brew.remainingWater)
        let tempPoint = brew.temperaturePoint

        return [
            BrewStep(
                id: 1,
                icon: .flame,
                title: "Heat the water",
                meta: tempPoint,
                body: makeBody(
                    "Bring water to ",
                    bold: tempPoint,
                    ". No thermometer? Let a rolling boil rest 30\u{2013}60 seconds."
                ),
                phase: nil
            ),
            BrewStep(
                id: 2,
                icon: .v60,
                title: "Rinse the filter",
                meta: "15 sec",
                body: AttributedString("Place the paper filter in your dripper. Rinse with hot water to wash out paper taste, then discard the rinse."),
                phase: nil
            ),
            BrewStep(
                id: 3,
                icon: .beans,
                title: "Add the grounds",
                meta: "\(weight)g · medium grind",
                body: makeBody(
                    "Add ",
                    bold: "\(weight)g",
                    " of medium-ground coffee \u{2014} the texture of sea salt. Tap to level the bed."
                ),
                phase: nil
            ),
            BrewStep(
                id: 4,
                icon: .bloom,
                title: "Bloom",
                meta: "\(bloom)g · 0:00 \u{2192} 0:30",
                body: makeBody(
                    "Start the timer. Pour ",
                    bold: "\(bloom)g",
                    " of water evenly over the grounds, saturating every dry spot."
                ),
                phase: .bloom
            ),
            BrewStep(
                id: 5,
                icon: .timer,
                title: "Wait, watch",
                meta: "30 sec",
                body: AttributedString("The bed swells and bubbles as CO\u{2082} escapes. This is the bloom. Patience here pays off in clarity."),
                phase: .bloom
            ),
            BrewStep(
                id: 6,
                icon: .spiral,
                title: "Spiral pour",
                meta: "\(remaining)g · 0:30 \u{2192} 2:30",
                body: makeBody(
                    "Pour the remaining ",
                    bold: "\(remaining)g",
                    " in a slow, steady spiral \u{2014} center out, then back in. Avoid the filter walls."
                ),
                phase: .pour
            ),
            BrewStep(
                id: 7,
                icon: .drop,
                title: "Drawdown",
                meta: "2:30 \u{2192} 3:30",
                body: makeBody(
                    "Let the water finish drawing through. Total brew time: ",
                    bold: "3:00 to 4:00",
                    ". Longer is over; shorter is under."
                ),
                phase: .drawdown
            ),
            BrewStep(
                id: 8,
                icon: .kettle,
                title: "Pour, sip, study",
                meta: "Enjoy",
                body: AttributedString("Decant. Take a moment before the first sip \u{2014} the aroma is half the cup."),
                phase: .done
            ),
        ]
    }

    private static func makeBody(_ prefix: String, bold: String, _ suffix: String) -> AttributedString {
        var result = AttributedString(prefix)
        var emphasized = AttributedString(bold)
        emphasized.font = .body.bold()
        result.append(emphasized)
        result.append(AttributedString(suffix))
        return result
    }
}
