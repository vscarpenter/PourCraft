# Pour-Over Coffee App: Creative Brief & Claude Code Prompt

## App Name Ideas

Here are ten name candidates, grouped by vibe:

### Warm & Inviting
1. **PourCraft** — Simple, memorable, signals handmade quality. "Craft" aligns with the specialty coffee ethos.
2. **Golden Ratio** — Directly references the coffee brewing standard. Elegant, educational, and instantly tells you what the app does.
3. **SlowPour** — Evokes the meditative ritual of pour-over. Calm, intentional, and differentiated.

### Playful & Personal
4. **Bloom** — Named after the first critical step in pour-over brewing. Short, warm, and beautiful as an app icon word.
5. **BrewNote** — Suggests a personal journal or guide. Approachable and hints at the tips/guidance features.
6. **Drip & Sip** — Fun, rhythmic, and immediately communicates what the app is about.

### Minimal & Modern
7. **Ratio** — Ultra-clean, one-word, and describes the core function. Works beautifully on a minimal app icon.
8. **Kettle** — Evocative of the gooseneck kettle, the iconic pour-over tool. Short and visual.

### Premium & Distinctive
9. **The Pour** — Definite article gives it a magazine-like editorial feel. Confident and elegant.
10. **Steep & Pour** — Slightly more descriptive, conveys the process without being generic.

**My recommendation:** **Bloom** or **PourCraft**. "Bloom" is short, beautiful, references a real coffee technique your wife will learn, and looks gorgeous on an app icon. "PourCraft" is more descriptive and searchable in the App Store.

---

## Color Palette

A warm, earthy palette inspired by the pour-over ritual, from light roast to dark roast, with a cream canvas and a copper accent for warmth.

### Primary Palette

| Role | Name | Hex | Usage |
|------|------|-----|-------|
| Background | Cream Canvas | `#FFF8F0` | Main background, cards, light surfaces |
| Surface | Latte Foam | `#F0E6D6` | Secondary backgrounds, input fields |
| Primary | Espresso | `#3B2F2F` | Primary text, headers, navigation |
| Secondary | Roasted Bean | `#6F4E37` | Secondary text, icons, labels |
| Accent | Copper Kettle | `#B87333` | Buttons, sliders, active states, highlights |
| Accent Alt | Caramel Drip | `#C8956C` | Progress indicators, secondary actions |

### Supporting Colors

| Role | Name | Hex | Usage |
|------|------|-----|-------|
| Light Roast | Morning Gold | `#D4A960` | Light roast indicator, warm highlights |
| Medium Roast | Hazelnut | `#8B6914` | Medium roast indicator |
| Dark Roast | Dark Walnut | `#4A3728` | Dark roast indicator |
| Success | Sage Brew | `#7A9E7E` | Success states, optimal range |
| Warning | Bloom Orange | `#D4854A` | Warning, out-of-range indicators |
| White | Pure Cream | `#FFFFFF` | Card surfaces in dark contexts |

### Dark Mode Variant

| Role | Name | Hex |
|------|------|-----|
| Background | Night Brew | `#1A1412` |
| Surface | Dark Roast Surface | `#2C2320` |
| Primary Text | Cream | `#F0E6D6` |
| Accent | Burnished Copper | `#D4935A` |

---

## Imagery & Visual Direction

### App Icon
- A minimal, geometric pour-over dripper (like a Hario V60 or Chemex silhouette) in copper/gold on a deep espresso background
- A single drop of coffee or a gentle spiral of steam adds life
- Typography: If using the name "Bloom," set in a warm serif or rounded sans-serif

### In-App Imagery Style
- **Illustrations over photos**: Use warm, hand-drawn or flat-style illustrations of pour-over equipment (gooseneck kettle, dripper, scale, filter). This keeps the app feeling personal and artisan rather than stock-photo generic.
- **Subtle textures**: Light paper grain or linen texture on backgrounds to evoke craft and warmth
- **Iconography**: Rounded, friendly line icons in Copper Kettle or Espresso tones. Think: water droplets, coffee beans, thermometer, timer, scale
- **Typography pairing**:
  - Display/Headers: A warm serif like **Playfair Display**, **Lora**, or **Cormorant Garamond**
  - Body: A clean, readable sans-serif like **Source Sans 3**, **DM Sans**, or **Nunito**
- **Visual metaphors**: Use the coffee color gradient (light gold → medium brown → deep espresso) to visually represent roast levels throughout the UI
- **Animations**: Gentle water-pouring animations during the bloom timer, a slow steam rise on the results screen, and a satisfying "drip" animation when the calculation completes

