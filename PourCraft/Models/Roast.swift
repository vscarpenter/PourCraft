import SwiftUI

enum Roast: String, CaseIterable, Codable, Identifiable {
    case light
    case medium
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .light: "Light"
        case .medium: "Medium"
        case .dark: "Dark"
        }
    }

    /// Coffee-to-water ratio (e.g., 17 means 1:17)
    var ratio: Int {
        switch self {
        case .light: 17
        case .medium: 16
        case .dark: 15
        }
    }

    var ratioLabel: String {
        "1:\(ratio)"
    }

    /// Brew water range in °F, matching field note 04: light roasts are dense
    /// and need hotter water, dark roasts turn bitter if it's too hot.
    var waterTemperatureF: ClosedRange<Int> {
        switch self {
        case .light: 205...210
        case .medium: 200...205
        case .dark: 195...200
        }
    }

    /// Long-form descriptor used in cards and bodies.
    var flavorProfile: String {
        switch self {
        case .light:
            "Bright, floral, tea-like. Origin flavors shine through."
        case .medium:
            "Balanced sweetness, clean body. The specialty sweet spot."
        case .dark:
            "Bold, rich, full-bodied. Chocolate and caramel forward."
        }
    }

    /// Two-word kicker used inline next to the roast name.
    var shortDescriptor: String {
        switch self {
        case .light: "Bright · Floral"
        case .medium: "Balanced · Sweet"
        case .dark: "Bold · Rich"
        }
    }
}
