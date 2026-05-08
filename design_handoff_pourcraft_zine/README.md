# Handoff: PourCraft — Editorial Zine

## Overview
PourCraft is a small iOS app that helps a home brewer calculate a pour-over coffee recipe and walk through the brew. This handoff covers the **Editorial Zine** visual direction — a typographic, magazine-inspired aesthetic anchored on Fraunces (serif) and Inter (sans), copper accent, ruled mastheads, and "Nº" numerals.

The app has **five screens**, all of which support light + dark mode and share a single brew state object.

## About the Design Files
The HTML files in this bundle are **design references**, not production code. They were built as JSX/React prototypes to communicate look, layout, motion, and interaction intent. Your task is to **recreate these designs in the existing PourCraft codebase** (a SwiftUI iOS app), reusing and updating its existing patterns. Don't ship the HTML — read it, lift the values, and re-implement natively.

## Fidelity
**High-fidelity.** Colors, type sizes, spacing, motion durations, and interaction details are intentional. Copy them precisely. Where the HTML and the existing Swift tokens conflict, **the HTML wins** — the existing `Colors.swift` / `Typography.swift` should be updated to match.

---

## Design Tokens

All tokens live in `tokens.jsx` and `zineSystem.jsx`. Translate these to Swift constants (`AppColors`, `AppTypography`, `AppSpacing`, `AppMotion`, `AppHaptics`).

### Color — Light
```
bg          #FBF3E5    cream
surface     #FFF8EC    elevated card
surface2    #F0E6D0    pressed card
ink         #2A1F1B    primary text
muted       #6B5239    secondary text
mutedSoft   #8A6F52    tertiary text
rule        rgba(42,31,27,0.18)   hairline
ruleStrong  rgba(42,31,27,0.85)   masthead bar
accent      #B87333    copper
accentInk   #FFF8EC    on-accent text
chip        rgba(184,115,51,0.12)  selected row tint
chipStrong  rgba(184,115,51,0.18)
```

### Color — Dark
```
bg          #221915
surface     #2C211C
surface2    #352721
ink         #F0E6D6
muted       #C4A88A     (raised from #B89A7E for contrast)
mutedSoft   #A38A6E
rule        rgba(240,230,214,0.20)
ruleStrong  rgba(240,230,214,0.65)
accent      #D4935A
accentInk   #221915
chip        rgba(212,147,90,0.16)
chipStrong  rgba(212,147,90,0.24)
```

### Typography
**Fraunces** (variable serif) for editorial display + body. **Inter** for kickers, captions, UI chrome.

| Token   | Size | Notes |
|---------|------|-------|
| caption | 10   | Inter 600/700, uppercase, letter-spacing 2–2.5 |
| kicker  | 11   | Inter 700, uppercase |
| body    | 15   | Fraunces, line-height 1.6 |
| callout | 17   | Fraunces 500 |
| title3  | 22   | Fraunces 500 |
| title2  | 28   | Fraunces 500 (section H2) |
| title1  | 36   | Fraunces 400 (sub-page H1) |
| display | 56   | Fraunces 400 (Brew screen masthead) |
| hero    | 96+  | Fraunces 400, tabular-nums (dose number, tip numerals) |

Letter-spacing on display sizes is tight (-1.5 to -4). Numbers always use tabular-nums.

### Spacing — 4-pt scale
```
xs 4   sm 8   md 12   lg 16   xl 24   xxl 32   xxxl 48
```
All padding/margin values must snap to this scale.

### Motion
```
micro   120ms  cubic-bezier(0.2, 0, 0, 1)   tap feedback
short   200ms  cubic-bezier(0.2, 0, 0, 1)   toggles, color shifts
medium  320ms  cubic-bezier(0.2, 0, 0, 1)   row expand, page transitions
long   1000ms  cubic-bezier(0.4, 0, 0.2, 1) bloom timer
```

### Haptics
```
selection         → roast pick, unit toggle
impact-light      → stepper +/-
impact-soft       → ruler snap (every 5g)
impact-medium     → "Begin the brew" CTA
notification-success → bloom done, brew complete
```

### Iconography
Hand-drawn ink style at 1.4 stroke width: V60 cone, kettle, beans, bloom dome, spiral, thermometer, drop, flame, timer, stamp, plus, minus, check, chevron. **Tab-bar icons should switch to SF Symbols** for OS consistency:
- Brew → `cup.and.saucer.fill`
- Guide → `book.fill`
- Tips → `sparkles`
- About → `info.circle.fill`