### Screens to Design
1. **Welcome/Onboarding** — Warm illustration of a pour-over setup with a brief intro
2. **Roast Selection** — Three cards (Light, Medium, Dark) with gradient colors and brief flavor descriptions
3. **Coffee Weight Input** — A clean input with a gram slider or stepper, showing the coffee-to-water ratio updating live
4. **Results/Brew Guide** — Water amount, bloom amount, temperature range, step-by-step pour instructions
5. **Pro Tips** — Scrollable cards with tips on water temp, bloom technique, grind size, etc.
6. **Brew Timer** (future feature) — A guided pour-over timer with bloom countdown and pour intervals

---

## Claude Code Prompt

Copy and paste the following prompt into Claude Code to kick off the project:

---

```
# Project: PourCraft (Pour-Over Coffee Ratio Calculator)
# Platform: iOS (SwiftUI, targeting iOS 17+)
# Language: Swift
# Architecture: MVVM

## Overview
Build a native iOS app called "PourCraft" that helps pour-over coffee enthusiasts calculate
the ideal coffee-to-water ratio. The app should feel warm, handcrafted, and personal, like
a guide from a knowledgeable barista friend.

## Core Features (MVP)

### 1. Roast Selection Screen
- Three selectable cards: Light, Medium, Dark
- Each card shows:
  - Roast name and a brief flavor profile description
  - Recommended ratio (Light: 1:17, Medium: 1:16, Dark: 1:15)
  - A visual color gradient representing the roast (gold → brown → espresso)
- Light roast: "Bright, floral, tea-like notes. Origin flavors shine through."
- Medium roast: "Balanced sweetness, clean body. The specialty coffee sweet spot."
- Dark roast: "Bold, rich, full-bodied. Chocolate and caramel forward."
- Default selection: Medium
- Users can tap to select, with a subtle copper-accent highlight on the active card

### 2. Coffee Weight Input
- A numeric input (grams) with stepper controls (+/- buttons) and direct text entry
- Range: 10g to 60g, default 20g
- As the user adjusts weight, the water amount updates in real-time
- Show the active ratio (e.g., "1:16") prominently
- Display both the total water needed AND the bloom water amount
  - Bloom water = 2x coffee weight (e.g., 20g coffee → 40g bloom water)
  - Remaining water = total water minus bloom water

### 3. Results / Brew Guide Screen
- Display calculated values:
  - Total water (grams)
  - Bloom water (grams)
  - Remaining pour water (grams)
  - Water temperature range (194-204°F / 90-96°C, toggle between F and C)
- Step-by-step brew guide:
  1. "Heat water to 200°F (93°C). If no thermometer, let boiling water rest 30-60 seconds."
  2. "Place filter in dripper. Rinse with hot water to remove paper taste, then discard rinse water."
  3. "Add [X]g of medium-ground coffee to the filter."
  4. "Start timer. Pour [bloom amount]g of water evenly over grounds."
  5. "Wait 30 seconds for the bloom. You'll see the coffee bed rise and bubble as CO₂ escapes."
  6. "Slowly pour remaining [remaining water]g in a steady spiral from center outward."
  7. "Total brew time target: 3:00 to 4:00 minutes."
  8. "Enjoy your perfect cup!"
- Each step should be in a card-style layout, easy to follow while brewing

### 4. Pro Tips Section
Implement as a scrollable list of expandable tip cards. Include these tips:

- **Use a Scale**: "Measuring by volume (tablespoons) is inconsistent because different
  roasts have different densities. Grams ensure your 'good' cup is repeatable every time."
- **Water Temperature**: "Aim for 194°F to 204°F (90°C to 96°C). If you don't have a
  temperature-controlled kettle, let the water sit for 30 to 60 seconds after it reaches
  a rolling boil."
- **The Bloom**: "Always start by pouring about double the weight of the coffee in water
  (e.g., 40g of water for 20g of coffee) and let it sit for 30 seconds. This releases CO₂
  and allows for more even extraction."
- **Grind Size**: "For pour-over, aim for a medium grind, roughly the texture of sea salt.
  Too fine leads to over-extraction and bitterness. Too coarse leads to a weak, sour cup."
- **Fresh is Best**: "Coffee is at its peak flavor 7 to 21 days after roasting. Check the
  roast date on the bag and buy from local roasters when possible."
- **Water Quality**: "Use filtered water. Tap water with heavy chlorine or mineral content
  can mute the delicate flavors in specialty coffee."
- **The Spiral Pour**: "Pour in a slow, steady spiral from the center outward, then back
  to the center. Avoid pouring directly on the filter walls, which lets water bypass the
  coffee grounds."
- **Dial It In**: "If your coffee tastes bitter, try a coarser grind or slightly less coffee.
  If it tastes sour or weak, try a finer grind or slightly more coffee."

### 5. Navigation
- Use a TabView with three tabs:
  1. "Brew" (main calculator, combining roast selection + weight input + results)
  2. "Tips" (pro tips section)
  3. "About" (brief app info, version, credits)

## Design System

### Color Palette (implement as a Swift Color extension)
```swift
// Light Mode
static let creamCanvas = Color(hex: "FFF8F0")       // Main background
static let latteFoam = Color(hex: "F0E6D6")          // Secondary surfaces
static let espresso = Color(hex: "3B2F2F")            // Primary text
static let roastedBean = Color(hex: "6F4E37")         // Secondary text
static let copperKettle = Color(hex: "B87333")        // Accent, buttons, active states
static let caramelDrip = Color(hex: "C8956C")         // Secondary accent
static let morningGold = Color(hex: "D4A960")         // Light roast
static let hazelnut = Color(hex: "8B6914")            // Medium roast
static let darkWalnut = Color(hex: "4A3728")          // Dark roast
static let sageBrew = Color(hex: "7A9E7E")            // Success states
static let bloomOrange = Color(hex: "D4854A")         // Warnings

