import SwiftUI

/// The Brew tab — magazine-style calculator. Three numbered sections
/// (roast, dose, the pour) plus a "Begin the brew" CTA that jumps to Guide.
struct BrewView: View {
    @Bindable var brewModel: BrewModel
    let onStartBrew: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Masthead(subtitle: "A calculator, set in type.") {
                    HStack(spacing: 0) {
                        Text("The ")
                        Text("Pour")
                            .italic()
                            .foregroundStyle(AppColors.accent(for: scheme))
                    }
                }

                ZineSection(number: "01", title: "Choose your roast.", kicker: "Three options") {
                    RoastList(brewModel: brewModel)
                }
                .padding(.top, 22)

                ZineSection(number: "02", title: "Dial in the dose.", kicker: "Grams") {
                    DoseInput(brewModel: brewModel)
                }
                .padding(.top, 28)

                ZineSection(number: "03", title: "The pour, by weight.", kicker: "Computed") {
                    PourBlock(brewModel: brewModel)
                }
                .padding(.top, 28)

                BeginBrewBlock(brewModel: brewModel, onStartBrew: onStartBrew)
                    .padding(.top, 28)
                    .padding(.horizontal, 24)

                Color.clear.frame(height: 24)
            }
        }
        .background(AppColors.background(for: scheme))
    }
}

// MARK: - Roast list (chip-tinted rows, 3px copper ruler-mark when selected)

private struct RoastList: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 0) {
            Rule(color: AppColors.rule(for: scheme))
            ForEach(Roast.allCases) { roast in
                RoastRow(roast: roast, brewModel: brewModel)
                Rule(color: AppColors.rule(for: scheme))
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

        Button {
            withAnimation(.snappy) {
                brewModel.selectedRoast = roast
            }
        } label: {
            HStack(alignment: .top, spacing: 0) {
                // 3px copper ruler-mark on the left edge — present always so
                // text alignment doesn't shift, copper only when selected.
                Rectangle()
                    .fill(selected ? accent : .clear)
                    .frame(width: 3)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(roast.displayName)
                            .font(AppTypography.serif(22, weight: .medium))
                            .foregroundStyle(ink)
                            .kerning(-0.3)

                        Text("\u{2014} \(roast.shortDescriptor)")
                            .font(AppTypography.serifItalic(13))
                            .foregroundStyle(muted)

                        Spacer(minLength: 8)

                        Text(roast.ratioLabel)
                            .font(AppTypography.serifItalic(22, weight: .medium))
                            .foregroundStyle(selected ? accent : ink)
                            .kerning(-0.5)
                    }

                    if selected {
                        Text(roast.flavorProfile)
                            .font(AppTypography.sans(.caption))
                            .foregroundStyle(muted)
                            .lineSpacing(1.45)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.opacity)
                    }
                }
                .padding(.leading, 14)
                .padding(.trailing, 4)
                .padding(.vertical, 14)
            }
            .background(selected ? chip : .clear)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(roast.displayName) roast, ratio \(roast.ratioLabel)")
        .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
    }
}

// MARK: - Dose input (big numeral + ruler slider)

private struct DoseInput: View {
    @Bindable var brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .bottom) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(Int(brewModel.coffeeWeight))")
                        .font(AppTypography.serif(96, weight: .regular))
                        .foregroundStyle(ink)
                        .kerning(-4)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.snappy, value: brewModel.coffeeWeight)
                    Text("g")
                        .font(AppTypography.serifItalic(22))
                        .foregroundStyle(muted)
                }

                Spacer()

                VStack(spacing: 8) {
                    StepperButton(icon: .plus, isDisabled: brewModel.coffeeWeight >= 60) {
                        brewModel.coffeeWeight += 1
                    }
                    StepperButton(icon: .minus, isDisabled: brewModel.coffeeWeight <= 10) {
                        brewModel.coffeeWeight -= 1
                    }
                }
            }

            DoseRuler(value: $brewModel.coffeeWeight)

            HStack {
                (Text("at a ratio of ")
                    .font(AppTypography.serifItalic(14))
                    .foregroundColor(muted)
                + Text(brewModel.selectedRoast.ratioLabel)
                    .font(AppTypography.serif(14, weight: .medium))
                    .foregroundColor(accent))
                Spacer()
                Text("10g \u{2014} 60g")
                    .font(AppTypography.kicker)
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(muted)
            }
        }
    }
}

private struct StepperButton: View {
    let icon: InkIcon
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
                Circle().strokeBorder(AppColors.ink(for: scheme), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.35 : 1.0)
        .accessibilityLabel(icon == .plus ? "Increase dose" : "Decrease dose")
    }
}

