# PourCraft

Pour-over coffee ratio calculator for iOS.

## Tech Stack

- **Platform:** iOS 17+ (SwiftUI)
- **Language:** Swift 5.9 (avoids Swift 6 strict concurrency)
- **Architecture:** MVVM with `@Observable` (iOS 17 Observation framework)
- **Build System:** XcodeGen v2.44.1 (`project.yml` → `PourCraft.xcodeproj`)
- **Testing:** Swift Testing framework (`import Testing`, `@Test`, `#expect`)
- **Xcode:** 16.0+

## Build & Test Commands

```bash
# Generate Xcode project (run after modifying project.yml or adding/removing files)
xcodegen generate

# Build
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,id=82110447-07A1-44C5-B549-B9ECAB6174CE' build

# Test (57 tests across 5 suites)
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,id=82110447-07A1-44C5-B549-B9ECAB6174CE' test

# If simulator plugin fails, run first:
xcodebuild -runFirstLaunch
```

The simulator ID `82110447...` is iPhone 16 (iOS 18.5). If unavailable, use any iOS 17+ simulator.

## Project Structure

```
PourCraft/
├── project.yml                    # XcodeGen spec (source of truth for .xcodeproj)
├── CLAUDE.md
├── pour-over-app-brief.md         # Product spec with colors, ratios, tip text
├── coding-standards.md            # Code quality and agentic workflow guidelines
├── PourCraft/
│   ├── PourCraftApp.swift         # @main entry, TabView, @AppStorage persistence
│   ├── Info.plist
│   ├── Models/
│   │   ├── BrewModel.swift        # @Observable: selectedRoast, coffeeWeight, computed water values, restorePreferences
│   │   ├── Roast.swift            # enum: light/medium/dark with ratio, flavor, color
│   │   └── BrewTip.swift          # struct with static allTips array (8 tips)
│   ├── Views/
│   │   ├── BrewView.swift         # Main Brew tab: roast cards + weight input + results
│   │   ├── RoastSelectionCard.swift
│   │   ├── CoffeeWeightInput.swift
│   │   ├── BrewResultsView.swift  # Calculated values + 8-step brew guide
│   │   ├── TipsView.swift         # Tips tab
│   │   ├── TipCard.swift          # Expandable tip with spring animation
│   │   └── AboutView.swift        # About tab
│   ├── Theme/
│   │   ├── Colors.swift           # AppColors enum: all palette colors + adaptive helpers
│   │   └── Typography.swift       # AppTypography enum: serif display + sans body fonts
│   ├── Extensions/
│   │   └── Color+Hex.swift        # Color(hex:) initializer
│   ├── PrivacyInfo.xcprivacy      # App Store privacy manifest (UserDefaults declaration)
│   └── Assets.xcassets/           # AccentColor (copper #B87333) + empty AppIcon
└── PourCraftTests/
    ├── RoastTests.swift           # 6 tests: cases, ratios, labels, Codable, flavors, names
    ├── BrewModelTests.swift       # 29 tests: defaults, reference table, bloom, clamping, formatting, persistence
    ├── ColorHexTests.swift        # 9 tests: valid/invalid hex parsing, whitespace, empty input
    ├── BrewTipTests.swift         # 6 tests: tip count, unique IDs, non-empty fields, sequential IDs
    └── AppColorsTests.swift       # 7 tests: adaptive color helpers for light/dark mode
```

## Architecture Decisions

### State Management
- Single `BrewModel` instance created with `@State` in `PourCraftApp`
- Passed explicitly to `BrewView` (only the Brew tab needs it)
- `@AppStorage` persistence lives at app level; restore logic in `BrewModel.restorePreferences()` for testability
- `.onChange` modifiers sync `selectedRoast` and `temperatureUnit` to UserDefaults

### @Observable Pattern: Avoid didSet Recursion
**Critical:** Never reassign a property to itself inside `didSet` on an `@Observable` class. The macro wraps setters with `withMutation(keyPath:)`, causing infinite recursion and a stack overflow crash.

**Pattern used for clamped values:**
```swift
// WRONG - causes infinite recursion
var coffeeWeight: Double = 20 {
    didSet { coffeeWeight = min(max(coffeeWeight, 10), 60) }
}

// CORRECT - private backing store
private var _coffeeWeight: Double = 20
var coffeeWeight: Double {
    get { _coffeeWeight }
    set { _coffeeWeight = min(max(newValue, 10), 60) }
}
```

### Design System
- Colors are code-based via `AppColors.background(for: colorScheme)` adaptive helpers
- Not using asset catalog color sets (managed through XcodeGen, no Xcode GUI)
- Typography uses `Font.system(.largeTitle, design: .serif, weight: .bold)` for warm serif headers
- Cards: 16pt corner radius, soft shadows, copper accent on selection

### iOS 17 Compatibility
- Uses `.tabItem { Label(...) }` (not iOS 18's `Tab` type)
- Uses `@Bindable` for creating bindings to `@Observable` properties
- Uses `.contentTransition(.numericText())` for animated number changes

## Coffee Ratio Reference

| Roast  | Ratio | 15g  | 20g  | 25g  | 30g  |
|--------|-------|------|------|------|------|
| Dark   | 1:15  | 225g | 300g | 375g | 450g |
| Medium | 1:16  | 240g | 320g | 400g | 480g |
| Light  | 1:17  | 255g | 340g | 425g | 510g |

Bloom water = 2x coffee weight. Coffee weight range: 10-60g, default 20g.

## Adding New Files

1. Create the `.swift` file in the appropriate directory
2. Run `xcodegen generate` to regenerate the `.xcodeproj`
3. XcodeGen auto-discovers all `.swift` files under `PourCraft/` and `PourCraftTests/`

## Future Features (not yet implemented)

- Brew timer with guided pour intervals
- Brew history / journal
- Custom ratio input
- Multiple brew methods (Chemex, V60, Kalita Wave)
- Apple Watch companion
