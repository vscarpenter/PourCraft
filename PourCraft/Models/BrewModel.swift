import Foundation
import Observation
import OSLog

@Observable
final class BrewModel {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.pourcraft.app",
        category: "BrewModel"
    )

    // MARK: - Ranges

    /// Coffee the dial allows in coffee mode, in grams.
    static let coffeeWeightRange: ClosedRange<Double> = 10...60
    static let coffeeWeightStep: Double = 1

    /// Water the dial allows in water mode, in grams. At every roast the
    /// derived dose stays inside `coffeeWeightRange` (11.8 g to 60 g).
    static let waterRange: ClosedRange<Double> = 200...900
    static let waterStep: Double = 10

    /// Bloom water per gram of coffee.
    static let bloomWaterPerGram: Double = 2

    var selectedRoast: Roast = .medium

    // Backing stores to avoid @Observable didSet infinite recursion
    private var _anchor: BrewAnchor = .coffee
    private var _coffeeWeight: Double = 20
    private var _waterTarget: Double = 320

    /// Which side of the ratio the user sets; the other side is derived.
    /// Switching carries the current numbers across so nothing jumps.
    var anchor: BrewAnchor {
        get { _anchor }
        set { switchAnchor(to: newValue) }
    }

    /// The dose for the current brew: the dialed-in grams in coffee mode, or
    /// water ÷ ratio rounded to 0.1 g in water mode. Setting it always
    /// updates coffee mode's dose.
    var coffeeWeight: Double {
        get {
            switch _anchor {
            case .coffee: _coffeeWeight
            case .water: Self.roundedToTenth(_waterTarget / Double(selectedRoast.ratio))
            }
        }
        set { _coffeeWeight = Self.clamped(newValue, to: Self.coffeeWeightRange) }
    }

    /// The water dialed in for water mode, kept in range on the 10 g grid.
    var waterTarget: Double {
        get { _waterTarget }
        set { _waterTarget = Self.snapped(newValue, step: Self.waterStep, in: Self.waterRange) }
    }

    var temperatureUnit: TemperatureUnit = .fahrenheit

    /// Plays haptic taps on brew-phase transitions when true. Surfaced in About → Settings.
    var hapticsEnabled: Bool = true

    /// When true, the Guide highlights the step matching the timer's current phase.
    /// When false, only manually tapped steps expand. Surfaced in About → Settings.
    var autoAdvanceSteps: Bool = true

    // MARK: - Computed Properties

    var totalWater: Double {
        switch _anchor {
        case .coffee: coffeeWeight * Double(selectedRoast.ratio)
        case .water: _waterTarget
        }
    }

    /// Twice the dose, rounded to a whole gram so bloom and remaining always
    /// add up to the total on every screen.
    var bloomWater: Double {
        (coffeeWeight * Self.bloomWaterPerGram).rounded()
    }

    var remainingWater: Double {
        totalWater - bloomWater
    }

    /// The current brew in the shape "Save as my morning" stores.
    var currentPreset: BrewPreset {
        BrewPreset(
            roast: selectedRoast,
            anchor: _anchor,
            amount: _anchor == .coffee ? _coffeeWeight : _waterTarget
        )
    }

    var temperatureRange: String {
        switch temperatureUnit {
        case .fahrenheit:
            "194\u{00B0} \u{2013} 204\u{00B0} F"
        case .celsius:
            "90\u{00B0} \u{2013} 96\u{00B0} C"
        }
    }

    /// Single-point temperature target shown in the Guide summary strip.
    var temperaturePoint: String {
        switch temperatureUnit {
        case .fahrenheit: "200\u{00B0} F"
        case .celsius: "93\u{00B0} C"
        }
    }

    // MARK: - Persistence

    /// Restores preferences from raw stored values.
    /// Invalid or unrecognized values are silently ignored, keeping current defaults.
    ///
    /// When a "Save as my morning" preset has an amount > 0 for its mode, it
    /// overrides `savedRoast` and `savedAnchor` and applies the stored amount;
    /// this is the brew the user explicitly pinned.
    func restorePreferences(
        savedRoast: String,
        savedTempUnit: String,
        savedHapticsEnabled: Bool = true,
        savedAutoAdvanceSteps: Bool = true,
        savedAnchor: String = "",
        savedPresetRoast: String = "",
        savedPresetWeight: Double = 0,
        savedPresetAnchor: String = "",
        savedPresetWater: Double = 0
    ) {
        if let roast = Roast(rawValue: savedRoast) {
            selectedRoast = roast
        } else if !savedRoast.isEmpty {
            Self.logger.warning("Ignored unrecognized saved roast: \(savedRoast, privacy: .public)")
        }

        if let unit = TemperatureUnit(rawValue: savedTempUnit) {
            temperatureUnit = unit
        } else if !savedTempUnit.isEmpty {
            Self.logger.warning("Ignored unrecognized saved temperature unit: \(savedTempUnit, privacy: .public)")
        }

        hapticsEnabled = savedHapticsEnabled
        autoAdvanceSteps = savedAutoAdvanceSteps

        // The last-used mode comes back as-is; its amount comes from the
        // preset below or the default.
        if let lastAnchor = BrewAnchor(rawValue: savedAnchor) {
            _anchor = lastAnchor
        } else if !savedAnchor.isEmpty {
            Self.logger.warning("Ignored unrecognized saved brew anchor: \(savedAnchor, privacy: .public)")
        }

        applyMorningPreset(
            storedRoast: savedPresetRoast,
            storedAnchor: savedPresetAnchor,
            coffeeGrams: savedPresetWeight,
            waterGrams: savedPresetWater
        )
    }

    /// Morning preset wins over the generic saved roast and mode when its
    /// amount is valid. Presets saved before water mode existed have no
    /// anchor and load as coffee-first.
    private func applyMorningPreset(
        storedRoast: String,
        storedAnchor: String,
        coffeeGrams: Double,
        waterGrams: Double
    ) {
        let presetAnchor = BrewAnchor(rawValue: storedAnchor) ?? .coffee
        if BrewAnchor(rawValue: storedAnchor) == nil, !storedAnchor.isEmpty {
            Self.logger.warning("Ignored unrecognized saved preset anchor: \(storedAnchor, privacy: .public)")
        }

        let amount = presetAnchor == .coffee ? coffeeGrams : waterGrams
        guard amount > 0 else { return }

        if let presetRoast = Roast(rawValue: storedRoast) {
            selectedRoast = presetRoast
        } else if !storedRoast.isEmpty {
            Self.logger.warning("Ignored unrecognized saved preset roast: \(storedRoast, privacy: .public)")
        }

        _anchor = presetAnchor
        switch presetAnchor {
        case .coffee: coffeeWeight = amount
        case .water: waterTarget = amount
        }
    }

    // MARK: - Mode switching

    private func switchAnchor(to newAnchor: BrewAnchor) {
        guard newAnchor != _anchor else { return }
        switch newAnchor {
        case .water:
            // Start water mode at the water the current dose calls for.
            waterTarget = totalWater
        case .coffee:
            // Return to coffee mode at the dose water mode was showing.
            coffeeWeight = Self.snapped(coffeeWeight, step: Self.coffeeWeightStep, in: Self.coffeeWeightRange)
        }
        _anchor = newAnchor
    }

    // MARK: - Helpers

    /// Rounds to the nearest multiple of `step`, then clamps to `range`.
    static func snapped(_ value: Double, step: Double, in range: ClosedRange<Double>) -> Double {
        clamped((value / step).rounded() * step, to: range)
    }

    static func clamped(_ value: Double, to range: ClosedRange<Double>) -> Double {
        min(max(value, range.lowerBound), range.upperBound)
    }

    /// One decimal place: the precision a coffee scale shows.
    static func roundedToTenth(_ value: Double) -> Double {
        (value * 10).rounded() / 10
    }

    /// Grams for display: whole numbers without a decimal, anything else to
    /// one place, with the locale's decimal separator and no grouping.
    static func formattedGrams(_ value: Double, locale: Locale = .current) -> String {
        value.formatted(
            .number
                .locale(locale)
                .grouping(.never)
                .precision(.fractionLength(0...1))
        )
    }

    func formattedWeight(_ value: Double, locale: Locale = .current) -> String {
        Self.formattedGrams(value, locale: locale)
    }
}

