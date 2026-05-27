import SwiftUI

/// About tab — back-of-book colophon. Manifesto, three numbered sections
/// (Settings / The Reading Room / Masthead), and a stamp footer.
struct AboutView: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SubHeader(
                    kicker: "Colophon",
                    subtitle: "A note on what this is, and who made it."
                ) {
                    HStack(spacing: 0) {
                        Text("The ")
                        Text("Colophon")
                            .italic()
                            .foregroundStyle(AppColors.accent(for: scheme))
                        Text(".")
                    }
                }

                Manifesto()
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                BodyParagraph()
                    .padding(.horizontal, 24)
                    .padding(.top, 18)

                SettingsSection(brewModel: brewModel)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                ReadingRoomSection()
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                MastheadSection()
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                Footer()
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                Color.clear.frame(height: 24)
            }
        }
        .background(AppColors.background(for: scheme))
    }
}

// MARK: - Manifesto + opening paragraph

private struct Manifesto: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("PourCraft is a small calculator that takes coffee seriously without taking itself too seriously.")
                .font(AppTypography.manifesto)
                .foregroundStyle(AppColors.ink(for: scheme))
                .kerning(-0.4)
                .lineSpacing(2)
            Rule(color: AppColors.rule(for: scheme))
        }
    }
}

private struct BodyParagraph: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        Text("Choose a roast. Set the dose. The numbers fall out. Then we get out of the way and let you brew.")
            .font(AppTypography.serif(15))
            .foregroundStyle(AppColors.ink(for: scheme))
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Nº 01 Settings

private struct SettingsSection: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(number: "01", kicker: "Settings")

            VStack(spacing: 0) {
                SettingRow(label: "Display temperature in") {
                    UnitSegmentToggle(brewModel: brewModel)
                }
                ToggleSettingRow(
                    label: "Haptic feedback",
                    accessibilityHint: "Plays a tap on each brew-phase change",
                    isOn: $brewModel.hapticsEnabled
                )
                ToggleSettingRow(
                    label: "Auto-advance brew steps",
                    accessibilityHint: "Highlights the step matching the live timer phase",
                    isOn: $brewModel.autoAdvanceSteps
                )
            }
        }
    }
}

private struct SettingRow<Trailing: View>: View {
    let label: String
    @ViewBuilder var trailing: () -> Trailing
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(label)
                    .font(AppTypography.serif(16))
                    .foregroundStyle(AppColors.ink(for: scheme))
                Spacer(minLength: 12)
                trailing()
            }
            .padding(.vertical, 12)
            .frame(minHeight: 44)
            Rule(color: AppColors.rule(for: scheme))
        }
    }
}

/// Tappable row whose trailing label flips between italic copper "On" / muted "Off".
/// The whole row is the hit target so it matches the 44pt zine row spec.
private struct ToggleSettingRow: View {
    let label: String
    let accessibilityHint: String
    @Binding var isOn: Bool
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        VStack(spacing: 0) {
            Button {
                isOn.toggle()
            } label: {
                HStack {
                    Text(label)
                        .font(AppTypography.serif(16))
                        .foregroundStyle(ink)
                    Spacer(minLength: 12)
                    Text(isOn ? "On" : "Off")
                        .font(AppTypography.serifItalic(15))
                        .foregroundStyle(isOn ? accent : muted)
                        .contentTransition(.opacity)
                        .animation(.snappy, value: isOn)
                }
                .padding(.vertical, 12)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(label)
            .accessibilityValue(isOn ? "On" : "Off")
            .accessibilityHint(accessibilityHint)
            .accessibilityAddTraits(.isButton)

            Rule(color: AppColors.rule(for: scheme))
        }
    }
}

private struct UnitSegmentToggle: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let bg = AppColors.background(for: scheme)

        HStack(spacing: 0) {
            ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                let selected = brewModel.temperatureUnit == unit
                Button {
                    brewModel.temperatureUnit = unit
                } label: {
                    Text(unit.shortLabel)
                        .font(AppTypography.sans(.caption, weight: .semibold))
                        .tracking(1)
                        .foregroundStyle(selected ? bg : ink)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(selected ? ink : .clear)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(unit == .fahrenheit ? "Fahrenheit" : "Celsius")
                .accessibilityAddTraits(selected ? .isSelected : [])
            }
        }
        .overlay(Capsule().stroke(ink, lineWidth: 1))
        .clipShape(Capsule())
    }
}

private extension TemperatureUnit {
    var shortLabel: String {
        switch self {
        case .fahrenheit: "\u{00B0}F"
        case .celsius: "\u{00B0}C"
        }
    }
}

