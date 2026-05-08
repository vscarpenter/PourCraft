import SwiftUI

/// Editorial Zine palette. Two adaptive sets — light cream paper and dark
/// paper — plus derived helpers (rule, chip) that stay in lockstep with the
/// scheme's accent.
///
/// All values come from the design handoff (`design_handoff_pourcraft_zine`).
/// Where the handoff and earlier Swift values disagreed, the handoff wins.
enum AppColors {
    // MARK: - Light Mode (cream paper)

    static let lightBackground = Color(hex: "FBF3E5")
    static let lightSurface = Color(hex: "FFF8EC")
    static let lightSurface2 = Color(hex: "F0E6D0")
    static let lightInk = Color(hex: "2A1F1B")
    static let lightMuted = Color(hex: "6B5239")
    static let lightMutedSoft = Color(hex: "8A6F52")
    static let lightAccent = Color(hex: "B87333")
    static let lightAccentInk = Color(hex: "FFF8EC")

    // MARK: - Dark Mode (dark paper)

    static let darkBackground = Color(hex: "221915")
    static let darkSurface = Color(hex: "2C211C")
    static let darkSurface2 = Color(hex: "352721")
    static let darkInk = Color(hex: "F0E6D6")
    /// Raised from `#B89A7E` to clear WCAG AA for tiny uppercase kickers.
    static let darkMuted = Color(hex: "C4A88A")
    static let darkMutedSoft = Color(hex: "A38A6E")
    static let darkAccent = Color(hex: "D4935A")
    static let darkAccentInk = Color(hex: "221915")

    // MARK: - Phase / semantic accents (kept for the timer ring)

    static let bloomOrange = Color(hex: "D4854A")
    static let sageBrew = Color(hex: "7A9E7E")

    // MARK: - Adaptive helpers

    static func background(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkBackground : lightBackground
    }

    static func surface(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkSurface : lightSurface
    }

    static func surface2(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkSurface2 : lightSurface2
    }

    static func ink(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkInk : lightInk
    }

    static func muted(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkMuted : lightMuted
    }

    static func mutedSoft(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkMutedSoft : lightMutedSoft
    }

    static func accent(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkAccent : lightAccent
    }

    /// Foreground color when laid on `accent`. Reverses to background for legibility.
    static func onAccent(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkAccentInk : lightAccentInk
    }

    static func rule(for scheme: ColorScheme) -> Color {
        ink(for: scheme).opacity(0.18)
    }

    /// Heavy hairline used for the masthead's ink bar and the article footer.
    static func ruleStrong(for scheme: ColorScheme) -> Color {
        scheme == .dark
            ? darkInk.opacity(0.65)
            : lightInk.opacity(0.85)
    }

    /// Selected-row tint. Derived from accent so the warmth stays consistent.
    static func chip(for scheme: ColorScheme) -> Color {
        accent(for: scheme).opacity(scheme == .dark ? 0.16 : 0.12)
    }

    static func chipStrong(for scheme: ColorScheme) -> Color {
        accent(for: scheme).opacity(scheme == .dark ? 0.24 : 0.18)
    }

    // MARK: - Legacy aliases used by remaining timer code

    static func primaryText(for scheme: ColorScheme) -> Color { ink(for: scheme) }
    static func secondaryText(for scheme: ColorScheme) -> Color { muted(for: scheme) }
    static func controlTint(for scheme: ColorScheme) -> Color { accent(for: scheme) }
}
