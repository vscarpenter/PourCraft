import Testing
import SwiftUI
import UIKit
@testable import PourCraft

@Suite("Color+Hex")
struct ColorHexTests {

    // MARK: - Helpers

    /// Extracts RGBA components from a SwiftUI Color via UIColor conversion.
    private func rgba(of color: Color) -> (red: Double, green: Double, blue: Double, alpha: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }

    // MARK: - Valid Hex Parsing

    @Test("Should parse 6-digit hex string without hash prefix")
    func parsesHexWithoutHash() {
        let color = Color(hex: "FF0000")
        let components = rgba(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    @Test("Should parse hex string with hash prefix")
    func parsesHexWithHash() {
        let color = Color(hex: "#00FF00")
        let components = rgba(of: color)
        #expect(abs(components.red - 0.0) < 0.01)
        #expect(abs(components.green - 1.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    @Test("Should parse app cream canvas color correctly")
    func parsesAppCreamCanvas() {
        // FFF8F0 → R:255 G:248 B:240
        let color = Color(hex: "FFF8F0")
        let components = rgba(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - (248.0 / 255.0)) < 0.01)
        #expect(abs(components.blue - (240.0 / 255.0)) < 0.01)
    }

    @Test("Should parse black hex correctly")
    func parsesBlack() {
        let color = Color(hex: "000000")
        let components = rgba(of: color)
        #expect(abs(components.red - 0.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    @Test("Should parse white hex correctly")
    func parsesWhite() {
        let color = Color(hex: "FFFFFF")
        let components = rgba(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - 1.0) < 0.01)
        #expect(abs(components.blue - 1.0) < 0.01)
    }

    // MARK: - Whitespace & Formatting

    @Test("Should trim leading and trailing whitespace")
    func trimsWhitespace() {
        let color = Color(hex: "  #FF0000  ")
        let components = rgba(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
    }

    @Test("Should parse lowercase hex characters")
    func parsesLowercaseHex() {
        let color = Color(hex: "ff8800")
        let components = rgba(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - (136.0 / 255.0)) < 0.02)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    // MARK: - Invalid Input (Graceful Degradation)

    @Test("Should fallback to black for invalid hex string")
    func invalidHexFallsBackToBlack() {
        // Scanner returns 0 for unparseable input → produces black
        let color = Color(hex: "ZZZZZZ")
        let components = rgba(of: color)
        #expect(abs(components.red - 0.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    @Test("Should fallback to black for empty string")
    func emptyStringFallsBackToBlack() {
        let color = Color(hex: "")
        let components = rgba(of: color)
        #expect(abs(components.red - 0.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }
}
