# Product

<!-- impeccable:product-schema 1 -->

## Platform

ios

## Users

The primary user is someone still learning pour-over. They stand at the kitchen counter in the morning with a scale, a gooseneck kettle, and a dripper. They follow the Guide one step at a time while they pour. Their hands are busy, and their attention splits between the kettle and the screen.

The app was first made for Kristin Carpenter (credited in the Colophon as "Inspired by"), the reference user for design decisions. The About copy names the audience plainly: "Made for people who weigh their coffee, and own a kettle with a spout that looks slightly silly." When a choice would serve a practiced brewer at the learner's expense, the learner wins.

## Product Purpose

PourCraft turns a roast and a dose into exact gram weights for the bloom and the pour. Then it walks the brewer through the brew with a live timer. Eight field notes explain why each step matters, so the learner understands the method instead of memorizing it.

Success is a learner who brews a cup they like and can repeat it the next morning. The README and the original brief put it as "Perfect Pour-Over, Every Time."

## Positioning

The Brew masthead says it in five words: "A calculator, set in type." PourCraft does a brew calculator's math but reads like a coffee-house zine, with numbered sections, field notes, and a colophon. It takes a position on ratios, one per roast, and doesn't hand the learner a blank ratio field. It asks for nothing in return: no account, no sign-in, and no network.

## Operating Context

- A morning ritual at the kitchen counter, with the phone or iPad propped near the scale and glanced at mid-pour.
- The user brings a gram scale, a gooseneck kettle, a dripper with a paper filter, and usually a grinder.
- A brew runs about 3:30: a 30-second bloom, a spiral pour that takes 60% of the remaining time, then drawdown.
- "Save as my morning" stores the daily recipe, so tomorrow starts where today ended.

## Capabilities and Constraints

Shipped as of version 2.5.0:

- Four tabs: Brew (the calculator), Guide (eight steps plus a live timer), Tips (eight field notes), and About (colophon, settings, and links). iPad replaces the tab bar with a sidebar.
- Ratios are Light 1:17, Medium 1:16, and Dark 1:15. Bloom water is 2× the dose, rounded to a whole gram.
- Coffee-first mode sets a dose from 10 to 60 g (default 20 g). Water-first mode sets 200 to 900 g in 10 g steps and derives the dose to 0.1 g. Switching modes carries the numbers across.
- The Brew tab shows the selected roast's water temperature range from field note 04 (Light 205° to 210°F, Medium 200° to 205°F, Dark 195° to 200°F), with a °F/°C toggle. The Guide targets the low end of that range.
- The live timer runs through ready, bloom, pour, drawdown, and done. Settings cover haptic feedback on phase changes and auto-advancing Guide steps.
- "Save as my morning" stores roast, mode, and amount, and restores them on launch.
- Light and dark appearance.

Constraints:

- iOS 17+ in SwiftUI. iPhone is portrait only. iPad is first-class in every orientation, with its own sidebar and split layouts, and gets the same care as iPhone. The "portrait only" line in CLAUDE.md predates iPad support.
- Scope stays focused on three roast ratios and one pour-over method. New work deepens Brew, Guide, and Tips. Brew history, custom ratios, Chemex or Kalita methods, and an Apple Watch app are parked. They return only by an explicit decision, even though CLAUDE.md still lists them as future features.
- Private and offline. No accounts, analytics, or network calls. The app stores only preferences in UserDefaults, as declared in `PrivacyInfo.xcprivacy`. Adding networking or custom crypto would also flip `ITSAppUsesNonExemptEncryption` in `project.yml`.
- Brewing claims stay sourced. Any new or changed ratio, temperature, or piece of advice needs a named source before it ships.

Terminology used in the app:

- Dose is the coffee weight. The brew moves through bloom, the pour, and drawdown.
- Field notes are the Tips articles. The About page is the Colophon, and its links section is The Reading Room.
- "Begin the brew" is the Brew tab's call to action. "Save as my morning" is the saved preset.

Open questions:

- The per-roast temperature ranges in field note 04, which the Brew tab and Guide now share through `Roast.waterTemperatureF`, have no named source. Roaster guides agree on the direction (hotter for light, cooler for dark) but disagree on the numbers, most of all for dark roasts.
- The field notes' reference cards are quick specs, such as "Target hardness: ~150 ppm," and they aren't citations. The repo has no source list yet, so the existing claims aren't traced.
- Price and business model aren't recorded here.

## Brand Commitments

- The name is PourCraft, one word with a capital P and C. The domain is pourcraftcoffee.com, and the App Store listing slug is pourcraft-coffee.
- Taglines in use: "A calculator, set in type." on the Brew masthead, and "Perfect Pour-Over, Every Time" in the README and original brief.
- The voice is wry, warm, and editorial, serious about coffee and never precious. Two lines set the register: "PourCraft is a small calculator that takes coffee seriously without taking itself too seriously." and the About line quoted under Users. Copy reads like a coffee zine and never like a SaaS app.
- New copy follows the vinny-voice rules, including no em dashes.
- Colophon credits: Created by Vinny Carpenter (vinny.dev), Inspired by Kristin Carpenter, and Developer Katie Carpenter.
- The shipped visual identity is the Editorial Zine, defined in `PourCraft/Theme/` and the `pourcraft-coffee-handoff/` prototype. Its details belong in DESIGN.md, which doesn't exist yet.

## Evidence on Hand

- Live App Store listing: https://apps.apple.com/us/app/pourcraft-coffee/id6759871953
- Website and privacy policy: https://www.pourcraftcoffee.com/ and https://www.pourcraftcoffee.com/privacy.html. Feedback goes to pourcraftcoffee@vinny.dev.
- App Store screenshots in `screenshots/appstore/iphone-6.9/` and `screenshots/appstore/ipad-13/`, regenerated by `scripts/generate-appstore-screenshots.sh`.
- App icon and splash art: `assets/pourcraft-coffee-appicon.png` and `assets/pourcraft-coffee-splash-screen.png`.
- Launch video and share copy in `brag-output/` (untracked): `brag.mp4`, `brag-landscape.mp4`, and `share-copy.txt`.
- The Editorial Zine design prototype in `pourcraft-coffee-handoff/project/`.
- Absent: testimonials, reviews, ratings, download counts, press, and user research. Future work must not invent them.

## Product Principles

1. The learner at the counter comes first. Every screen should work mid-pour, with the next action and its number readable at a glance.
2. Opinion over options. Deepen the three ratios and the one method before adding any new input.
3. Every brewing claim names its source. The app teaches, so a wrong number teaches the wrong thing.
4. Nothing leaves the device, and the app never asks who you are.

## Accessibility & Inclusion

No formal standard is set. The shipped app already keeps these commitments, and future work holds them:

- Dynamic Type throughout. Fraunces scales through `relativeTo:`, and display sizes scale gently or cap so layouts hold at the largest sizes.
- VoiceOver labels and hints on custom controls.
- Touch targets of at least 44 pt.
- AA contrast for muted text in dark mode.

The counter raises the bar: wet hands, a glance from arm's length, and a timer that keeps running.
