import SwiftUI

/// The Brew tab — magazine-style calculator. Three numbered sections
/// (roast, dose, the pour) plus a "Begin the brew" CTA that jumps to Guide.
struct BrewView: View {
    @Bindable var brewModel: BrewModel
    let morningPreset: BrewPreset?
    let onSaveMorningPreset: () -> Void
    let onStartBrew: () -> Void

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
        ScrollView {
            VStack(spacing: 0) {
                brewMasthead

                roastSection
                    .padding(.top, 18)

                doseSection
                    .padding(.top, 20)

                pourSection
                    .padding(.top, 24)

                beginBrewBlock
                    .padding(.top, 24)
                    .padding(.horizontal, 24)

                Color.clear.frame(height: bottomScrollPadding)
            }
        }
    }

    private func wideLayout(width: CGFloat) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                brewMasthead
                    .frame(maxWidth: AppLayout.iPadContentMaxWidth)
                    .frame(maxWidth: .infinity)

                HStack(alignment: .top, spacing: AppLayout.iPadColumnSpacing) {
                    VStack(spacing: 20) {
                        roastSection
                        doseSection
                    }
                    .frame(maxWidth: .infinity, alignment: .top)

                    VStack(spacing: 24) {
                        pourSection
                        beginBrewBlock
                    }
                    .frame(width: AppLayout.brewResultColumnWidth(for: width), alignment: .top)
                }
                .frame(maxWidth: AppLayout.iPadContentMaxWidth, alignment: .top)
                .padding(.horizontal, AppLayout.outerPadding(for: width))
                .padding(.top, 24)

                Color.clear.frame(height: bottomScrollPadding)
            }
        }
    }

    private var brewMasthead: some View {
        Masthead(subtitle: "A calculator, set in type.") {
            HStack(spacing: 0) {
                Text("The ")
                Text("Pour")
                    .italic()
                    .foregroundStyle(AppColors.accent(for: scheme))
            }
            .accessibilityIdentifier("brew.header.title")
        }
    }

    private var roastSection: some View {
        ZineSection(number: "01", title: "Choose your roast.", kicker: "Three options") {
            RoastList(brewModel: brewModel)
        }
    }

    private var doseSection: some View {
        ZineSection(
            number: "02",
            title: brewModel.anchor == .coffee ? "Dial in the dose." : "Dial in the water.",
            kicker: "Grams"
        ) {
            ZineSegmentedPicker(
                options: BrewAnchor.allCases,
                selection: $brewModel.anchor,
                title: { $0.label },
                spokenLabel: { "Start from \($0.label.lowercased())" },
                horizontalPadding: 12
            )
        } content: {
            DoseInput(brewModel: brewModel)
        }
    }

    private var pourSection: some View {
        ZineSection(number: "03", title: "The pour, by weight.", kicker: "Computed") {
            PourBlock(brewModel: brewModel)
        }
    }

    private var beginBrewBlock: some View {
        BeginBrewBlock(
            brewModel: brewModel,
            morningPreset: morningPreset,
            onSaveMorningPreset: onSaveMorningPreset,
            onStartBrew: onStartBrew
        )
    }
}

// MARK: - Roast list (rounded rows, terracotta ruler-mark when selected)

private struct RoastList: View {
    @Bindable var brewModel: BrewModel

    var body: some View {
        VStack(spacing: 8) {
            ForEach(Roast.allCases) { roast in
                RoastRow(roast: roast, brewModel: brewModel)
            }
        }
    }
}