// MARK: - BrewAnchor

/// Which side of the ratio the user sets on the Brew tab.
enum BrewAnchor: String, CaseIterable, Codable {
    case coffee
    case water

    var label: String {
        switch self {
        case .coffee: "Coffee"
        case .water: "Water"
        }
    }
}

// MARK: - BrewPreset

/// The brew "Save as my morning" pins: roast, mode, and the amount the user set.
struct BrewPreset: Equatable {
    let roast: Roast
    let anchor: BrewAnchor
    /// Coffee grams for a coffee-first preset, water grams for a water-first one.
    let amount: Double

    /// Amounts compare within 0.05 g, so floating-point noise never breaks a
    /// match while 35.3 g and 35.9 g stay distinct.
    func matches(_ other: BrewPreset) -> Bool {
        roast == other.roast && anchor == other.anchor && abs(amount - other.amount) < 0.05
    }
}

extension BrewPreset {
    /// Rebuilds a saved preset from its raw stored values, or nil when none is
    /// saved. Presets saved before water mode existed load as coffee-first.
    init?(storedRoast: String, storedAnchor: String, coffeeGrams: Double, waterGrams: Double) {
        guard let roast = Roast(rawValue: storedRoast) else { return nil }
        let anchor = BrewAnchor(rawValue: storedAnchor) ?? .coffee
        let amount = anchor == .coffee ? coffeeGrams : waterGrams
        guard amount > 0 else { return nil }
        self.init(roast: roast, anchor: anchor, amount: amount)
    }
}

// MARK: - TemperatureUnit

enum TemperatureUnit: String, CaseIterable, Codable {
    case fahrenheit
    case celsius

    var label: String {
        switch self {
        case .fahrenheit: "\u{00B0}F"
        case .celsius: "\u{00B0}C"
        }
    }
}