private struct DoseRuler: View {
    @Binding var value: Double
    @Environment(\.colorScheme) private var scheme

    private let minValue: Double = 10
    private let maxValue: Double = 60

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
        let accent = AppColors.accent(for: scheme)

        GeometryReader { geo in
            let range = maxValue - minValue
            let pct = (value - minValue) / range
            let markerX = pct * geo.size.width

            ZStack(alignment: .topLeading) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(stride(from: 10, through: 60, by: 1)), id: \.self) { tick in
                        let isMajor = tick % 5 == 0
                        Rectangle()
                            .fill(ink.opacity(isMajor ? 0.85 : 0.35))
                            .frame(width: 1, height: isMajor ? 18 : 9)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(height: 18, alignment: .top)

                HStack {
                    ForEach([10, 20, 30, 40, 50, 60], id: \.self) { value in
                        if value != 10 { Spacer() }
                        Text("\(value)")
                            .font(AppTypography.sans(.caption2, weight: .semibold))
                            .foregroundStyle(muted)
                    }
                }
                .padding(.top, 22)

                Path { p in
                    p.move(to: CGPoint(x: 0, y: 10))
                    p.addLine(to: CGPoint(x: 7, y: 0))
                    p.addLine(to: CGPoint(x: 14, y: 10))
                    p.closeSubpath()
                }
                .fill(accent)
                .frame(width: 14, height: 10)
                .offset(x: markerX - 7, y: -6)
                .animation(.snappy, value: value)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        let clampedX = max(0, min(geo.size.width, drag.location.x))
                        let newPct = clampedX / geo.size.width
                        value = (minValue + newPct * range).rounded()
                    }
            )
        }
        .frame(height: 50)
        .accessibilityElement()
        .accessibilityLabel("Coffee dose")
        .accessibilityValue("\(Int(value)) grams")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: value += 1
            case .decrement: value -= 1
            @unknown default: break
            }
        }
    }
}

// MARK: - Pour block (Total · single rule · the smaller rows)

private struct PourBlock: View {
    let brewModel: BrewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
                PourLine(
                    icon: .v60,
                    label: "Total water",
                    value: integer(brewModel.totalWater),
                    unit: "g",
                    big: true
                )

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
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
            .background(AppColors.surface(for: scheme))
            .overlay(
                Rectangle().stroke(AppColors.rule(for: scheme), lineWidth: 1)
            )

            HStack {
                Text("Display in")
                    .font(AppTypography.serifItalic(13))
                    .foregroundStyle(AppColors.muted(for: scheme))
                Spacer()
                TempUnitToggle(brewModel: brewModel)
            }
            .padding(.top, 16)
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
        .accessibilityElement(children: .combine)
    }
}

private struct TempUnitToggle: View {
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
                    Text(unit.toggleLabel)
                        .font(AppTypography.sans(.caption, weight: .semibold))
                        .tracking(1)
                        .foregroundStyle(selected ? bg : ink)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(selected ? ink : .clear)
                }
                .buttonStyle(.plain)
            }
        }
        .overlay(Capsule().stroke(ink, lineWidth: 1))
        .clipShape(Capsule())
    }
}

private extension TemperatureUnit {
    var toggleLabel: String {
        switch self {
        case .fahrenheit: "\u{00B0}F"
        case .celsius: "\u{00B0}C"
        }
    }
}

// MARK: - Begin brew CTA + save preset pill

private struct BeginBrewBlock: View {
    let brewModel: BrewModel
    let onStartBrew: () -> Void

    @Environment(\.colorScheme) private var scheme
    @AppStorage("savedPresetRoast") private var savedPresetRoast: String = ""
    @AppStorage("savedPresetWeight") private var savedPresetWeight: Double = 0

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
                .background(Rectangle().fill(accent))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Begin the brew. Switches to the Guide tab.")

            SavePresetPill(
                isSaved: presetMatchesCurrent,
                onSave: savePreset
            )
        }
    }

    private var presetMatchesCurrent: Bool {
        savedPresetRoast == brewModel.selectedRoast.rawValue
            && Int(savedPresetWeight) == Int(brewModel.coffeeWeight)
    }

    private func savePreset() {
        savedPresetRoast = brewModel.selectedRoast.rawValue
        savedPresetWeight = brewModel.coffeeWeight
    }
}

private struct SavePresetPill: View {
    let isSaved: Bool
    let onSave: () -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let ink = AppColors.ink(for: scheme)
        let muted = AppColors.muted(for: scheme)
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
            .overlay(
                Capsule().stroke(isSaved ? accent : muted, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isSaved ? "Preset saved as my morning" : "Save as my morning preset")
        .animation(.snappy, value: isSaved)
    }
}
