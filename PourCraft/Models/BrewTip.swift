import Foundation

/// A magazine-style "field note" — short title and dek for the contents page,
/// plus a full body, pull quote, and reference data for the article view.
struct BrewTip: Identifiable, Hashable {
    let id: String
    let number: Int
    let category: String
    let title: String
    let dek: String
    let body: [String]
    let pullQuote: String
    let references: [Reference]
    let icon: InkIcon

    /// Two-digit display number ("01", "07").
    var numberLabel: String { String(format: "%02d", number) }

    struct Reference: Hashable {
        let key: String
        let value: String
    }

    static let allTips: [BrewTip] = [
        BrewTip(
            id: "grind",
            number: 1,
            category: "Technique",
            title: "Grind matters more than beans.",
            dek: "A great roast destroyed by a stale blade grinder is just brown water. Burrs first, beans second.",
            body: [
                "Of every variable in the cup, grind size accounts for the most variance. Two of the same grams from the same bag, ground differently, will produce drinks that taste like different coffees entirely.",
                "Why? Surface area. The water doesn\u{2019}t see beans \u{2014} it sees particles. Smaller particles extract faster and more completely. The trick is uniformity: a wide spread of sizes means some grounds over-extract while others under-extract, and the cup arrives muddled.",
                "Burr grinders crush beans between two ridged surfaces, producing particles of consistent size. Blade grinders chop, producing dust and boulders in equal measure. The difference is not subtle.",
                "If you buy one piece of equipment, buy a hand burr grinder. You will taste it on the first cup.",
            ],
            pullQuote: "\u{201C}Two of the same grams, ground differently, are different coffees.\u{201D}",
            references: [
                Reference(key: "Recommended", value: "Hand burr grinder"),
                Reference(key: "Setting", value: "Medium · sea-salt texture"),
                Reference(key: "Replace burrs", value: "Every 1,000 lb"),
            ],
            icon: .beans
        ),
        BrewTip(
            id: "water",
            number: 2,
            category: "Chemistry",
            title: "Water is 98% of the cup.",
            dek: "If your tap tastes good, brew with it. If it doesn\u{2019}t, neither will your coffee.",
            body: [
                "By weight, a cup of coffee is roughly 98.5% water. Whatever character that water has \u{2014} chlorinated, mineral-heavy, soft \u{2014} finds its way into the brew.",
                "Filtered water is the cheapest upgrade you can make. A simple carbon filter pitcher pulls out chlorine and most off-flavors. For the obsessed, mineral packets reproduce the SCA\u{2019}s recommended brewing water profile at home.",
                "Distilled water is too clean \u{2014} minerals participate in extraction. Skip it.",
                "If your tap is potable and pleasant on its own, it\u{2019}s probably fine for coffee. Trust your tongue.",
            ],
            pullQuote: "\u{201C}By weight, a cup of coffee is 98.5% water.\u{201D}",
            references: [
                Reference(key: "Target hardness", value: "~150 ppm"),
                Reference(key: "Avoid", value: "Distilled, softened"),
                Reference(key: "Easy fix", value: "Carbon-filter pitcher"),
            ],
            icon: .drop
        ),
        BrewTip(
            id: "bloom",
            number: 3,
            category: "Method",
            title: "Bloom is not optional.",
            dek: "Skip the bloom and you trap CO\u{2082} that fights your pour. The first thirty seconds set up the rest.",
            body: [
                "Fresh coffee is full of carbon dioxide. When hot water hits, the gas erupts \u{2014} that mesmerizing dome of bubbles. If you don\u{2019}t let it escape, it forms channels in the bed and your subsequent pours race past instead of brewing.",
                "Pour twice the weight of your dose, evenly, and wait thirty seconds. Watch the bed swell. Watch it deflate. Then pour.",
                "The fresher the bean, the more dramatic the bloom. A flat bloom usually means stale beans \u{2014} or a roast more than four weeks past its date.",
            ],
            pullQuote: "\u{201C}Skip the bloom; trap the gas; ruin the pour.\u{201D}",
            references: [
                Reference(key: "Bloom water", value: "2\u{00D7} dose"),
                Reference(key: "Duration", value: "30 sec"),
                Reference(key: "Sign of life", value: "Visible dome"),
            ],
            icon: .bloom
        ),
        BrewTip(
            id: "temp",
            number: 4,
            category: "Chemistry",
            title: "Hotter for light, cooler for dark.",
            dek: "Roast level decides the temperature. Pulling against it is the difference between bright and bitter.",
            body: [
                "Light-roasted beans are dense and require more energy to extract their sugars and acids. Pour at 205\u{2013}210\u{00B0}F.",
                "Dark roasts are porous and extract easily \u{2014} too easily. Cooler water (195\u{2013}200\u{00B0}F) keeps them from going bitter and ashy.",
                "Medium roasts split the difference at 200\u{2013}205\u{00B0}F. When in doubt, that\u{2019}s the safe target.",
                "An off-boil kettle, rested 30\u{2013}60 seconds, lands roughly at 205\u{00B0}F. No thermometer needed for most homes.",
            ],
            pullQuote: "\u{201C}Light wants hot. Dark wants restraint.\u{201D}",
            references: [
                Reference(key: "Light", value: "205\u{2013}210\u{00B0}F"),
                Reference(key: "Medium", value: "200\u{2013}205\u{00B0}F"),
                Reference(key: "Dark", value: "195\u{2013}200\u{00B0}F"),
            ],
            icon: .thermo
        ),
        BrewTip(
            id: "ratio",
            number: 5,
            category: "Method",
            title: "A ratio, not a recipe.",
            dek: "1:15 to 1:17. Memorize the band, scale the dose, and stop measuring with a scoop.",
            body: [
                "Recipes lie. Ratios scale. One gram of coffee to fifteen grams of water makes a strong cup; 1:17 makes a clean one. Anywhere in between is good coffee.",
                "Volume measurements (scoops, tablespoons) vary with bean size and grind. A scoop of light Ethiopian and a scoop of dark Sumatra are not the same dose.",
                "A $15 kitchen scale ends every argument. Weigh the dose, weigh the water, taste, adjust. The whole thing takes ten seconds longer.",
            ],
            pullQuote: "\u{201C}Recipes lie. Ratios scale.\u{201D}",
            references: [
                Reference(key: "Strong", value: "1:15"),
                Reference(key: "Balanced", value: "1:16"),
                Reference(key: "Clean", value: "1:17"),
            ],
            icon: .scale
        ),
        BrewTip(
            id: "pour",
            number: 6,
            category: "Technique",
            title: "Pour slowly, in a spiral.",
            dek: "A gooseneck kettle is half technique, half jewelry. The spiral pour is what it buys you.",
            body: [
                "Direct, fast pours blast a hole through the center of the bed and channel water past the grounds. The result tastes thin and uneven.",
                "A spiral pour \u{2014} center out to the edge, then back in \u{2014} saturates the entire bed evenly. Keep the stream pencil-thin.",
                "Avoid the filter walls. Water touching paper instead of grounds is wasted; worse, it dilutes the cup.",
                "Aim for a steady tempo over the full pour window. Two-minute spirals feel slow; they taste correct.",
            ],
            pullQuote: "\u{201C}Center out, then back in. Never the walls.\u{201D}",
            references: [
                Reference(key: "Tool", value: "Gooseneck kettle"),
                Reference(key: "Pattern", value: "Spiral, center out"),
                Reference(key: "Pour window", value: "2:00 from bloom"),
            ],
            icon: .spiral
        ),
        BrewTip(
            id: "fresh",
            number: 7,
            category: "Beans",
            title: "Fresh, but not too fresh.",
            dek: "Beans need a week to settle. After four, they fade. Read the roast date, not the sell-by.",
            body: [
                "Roasted beans off-gas CO\u{2082} for several days. Brew them too early and the gas crowds out the water; the cup tastes flat or sour.",
                "Wait 7 to 14 days from roast date. The flavors round out, the bloom becomes lively but controllable.",
                "After about 30 days, the volatile aromatics \u{2014} the things that make coffee smell like coffee \u{2014} start to disappear. The cup becomes muted.",
                "The only date that matters is the roast date. \u{2018}Best by\u{2019} is marketing.",
            ],
            pullQuote: "\u{201C}Read the roast date. Ignore the rest.\u{201D}",
            references: [
                Reference(key: "Best window", value: "7\u{2013}28 days post-roast"),
                Reference(key: "Storage", value: "Sealed, dark, cool"),
                Reference(key: "Avoid", value: "Freezer, fridge"),
            ],
            icon: .beans
        ),
        BrewTip(
            id: "taste",
            number: 8,
            category: "Practice",
            title: "Taste, then adjust \u{2014} one variable at a time.",
            dek: "Bitter? Grind coarser. Sour? Grind finer. Don\u{2019}t change three things at once and call it a method.",
            body: [
                "Coffee diagnostics are simple if you isolate the variable. Bitter and dry on the back of the tongue means over-extraction \u{2014} coarsen the grind or shorten the pour.",
                "Sour, sharp, lemony? Under-extracted. Grind finer or pour slower. Watery and thin? Often a dose problem; weigh again.",
                "Change one thing per brew. Two changes and you can\u{2019}t tell which fixed it. Three and you\u{2019}re guessing.",
                "Keep a tasting note for each new bag. Within a week you\u{2019}ll have your dialed-in recipe.",
            ],
            pullQuote: "\u{201C}One variable at a time. Always.\u{201D}",
            references: [
                Reference(key: "Bitter", value: "Coarsen"),
                Reference(key: "Sour", value: "Finer"),
                Reference(key: "Thin", value: "Re-weigh"),
            ],
            icon: .check
        ),
    ]

    static func tip(id: String) -> BrewTip {
        allTips.first(where: { $0.id == id }) ?? allTips[0]
    }

    /// The "Continued in" link target. Wraps to the start after #8.
    var nextTip: BrewTip {
        let nextIndex = number % BrewTip.allTips.count
        return BrewTip.allTips[nextIndex]
    }

    /// True for the final entry — the article view shows an "end of
    /// contents" footer instead of a Continued-in link.
    var isLast: Bool {
        number == BrewTip.allTips.count
    }
}
