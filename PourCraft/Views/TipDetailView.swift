import SwiftUI

/// Tip article view — magazine spread for a single field-note. 110pt terracotta
/// numeral hero, left-aligned body paragraphs, pull-quote between paragraphs
/// 1 and 2, "by the numbers" reference block, and either a "Continued in"
/// link or, on the final tip, an "end of contents" CTA back to Field Notes.
struct TipDetailView: View {
    let tip: BrewTip
    let showsBackButton: Bool
    let onSelectTip: ((BrewTip) -> Void)?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.zineBottomScrollPadding) private var bottomScrollPadding

    init(
        tip: BrewTip,
        showsBackButton: Bool = true,
        onSelectTip: ((BrewTip) -> Void)? = nil
    ) {
        self.tip = tip
        self.showsBackButton = showsBackButton
        self.onSelectTip = onSelectTip
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ArticleHeader(tip: tip, showsBackButton: showsBackButton)
                    .padding(.horizontal, 24)
                    .padding(.top, 4)

                BigNumeralHero(tip: tip)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                ArticleBody(tip: tip)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                ReferencesBlock(tip: tip)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                if tip.isLast {
                    EndOfContents(onSelectTip: onSelectTip)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                } else {
                    NextTipLink(tip: tip, onSelectTip: onSelectTip)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                }

                Color.clear.frame(height: bottomScrollPadding)
            }
            .frame(maxWidth: AppLayout.iPadArticleMaxWidth, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .background(AppColors.background(for: scheme))
        .navigationBarBackButtonHidden(true)
        .accessibilityIdentifier("article.\(tip.id)")
    }
}

// MARK: - Article header (back chevron / Nº / category)

private struct ArticleHeader: View {
    let tip: BrewTip
    let showsBackButton: Bool
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let muted = AppColors.muted(for: scheme)

        VStack(spacing: 10) {
            HStack {
                if showsBackButton {
                    Button(action: { dismiss() }, label: {
                        HStack(spacing: 4) {
                            InkIconView(icon: .chevron, size: 11, color: muted, strokeWidth: 1.6)
                                .rotationEffect(.degrees(180))
                            Text("Field Notes")
                        }
                    })
                    .buttonStyle(.plain)
                    .accessibilityLabel("Back to Field Notes")
                } else {
                    Text("Field Notes")
                }
                Spacer()
                Text("Nº \(tip.numberLabel)")
                Spacer()
                Text(tip.category)
            }
            .font(AppTypography.kicker)
            .tracking(2.5)
            .textCase(.uppercase)
            .foregroundStyle(muted)
            .padding(.top, 6)

            Rule(color: AppColors.rule(for: scheme))
        }
    }
}

// MARK: - Big numeral hero + title + dek

private struct BigNumeralHero: View {
    let tip: BrewTip
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        VStack(alignment: .leading, spacing: 0) {
            Text(tip.numberLabel)
                .font(AppTypography.serif(110, weight: .regular, relativeTo: .title))
                .foregroundStyle(accent)
                .kerning(-5)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.bottom, 4)
            Text("Tip · \(tip.category)")
                .font(AppTypography.micro)
                .tracking(3)
                .textCase(.uppercase)
                .foregroundStyle(muted)
                .padding(.bottom, 6)
            Text(tip.title)
                .font(AppTypography.serif(34, weight: .regular))
                .foregroundStyle(ink)
                .kerning(-1.5)
                .lineSpacing(-2)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityIdentifier("article.title.\(tip.id)")
            Text(tip.dek)
                .font(AppTypography.serifItalic(17))
                .foregroundStyle(muted)
                .lineSpacing(2)
                .padding(.top, 14)
                .fixedSize(horizontal: false, vertical: true)

            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 2)
                .padding(.top, 22)
            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 1)
                .padding(.top, 2)
        }
    }
}

// MARK: - Article body (left-aligned paragraphs + pull quote)

private struct ArticleBody: View {
    let tip: BrewTip
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)

        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(tip.body.enumerated()), id: \.offset) { index, paragraph in
                Text(paragraph)
                    .articleBodyStyle(color: ink)

                if index == 0 {
                    PullQuote(text: tip.pullQuote)
                }
            }
        }
    }
}

