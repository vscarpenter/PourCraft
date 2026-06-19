import SwiftUI

enum ZineTab: String, CaseIterable, Identifiable {
    case brew, guide, tips, about

    var id: String { rawValue }

    var label: String {
        switch self {
        case .brew: "Brew"
        case .guide: "Guide"
        case .tips: "Tips"
        case .about: "About"
        }
    }

    /// SF Symbols per design handoff — keeps the bar consistent with the
    /// rest of iOS while the body of the app stays in the ink-icon set.
    var symbol: String {
        switch self {
        case .brew: "cup.and.saucer.fill"
        case .guide: "book.fill"
        case .tips: "sparkles"
        case .about: "info.circle.fill"
        }
    }
}

/// Custom magazine-style tab bar. Sits flush at the bottom of every screen.
struct ZineTabBar: View {
    @Environment(\.colorScheme) private var scheme
    @Binding var selection: ZineTab

    var body: some View {
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)
        let surface = AppColors.surface(for: scheme)

        VStack(spacing: 0) {
            Rule(color: AppColors.rule(for: scheme))
            HStack(alignment: .top) {
                ForEach(ZineTab.allCases) { tab in
                    Button {
                        selection = tab
                    } label: {
                        let active = tab == selection
                        VStack(spacing: 4) {
                            Image(systemName: tab.symbol)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(active ? accent : muted)
                                .frame(height: 20)
                            Text(tab.label)
                                .font(AppTypography.tabLabel)
                                .tracking(1)
                                .textCase(.uppercase)
                                .foregroundStyle(active ? accent : muted)
                                .zineChromeLine(minimumScaleFactor: 0.78)
                                .dynamicTypeSize(...DynamicTypeSize.large)
                        }
                        .padding(.vertical, 6)
                        .frame(minHeight: 52)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: AppCorners.control, style: .continuous)
                                .fill(active ? AppColors.chip(for: scheme) : .clear)
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(tab.label)
                    .accessibilityValue(tab == selection ? "Selected" : "")
                    .accessibilityAddTraits(tab == selection ? .isSelected : [])
                    .accessibilityIdentifier("nav.tab.\(tab.rawValue)")
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 5)
            .padding(.bottom, 5)
        }
        .background(surface)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("nav.tabbar")
    }
}

/// Persistent iPad navigation rail. Keeps the zine identity while using the
/// extra width for direct section switching instead of a phone-style bottom bar.
struct ZineSidebar: View {
    @Environment(\.colorScheme) private var scheme
    @Binding var selection: ZineTab

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)
        let surface = AppColors.surface(for: scheme)
        let chip = AppColors.chipStrong(for: scheme)

        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("PourCraft")
                    .font(AppTypography.micro)
                    .tracking(3)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
                    .zineChromeLine(minimumScaleFactor: 0.7)

                Text("The Pour")
                    .font(AppTypography.serif(30, weight: .regular, relativeTo: .title))
                    .foregroundStyle(ink)
                    .kerning(-1.2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text("Editorial brew desk")
                    .font(AppTypography.serifItalic(13))
                    .foregroundStyle(muted)
                    .zineChromeLine(minimumScaleFactor: 0.72)
            }
            .padding(.top, 8)
            .padding(.bottom, 20)

            Rule(color: AppColors.ruleStrong(for: scheme), opacity: 0.9)

            VStack(spacing: 6) {
                ForEach(ZineTab.allCases) { tab in
                    SidebarTabButton(
                        tab: tab,
                        isSelected: tab == selection,
                        accent: accent,
                        ink: ink,
                        muted: muted,
                        chip: chip
                    ) {
                        withAnimation(.snappy) {
                            selection = tab
                        }
                    }
                }
            }
            .padding(.top, 18)

            Spacer(minLength: 24)

            VStack(alignment: .leading, spacing: 8) {
                Rule(color: AppColors.rule(for: scheme))
                Text("Roast, ratio, ritual.")
                    .font(AppTypography.serifItalic(13))
                    .foregroundStyle(muted)
                    .fixedSize(horizontal: false, vertical: true)
                Text("v\(appVersion())")
                    .font(AppTypography.micro)
                    .tracking(2.5)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
                    .zineChromeLine(minimumScaleFactor: 0.72)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(surface.ignoresSafeArea())
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("nav.sidebar")
    }

    private func appVersion() -> String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
}

private struct SidebarTabButton: View {
    let tab: ZineTab
    let isSelected: Bool
    let accent: Color
    let ink: Color
    let muted: Color
    let chip: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: tab.symbol)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(isSelected ? accent : muted)
                    .frame(width: 22, height: 22)

                Text(tab.label)
                    .font(AppTypography.tabLabel)
                    .tracking(1.4)
                    .textCase(.uppercase)
                    .foregroundStyle(isSelected ? ink : muted)
                    .zineChromeLine(minimumScaleFactor: 0.78)

                Spacer(minLength: 0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.control, style: .continuous)
                    .fill(isSelected ? chip : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppCorners.control, style: .continuous)
                    .stroke(isSelected ? accent.opacity(0.45) : .clear, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.label)
        .accessibilityValue(isSelected ? "Selected" : "")
        .accessibilityHint("Switches to the \(tab.label) section")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("nav.sidebar.\(tab.rawValue)")
    }
}
