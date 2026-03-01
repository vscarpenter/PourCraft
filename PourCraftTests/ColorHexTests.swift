import Testing
import SwiftUI
import UIKit
@testable import PourCraft

@Suite("Color+Hex")
struct ColorHexTests {

    // MARK: - Helpers

    /// Extracts RGB components from a SwiftUI Color via UIColor conversion.
    private func rgb(of color: Color) -> (red: Double, green: Double, blue: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b))
    }

    // MARK: - Valid Hex Parsing

    @Test("Should parse 6-digit hex string without hash prefix")
    func shouldParseHexWithoutHash() {
        let color = Color(hex: "FF0000")
        let components = rgb(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    @Test("Should parse hex string with hash prefix")
    func shouldParseHexWithHash() {
        let color = Color(hex: "#00FF00")
        let components = rgb(of: color)
        #expect(abs(components.red - 0.0) < 0.01)
        #expect(abs(components.green - 1.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    @Test("Should parse app cream canvas color correctly")
    func shouldParseAppCreamCanvas() {
        // FFF8F0 → R:255 G:248 B:240
        let color = Color(hex: "FFF8F0")
        let components = rgb(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - (248.0 / 255.0)) < 0.01)
        #expect(abs(components.blue - (240.0 / 255.0)) < 0.01)
    }

    @Test("Should parse black hex correctly")
    func shouldParseBlack() {
        let color = Color(hex: "000000")
        let components = rgb(of: color)
        #expect(abs(components.red - 0.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    @Test("Should parse white hex correctly")
    func shouldParseWhite() {
        let color = Color(hex: "FFFFFF")
        let components = rgb(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - 1.0) < 0.01)
        #expect(abs(components.blue - 1.0) < 0.01)
    }

    // MARK: - Whitespace & Formatting

    @Test("Should trim leading and trailing whitespace")
    func shouldTrimWhitespace() {
        let color = Color(hex: "  #FF0000  ")
        let components = rgb(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
    }

    @Test("Should parse lowercase hex characters")
    func shouldParseLowercaseHex() {
        let color = Color(hex: "ff8800")
        let components = rgb(of: color)
        #expect(abs(components.red - 1.0) < 0.01)
        #expect(abs(components.green - (136.0 / 255.0)) < 0.02)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    // MARK: - Invalid Input (Graceful Degradation)

    @Test("Should fallback to black for invalid hex string")
    func shouldFallbackToBlackForInvalidHex() {
        // Scanner returns 0 for unparseable input → produces black
        let color = Color(hex: "ZZZZZZ")
        let components = rgb(of: color)
        #expect(abs(components.red - 0.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }

    @Test("Should fallback to black for empty string")
    func shouldFallbackToBlackForEmptyString() {
        let color = Color(hex: "")
        let components = rgb(of: color)
        #expect(abs(components.red - 0.0) < 0.01)
        #expect(abs(components.green - 0.0) < 0.01)
        #expect(abs(components.blue - 0.0) < 0.01)
    }
}
