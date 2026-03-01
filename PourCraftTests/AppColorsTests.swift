import Testing
import SwiftUI
import UIKit
@testable import PourCraft

@Suite("AppColors")
struct AppColorsTests {

    // MARK: - Helpers

    private func rgba(of color: Color) -> (red: Double, green: Double, blue: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b))
    }

    private func colorsAreDifferent(_ a: Color, _ b: Color) -> Bool {
        let lhs = rgba(of: a)
        let rhs = rgba(of: b)
        return abs(lhs.red - rhs.red) > 0.01
            || abs(lhs.green - rhs.green) > 0.01
            || abs(lhs.blue - rhs.blue) > 0.01
    }

    // MARK: - Adaptive Helpers Return Different Colors for Light vs Dark

    @Test("Should return different background colors for light and dark mode")
    func shouldReturnDifferentBackgrounds() {
        let light = AppColors.background(for: .light)
        let dark = AppColors.background(for: .dark)
        #expect(colorsAreDifferent(light, dark))
    }

    @Test("Should return different surface colors for light and dark mode")
    func shouldReturnDifferentSurfaces() {
        let light = AppColors.surface(for: .light)
        let dark = AppColors.surface(for: .dark)
        #expect(colorsAreDifferent(light, dark))
    }

    @Test("Should return different primary text colors for light and dark mode")
    func shouldReturnDifferentPrimaryText() {
        let light = AppColors.primaryText(for: .light)
        let dark = AppColors.primaryText(for: .dark)
        #expect(colorsAreDifferent(light, dark))
    }

    @Test("Should return different secondary text colors for light and dark mode")
    func shouldReturnDifferentSecondaryText() {
        let light = AppColors.secondaryText(for: .light)
        let dark = AppColors.secondaryText(for: .dark)
        #expect(colorsAreDifferent(light, dark))
    }

    @Test("Should return different accent colors for light and dark mode")
    func shouldReturnDifferentAccent() {
        let light = AppColors.accent(for: .light)
        let dark = AppColors.accent(for: .dark)
        #expect(colorsAreDifferent(light, dark))
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