private struct RoastRow: View {
    let roast: Roast
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let selected = brewModel.selectedRoast == roast
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)
        let chip = AppColors.chip(for: scheme)
        let surface = AppColors.surface(for: scheme)

        Button {
            withAnimation(.snappy) {
                brewModel.selectedRoast = roast
            }
        } label: {
            HStack(alignment: .top, spacing: 0) {
                // Present always so text alignment doesn't shift.
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(selected ? accent : .clear)
                    .frame(width: 3)
                    .padding(.vertical, 12)

                VStack(alignment: .leading, spacing: 4) {
                    ViewThatFits(in: .horizontal) {
                        HStack(alignment: .firstTextBaseline) {
                            roastName(color: ink)
                            roastDescriptor(color: muted)

                            Spacer(minLength: 8)

                            ratioLabel(color: accent)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(alignment: .firstTextBaseline) {
                                roastName(color: ink)
                                Spacer(minLength: 8)
                                ratioLabel(color: accent)
                            }
                            roastDescriptor(color: muted)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Text(roast.flavorProfile)
                        .font(AppTypography.serifItalic(12))
                        .foregroundStyle(muted)
                        .lineSpacing(1.2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 14)
                .padding(.trailing, 12)
                .padding(.vertical, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: AppCorners.row, style: .continuous)
                    .fill(selected ? chip : surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppCorners.row, style: .continuous)
                    .stroke(selected ? accent.opacity(0.42) : AppColors.rule(for: scheme), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(roast.displayName) roast, ratio \(roast.ratioLabel)")
        .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
    }

    private func roastName(color: Color) -> some View {
        Text(roast.displayName)
            .font(AppTypography.serif(18, weight: .medium))
            .foregroundStyle(color)
            .kerning(-0.3)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }

    private func roastDescriptor(color: Color) -> some View {
        Text("\u{2014} \(roast.shortDescriptor)")
            .font(AppTypography.serifItalic(11))
            .foregroundStyle(color)
    }

    private func ratioLabel(color: Color) -> some View {
        Text(roast.ratioLabel)
            .font(AppTypography.serifItalic(18, weight: .medium))
            .foregroundStyle(color)
            .kerning(-0.5)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
}

// MARK: - Dose input (big numeral + ruler slider)

/// What Section 02's dial edits: the dose in coffee mode, the water in water mode.
private struct DialSpec {
    let scale: RulerScale
    /// Noun for the stepper labels, as in "Increase dose".
    let noun: String
    /// VoiceOver name for the numeral and the ruler.
    let spokenName: String

    init(anchor: BrewAnchor) {
        switch anchor {
        case .coffee:
            scale = RulerScale(range: BrewModel.coffeeWeightRange, step: BrewModel.coffeeWeightStep)
            noun = "dose"
            spokenName = "Coffee dose"
        case .water:
            scale = RulerScale(range: BrewModel.waterRange, step: BrewModel.waterStep)
            noun = "water"
            spokenName = "Water amount"
        }
    }

    var rangeLabel: String {
        let low = BrewModel.formattedGrams(scale.range.lowerBound)
        let high = BrewModel.formattedGrams(scale.range.upperBound)
        return "\(low)g \u{2014} \(high)g"
    }
}

private struct DoseInput: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)
        let dial = DialSpec(anchor: brewModel.anchor)
        let amount = amountBinding
        let amountText = brewModel.formattedWeight(amount.wrappedValue)

        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .bottom) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(amountText)
                        .font(AppTypography.serif(76, weight: .regular, relativeTo: .title))
                        .foregroundStyle(ink)
                        .kerning(-3)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.snappy, value: amount.wrappedValue)
                    Text("g")
                        .font(AppTypography.serifItalic(22))
                        .foregroundStyle(muted)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(dial.spokenName)
                .accessibilityValue("\(amountText) grams")

                Spacer()

                VStack(spacing: 8) {
                    StepperButton(
                        icon: .plus,
                        spokenLabel: "Increase \(dial.noun)",
                        isDisabled: amount.wrappedValue >= dial.scale.range.upperBound
                    ) {
                        amount.wrappedValue += dial.scale.step
                    }
                    StepperButton(
                        icon: .minus,
                        spokenLabel: "Decrease \(dial.noun)",
                        isDisabled: amount.wrappedValue <= dial.scale.range.lowerBound
                    ) {
                        amount.wrappedValue -= dial.scale.step
                    }
                }
            }

            DoseRuler(value: amount, scale: dial.scale, spokenLabel: dial.spokenName)
                .padding(.top, -2)

            HStack {
                (Text("at a ratio of ")
                    .font(AppTypography.serifItalic(14))
                    .foregroundColor(muted)
                + Text(brewModel.selectedRoast.ratioLabel)
                    .font(AppTypography.serif(14, weight: .medium))
                    .foregroundColor(accent))
                Spacer()
                Text(dial.rangeLabel)
                    .font(AppTypography.kicker)
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
            }
        }
    }

    /// The dial edits the dose in coffee mode and the water in water mode.
    private var amountBinding: Binding<Double> {
        switch brewModel.anchor {
        case .coffee: $brewModel.coffeeWeight
        case .water: $brewModel.waterTarget
        }
    }
}

