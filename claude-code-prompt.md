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
