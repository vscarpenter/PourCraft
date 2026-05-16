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

                content
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

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .brew:
            BrewView(brewModel: brewModel) {
                withAnimation(.snappy) { selectedTab = .guide }
            }
        case .guide:
            GuideView(brewModel: brewModel, timerModel: timerModel)
        case .tips:
            TipsView()
        case .about:
            AboutView(brewModel: brewModel)
        }
    }
}
