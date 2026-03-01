import SwiftUI

@main
struct PourCraftApp: App {
    @State private var brewModel = BrewModel()
    @AppStorage("selectedRoast") private var savedRoast: String = Roast.medium.rawValue
    @AppStorage("temperatureUnit") private var savedTempUnit: String = TemperatureUnit.fahrenheit.rawValue

    var body: some Scene {
        WindowGroup {
            TabView {
                BrewView(brewModel: brewModel)
                    .tabItem {
                        Label("Brew", systemImage: "cup.and.saucer")
                    }

                TipsView()
                    .tabItem {
                        Label("Tips", systemImage: "lightbulb")
                    }

                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
            }
            .tint(AppColors.copperKettle)
            .onAppear {
                restorePreferences()
            }
            .onChange(of: brewModel.selectedRoast) { _, newValue in
                savedRoast = newValue.rawValue
            }
            .onChange(of: brewModel.temperatureUnit) { _, newValue in
                savedTempUnit = newValue.rawValue
            }
        }
    }

    private func restorePreferences() {
        if let roast = Roast(rawValue: savedRoast) {
            brewModel.selectedRoast = roast
        }
        if let unit = TemperatureUnit(rawValue: savedTempUnit) {
            brewModel.temperatureUnit = unit
        }
    }
}
