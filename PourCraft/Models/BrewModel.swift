import Foundation
import Observation
import OSLog

@Observable
final class BrewModel {
    private static let logger = Logger(subsystem: "com.pourcraft.app", category: "BrewModel")

    var selectedRoast: Roast = .medium

    // Backing store to avoid @Observable didSet infinite recursion
    private var _coffeeWeight: Double = 20

    var coffeeWeight: Double {
        get { _coffeeWeight }
        set { _coffeeWeight = min(max(newValue, 10), 60) }
    }

    var temperatureUnit: TemperatureUnit = .fahrenheit

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
            "194\u{00B0}F \u{2013} 204\u{00B0}F"
        case .celsius:
            "90\u{00B0}C \u{2013} 96\u{00B0}C"
        }
    }

    // MARK: - Brew Steps

    var brewSteps: [String] {
        let tempAdvice = temperatureUnit == .fahrenheit
            ? "200\u{00B0}F (93\u{00B0}C)"
            : "93\u{00B0}C (200\u{00B0}F)"

        return [
            "Heat water to \(tempAdvice). If no thermometer, let boiling water rest 30\u{2013}60 seconds.",
            "Place filter in dripper. Rinse with hot water to remove paper taste, then discard rinse water.",
            "Add \(formattedWeight(coffeeWeight))g of medium-ground coffee to the filter.",
            "Start timer. Pour \(formattedWeight(bloomWater))g of water evenly over grounds.",
            "Wait 30 seconds for the bloom. You\u{2019}ll see the coffee bed rise and bubble as CO\u{2082} escapes.",
            "Slowly pour remaining \(formattedWeight(remainingWater))g in a steady spiral from center outward.",
            "Total brew time target: 3:00 to 4:00 minutes.",
            "Enjoy your perfect cup!",
        ]
    }

    // MARK: - Persistence

    /// Restores preferences from raw stored values.
    /// Invalid or unrecognized values are silently ignored, keeping current defaults.
    func restorePreferences(savedRoast: String, savedTempUnit: String) {
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

