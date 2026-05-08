# Handoff: PourCraft Editorial Zine refactor (in-flight)

## Where you're picking up

The user is mid-way through aligning the iOS app with `design_handoff_pourcraft_zine/README.md`
(the "Editorial Zine" visual direction). Most of the scaffolding was already in place when this
session started — the work this session did was a **spec-alignment pass**, not greenfield. The
build succeeds and all 100 tests across 8 suites pass. **Nothing is committed yet.** Review the
diff against `main` before deciding what to do next.

Verify state with:
```bash
git status
xcodegen generate
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
xcodebuild ... test
```

## Spec source of truth

`design_handoff_pourcraft_zine/README.md` is canonical. The README explicitly states that where
HTML/handoff values disagree with existing Swift, **the handoff wins**. Treat that rule as
non-negotiable.

## Changes made this session

### Theme

- `Theme/Colors.swift` — palette aligned to spec exactly. `lightMuted` `#7A5E45 → #6B5239`. All four
  dark tokens shifted: `bg #221915`, `surface #2C211C`, `surface2 #352721`, `muted #C4A88A`
  (the deliberate AA contrast bump the spec calls out). Added new tokens: `mutedSoft`, `accentInk`,
  `ruleStrong` helper, and `chip`/`chipStrong` derived as `accent` at 0.12/0.18 light, 0.16/0.24 dark
  so warmth tracks the scheme automatically.

### Views

- `Views/ZineTabBar.swift` — switched from ink icons to **SF Symbols** per spec
  (`cup.and.saucer.fill` / `book.fill` / `sparkles` / `info.circle.fill`). Bottom padding reduced
  since `safeAreaInset` already handles the home indicator.
- `Views/ZineComponents.swift` — `SubHeader` now omits the month from the kicker row
  (spec: "No Vol/Issue/Month — that's Brew-only") and uses a single `ruleStrong` line instead of
  a double rule. `Masthead` migrated to use the `ruleStrong` helper for consistency.
- `Views/TipDetailView.swift` — removed `DropCapParagraph` (spec says no drop cap, left-aligned
  paragraphs). Hero numeral 140pt → **110pt**. Added `EndOfContents` footer that renders only
  when `tip.isLast`; non-last tips still show `NextTipLink`.
- `Views/AboutView.swift` — full restructure to spec sections:
  - `Nº 01 Settings` — `°F/°C` segment toggle bound live to `brewModel.temperatureUnit`,
    plus haptic and auto-advance rows (44pt min height).
  - `Nº 02 The Reading Room` — Rate / Share / Send feedback (mailto) / Privacy chevron rows
    using `Environment(\.openURL)`.
  - `Nº 03 Masthead` — real credits: Vinny Carpenter (`https://vinny.dev`), Kristin Carpenter,
    Katie Carpenter, "Type — Fraunces & Inter".
  - `AboutView` now takes `brewModel`; call site in `PourCraftApp.swift` updated.
- `Views/BrewView.swift` — structural changes:
  - Roast row: 3px copper left ruler-mark + `chip`-tinted background when selected; flavor copy
    only on selected row; ratio right-aligned. The radio-circle pattern was removed.
  - Steppers 36×36 → **44×44**, with disabled-at-bounds state at 35% opacity.
  - Pour block: single rule between Total and the smaller rows (was three).
  - **Save as my morning** pill below the CTA — persists `{roast, weight}` snapshot via separate
    `@AppStorage("savedPresetRoast")` / `savedPresetWeight` keys (deliberately separate from the
    existing `selectedRoast`/`temperatureUnit` keys, which track *current* state, not preset).
    Pill flips to "✓ Saved as my morning" with copper border when current matches saved.

### Models

- `Models/BrewTip.swift` — added `isLast: Bool` computed helper for the Tip 8 special case.

### URL fixes (`Views/AboutView.swift`)

| Row | URL |
|-----|-----|
| Privacy policy (line 200) | `https://www.pourcraftcoffee.com/privacy.html` ✓ |
| Share with a friend (line 190) | `https://www.pourcraftcoffee.com/` ✓ |

### App Store export-compliance prompt

- `project.yml:31` — added `ITSAppUsesNonExemptEncryption: false` under `info.properties`.
- Ran `xcodegen generate`; key landed in `Info.plist` as `<false/>`. The next App Store Connect
  upload will skip the encryption modal that the user was hitting on every submission.
- The value is correct because PourCraft uses no crypto and no networking. **If a future change
  introduces a custom crypto library, a third-party SDK with its own TLS/encryption beyond the
  system stack, or proprietary encryption, flip this to `true`** and complete the BIS year-end
  self-classification report.

## What's still open

### URLs in `AboutView.swift` that are still placeholders / wrong

