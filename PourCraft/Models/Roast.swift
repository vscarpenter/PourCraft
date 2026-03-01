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

    var flavorProfile: String {
        switch self {
        case .light:
            "Bright, floral, tea-like notes. Origin flavors shine through."
        case .medium:
            "Balanced sweetness, clean body. The specialty coffee sweet spot."
        case .dark:
            "Bold, rich, full-bodied. Chocolate and caramel forward."
        }
    }

    var color: Color {
        switch self {
        case .light: AppColors.morningGold
        case .medium: AppColors.hazelnut
        case .dark: AppColors.darkWalnut
        }
    }
}
