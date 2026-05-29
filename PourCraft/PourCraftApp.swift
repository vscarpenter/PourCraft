import SwiftUI

@main
struct PourCraftApp: App {
    @State private var brewModel = BrewModel()
    @State private var timerModel = BrewTimerModel()
    @State private var selectedTab: ZineTab = .brew

    @AppStorage("selectedRoast") private var savedRoast: String = Roast.medium.rawValue
    @AppStorage("temperatureUnit") private var savedTempUnit: String = TemperatureUnit.fahrenheit.rawValue
    @AppStorage("hapticsEnabled") private var savedHapticsEnabled: Bool = true
    @AppStorage("autoAdvanceSteps") private var savedAutoAdvanceSteps: Bool = true
    @AppStorage("savedPresetRoast") private var savedPresetRoast: String = ""
    @AppStorage("savedPresetWeight") private var savedPresetWeight: Double = 0

    @Environment(\.colorScheme) private var colorScheme

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                AppColors.background(for: colorScheme)
                    .ignoresSafeArea()

                tabContent
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        ZineTabBar(selection: $selectedTab)
                    }
            }
            .preferredColorScheme(nil) // honor system; explicit for clarity
            .onAppear {
                brewModel.restorePreferences(
                    savedRoast: savedRoast,
                    savedTempUnit: savedTempUnit,
                    savedHapticsEnabled: savedHapticsEnabled,
                    savedAutoAdvanceSteps: savedAutoAdvanceSteps,
                    savedPresetRoast: savedPresetRoast,
                    savedPresetWeight: savedPresetWeight
                )
            }
            .onChange(of: brewModel.selectedRoast) { _, newValue in
                savedRoast = newValue.rawValue
            }
            .onChange(of: brewModel.temperatureUnit) { _, newValue in
                savedTempUnit = newValue.rawValue
            }
            .onChange(of: brewModel.hapticsEnabled) { _, newValue in
                savedHapticsEnabled = newValue
            }
            .onChange(of: brewModel.autoAdvanceSteps) { _, newValue in
                savedAutoAdvanceSteps = newValue
            }
        }
    }

    private var tabContent: some View {
        TabView(selection: $selectedTab) {
            BrewView(
                brewModel: brewModel,
                morningPreset: morningPreset,
                onSaveMorningPreset: saveMorningPreset
            ) {
                withAnimation(.snappy) { selectedTab = .guide }
            }
            .tag(ZineTab.brew)
            .tabItem { Label(ZineTab.brew.label, systemImage: ZineTab.brew.symbol) }

            GuideView(brewModel: brewModel, timerModel: timerModel)
                .tag(ZineTab.guide)
                .tabItem { Label(ZineTab.guide.label, systemImage: ZineTab.guide.symbol) }

            TipsView()
                .tag(ZineTab.tips)
                .tabItem { Label(ZineTab.tips.label, systemImage: ZineTab.tips.symbol) }

            AboutView(brewModel: brewModel)
                .tag(ZineTab.about)
                .tabItem { Label(ZineTab.about.label, systemImage: ZineTab.about.symbol) }
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private var morningPreset: BrewPreset? {
        guard savedPresetWeight > 0, let roast = Roast(rawValue: savedPresetRoast) else {
            return nil
        }
        return BrewPreset(roast: roast, coffeeWeight: savedPresetWeight)
    }

    private func saveMorningPreset() {
        savedPresetRoast = brewModel.selectedRoast.rawValue
        savedPresetWeight = brewModel.coffeeWeight
    }
}
