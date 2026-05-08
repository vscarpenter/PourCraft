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
                                .font(.system(size: 20, weight: .regular))
                                .foregroundStyle(active ? accent : muted)
                                .frame(height: 24)
                            Text(tab.label)
                                .font(AppTypography.tabLabel)
                                .tracking(1)
                                .textCase(.uppercase)
                                .foregroundStyle(active ? accent : muted)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(tab.label)
                    .accessibilityAddTraits(tab == selection ? .isSelected : [])
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 4)
        }
        .background(AppColors.background(for: scheme))
    }
}
