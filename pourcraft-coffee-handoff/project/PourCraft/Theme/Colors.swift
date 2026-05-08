import SwiftUI

enum AppColors {
    // MARK: - Light Mode Palette

    static let creamCanvas = Color(hex: "FFF8F0")
    static let latteFoam = Color(hex: "F0E6D6")
    static let espresso = Color(hex: "3B2F2F")
    static let roastedBean = Color(hex: "6F4E37")
    static let copperKettle = Color(hex: "B87333")
    static let caramelDrip = Color(hex: "C8956C")

    // MARK: - Roast Colors

    static let morningGold = Color(hex: "D4A960")
    static let hazelnut = Color(hex: "8B6914")
    static let darkWalnut = Color(hex: "4A3728")

    // MARK: - Semantic

    static let sageBrew = Color(hex: "7A9E7E")
    static let bloomOrange = Color(hex: "D4854A")

    // MARK: - Dark Mode Palette

    static let nightBrew = Color(hex: "1A1412")
    static let darkRoastSurface = Color(hex: "2C2320")
    static let cream = Color(hex: "F0E6D6")
    static let burnishedCopper = Color(hex: "D4935A")

    // MARK: - Adaptive Helpers

    static func background(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? nightBrew : creamCanvas
    }

    static func surface(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkRoastSurface : latteFoam
    }

    static func primaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? cream : espresso
    }

    static func secondaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? caramelDrip : roastedBean
    }

    static func accent(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? burnishedCopper : copperKettle
    }

    static func controlTint(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? burnishedCopper : roastedBean
    }

    static func onAccent(for _: ColorScheme) -> Color {
        nightBrew
    }
}