private struct StepperButton: View {
    let icon: InkIcon
    let spokenLabel: String
    var isDisabled: Bool = false
    let action: () -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Button(action: action) {
            InkIconView(
                icon: icon, size: 18,
                color: AppColors.ink(for: scheme), strokeWidth: 1.6
            )
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.control, style: .continuous)
                    .fill(AppColors.surface(for: scheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppCorners.control, style: .continuous)
                    .stroke(AppColors.rule(for: scheme), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.35 : 1.0)
        .accessibilityLabel(spokenLabel)
    }
}

private struct DoseRuler: View {
    @Binding var value: Double
    let scale: RulerScale
    let spokenLabel: String
    @Environment(\.colorScheme) private var scheme

    /// Every fifth tick is tall: each 5 g of coffee or 50 g of water.
    private static let majorTickInterval = 5

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let accent = AppColors.accent(for: scheme)

        GeometryReader { geo in
            let width = geo.size.width

            ZStack(alignment: .topLeading) {
                Canvas { context, size in
                    for index in 0..<scale.tickCount {
                        let isMajor = index % Self.majorTickInterval == 0
                        let tick = CGRect(
                            x: scale.x(forTick: index, width: size.width) - 0.5,
                            y: 0,
                            width: 1,
                            height: isMajor ? 18 : 9
                        )
                        context.fill(Path(tick), with: .color(ink.opacity(isMajor ? 0.85 : 0.35)))
                    }
                }
                .frame(height: 18)

                Path { path in
                    path.move(to: CGPoint(x: 0, y: 10))
                    path.addLine(to: CGPoint(x: 7, y: 0))
                    path.addLine(to: CGPoint(x: 14, y: 10))
                    path.closeSubpath()
                }
                .fill(accent)
                .frame(width: 14, height: 10)
                .offset(x: scale.x(for: value, width: width) - 7, y: -6)
                .animation(.snappy, value: value)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        guard width > 1 else { return }
                        setValue(scale.value(at: drag.location.x, width: width))
                    }
            )
        }
        .frame(height: 34)
        .accessibilityElement()
        .accessibilityLabel(spokenLabel)
        .accessibilityValue("\(BrewModel.formattedGrams(value)) grams")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: nudge(by: scale.step)
            case .decrement: nudge(by: -scale.step)
            @unknown default: break
            }
        }
    }

    private func nudge(by delta: Double) {
        setValue(BrewModel.snapped(value + delta, step: scale.step, in: scale.range))
    }

    private func setValue(_ newValue: Double) {
        guard newValue != value else { return }
        value = newValue
    }
}

// MARK: - Pour block (Total · single rule · the smaller rows)