private struct PullQuote: View {
    let text: String
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let accent = AppColors.accent(for: scheme)

        VStack(spacing: 0) {
            Rule(color: AppColors.rule(for: scheme))
                .padding(.bottom, 14)
            Text(text)
                .font(AppTypography.pullQuote)
                .foregroundStyle(accent)
                .kerning(-0.5)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .frame(maxWidth: .infinity)
            Rule(color: AppColors.rule(for: scheme))
                .padding(.top, 14)
        }
        .padding(.vertical, 8)
    }
}

private extension Text {
    func articleBodyStyle(color: Color) -> some View {
        self
            .font(AppTypography.articleBody)
            .foregroundStyle(color)
            .lineSpacing(4)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - References ("by the numbers")

private struct ReferencesBlock: View {
    let tip: BrewTip
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)

        VStack(alignment: .leading, spacing: 14) {
            Rule(color: AppColors.rule(for: scheme))
            Text("By the numbers")
                .font(AppTypography.micro)
                .tracking(2.5)
                .textCase(.uppercase)
                .foregroundStyle(muted)

            CafeCard(padding: 0) {
                VStack(spacing: 0) {
                    ForEach(Array(tip.references.enumerated()), id: \.offset) { index, ref in
                        HStack(alignment: .firstTextBaseline) {
                            Text(ref.key)
                                .font(AppTypography.micro)
                                .tracking(2)
                                .textCase(.uppercase)
                                .foregroundStyle(muted)
                            Spacer()
                            Text(ref.value)
                                .font(AppTypography.serif(17, weight: .medium))
                                .foregroundStyle(ink)
                                .kerning(-0.3)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        if index < tip.references.count - 1 {
                            Rule(color: AppColors.rule(for: scheme), opacity: 0.6)
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Next-tip link

private struct NextTipLink: View {
    let tip: BrewTip
    let onSelectTip: ((BrewTip) -> Void)?
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let next = tip.nextTip

        VStack(spacing: 10) {
            Group {
                if let onSelectTip {
                    Button {
                        onSelectTip(next)
                    } label: {
                        linkLabel(for: next)
                    }
                } else {
                    NavigationLink(value: next) {
                        linkLabel(for: next)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("article.next")
        }
    }

    private func linkLabel(for next: BrewTip) -> some View {
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)
        let nextHook = next.title.split(separator: ".").first.map(String.init) ?? next.title

        return HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Continued in")
                    .font(AppTypography.micro)
                    .tracking(2.5)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
                Text("Nº \(next.numberLabel) \u{2014} \(nextHook)")
                    .font(AppTypography.serifItalic(18))
                    .foregroundStyle(accent)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            InkIconView(icon: .chevron, size: 16, color: accent, strokeWidth: 1.8)
        }
        .padding(16)
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

// MARK: - End-of-contents footer (final tip only)

private struct EndOfContents: View {
    let onSelectTip: ((BrewTip) -> Void)?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        VStack(spacing: 18) {
            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 2)
            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 1)
                .padding(.top, -16)

            Text("\u{2014} end of contents \u{2014}")
                .font(AppTypography.serifItalic(14))
                .foregroundStyle(muted)
                .padding(.top, 4)

            Button(action: handleTap) {
                HStack(spacing: 8) {
                    InkIconView(icon: .chevron, size: 12, color: accent, strokeWidth: 1.8)
                        .rotationEffect(.degrees(180))
                    Text("Back to Field Notes")
                        .font(AppTypography.serif(15, weight: .medium))
                        .foregroundStyle(accent)
                        .kerning(-0.2)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(AppColors.surface(for: scheme))
                )
                .overlay(
                    Capsule()
                        .stroke(AppColors.rule(for: scheme), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back to Field Notes")
            .accessibilityIdentifier("article.backToContents")
        }
        .frame(maxWidth: .infinity)
    }

    private func handleTap() {
        if let onSelectTip {
            onSelectTip(BrewTip.allTips[0])
        } else {
            dismiss()
        }
    }
}
