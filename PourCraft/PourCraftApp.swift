import SwiftUI

@main
struct PourCraftApp: App {
    @State private var brewModel = BrewModel()
    @State private var timerModel = BrewTimerModel()
    @State private var selectedTab: ZineTab = .brew
    @State private var selectedTip: BrewTip = BrewTip.allTips[0]

    @AppStorage("selectedRoast") private var savedRoast: String = Roast.medium.rawValue
    @AppStorage("temperatureUnit") private var savedTempUnit: String = TemperatureUnit.fahrenheit.rawValue
    @AppStorage("hapticsEnabled") private var savedHapticsEnabled: Bool = true
    @AppStorage("autoAdvanceSteps") private var savedAutoAdvanceSteps: Bool = true
    @AppStorage("savedPresetRoast") private var savedPresetRoast: String = ""
    @AppStorage("savedPresetWeight") private var savedPresetWeight: Double = 0

    @Environment(\.colorScheme) private var colorScheme

    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                let usesWideLayout = AppLayout.usesWideLayout(width: proxy.size.width)

                Group {
                    if usesWideLayout {
                        iPadShell(width: proxy.size.width)
                    } else {
                        iPhoneShell
                    }
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

    private var iPhoneShell: some View {
        ZStack(alignment: .bottom) {
            AppColors.background(for: colorScheme)
                .ignoresSafeArea()

            tabContent
                .environment(\.zineBottomScrollPadding, AppLayout.bottomScrollPadding)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    ZineTabBar(selection: $selectedTab)
                }

            GeometryReader { proxy in
                AppColors.background(for: colorScheme)
                    .frame(height: proxy.safeAreaInsets.top)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(edges: .top)
                    .allowsHitTesting(false)
            }
        }
    }

    private func iPadShell(width: CGFloat) -> some View {
        HStack(spacing: 0) {
            ZineSidebar(selection: $selectedTab)
                .frame(width: AppLayout.sidebarWidth(for: width))

            Rectangle()
                .fill(AppColors.rule(for: colorScheme))
                .frame(width: 1)
                .ignoresSafeArea(edges: .vertical)

            tabContent
                .environment(\.zineBottomScrollPadding, AppLayout.iPadScrollPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(AppColors.background(for: colorScheme).ignoresSafeArea())
    }

    private var tabContent: some View {
        Group {
            switch selectedTab {
            case .brew:
                BrewView(
                    brewModel: brewModel,
                    morningPreset: morningPreset,
                    onSaveMorningPreset: saveMorningPreset
                ) {
                    withAnimation(.snappy) { selectedTab = .guide }
                }
            case .guide:
                GuideView(brewModel: brewModel, timerModel: timerModel)
            case .tips:
                TipsView(selectedTip: $selectedTip)
            case .about:
                AboutView(brewModel: brewModel)
            }
        }
        .animation(.snappy, value: selectedTab)
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