// Dark Mode
static let nightBrew = Color(hex: "1A1412")           // Background
static let darkRoastSurface = Color(hex: "2C2320")    // Surface
static let burnishedCopper = Color(hex: "D4935A")     // Accent
```

### Typography
- Use system fonts with a warm, readable hierarchy:
  - Large Title: `.largeTitle` with `.bold` weight
  - Headlines: `.title2` or `.title3` with `.semibold`
  - Body: `.body` for descriptions and tips
  - Captions: `.caption` for labels and helper text
- If available, use `Font.custom()` with a serif font for display headers
  to add warmth (e.g., a bundled font or system serif via `.design(.serif)`)

### Visual Style
- Cards with subtle rounded corners (16pt radius) and soft shadows
- Warm background (`creamCanvas`) throughout, with `latteFoam` for card surfaces
- Copper/gold accent on interactive elements (buttons, sliders, selected states)
- Support both Light and Dark mode using the palette above
- Subtle animations:
  - Card selection: gentle scale + opacity transition
  - Number changes: smooth counter animation on water amount
  - Tip cards: expand/collapse with spring animation

## Architecture Notes
- Use MVVM with `@Observable` (iOS 17+) for the brew calculator model
- BrewModel should contain:
  - `selectedRoast` enum (light, medium, dark) with associated ratio
  - `coffeeWeight` (Double, grams)
  - Computed properties: `totalWater`, `bloomWater`, `remainingWater`
  - `temperatureUnit` enum (fahrenheit, celsius)
- Keep the model testable and separate from views
- Use SwiftUI's native components: Stepper, Picker, ScrollView, TabView
- Store user preferences (last selected roast, preferred temp unit) with @AppStorage

## File Structure
```
PourCraft/
├── PourCraftApp.swift
├── Models/
│   ├── BrewModel.swift
│   ├── Roast.swift
│   └── BrewTip.swift
├── Views/
│   ├── BrewView.swift
│   ├── RoastSelectionCard.swift
│   ├── CoffeeWeightInput.swift
│   ├── BrewResultsView.swift
│   ├── TipsView.swift
│   ├── TipCard.swift
│   └── AboutView.swift
├── Theme/
│   ├── Colors.swift
│   └── Typography.swift
├── Extensions/
│   └── Color+Hex.swift
└── Assets.xcassets/
    └── AppIcon.appiconset/
```

## App Store Metadata (for later)
- **Subtitle**: "Perfect Pour-Over, Every Time"
- **Keywords**: pour over, coffee ratio, brew calculator, golden ratio, coffee scale,
  water ratio, specialty coffee, brew guide, pour over timer, coffee tips
- **Category**: Food & Drink

## Future Features (do NOT build yet, just structure code to accommodate)
- Brew timer with guided pour intervals
- Brew history / journal
- Custom ratio input
- Multiple brew methods (Chemex, V60, Kalita Wave)
- Apple Watch companion for timer
```

---

## Quick Reference: The Ratios

| Roast Level | Ratio | 15g Coffee | 20g Coffee | 25g Coffee | 30g Coffee |
|-------------|-------|------------|------------|------------|------------|
| Dark (Bold) | 1:15 | 225g water | 300g water | 375g water | 450g water |
| Medium (Balanced) | 1:16 | 240g water | 320g water | 400g water | 480g water |
| Light (Delicate) | 1:17 | 255g water | 340g water | 425g water | 510g water |

**Bloom water** is always 2x the coffee weight, regardless of roast.

---

*Built with love for better mornings. ☕*
