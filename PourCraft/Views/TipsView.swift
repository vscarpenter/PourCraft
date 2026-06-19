import SwiftUI

/// Tips tab — magazine table-of-contents listing the eight field notes.
/// Tapping a row pushes on iPhone and updates a persistent article pane on iPad.
struct TipsView: View {
    @Binding var selectedTip: BrewTip

    @Environment(\.colorScheme) private var scheme
    @Environment(\.zineBottomScrollPadding) private var bottomScrollPadding

    var body: some View {
        GeometryReader { proxy in
            if AppLayout.usesWideLayout(width: proxy.size.width) {
                wideLayout(width: proxy.size.width)
            } else {
                compactLayout
            }
        }
        .background(AppColors.background(for: scheme))
    }

    private var compactLayout: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    fieldNotesHeader

                    PullQuoteIntro()
                        .padding(.horizontal, 24)
                        .padding(.top, 18)

                    ContentsTOC()
                        .padding(.top, 2)

                    Color.clear.frame(height: bottomScrollPadding)
                }
            }
            .background(AppColors.background(for: scheme))
            .navigationDestination(for: BrewTip.self) { tip in
                TipDetailView(tip: tip)
            }
        }
    }

    private func wideLayout(width: CGFloat) -> some View {
        let indexWidth = AppLayout.tipsIndexWidth(for: width)

        return HStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    fieldNotesHeader

                    PullQuoteIntro()
                        .padding(.horizontal, 24)
                        .padding(.top, 18)

                    TipsSplitIndex(selectedTip: $selectedTip)
                        .padding(.top, 2)

                    Color.clear.frame(height: bottomScrollPadding)
                }
            }
            .frame(width: indexWidth)

            Rectangle()
                .fill(AppColors.rule(for: scheme))
                .frame(width: 1)

            TipDetailView(
                tip: selectedTip,
                showsBackButton: false,
                onSelectTip: { tip in
                    withAnimation(.snappy) {
                        selectedTip = tip
                    }
                }
            )
            .id(selectedTip.id)
        }
    }

    private var fieldNotesHeader: some View {
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
            .accessibilityIdentifier("tips.header.title")
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
                    .accessibilityIdentifier("tips.row.\(tip.id)")
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

private struct TipsSplitIndex: View {
    @Binding var selectedTip: BrewTip
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let muted = AppColors.muted(for: scheme)

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
                    Button {
                        withAnimation(.snappy) {
                            selectedTip = tip
                        }
                    } label: {
                        TipRow(
                            tip: tip,
                            isSelected: selectedTip.id == tip.id,
                            showsChevron: false
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("tips.row.\(tip.id)")
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

private struct TipRow: View {
    let tip: BrewTip
    var isSelected: Bool = false
    var showsChevron: Bool = true

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)
        let surface = AppColors.surface(for: scheme)
        let chip = AppColors.chip(for: scheme)

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

            if showsChevron {
                InkIconView(icon: .chevron, size: 14, color: muted, strokeWidth: 1.6)
                    .padding(.top, 14)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppCorners.row, style: .continuous)
                .fill(isSelected ? chip : surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCorners.row, style: .continuous)
                .stroke(isSelected ? accent.opacity(0.42) : AppColors.rule(for: scheme), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(tip.category). \(tip.title) — \(tip.dek)")
        .accessibilityValue(isSelected ? "Selected" : "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("tips.rowLabel.\(tip.id)")
    }
}
