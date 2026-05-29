import SwiftUI

/// Editorial Zine palette. Two adaptive sets -- warm cafe paper and dark
/// paper -- plus derived helpers (rule, chip) that stay in lockstep with the
/// scheme's accent.
///
/// All values come from the design handoff (`design_handoff_pourcraft_zine`).
/// Where the handoff and earlier Swift values disagreed, the handoff wins.
enum AppColors {
    // MARK: - Light Mode (warm cafe paper)

    static let lightBackground = Color(hex: "FFF7EA")
    static let lightSurface = Color(hex: "FFFCF4")
    static let lightSurface2 = Color(hex: "EADCC4")
    static let lightInk = Color(hex: "2F211A")
    static let lightMuted = Color(hex: "78604E")
    static let lightMutedSoft = Color(hex: "987C63")
    static let lightAccent = Color(hex: "BF6745")
    static let lightAccentInk = Color(hex: "FFF7EA")

    // MARK: - Dark Mode (dark paper)

    static let darkBackground = Color(hex: "201614")
    static let darkSurface = Color(hex: "2B201B")
    static let darkSurface2 = Color(hex: "3A2A23")
    static let darkInk = Color(hex: "F6E8D4")
    /// Raised from `#B89A7E` to clear WCAG AA for tiny uppercase kickers.
    static let darkMuted = Color(hex: "D0B497")
    static let darkMutedSoft = Color(hex: "B79577")
    static let darkAccent = Color(hex: "E08A62")
    static let darkAccentInk = Color(hex: "201614")

    // MARK: - Phase / semantic accents (kept for the timer ring)

    static let bloomOrange = Color(hex: "C5794F")
    static let sageBrew = Color(hex: "7F9B78")

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
