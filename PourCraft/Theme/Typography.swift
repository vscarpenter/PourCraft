import SwiftUI

/// Editorial Zine type system. Fraunces (variable serif) for display + body
/// editorial copy; system sans for utilitarian UI labels and kickers.
///
/// Every token scales with Dynamic Type:
///   • Serif tokens use `Font.custom(_, size:, relativeTo:)`. Display sizes
///     are anchored to `.title` so giant numerals scale gently rather than
///     blowing through layouts at AX5.
///   • Sans tokens use `Font.system(_:design:)` with a text style — this is
///     the only way to get a system font that respects Dynamic Type.
enum AppTypography {
    static let serifName = "Fraunces"

    // MARK: - Serif builders

    static func serif(
        _ size: CGFloat,
        weight: Font.Weight = .regular,
        relativeTo style: Font.TextStyle = .body
    ) -> Font {
        Font.custom(serifName, size: size, relativeTo: style).weight(weight)
    }

    static func serifItalic(
        _ size: CGFloat,
        weight: Font.Weight = .regular,
        relativeTo style: Font.TextStyle = .body
    ) -> Font {
        Font.custom(serifName, size: size, relativeTo: style).weight(weight).italic()
    }

    // MARK: - Sans builders (system, scales with Dynamic Type)

    static func sans(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        Font.system(style, design: .default).weight(weight)
    }

    // MARK: - Display tokens

    static let masthead = serif(46, relativeTo: .title)
    static let subPageTitle = serif(38, relativeTo: .title)
    static let sectionTitle = serif(21, weight: .medium, relativeTo: .title2)

    // MARK: - Editorial body

    static let articleBody = serif(16, relativeTo: .body)
    static let manifesto = serifItalic(21, relativeTo: .title3)
    static let pullQuote = serifItalic(23, relativeTo: .title3)

    // MARK: - UI labels (sans, ~caption2 size, scales with Dynamic Type)

    static let kicker = sans(.caption2, weight: .semibold)
    static let micro = sans(.caption2, weight: .bold)
    static let tabLabel = sans(.caption2, weight: .semibold)
}