// MARK: - Nº 02 The Reading Room

private struct ReadingRoomSection: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(number: "02", kicker: "The Reading Room")

            VStack(spacing: 0) {
                ChevronRow(label: "Rate PourCraft") {
                    let reviewURL = "https://apps.apple.com/us/app/pourcraft-coffee/id6759871953?action=write-review"
                    if let url = URL(string: reviewURL) {
                        openURL(url)
                    }
                }
                ChevronRow(label: "Share with a friend") {
                    if let url = URL(string: "https://www.pourcraftcoffee.com/") {
                        openURL(url)
                    }
                }
                ChevronRow(label: "Send feedback") {
                    if let url = URL(string: "mailto:pourcraftcoffee@vinny.dev?subject=PourCraft%20feedback") {
                        openURL(url)
                    }
                }
                ChevronRow(label: "Privacy policy") {
                    if let url = URL(string: "https://www.pourcraftcoffee.com/privacy.html") {
                        openURL(url)
                    }
                }
            }
        }
    }
}

private struct ChevronRow: View {
    let label: String
    let action: () -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)

        VStack(spacing: 0) {
            Button(action: action) {
                HStack {
                    Text(label)
                        .font(AppTypography.serif(16))
                        .foregroundStyle(ink)
                    Spacer()
                    InkIconView(icon: .chevron, size: 14, color: muted, strokeWidth: 1.6)
                }
                .padding(.vertical, 14)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Rule(color: AppColors.rule(for: scheme))
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Nº 03 Masthead (real credits)

private struct MastheadSection: View {
    @Environment(\.openURL) private var openURL

    fileprivate struct Credit: Identifiable {
        let id = UUID()
        let role: String
        let person: String
        let url: URL?
    }

    private var credits: [Credit] {
        [
            Credit(role: "Created by", person: "Vinny Carpenter", url: URL(string: "https://vinny.dev")),
            Credit(role: "Inspired by", person: "Kristin Carpenter", url: nil),
            Credit(role: "Developer", person: "Katie Carpenter", url: nil),
            Credit(role: "Type", person: "Fraunces & Inter", url: nil),
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(number: "03", kicker: "Masthead")
            VStack(spacing: 0) {
                ForEach(credits) { credit in
                    CreditRow(credit: credit, openURL: openURL)
                }
            }
        }
    }
}

private struct CreditRow: View {
    let credit: MastheadSection.Credit
    let openURL: OpenURLAction
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let muted = AppColors.muted(for: scheme)
        let ink = AppColors.ink(for: scheme)
        let accent = AppColors.accent(for: scheme)

        VStack(spacing: 0) {
            HStack(alignment: .lastTextBaseline, spacing: 8) {
                Text(credit.role)
                    .font(AppTypography.micro)
                    .tracking(2)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
                LeaderDots()
                Group {
                    if let url = credit.url {
                        Button { openURL(url) } label: {
                            Text(credit.person)
                                .font(AppTypography.serifItalic(15))
                                .foregroundStyle(accent)
                                .underline()
                        }
                        .buttonStyle(.plain)
                    } else {
                        Text(credit.person)
                            .font(AppTypography.serifItalic(15))
                            .foregroundStyle(ink)
                    }
                }
            }
            .padding(.vertical, 10)
            .frame(minHeight: 44)
            Rule(color: AppColors.rule(for: scheme), opacity: 0.6)
        }
    }
}

private struct LeaderDots: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        GeometryReader { geo in
            let dotCount = max(2, Int(geo.size.width / 6))
            HStack(spacing: 0) {
                ForEach(0..<dotCount, id: \.self) { _ in
                    Text("·")
                        .font(AppTypography.sans(.caption2))
                        .foregroundStyle(AppColors.muted(for: scheme))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 12)
    }
}

// MARK: - Footer

private struct Footer: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        VStack(spacing: 0) {
            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 2)
            Rectangle()
                .fill(AppColors.ruleStrong(for: scheme))
                .frame(height: 1)
                .padding(.top, 2)

            InkIconView(icon: .stamp, size: 28, color: accent, strokeWidth: 1.4)
                .padding(.top, 20)

            Text("Made for people who weigh their coffee, and own a kettle with a spout that looks slightly silly.")
                .font(AppTypography.serifItalic(14))
                .foregroundStyle(muted)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 8)

            Text("v\(appVersion()) · pourcraftcoffee.com")
                .font(AppTypography.micro)
                .tracking(3)
                .textCase(.uppercase)
                .foregroundStyle(muted)
                .padding(.top, 14)
        }
        .frame(maxWidth: .infinity)
    }

    private func appVersion() -> String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
}
