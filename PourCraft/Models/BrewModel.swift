import Foundation
import Observation
import OSLog

@Observable
final class BrewModel {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.pourcraft.app",
        category: "BrewModel"
    )

    var selectedRoast: Roast = .medium

    // Backing store to avoid @Observable didSet infinite recursion
    private var _coffeeWeight: Double = 20

    var coffeeWeight: Double {
        get { _coffeeWeight }
        set { _coffeeWeight = min(max(newValue, 10), 60) }
    }

    var temperatureUnit: TemperatureUnit = .fahrenheit

    /// Plays haptic taps on brew-phase transitions when true. Surfaced in About → Settings.
    var hapticsEnabled: Bool = true

    /// When true, the Guide highlights the step matching the timer's current phase.
    /// When false, only manually tapped steps expand. Surfaced in About → Settings.
    var autoAdvanceSteps: Bool = true

    // MARK: - Computed Properties

    var totalWater: Double {
        coffeeWeight * Double(selectedRoast.ratio)
    }

    var bloomWater: Double {
        coffeeWeight * 2
    }

    var remainingWater: Double {
        totalWater - bloomWater
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
    /// When a "Save as my morning" preset is present (`savedPresetRoast` non-empty
    /// and `savedPresetWeight` > 0), it overrides `savedRoast` and applies the
    /// stored coffee weight — this is the brew the user explicitly pinned.
    func restorePreferences(
        savedRoast: String,
        savedTempUnit: String,
        savedHapticsEnabled: Bool = true,
        savedAutoAdvanceSteps: Bool = true,
        savedPresetRoast: String = "",
        savedPresetWeight: Double = 0
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

        // Morning preset wins over the generic saved roast when both are valid.
        if savedPresetWeight > 0 {
            if let presetRoast = Roast(rawValue: savedPresetRoast) {
                selectedRoast = presetRoast
            } else if !savedPresetRoast.isEmpty {
                Self.logger.warning("Ignored unrecognized saved preset roast: \(savedPresetRoast, privacy: .public)")
            }
            coffeeWeight = savedPresetWeight
        }
    }

    // MARK: - Helpers

    func formattedWeight(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", value)
            : String(format: "%.1f", value)
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

