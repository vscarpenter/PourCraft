import SwiftUI

// MARK: - Rule (horizontal divider)

/// A flat horizontal divider. Pairs of rules (2px + 1px) approximate the
/// double-rule magazine masthead from the handoff.
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
        let edition = ZineEdition.current
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Vol. \(edition.volume) · Issue \(edition.issue)")
                Spacer()
                HStack(spacing: 6) {
                    InkIconView(icon: .stamp, size: 12, color: accent, strokeWidth: 1.4)
                    Text("Pourcraft")
                }
                Spacer()
                Text(edition.month)
            }
            .font(AppTypography.kicker)
            .tracking(2.5)
            .textCase(.uppercase)
            .foregroundStyle(muted)
            .padding(.top, 6)

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
                .kerning(-2.5)
                .padding(.top, 20)
                .padding(.bottom, 4)

            HStack {
                Text(subtitle)
                    .font(AppTypography.serifItalic(14))
                    .foregroundStyle(muted)
                Spacer()
                Text("EST. 2024")
                    .font(AppTypography.kicker)
                    .tracking(2)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
            }

            Rule(color: AppColors.rule(for: scheme))
                .padding(.top, 14)
        }
        .padding(.horizontal, 24)
        .padding(.top, 4)
        .accessibilityElement(children: .combine)
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
            HStack {
                if let onBack {
                    Button(action: onBack) {
                        HStack(spacing: 4) {
                            InkIconView(
                                icon: .chevron, size: 11,
                                color: muted, strokeWidth: 1.6
                            )
                            .rotationEffect(.degrees(180))
                            Text("Back")
                        }
                    }
                    .buttonStyle(.plain)
                } else {
                    Text("Pourcraft")
                }
                Spacer()
                Text(kicker)
            }
            .font(AppTypography.kicker)
            .tracking(2.5)
            .foregroundStyle(muted)
            .padding(.top, 6)
            .textCase(.uppercase)

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

            Text(subtitle)
                .font(AppTypography.serifItalic(14))
                .foregroundStyle(muted)
                .padding(.bottom, 14)

            Rule(color: AppColors.rule(for: scheme))
        }
        .padding(.horizontal, 24)
        .padding(.top, 4)
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

        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text("Nº \(number)")
                .font(AppTypography.serifItalic(13))
                .foregroundStyle(accent)
                .tracking(0.4)

            Rectangle()
                .fill(accent.opacity(0.5))
                .frame(height: 1)

            Text(kicker)
                .font(AppTypography.kicker)
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(muted)
        }
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
                .padding(.top, 10)
                .padding(.bottom, 16)

            content
        }
        .padding(.horizontal, 24)
    }
}
