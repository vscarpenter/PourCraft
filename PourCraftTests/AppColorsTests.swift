import Testing
import SwiftUI
import UIKit
@testable import PourCraft

@Suite("AppColors")
struct AppColorsTests {

    // MARK: - Helpers

    private func rgb(of color: Color) -> (red: Double, green: Double, blue: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b))
    }

    private func colorsAreDifferent(_ a: Color, _ b: Color) -> Bool {
        let lhs = rgb(of: a)
        let rhs = rgb(of: b)
        return abs(lhs.red - rhs.red) > 0.01
            || abs(lhs.green - rhs.green) > 0.01
            || abs(lhs.blue - rhs.blue) > 0.01
    }

    // MARK: - Adaptive Helpers

    private func assertDifferentForLightAndDark(
        _ getter: (ColorScheme) -> Color,
        name: String
    ) {
        let light = getter(.light)
        let dark = getter(.dark)
        #expect(colorsAreDifferent(light, dark), "\(name) should differ between light and dark mode")
    }

    @Test("Should return different colors for light vs dark across all adaptive helpers")
    func shouldReturnDifferentColorsForLightVsDark() {
        assertDifferentForLightAndDark(AppColors.background, name: "background")
        assertDifferentForLightAndDark(AppColors.surface, name: "surface")
        assertDifferentForLightAndDark(AppColors.primaryText, name: "primaryText")
        assertDifferentForLightAndDark(AppColors.secondaryText, name: "secondaryText")
        assertDifferentForLightAndDark(AppColors.accent, name: "accent")
    }

    // MARK: - Light Mode Values Match Design System

    @Test("Should use cream canvas for light mode background")
    func shouldUseCreamCanvasForLightBackground() {
        let background = AppColors.background(for: .light)
        let expected = AppColors.creamCanvas
        #expect(!colorsAreDifferent(background, expected))
    }

    @Test("Should use night brew for dark mode background")
    func shouldUseNightBrewForDarkBackground() {
        let background = AppColors.background(for: .dark)
        let expected = AppColors.nightBrew
        #expect(!colorsAreDifferent(background, expected))
    }
}