private struct PourBlock: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CafeCard(padding: 18) {
                VStack(spacing: 0) {
                    headline

                    Rule(color: AppColors.rule(for: scheme))
                        .padding(.vertical, 14)

                    PourLine(
                        icon: .bloom,
                        label: "Bloom · 30 sec",
                        value: integer(brewModel.bloomWater),
                        unit: "g"
                    )
                    .padding(.bottom, 10)

                    PourLine(
                        icon: .spiral,
                        label: "Remaining · spiral",
                        value: integer(brewModel.remainingWater),
                        unit: "g"
                    )
                    .padding(.bottom, 10)

                    PourLine(
                        icon: .thermo,
                        label: "Water temp",
                        value: brewModel.temperatureRange,
                        unit: nil
                    )
                }
            }

            HStack {
                Text("Display in")
                    .font(AppTypography.serifItalic(13))
                    .foregroundStyle(AppColors.muted(for: scheme))
                Spacer()
                TemperatureUnitPicker(selection: $brewModel.temperatureUnit, horizontalPadding: 16)
            }
            .padding(.top, 14)
        }
    }

    /// The computed side of the ratio leads: water in coffee mode, the dose in water mode.
    @ViewBuilder
    private var headline: some View {
        switch brewModel.anchor {
        case .coffee:
            PourLine(
                icon: .v60,
                label: "Total water",
                value: integer(brewModel.totalWater),
                unit: "g",
                big: true
            )
        case .water:
            PourLine(
                icon: .beans,
                label: "Coffee dose",
                value: brewModel.formattedWeight(brewModel.coffeeWeight),
                unit: "g",
                big: true
            )
        }
    }

    private func integer(_ value: Double) -> String {
        String(Int(value.rounded()))
    }
}

private struct PourLine: View {
    let icon: InkIcon
    let label: String
    let value: String
    let unit: String?
    var big: Bool = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)

        HStack(alignment: .firstTextBaseline) {
            HStack(spacing: 12) {
                InkIconView(
                    icon: icon, size: big ? 22 : 18,
                    color: ink, strokeWidth: 1.4
                )
                Text(label)
                    .font(AppTypography.serifItalic(big ? 18 : 14))
                    .foregroundStyle(ink)
            }
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(AppTypography.serif(big ? 36 : 22, weight: .medium))
                    .foregroundStyle(ink)
                    .kerning(-1)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(.snappy, value: value)
                if let unit {
                    Text(unit)
                        .font(AppTypography.serifItalic(big ? 16 : 13))
                        .foregroundStyle(muted)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(unit == "g" ? "\(value) grams" : value)
    }
}

// MARK: - Begin brew CTA + save preset pill

private struct BeginBrewBlock: View {
    let brewModel: BrewModel
    let morningPreset: BrewPreset?
    let onSaveMorningPreset: () -> Void
    let onStartBrew: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let accent = AppColors.accent(for: scheme)
        let onAccent = AppColors.onAccent(for: scheme)

        VStack(spacing: 14) {
            Button(action: onStartBrew) {
                HStack {
                    HStack(spacing: 12) {
                        InkIconView(
                            icon: .kettle, size: 22,
                            color: onAccent, strokeWidth: 1.6
                        )
                        Text("Begin the brew")
                            .font(AppTypography.serif(18, weight: .medium))
                            .kerning(-0.2)
                            .foregroundStyle(onAccent)
                    }
                    Spacer()
                    InkIconView(
                        icon: .chevron, size: 18,
                        color: onAccent, strokeWidth: 1.8
                    )
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 22)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous)
                        .fill(accent)
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Begin the brew. Switches to the Guide tab.")
            .accessibilityIdentifier("brew.begin")

            SavePresetPill(
                isSaved: presetMatchesCurrent,
                onSave: onSaveMorningPreset
            )
        }
    }

    private var presetMatchesCurrent: Bool {
        morningPreset?.matches(brewModel.currentPreset) == true
    }
}

private struct SavePresetPill: View {
    let isSaved: Bool
    let onSave: () -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let accent = AppColors.accent(for: scheme)

        Button(action: onSave) {
            HStack(spacing: 8) {
                if isSaved {
                    InkIconView(icon: .check, size: 11, color: accent, strokeWidth: 2.2)
                    Text("Saved as my morning")
                        .foregroundStyle(accent)
                } else {
                    Text("Save as my morning")
                        .foregroundStyle(ink)
                }
            }
            .font(AppTypography.serif(13, weight: .medium))
            .kerning(-0.1)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(isSaved ? AppColors.chip(for: scheme) : AppColors.surface(for: scheme))
            )
            .overlay(
                Capsule().stroke(isSaved ? accent : AppColors.rule(for: scheme), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isSaved ? "Preset saved as my morning" : "Save as my morning preset")
        .accessibilityIdentifier("brew.savePreset")
        .animation(.snappy, value: isSaved)
    }
}
