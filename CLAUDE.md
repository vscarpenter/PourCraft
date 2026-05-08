# PourCraft

Pour-over coffee ratio calculator for iOS. Editorial Zine visual identity —
magazine masthead, Fraunces serif, copper accents, hand-drawn ink iconography.

## Tech Stack

- **Platform:** iOS 17+ (SwiftUI), portrait only
- **Language:** Swift 5.9 (avoids Swift 6 strict concurrency)
- **Architecture:** MVVM with `@Observable` (iOS 17 Observation framework)
- **Build System:** XcodeGen v2.44.1 (`project.yml` → `PourCraft.xcodeproj`)
- **Testing:** Swift Testing framework (`import Testing`, `@Test`, `#expect`)
- **Xcode:** 16.0+
- **Bundled type:** Fraunces variable font (regular + italic) under SIL OFL,
  loaded via `UIAppFonts` in `Info.plist`. UI sans is the system font.

## Build & Test Commands

```bash
# Generate Xcode project (run after modifying project.yml or adding/removing files)
xcodegen generate

# Build (substitute any iOS 17+ simulator id)
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,id=0662D10D-5AF9-47F2-B95D-850614D405A3' build

# Test (100 tests across 8 suites)
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,id=0662D10D-5AF9-47F2-B95D-850614D405A3' test

# If simulator plugin fails, run first:
xcodebuild -runFirstLaunch
```

`0662D10D...` is iPhone 17 (iOS 26.4). Pick whatever simulator you have with
`xcrun simctl list devices available iOS` if that id is gone.

## Project Structure

```
PourCraft/
├── project.yml                      # XcodeGen spec (source of truth for .xcodeproj)
├── CLAUDE.md
├── pour-over-app-brief.md           # Original product spec (pre-zine)
├── coding-standards.md              # Code quality and agentic workflow guidelines
├── pourcraft-coffee-handoff/        # Editorial Zine handoff bundle (HTML/JSX prototypes)
├── PourCraft/
│   ├── PourCraftApp.swift           # @main, custom 4-tab shell, @AppStorage persistence
│   ├── Info.plist                   # UIAppFonts (Fraunces) + UILaunchScreen (LaunchIcon)
│   ├── Models/
│   │   ├── BrewModel.swift          # @Observable: roast, weight, temp unit, computed water
│   │   ├── BrewTimerModel.swift     # @Observable: live brew timer (ready/bloom/pour/drawdown/done)
│   │   ├── BrewStep.swift           # 8 guide steps derived from BrewModel + timer phase
│   │   ├── BrewTip.swift            # 8 magazine field-notes (title, dek, body[], pull, refs[])
│   │   └── Roast.swift              # enum: light/medium/dark with ratio + flavor + short descriptor
│   ├── Views/
│   │   ├── BrewView.swift           # Brew tab: masthead + 3 numbered sections + ruler slider + CTA
│   │   ├── GuideView.swift          # Guide tab: recipe summary + live timer + 8 expandable steps
│   │   ├── TipsView.swift           # Tips tab: TOC list, pushes TipDetailView
│   │   ├── TipDetailView.swift      # Article: 140pt numeral, drop cap, pull quote, references
│   │   ├── AboutView.swift          # Colophon: manifesto, by-the-numbers, masthead credits, prefs
│   │   ├── ZineComponents.swift     # Masthead, SubHeader, ZineSection, SectionHeader, Rule
│   │   └── ZineTabBar.swift         # Custom 4-tab bar (Brew / Guide / Tips / About)
│   ├── Theme/
│   │   ├── Colors.swift             # AppColors: zine palette + adaptive light/dark helpers
│   │   ├── Typography.swift         # AppTypography: Fraunces serif + system sans, Dynamic Type aware
│   │   ├── InkIcons.swift           # 15 hand-drawn icons rendered as SwiftUI Canvas paths
│   │   └── ZineEdition.swift        # Randomized vol/issue/cups for the masthead chrome
│   ├── Extensions/
│   │   └── Color+Hex.swift          # Color(hex:) initializer
│   ├── Resources/
│   │   └── Fonts/                   # Fraunces[opsz,wght].ttf + Fraunces-Italic[opsz,wght].ttf + OFL.txt
│   ├── PrivacyInfo.xcprivacy        # App Store privacy manifest (UserDefaults declaration)
│   └── Assets.xcassets/             # AppIcon (single 1024 universal), LaunchIcon, AccentColor, LaunchBackground
└── PourCraftTests/
    ├── RoastTests.swift             # 7 tests: cases, ratios, labels, Codable, flavors, names, short descriptor
    ├── BrewModelTests.swift         # 24 tests: defaults, reference table, bloom, clamping, formatting, persistence, temp point
    ├── BrewStepTests.swift          # 7 tests: 8-step generation, dynamic weights, phase mapping
    ├── BrewTimerModelTests.swift    # 27 tests: phase transitions, pause/resume, wall-clock sync
    ├── BrewTipTests.swift           # 9 tests: count, schema completeness, body length, refs, lookup, wraparound
    ├── ZineEditionTests.swift       # 5 tests: month derivation, randomization formatting, determinism
    ├── ColorHexTests.swift          # 9 tests: valid/invalid hex parsing, whitespace, empty input
    └── AppColorsTests.swift         # 5 tests: adaptive helpers, palette tokens, derived rule color
```