---

## Screens

### 1. Brew (Calculator) — `screenCalculator.jsx`
Home screen. Magazine masthead "PourCraft / The Brew" with double-rule. Three numbered sections.

- **Nº 01 — Choose your roast.** Three rows (Light / Medium / Dark). Selected row gets `chip` background tint and a 3-px copper ruler-mark on the left. Flavor copy only on the selected row. Ratio label on the right (`1:17` etc.).
- **Nº 02 — Dial in the dose.** 96px tabular numeral with "g" italic suffix. 44×44 +/- circle steppers (light haptic). Custom ruler 10–60g — drag-anywhere with 5g snap haptic. Range chip "10g — 60g."
- **Nº 03 — The pour, by weight.** Surface card with bordered top: Total water (big), then Bloom · 30 sec, Remaining · spiral, Water temp. Single rule between the big "Total" and the smaller rows.
- **CTA**: "Begin the brew" — copper bar, kettle icon, chevron, medium haptic. Below: "Save as my morning" pill (selection haptic).

### 2. Guide — `screenGuide.jsx`
Sub-page header (kicker "The Method", italic dek, single rule).

- **Today's Recipe** strip: roast + ratio, then a 3-column grid (Coffee / Water / Temp) populated from brew state.
- **Progress meter**: Nº 0X / 08, copper bar, "In progress" kicker.
- **Eight steps**, each row with: 38px serif numeral (mutedSoft when done with strikethrough; copper when current; ink otherwise), icon, title, kicker meta, body. Current row has chip tint + ruler-mark. Tapping toggles expansion (separate from "current"). The current step shows a "Mark done" pill when expanded — advances `currentStep`.
- Steps: Heat the water, Rinse the filter, Add the grounds, Bloom, Wait/watch, Spiral pour, Drawdown, Pour/sip/study.

### 3. Tips — `screenTips.jsx`
Magazine table-of-contents.

- Sub-page header "Field Notes."
- Pull quote at top: "Most great cups fail on a small detail. These are the small details."
- "Contents · 8 entries" rule line.
- 8 rows. Each row: large copper "01"-"08" numeral, category kicker, title (Fraunces 19 / 500), italic dek, chevron. Dotted separator between rows.
- Tap → opens detail.

### 4. Tip Detail — `screenTipDetail.jsx`
Article view.

- Header: "← Field Notes · Nº 0X · Category."
- Hero: 110px copper numeral, "Tip · Category" kicker, then `title1` headline, italic dek.
- Body: 4 paragraphs, **left-aligned with `text-wrap: pretty`** (no justify, no drop cap). Pull quote inserted between paragraph 1 and 2 — italic Fraunces 24, copper, top + bottom rule.
- "By the numbers" reference block: surface card with 3 key/value rows.
- Footer: "Continued in Nº 0Y — Title" with chevron. **Tip 8 hides this** and shows a centered "— end of contents — / Back to Field Notes" CTA instead.

### 5. About — `screenAbout.jsx`
Colophon.

- Sub-page header "Colophon."
- Manifesto block (italic Fraunces 22): "PourCraft is a small calculator that takes coffee seriously without taking itself too seriously."
- One short paragraph.
- **Nº 01 — Settings**: "Display temperature in" with °F/°C segmented toggle (global brew state), "Haptic feedback: On", "Auto-advance brew steps: On".
- **Nº 02 — The Reading Room**: Rate PourCraft, Share with a friend, Send feedback (mailto), Privacy policy. All chevroned rows, 44pt min height.
- **Nº 03 — Masthead**: Created by Vinny Carpenter (link to vinny.dev), Inspired by Kristin Carpenter, Developer Katie Carpenter, Type Fraunces & Inter.
- Footer: stamp icon, italic credit, version + domain.

---

## Shared Chrome

### Masthead (Brew only)
Top kicker line "PourCraft · The Brew" with a stamp icon left, kicker right. Double rule (2px + 1px) below. Fraunces display headline. Italic sub. Single hairline rule under sub.

### SubHeader (Guide / Tips / About / Tip Detail)
Single back button (or PourCraft branding) + kicker (right-aligned). Single ruleStrong line. `title1` H1. Italic dek. Hairline rule. **No Vol/Issue/Month — that's Brew-only.**

