import Foundation

struct BrewTip: Identifiable {
    let id: Int
    let title: String
    let body: String
    let iconName: String

    static let allTips: [BrewTip] = [
        BrewTip(
            id: 1,
            title: "Use a Scale",
            body: "Measuring by volume (tablespoons) is inconsistent because different roasts have different densities. Grams ensure your 'good' cup is repeatable every time.",
            iconName: "scalemass"
        ),
        BrewTip(
            id: 2,
            title: "Water Temperature",
            body: "Aim for 194\u{00B0}F to 204\u{00B0}F (90\u{00B0}C to 96\u{00B0}C). If you don't have a temperature-controlled kettle, let the water sit for 30 to 60 seconds after it reaches a rolling boil.",
            iconName: "thermometer.medium"
        ),
        BrewTip(
            id: 3,
            title: "The Bloom",
            body: "Always start by pouring about double the weight of the coffee in water (e.g., 40g of water for 20g of coffee) and let it sit for 30 seconds. This releases CO\u{2082} and allows for more even extraction.",
            iconName: "drop.fill"
        ),
        BrewTip(
            id: 4,
            title: "Grind Size",
            body: "For pour-over, aim for a medium grind, roughly the texture of sea salt. Too fine leads to over-extraction and bitterness. Too coarse leads to a weak, sour cup.",
            iconName: "circle.grid.3x3"
        ),
        BrewTip(
            id: 5,
            title: "Fresh is Best",
            body: "Coffee is at its peak flavor 7 to 21 days after roasting. Check the roast date on the bag and buy from local roasters when possible.",
            iconName: "leaf"
        ),
        BrewTip(
            id: 6,
            title: "Water Quality",
            body: "Use filtered water. Tap water with heavy chlorine or mineral content can mute the delicate flavors in specialty coffee.",
            iconName: "drop.triangle"
        ),
        BrewTip(
            id: 7,
            title: "The Spiral Pour",
            body: "Pour in a slow, steady spiral from the center outward, then back to the center. Avoid pouring directly on the filter walls, which lets water bypass the coffee grounds.",
            iconName: "arrow.trianglehead.2.counterclockwise"
        ),
        BrewTip(
            id: 8,
            title: "Dial It In",
            body: "If your coffee tastes bitter, try a coarser grind or slightly less coffee. If it tastes sour or weak, try a finer grind or slightly more coffee.",
            iconName: "slider.horizontal.3"
        ),
    ]
}
