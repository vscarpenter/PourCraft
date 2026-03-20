import SwiftUI

@main
struct PourCraftApp: App {
    @State private var brewModel = BrewModel()
    @State private var timerModel = BrewTimerModel()
    @AppStorage("selectedRoast") private var savedRoast: String = Roast.medium.rawValue
    @AppStorage("temperatureUnit") private var savedTempUnit: String = TemperatureUnit.fahrenheit.rawValue
    @Environment(\.colorScheme) private var colorScheme

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    BrewView(brewModel: brewModel)
                        .navigationTitle("PourCraft")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("PourCraft")
                                    .font(AppTypography.title)
                                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                            }
                        }
                        .toolbarBackground(AppColors.background(for: colorScheme), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                    .tabItem {
                        Label("Brew", systemImage: "cup.and.saucer")
                    }

                NavigationStack {
                    TimerView(brewModel: brewModel, timerModel: timerModel)
                        .navigationTitle("Timer")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Timer")
                                    .font(AppTypography.title)
                                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                            }
                        }
                        .toolbarBackground(AppColors.background(for: colorScheme), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                    .tabItem {
                        Label("Timer", systemImage: "timer")
                    }

                NavigationStack {
                    TipsView()
                        .navigationTitle("Tips")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Tips")
                                    .font(AppTypography.title)
                                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                            }
                        }
                        .toolbarBackground(AppColors.background(for: colorScheme), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                    .tabItem {
                        Label("Tips", systemImage: "lightbulb")
                    }

                NavigationStack {
                    AboutView()
                        .navigationTitle("About")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("About")
                                    .font(AppTypography.title)
                                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                            }
                        }
                        .toolbarBackground(AppColors.background(for: colorScheme), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
            }
            .tint(AppColors.controlTint(for: colorScheme))
            .toolbarBackground(AppColors.surface(for: colorScheme), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
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
        brewModel.restorePreferences(savedRoast: savedRoast, savedTempUnit: savedTempUnit)
    }
}
