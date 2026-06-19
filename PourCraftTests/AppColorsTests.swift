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
        assertDifferentForLightAndDark(AppColors.surface2, name: "surface2")
        assertDifferentForLightAndDark(AppColors.ink, name: "ink")
        assertDifferentForLightAndDark(AppColors.muted, name: "muted")
        assertDifferentForLightAndDark(AppColors.accent, name: "accent")
    }

    // MARK: - Mapped values match palette tokens

    @Test("Should map light mode background to the warm cafe paper token")
    func shouldUseLightBackgroundToken() {
        #expect(!colorsAreDifferent(AppColors.background(for: .light), AppColors.lightBackground))
    }

    @Test("Should map dark mode background to the dark paper token")
    func shouldUseDarkBackgroundToken() {
        #expect(!colorsAreDifferent(AppColors.background(for: .dark), AppColors.darkBackground))
    }

    @Test("Should map accent to terracotta in light and warm copper in dark")
    func shouldUseExpectedAccentTokens() {
        #expect(!colorsAreDifferent(AppColors.accent(for: .light), AppColors.lightAccent))
        #expect(!colorsAreDifferent(AppColors.accent(for: .dark), AppColors.darkAccent))
    }

    @Test("Should derive rule color from ink at low opacity")
    func shouldDeriveRuleFromInk() {
        // Both should be defined and non-zero alpha; the helper just opacities ink.
        let lightRule = AppColors.rule(for: .light)
        let darkRule = AppColors.rule(for: .dark)
        var alpha: CGFloat = 0
        UIColor(lightRule).getRed(nil, green: nil, blue: nil, alpha: &alpha)
        #expect(alpha > 0 && alpha < 1)
        UIColor(darkRule).getRed(nil, green: nil, blue: nil, alpha: &alpha)
        #expect(alpha > 0 && alpha < 1)
    }
}
