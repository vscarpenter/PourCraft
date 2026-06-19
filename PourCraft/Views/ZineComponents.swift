import SwiftUI

enum AppCorners {
    static let card: CGFloat = 18
    static let row: CGFloat = 16
    static let control: CGFloat = 14
}

enum AppLayout {
    static let bottomScrollPadding: CGFloat = 104
    static let iPadScrollPadding: CGFloat = 40
    static let iPadBreakpoint: CGFloat = 760
    static let iPadSidebarWidth: CGFloat = 220
    static let iPadContentMaxWidth: CGFloat = 1120
    static let iPadArticleMaxWidth: CGFloat = 680
    static let iPadColumnSpacing: CGFloat = 24
    static let iPadOuterPadding: CGFloat = 32

    static func usesWideLayout(width: CGFloat) -> Bool {
        width >= iPadBreakpoint
    }

    static func sidebarWidth(for width: CGFloat) -> CGFloat {
        width < 900 ? 196 : iPadSidebarWidth
    }

    static func outerPadding(for width: CGFloat) -> CGFloat {
        width < 900 ? 24 : iPadOuterPadding
    }

    static func brewResultColumnWidth(for width: CGFloat) -> CGFloat {
        width < 940 ? 360 : 420
    }

    static func guideSidePanelWidth(for width: CGFloat) -> CGFloat {
        width < 940 ? 320 : 360
    }

    static func aboutSecondaryColumnWidth(for width: CGFloat) -> CGFloat {
        width < 940 ? 360 : 430
    }

    static func tipsIndexWidth(for width: CGFloat) -> CGFloat {
        let minimumWidth: CGFloat = width < 900 ? 300 : 328
        return min(392, max(minimumWidth, width * 0.34))
    }
}

private struct ZineBottomScrollPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = AppLayout.bottomScrollPadding
}

extension EnvironmentValues {
    var zineBottomScrollPadding: CGFloat {
        get { self[ZineBottomScrollPaddingKey.self] }
        set { self[ZineBottomScrollPaddingKey.self] = newValue }
    }
}

extension View {
    /// Editorial chrome should remain recognizable at large accessibility sizes
    /// without fragmenting into one-letter words.
    func zineChromeLine(minimumScaleFactor: CGFloat = 0.72) -> some View {
        self
            .lineLimit(1)
            .minimumScaleFactor(minimumScaleFactor)
            .allowsTightening(true)
            .dynamicTypeSize(...DynamicTypeSize.xxLarge)
    }
}

// MARK: - Cafe card

struct CafeCard<Content: View>: View {
    @Environment(\.colorScheme) private var scheme

    let padding: CGFloat
    let content: Content

    init(padding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous)
                    .fill(AppColors.surface(for: scheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous)
                    .stroke(AppColors.rule(for: scheme), lineWidth: 1)
            )
    }
}

// MARK: - Rule (horizontal divider)

/// A flat horizontal divider. Pairs of rules (2px + 1px) carry the
/// magazine masthead language without adding boxed chrome.
struct Rule: View {
    var thickness: CGFloat = 1
    var color: Color
    var opacity: Double = 1

    var body: some View {
        Rectangle()
            .fill(color.opacity(opacity))
            .frame(height: thickness)
    }
}

// MARK: - Dotted rule (table-of-contents separators)

struct DottedRule: View {
    var color: Color
    var opacity: Double = 1

    var body: some View {
        GeometryReader { geo in
            let dotCount = max(3, Int(geo.size.width / 7))
            HStack(spacing: 0) {
                ForEach(0..<dotCount, id: \.self) { _ in
                    Circle()
                        .fill(color.opacity(opacity))
                        .frame(width: 1.6, height: 1.6)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 2)
    }
}

// MARK: - Masthead (top-of-page magazine header)

struct Masthead<Title: View>: View {
    @Environment(\.colorScheme) private var scheme
    let title: Title
    let subtitle: String

    init(subtitle: String, @ViewBuilder title: () -> Title) {
        self.title = title()
        self.subtitle = subtitle
    }

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)

        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("PourCraft")
                Spacer(minLength: 12)
                Text("The Brew")
            }
            .font(AppTypography.micro)
            .tracking(2.5)
            .textCase(.uppercase)
            .foregroundStyle(muted)
            .padding(.top, 6)
            .zineChromeLine(minimumScaleFactor: 0.62)

            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 2)
                .padding(.top, 10)
            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 1)
                .padding(.top, 2)

            title
                .font(AppTypography.masthead)
                .foregroundStyle(ink)
                .kerning(-2)
                .padding(.top, 14)
                .padding(.bottom, 4)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
                .allowsTightening(true)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)

            ViewThatFits(in: .horizontal) {
                HStack {
                    mastheadSubtitle(subtitle, color: muted)
                    Spacer()
                    mastheadEdition(color: muted)
                }

                VStack(alignment: .leading, spacing: 4) {
                    mastheadSubtitle(subtitle, color: muted)
                    mastheadEdition(color: muted)
                }
            }

            Rule(color: AppColors.rule(for: scheme))
                .padding(.top, 10)
        }
        .padding(.horizontal, 24)
        .padding(.top, 4)
        .accessibilityElement(children: .combine)
    }

    private func mastheadSubtitle(_ text: String, color: Color) -> some View {
        Text(text)
            .font(AppTypography.serifItalic(14))
            .foregroundStyle(color)
            .zineChromeLine(minimumScaleFactor: 0.72)
    }

    private func mastheadEdition(color: Color) -> some View {
        Text("EST. 2024")
            .font(AppTypography.kicker)
            .tracking(2)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .zineChromeLine(minimumScaleFactor: 0.72)
    }
}