### Tab Bar
Bottom-anchored, **safe-area-inset for the home indicator**. Four tabs (Brew / Guide / Tips / About). Selected = copper, unselected = muted. SF Symbols (see Iconography).

---

## Brew State

The `useBrew()` hook (in `shared.jsx`) is the single source of truth — port it to a Swift `ObservableObject` (`BrewModel`) injected via `@StateObject` at app root.

```
roastId     "light" | "medium" | "dark"
roast       { id, name, short, label ("1:17"), flavor, ratio }
weight      Int    10–60g
unit        "F" | "C"
total       Int    weight * ratio
bloom       Int    weight * 2
remaining   Int    total - bloom
tempPoint   String "205°F" / "96°C" etc.
tempRange   String "200–210°F"
```

Persistence: roast, weight, unit, "saved preset" all to `UserDefaults` (or `@AppStorage`).

---

## Interactions & Behavior

- **Tab switching** preserves brew state. Tapping a tab while on it scrolls top.
- **Roast pick** updates `total/bloom/remaining/tempPoint/tempRange` immediately. Selection haptic.
- **Stepper +/-** clamps 10–60. Light haptic. Disable button at bound (don't no-op silently).
- **Ruler drag** anywhere on the bar; thumb follows pointer. Soft haptic at every 5g mark.
- **Begin the brew** → push Guide. Sets `currentStep = 0`. Medium haptic.
- **Mark done** → `currentStep += 1`, expand next step. Light haptic. On final step, success notification haptic.
- **Open tip** → push Tip Detail with tipId.
- **Continued in** → replace current detail with next tip. Smooth scroll-to-top.
- **Unit toggle** in About → updates everything live across all screens.
- **Save preset** → stores `{roast, weight}` to UserDefaults. Pill turns into "✓ Saved as morning."

### Future (post-v1)
- Live brewing mode with real timer + lock-screen Live Activity (referenced but not in this handoff).
- Email feedback / share-sheet / privacy-policy actions wired up before submission.

---

## Accessibility

- All interactive elements ≥ 44 × 44 pt.
- Test with Dynamic Type up to XXL — display sizes will need `minimumScaleFactor: 0.7` or alternative layouts at AX1+.
- Colors meet WCAG AA. Dark muted was raised from `#B89A7E` to `#C4A88A` specifically to clear the bar for tiny uppercase.
- Use `accessibilityLabel` for icon-only buttons (steppers, back, tab bar).
- Respect Reduce Motion: clamp transitions to fade only, kill the bloom dome animation, keep haptics.

---

## Files

Reference files in this folder (all React/JSX prototypes):
- `PourCraft Editorial Zine.html` — entrypoint that mounts the prototype
- `tokens.jsx` — spacing, type, motion, haptics, safe-area
- `zineSystem.jsx` — colors, masthead, sub-header, tab bar, atoms
- `shared.jsx` — `useBrew` state hook, `ROASTS`, `PCFrame`, icon set
- `screenCalculator.jsx` — Brew screen (the calculator)
- `screenGuide.jsx` — eight-step brew guide
- `screenTips.jsx` — Field Notes index
- `screenTipDetail.jsx` — Tip article
- `screenAbout.jsx` — Colophon + Settings
- `prototype.jsx` — main wrapper that wires up navigation between screens

Read these in roughly that order. Tokens first, then the system, then any one screen.

---

## Notes for the Implementer

1. **Update existing tokens before rebuilding screens.** The current Swift `AppColors` / `AppTypography` use a different palette and type set. Rewrite those first; old views will reflow gracefully.
2. **Build atoms before screens.** A `ZineSection` view, `ZineMasthead`, `ZineSubHeader`, `ZineTabBar`, `RuleLine`, `Kicker`, `PourLine`, `StepRow`, `TipRow` — these recur. Don't inline.
3. **Don't draw the iOS status bar.** The HTML mocks one for completeness; native gives it for free.
4. **Status-bar times in the HTML (`6:41`, etc.) are mock-only.** Delete.
5. **Justified text and drop caps were removed for a reason** — don't re-introduce them in Swift.
6. **The hero numeral on Tip Detail is 110px, not the 140px from earlier mocks.** Ditto: dose stayed at 96px.

If anything is ambiguous, the HTML is canonical — open it in a browser and inspect.