## Architecture Decisions

### Tab structure
- Custom `ZineTabBar` (not SwiftUI's `TabView`). Selected tab is `@State` in
  `PourCraftApp`; "Begin the brew" CTA on Brew swaps to Guide via that binding.
- Tips uses an inner `NavigationStack` to push `TipDetailView`.

### State management
- Single `BrewModel` and `BrewTimerModel` instances created with `@State` in
  `PourCraftApp`. Brew owns the calculator state; Guide reuses both.
- `@AppStorage` persistence at app level; restore via
  `BrewModel.restorePreferences()` for testability.
- `os.Logger` warns when invalid saved values are silently ignored.

### @Observable + didSet = infinite recursion
**Critical:** Never reassign a property to itself inside `didSet` on
`@Observable`. The macro wraps setters with `withMutation(keyPath:)` →
recursive setter calls → stack overflow.

```swift
// WRONG
var coffeeWeight: Double = 20 {
    didSet { coffeeWeight = min(max(coffeeWeight, 10), 60) }
}

// CORRECT — private backing store
private var _coffeeWeight: Double = 20
var coffeeWeight: Double {
    get { _coffeeWeight }
    set { _coffeeWeight = min(max(newValue, 10), 60) }
}
```

### Typography & Dynamic Type
- All `Font.custom(_, size:)` callers use `relativeTo:` so Fraunces scales with
  Dynamic Type. Display sizes (masthead 56pt, sub-page 44pt, dose 96pt) are
  anchored to `.title`/`.title2` so they scale gently rather than blowing past
  layouts at AX5.
- System sans uses `Font.system(.caption2, design: .default)` style anchors —
  `Font.system(size:)` does NOT scale, so avoid it.

### Editorial chrome
- `ZineEdition.current` randomizes Vol/Issue/Cups Poured once at app launch
  (`SystemRandomNumberGenerator`). Month comes from `Date()`. Stable for the
  session; refreshed each cold start.

### Design system
- Colors live in `AppColors` (code, not asset catalog) with light/dark adaptive
  helpers. Palette: bg `#FBF3E5`, ink `#2A1F1B`, accent copper `#B87333`.
- Hand-drawn ink icons are SwiftUI `Path`s rendered into a `Canvas`, scaled
  from a 24×24 unit space to the requested size.

### iOS 17 compatibility
- Uses `@Bindable` for `@Observable` bindings.
- Uses `.contentTransition(.numericText())` for animated number changes.

## Coffee Ratio Reference

| Roast  | Ratio | 15g  | 20g  | 25g  | 30g  |
|--------|-------|------|------|------|------|
| Dark   | 1:15  | 225g | 300g | 375g | 450g |
| Medium | 1:16  | 240g | 320g | 400g | 480g |
| Light  | 1:17  | 255g | 340g | 425g | 510g |

Bloom water = 2× coffee weight. Coffee weight range: 10–60g, default 20g.
Brew timer target: 3:30 total (30s bloom, 60% of remaining for pour, rest drawdown).

## Adding New Files

1. Create the `.swift` file in the appropriate directory.
2. Run `xcodegen generate` to regenerate the `.xcodeproj`.
3. XcodeGen auto-discovers all `.swift` files under `PourCraft/` and
   `PourCraftTests/`. Resources under `PourCraft/Resources/` are auto-included.

## Future Features (not yet implemented)

- Brew history / journal
- Custom ratio input
- Multiple brew methods (Chemex, Kalita Wave)
- Haptic feedback on phase transitions
- Apple Watch companion