// MARK: - SubHeader (sub-page header for Guide / Tips / About)

struct SubHeader<Title: View>: View {
    @Environment(\.colorScheme) private var scheme
    let kicker: String
    let title: Title
    let subtitle: String
    let onBack: (() -> Void)?

    init(
        kicker: String,
        subtitle: String,
        onBack: (() -> Void)? = nil,
        @ViewBuilder title: () -> Title
    ) {
        self.kicker = kicker
        self.subtitle = subtitle
        self.onBack = onBack
        self.title = title()
    }

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)

        VStack(alignment: .leading, spacing: 0) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    subHeaderLeading(onBack: onBack, color: muted)
                    Spacer()
                    subHeaderKicker(kicker, color: muted)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        subHeaderLeading(onBack: onBack, color: muted)
                        Spacer()
                    }
                    subHeaderKicker(kicker, color: muted)
                }
            }
            .padding(.top, 6)

            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 1)
                .padding(.top, 10)

            title
                .font(AppTypography.subPageTitle)
                .foregroundStyle(ink)
                .kerning(-2)
                .padding(.top, 18)
                .padding(.bottom, 4)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
                .allowsTightening(true)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)

            Text(subtitle)
                .font(AppTypography.serifItalic(14))
                .foregroundStyle(muted)
                .padding(.bottom, 14)
                .fixedSize(horizontal: false, vertical: true)

            Rule(color: AppColors.rule(for: scheme))
        }
        .padding(.horizontal, 24)
        .padding(.top, 4)
    }

    private func subHeaderLeading(onBack: (() -> Void)?, color: Color) -> some View {
        Group {
            if let onBack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        InkIconView(
                            icon: .chevron, size: 11,
                            color: color, strokeWidth: 1.6
                        )
                        .rotationEffect(.degrees(180))
                        Text("Back")
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")
            } else {
                Text("PourCraft")
            }
        }
        .font(AppTypography.kicker)
        .tracking(2.5)
        .foregroundStyle(color)
        .textCase(.uppercase)
        .zineChromeLine(minimumScaleFactor: 0.62)
    }

    private func subHeaderKicker(_ text: String, color: Color) -> some View {
        Text(text)
            .font(AppTypography.kicker)
            .tracking(2.5)
            .foregroundStyle(color)
            .textCase(.uppercase)
            .zineChromeLine(minimumScaleFactor: 0.62)
    }
}

// MARK: - SectionHeader ("Nº 01 ────── KICKER")

struct SectionHeader: View {
    @Environment(\.colorScheme) private var scheme
    let number: String
    let kicker: String

    var body: some View {
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        ViewThatFits(in: .horizontal) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                sectionNumber(color: accent)

                Rectangle()
                    .fill(accent.opacity(0.42))
                    .frame(height: 1)

                sectionKicker(color: muted)
            }

            HStack(alignment: .firstTextBaseline) {
                sectionNumber(color: accent)
                Spacer(minLength: 12)
                sectionKicker(color: muted)
            }
        }
        .zineChromeLine(minimumScaleFactor: 0.62)
    }

    private func sectionNumber(color: Color) -> some View {
        Text("No. \(number)")
            .font(AppTypography.micro)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .tracking(2)
            .zineChromeLine(minimumScaleFactor: 0.62)
    }

    private func sectionKicker(color: Color) -> some View {
        Text(kicker)
            .font(AppTypography.kicker)
            .tracking(2)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .zineChromeLine(minimumScaleFactor: 0.62)
    }
}

// MARK: - ZineSection (header + title + content)

struct ZineSection<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    let number: String
    let title: String
    let kicker: String
    let content: Content

    init(
        number: String, title: String, kicker: String,
        @ViewBuilder content: () -> Content
    ) {
        self.number = number
        self.title = title
        self.kicker = kicker
        self.content = content()
    }

    var body: some View {
        let ink = AppColors.ink(for: scheme)

        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(number: number, kicker: kicker)

            Text(title)
                .font(AppTypography.sectionTitle)
                .foregroundStyle(ink)
                .kerning(-0.5)
                .padding(.top, 7)
                .padding(.bottom, 10)

            content
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - TemperatureUnitPicker

struct TemperatureUnitPicker: View {
    @Binding var selection: TemperatureUnit
    var horizontalPadding: CGFloat = 14

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let accent = AppColors.accent(for: scheme)
        let onAccent = AppColors.onAccent(for: scheme)

        HStack(spacing: 0) {
            ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                let selected = selection == unit
                Button {
                    withAnimation(.snappy) {
                        selection = unit
                    }
                } label: {
                Text(unit.label)
                    .font(AppTypography.sans(.caption, weight: .semibold))
                    .tracking(1)
                    .foregroundStyle(selected ? onAccent : ink)
                    .zineChromeLine(minimumScaleFactor: 0.75)
                    .padding(.vertical, 6)
                    .padding(.horizontal, horizontalPadding)
                        .background(
                            RoundedRectangle(cornerRadius: AppCorners.control - 4, style: .continuous)
                                .fill(selected ? accent : .clear)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(unit == .fahrenheit ? "Fahrenheit" : "Celsius")
                .accessibilityAddTraits(selected ? .isSelected : [])
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: AppCorners.control, style: .continuous)
                .fill(AppColors.surface(for: scheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCorners.control, style: .continuous)
                .stroke(AppColors.rule(for: scheme), lineWidth: 1)
        )
    }
}