1. ~~**Line 185 — Rate Pourcraft**~~: resolved — now uses real App Store URL
   `https://apps.apple.com/us/app/pourcraft-coffee/id6759871953?action=write-review`.
2. ~~**Line 195 — Send feedback**~~: resolved — now uses `pourcraftcoffee@vinny.dev`.
3. ~~**Line 359 — Footer display string**~~: resolved — now reads `pourcraftcoffee.com`.

### Spec features deliberately not picked up this session

- **Guide live-timer rip-out.** Spec puts live brewing in post-v1, but the existing implementation
  has a working `BrewTimerModel` with 27 tests. Left intact. The spec's "Progress meter (Nº 0X / 08
  with copper bar, 'In progress' kicker)" is a separate, lighter element that could be added
  *alongside* the timer rather than replacing it — additive win if the user wants it.
- **Haptics.** Spec lists a haptic table (selection / impact-light / impact-soft / impact-medium /
  notification-success). Easy to layer in via `UIImpactFeedbackGenerator` on the existing tap
  callbacks (roast pick, stepper +/-, ruler 5g snap, Begin the brew CTA, bloom-done /
  brew-complete). Localised changes; no architecture impact.
- **Brew masthead edition chrome.** Currently shows Vol/Issue + "EST. 2024" + month. Spec is less
  prescriptive here ("magazine masthead with double-rule"), so I left it. User may want it
  trimmed.
- **About → Settings rows.** Haptic feedback and auto-advance display hardcoded "On" labels.
  Spec calls them out as toggles ("Haptic feedback: On" reads ambiguous in the spec — could be
  status text or could be a toggle). Worth confirming with user before wiring.
- **Save preset restore.** The pill saves `{roast, weight}` to `@AppStorage` but nothing reads
  the preset back to *apply* it on a future visit. Spec doesn't explicitly require restore — it
  just says "stores to UserDefaults" — but worth flagging.

## Critical things to know before you write code

- **`@Observable` + `didSet` = infinite recursion.** The macro wraps setters with
  `withMutation(keyPath:)` which causes recursive setter calls. `BrewModel.coffeeWeight` uses a
  private backing store (`_coffeeWeight`) with a computed property that clamps in `set`. Don't
  re-introduce `didSet` on `@Observable` properties.
- **`project.yml` is the source of truth for `Info.plist`.** Running `xcodegen generate`
  overwrites `Info.plist` from the `info.properties` block. Edit `project.yml` and regenerate;
  don't edit `Info.plist` directly or your changes will be clobbered.
- **`xcodegen generate` after adding/removing/moving any `.swift` file** under `PourCraft/` or
  `PourCraftTests/`. XcodeGen auto-discovers files; the `.xcodeproj` won't update without it.
- **Tests cover models and the color helper, not the views.** The 100-test suite caught zero
  regressions through this UI rewrite because views have no behavioural test coverage. That means
  the test suite passing is necessary but not sufficient — open the simulator (or use a build
  destination on a sim) before claiming any UI change works.

## Suggested skills for the next session

These skills should be invoked at the start, before any new work:

- **`coding-standards`** — baseline for every coding session in this repo. Rigid rules around
  TDD, verification-before-completion, and the Definition of Done.
- **`superpowers:verification-before-completion`** — required before claiming work is done. The
  build-and-test commands are in this handoff; run them.

Conditional, depending on what the user asks for next:

- **`superpowers:test-driven-development`** — if the next feature is a model change (e.g. preset
  restore logic), drive it red→green→refactor since the model layer has real test coverage.
- **`superpowers:brainstorming`** — if the user opens with "let's do X" rather than a concrete
  task. The remaining items (timer rip-out, haptics layer, masthead trim) are judgment calls
  worth aligning on before implementing.
- **`commit-commands:commit-push-pr`** — none of this session's work is committed. The user may
  want the whole refactor in a single PR or split per area. Ask before committing.
- **`document-skills:webapp-testing` / Chrome DevTools skills** — **not applicable**. This is a
  native iOS app, not a webapp.

## Files touched this session

```
PourCraft/Theme/Colors.swift
PourCraft/Views/ZineTabBar.swift
PourCraft/Views/ZineComponents.swift
PourCraft/Views/TipDetailView.swift
PourCraft/Views/AboutView.swift
PourCraft/Views/BrewView.swift
PourCraft/Models/BrewTip.swift
PourCraft/PourCraftApp.swift
PourCraft/Info.plist            # regenerated by xcodegen
project.yml
```

Plus this `handoff.md`.

## Verification before declaring further work done

```bash
# Regenerate project (whenever project.yml or files change)
xcodegen generate

# Build
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17' build

# Test (100 tests, ~17s)
xcodebuild -project PourCraft.xcodeproj -scheme PourCraft -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
```

Open the simulator and exercise the affected screen for any UI change — the test suite covers
models and adaptive color helpers only.
