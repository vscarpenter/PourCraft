# PourCraft

**Perfect Pour-Over, Every Time.**

PourCraft is a native iOS app that helps pour-over coffee enthusiasts calculate the ideal coffee-to-water ratio. Select your roast, dial in your coffee weight, and get precise water amounts — plus a step-by-step brew guide you can follow while you pour.

## Features

- **Roast-specific ratios** — Light (1:17), Medium (1:16), and Dark (1:15) with flavor descriptions
- **Live calculation** — Total water, bloom water, and remaining pour update as you adjust coffee weight (10–60g)
- **Step-by-step brew guide** — 8 clear steps from heating water to enjoying your cup
- **Pro tips** — Expandable cards covering grind size, water quality, bloom technique, and more
- **Temperature toggle** — Switch between Fahrenheit and Celsius
- **Dark mode** — Full dark mode support with a warm, coffee-inspired palette
- **Persistence** — Remembers your last roast selection and temperature unit

## Screenshots

<!-- Add screenshots here -->

## Requirements

- iOS 17.0+
- Xcode 16.0+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) 2.44+

## Getting Started

```bash
# Clone the repository
git clone https://github.com/your-username/PourCraft.git
cd PourCraft

# Generate the Xcode project
xcodegen generate

# Open in Xcode
open PourCraft.xcodeproj
```

Build and run on an iOS 17+ simulator or device.

## Build & Test

```bash
# Build
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run tests (21 tests across 2 suites)
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' test
```

## Project Structure

```
PourCraft/
├── project.yml                 # XcodeGen project spec (source of truth)
├── PourCraft/
│   ├── PourCraftApp.swift      # App entry point, TabView, persistence
│   ├── Models/
│   │   ├── BrewModel.swift     # Core calculator logic (@Observable)
│   │   ├── Roast.swift         # Light/Medium/Dark enum with ratios
│   │   └── BrewTip.swift       # Tip content data
│   ├── Views/
│   │   ├── BrewView.swift      # Main brew tab
│   │   ├── RoastSelectionCard.swift
│   │   ├── CoffeeWeightInput.swift
│   │   ├── BrewResultsView.swift
│   │   ├── TipsView.swift
│   │   ├── TipCard.swift
│   │   └── AboutView.swift
│   ├── Theme/
│   │   ├── Colors.swift        # Adaptive color palette
│   │   └── Typography.swift    # Serif/sans font system
│   ├── Extensions/
│   │   └── Color+Hex.swift
│   └── Assets.xcassets/
└── PourCraftTests/
    ├── RoastTests.swift        # 6 tests
    └── BrewModelTests.swift    # 15 tests
```

## Architecture

- **MVVM** with iOS 17's `@Observable` macro
- Single `BrewModel` instance owned by `PourCraftApp` via `@State`
- `@AppStorage` persistence at the app level, keeping the model free of UserDefaults coupling
- Adaptive color system implemented in code (not asset catalog color sets)
- Uses `@Bindable` for creating bindings to `@Observable` properties

## Coffee Ratios

| Roast  | Ratio | 15g  | 20g  | 25g  | 30g  |
|--------|-------|------|------|------|------|
| Light  | 1:17  | 255g | 340g | 425g | 510g |
| Medium | 1:16  | 240g | 320g | 400g | 480g |
| Dark   | 1:15  | 225g | 300g | 375g | 450g |

Bloom water is always **2x coffee weight**, regardless of roast.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
