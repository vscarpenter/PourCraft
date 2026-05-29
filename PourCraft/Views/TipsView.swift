import SwiftUI

/// Tips tab — magazine table-of-contents listing the eight field notes.
/// Tapping a row pushes the article view onto the navigation stack.
struct TipsView: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    SubHeader(
                        kicker: "Field Notes",
                        subtitle: "Eight pieces of advice we'd give a friend."
                    ) {
                        HStack(spacing: 0) {
                            Text("Field ")
                            Text("Notes")
                                .italic()
                                .foregroundStyle(AppColors.accent(for: scheme))
                            Text(".")
                        }
                    }

                    PullQuoteIntro()
                        .padding(.horizontal, 24)
                        .padding(.top, 18)

                    ContentsTOC()
                        .padding(.top, 2)

                    Color.clear.frame(height: 24)
                }
            }
            .background(AppColors.background(for: scheme))
            .navigationDestination(for: BrewTip.self) { tip in
                TipDetailView(tip: tip)
            }
        }
    }
}

private struct PullQuoteIntro: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Most great cups fail on a small detail. These are the small details.")
                .font(AppTypography.serifItalic(20))
                .foregroundStyle(AppColors.ink(for: scheme))
                .kerning(-0.4)
                .lineSpacing(2)
            Rule(color: AppColors.rule(for: scheme))
        }
    }
}

private struct ContentsTOC: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let muted = AppColors.muted(for: scheme)
        let ink = AppColors.ink(for: scheme)

        VStack(spacing: 0) {
            HStack {
                Text("Contents")
                    .font(AppTypography.micro)
                    .tracking(2.5)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
                Rectangle()
                    .fill(AppColors.rule(for: scheme))
                    .frame(height: 1)
                Text("\(BrewTip.allTips.count) entries")
                    .font(AppTypography.sans(.caption2, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(muted)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 24)

            VStack(spacing: 8) {
                ForEach(BrewTip.allTips) { tip in
                    NavigationLink(value: tip) {
                        TipRow(tip: tip)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)

            VStack(spacing: 0) {
                Rule(thickness: 2, color: ink, opacity: 0.85)
                    .padding(.top, 18)
                Rule(thickness: 1, color: ink, opacity: 0.85)
                    .padding(.top, 2)
                Text("\u{2014} end of contents \u{2014}")
                    .font(AppTypography.serifItalic(12))
                    .foregroundStyle(muted)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 24)
        }
    }
}

private struct TipRow: View {
    let tip: BrewTip
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Text(tip.numberLabel)
                .font(AppTypography.serif(30, weight: .regular))
                .foregroundStyle(accent)
                .kerning(-1)
                .frame(width: 38, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(tip.category)
                    .font(AppTypography.micro)
                    .tracking(2.5)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
                Text(tip.title)
                    .font(AppTypography.serif(19, weight: .medium))
                    .foregroundStyle(ink)
                    .kerning(-0.3)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(1.15)
                Text(tip.dek)
                    .font(AppTypography.serifItalic(13))
                    .foregroundStyle(muted)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(1.4)
            }

            Spacer()

            InkIconView(icon: .chevron, size: 14, color: muted, strokeWidth: 1.6)
                .padding(.top, 14)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppCorners.row, style: .continuous)
                .fill(AppColors.surface(for: scheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCorners.row, style: .continuous)
                .stroke(AppColors.rule(for: scheme), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(tip.category). \(tip.title) — \(tip.dek)")
    }
}
