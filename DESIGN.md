---
name: PourCraft
description: A pour-over calculator, set in type.
colors:
  copper-kettle: "#B87333"
  cafe-paper: "#FBF3E5"
  steamed-milk: "#FFF8EC"
  espresso-ink: "#2A1F1B"
  roasted-bean: "#6B5239"
  hairline: "rgba(42, 31, 27, 0.18)"
  hairline-strong: "rgba(42, 31, 27, 0.85)"
  copper-rule: "rgba(184, 115, 51, 0.42)"
  copper-tint: "rgba(184, 115, 51, 0.12)"
  copper-tint-strong: "rgba(184, 115, 51, 0.18)"
  burnished-copper: "#D4935A"
  night-brew: "#221915"
  dark-roast: "#2C211C"
  crema: "#F0E6D6"
  cappuccino: "#C4A88A"
  hairline-dark: "rgba(240, 230, 214, 0.20)"
  hairline-strong-dark: "rgba(240, 230, 214, 0.65)"
  copper-rule-dark: "rgba(212, 147, 90, 0.42)"
  copper-tint-dark: "rgba(212, 147, 90, 0.16)"
  copper-tint-strong-dark: "rgba(212, 147, 90, 0.24)"
typography:
  display:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "46px"
    fontWeight: 400
    letterSpacing: "-2px"
  folio:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "110px"
    fontWeight: 400
    letterSpacing: "-5px"
  numeral:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "76px"
    fontWeight: 400
    letterSpacing: "-3px"
    fontFeature: '"tnum"'
  headline:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "38px"
    fontWeight: 400
    letterSpacing: "-2px"
  figure:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "36px"
    fontWeight: 500
    letterSpacing: "-1px"
    fontFeature: '"tnum"'
  title:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "21px"
    fontWeight: 500
    letterSpacing: "-0.5px"
  body:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "16px"
    fontWeight: 400
  dek:
    fontFamily: "Fraunces Italic, Fraunces, Georgia, serif"
    fontSize: "14px"
    fontWeight: 400
  pull-quote:
    fontFamily: "Fraunces Italic, Fraunces, Georgia, serif"
    fontSize: "23px"
    fontWeight: 400
    letterSpacing: "-0.5px"
  button:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "18px"
    fontWeight: 500
    letterSpacing: "-0.2px"
  button-small:
    fontFamily: "Fraunces, Georgia, serif"
    fontSize: "15px"
    fontWeight: 500
  label:
    fontFamily: "-apple-system, system-ui, sans-serif"
    fontSize: "11px"
    fontWeight: 600
    letterSpacing: "2.5px"
  label-strong:
    fontFamily: "-apple-system, system-ui, sans-serif"
    fontSize: "11px"
    fontWeight: 700
    letterSpacing: "2.5px"
rounded:
  mark: "2px"
  segment: "10px"
  control: "14px"
  row: "16px"
  card: "18px"
  pill: "9999px"
spacing:
  stack: "8px"
  row: "12px"
  card: "16px"
  section: "24px"
  gutter: "24px"
  gutter-wide: "32px"
components:
  button-primary:
    backgroundColor: "{colors.copper-kettle}"
    textColor: "{colors.steamed-milk}"
    typography: "{typography.button}"
    rounded: "{rounded.card}"
    padding: "18px 22px"
  button-solid:
    backgroundColor: "{colors.copper-kettle}"
    textColor: "{colors.steamed-milk}"
    typography: "{typography.button-small}"
    rounded: "{rounded.control}"
    padding: "12px"
  button-ghost:
    backgroundColor: "{colors.steamed-milk}"
    textColor: "{colors.espresso-ink}"
    typography: "{typography.button-small}"
    rounded: "{rounded.control}"
    padding: "12px"
  pill-save:
    backgroundColor: "{colors.steamed-milk}"
    textColor: "{colors.espresso-ink}"
    rounded: "{rounded.pill}"
    padding: "8px 16px"
  pill-save-saved:
    backgroundColor: "{colors.copper-tint}"
    textColor: "{colors.copper-kettle}"
    rounded: "{rounded.pill}"
    padding: "8px 16px"
  card:
    backgroundColor: "{colors.steamed-milk}"
    rounded: "{rounded.card}"
    padding: "16px"
  row:
    backgroundColor: "{colors.steamed-milk}"
    textColor: "{colors.espresso-ink}"
    rounded: "{rounded.row}"
    padding: "12px 12px 12px 14px"
  row-selected:
    backgroundColor: "{colors.copper-tint}"
    textColor: "{colors.espresso-ink}"
    rounded: "{rounded.row}"
    padding: "12px 12px 12px 14px"
  segmented-picker:
    backgroundColor: "{colors.steamed-milk}"
    rounded: "{rounded.control}"
    padding: "3px"
  segment-selected:
    backgroundColor: "{colors.copper-kettle}"
    textColor: "{colors.steamed-milk}"
    rounded: "{rounded.segment}"
    padding: "6px 14px"
  stepper:
    backgroundColor: "{colors.steamed-milk}"
    textColor: "{colors.espresso-ink}"
    rounded: "{rounded.control}"
    size: "44px"
  setting-row:
    textColor: "{colors.espresso-ink}"
    padding: "12px 16px"
    height: "44px"
  tab-item:
    textColor: "{colors.roasted-bean}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    height: "52px"
  tab-item-active:
    backgroundColor: "{colors.copper-tint}"
    textColor: "{colors.copper-kettle}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    height: "52px"
---

# Design System: PourCraft

## Overview

**Creative North Star: "Set in Type"**

PourCraft is a calculator typeset like a small coffee magazine. Every number the brewer acts on (the dose, the total water, the bloom) sits on the page the way a headline would. It's large, set in Fraunces, with tabular figures and tight tracking. Each screen is a page, with a masthead over a double ink rule, numbered sections, an italic dek, and a colophon at the back.

The system is quiet on purpose. Warm paper carries the page, and espresso ink carries the words. Copper marks what matters on each screen: the chosen ratio, the selected row, and the next action. Depth comes from 1pt hairlines and tonal fills. Controls read as part of the typography, so a stepper, a row, and a segment look like the same hand set them as the headline.

Density is comfortable. iPhone runs one column with 24pt margins, and iPad opens into a sidebar and two columns. Three looks are off the table: the utility calculator (gray system steppers, a form that happens to compute), faux-craft texture (paper grain, coffee rings, kraft backgrounds), and dashboard chrome (drop shadows, floating cards, charts, metric tiles).

Motion stays small and physical. State changes use the `.snappy` spring, numbers roll with a numeric-text transition, and the timer's progress bar moves linearly, one second per tick. Brew-phase changes play a haptic when the setting is on.

**Key Characteristics:**
- Fraunces for every headline, numeral, and line of reading copy. System sans only for small chrome labels.
- Warm paper and espresso ink in light mode, umber and crema in dark mode. No pure white or black.
- Copper as a scarce signal: one italic word per page title, section numbers, ratios, selection, and the primary action.
- Flat surfaces bounded by 1pt hairlines, with continuous corners from 2pt marks to 18pt cards.
- Hand-drawn ink icons in page content. SF Symbols only in the tab bar and sidebar.

## Colors

The palette is a cup of coffee on a cafe table: cream paper, espresso ink, and a copper kettle, with a matching after-dark set.

Every role exists as a light and dark pair, and `AppColors` in `PourCraft/Theme/Colors.swift` resolves each pair per color scheme. The dark set is its own tuned palette: an umber ground, crema ink, and a lighter copper that holds contrast. Tokens ending in `-dark` are the dark-mode half of a pair.

### Primary
- **Copper Kettle** (light) and **Burnished Copper** (dark): the only accent. It fills the primary action ("Begin the brew" and the timer's Start and Pause) and the selected segment. Everywhere else it appears as type (ratios, section numbers, the italic word in each page title, the article folio, pull quotes), as the 3pt mark on a selected row, or as text on the active tab.
- **Copper Rule** (accent at 42%): the hairline that runs beside each section number, and the stroke around a selected row.
- **Copper Tint** (12% light, 16% dark) and **Copper Tint Strong** (18% light, 24% dark): the fill behind a selected roast, step, tip, or tab. Both derive from the accent, so the warmth tracks the scheme.

### Neutral
- **Cafe Paper** and **Night Brew**: the page ground behind every screen. Night Brew also sets text on copper in dark mode.
- **Steamed Milk** and **Dark Roast**: card, row, control, and bar surfaces, one step lighter than the page. Steamed Milk also sets text on copper in light mode.
- **Espresso Ink** and **Crema**: headlines, numerals, body copy, and icons.
- **Roasted Bean** and **Cappuccino**: kickers, deks, units, inactive tabs, and supporting copy. Cappuccino was raised from #B89A7E so tiny uppercase kickers clear WCAG AA on dark paper.
- **Hairline** (ink at 18% light, 20% dark): every card border, divider, and inactive control stroke.
- **Hairline Strong** (ink at 85% light, 65% dark): the masthead's double rule and the article's closing rules.

### Named Rules
**The Copper Rarity Rule.** Copper fills only the primary action and the selected segment. Everywhere else it's type, a 3pt mark, a 42% rule, or a tint.

**The Paper Rule.** No pure white and no pure black. The lightest value is Steamed Milk, and the darkest is Night Brew.

## Typography

**Display Font:** Fraunces, a variable serif bundled in regular and italic under SIL OFL (with Georgia as the web fallback)
**Body Font:** Fraunces, at reading sizes
**Label Font:** San Francisco, the system sans, through text styles so it follows Dynamic Type

**Character:** A soft, high-contrast serif does nearly all the talking, numbers included. The system sans speaks only in tracked capitals around the edges, like folio lines in a printed magazine.

Every Fraunces size is built with `relativeTo:` so it scales with Dynamic Type. Display sizes anchor to `.title` and cap at accessibility1, so they grow gently and never break the page.

### Hierarchy
- **Display** (400, 46pt, -2pt tracking): page mastheads such as "The *Pour*." The iPad sidebar uses a 30pt version.
- **Folio** (400, 110pt, -5pt, copper): the number that opens each field note article.
- **Numeral** (400, 76pt, -3pt, tabular figures): the dose or water amount on the Brew dial, paired with an italic 22pt "g" in muted ink.
- **Headline** (400, 38pt, -2pt): sub-page titles on Guide, Tips, and About. Article titles run at 34pt with -1.5pt tracking.
- **Figure** (500, 36pt, -1pt, tabular figures): the computed total in the pour card. Supporting figures run at 22pt, and the timer's elapsed time at 34pt.
- **Title** (500, 21pt, -0.5pt): numbered section titles, which end in a period ("Choose your roast."). Row titles run at 18pt.
- **Body** (400, 16pt, 4pt added line spacing): article paragraphs. Step and row copy runs at 14pt.
- **Dek** (italic 400, 14pt, muted): subtitles under titles and supporting lines. Roast flavor lines drop to 12pt.
- **Pull Quote** (italic 400, 23pt, copper, centered): one per article, set between two hairlines.
- **Label** (system 600 or 700, caption2 at 11pt, 2 to 2.5pt tracking, uppercase): kickers, chrome rows, section numbers, tab labels, and metadata. Segment labels use caption semibold with 1pt tracking.

### Named Rules
**The Typeset Numbers Rule.** Every number the brewer reads is Fraunces with tabular figures, and it changes with a numeric-text transition. The system sans never carries a value.

**The One Italic Word Rule.** Each page title sets exactly one word in copper italic: "The *Pour*," "The *Method*.," "Field *Notes*," and "The *Colophon*."

**The Small Sans Rule.** The system sans appears only at caption sizes, in chrome: tracked uppercase labels, tab labels, and segment labels. Everything else is Fraunces.

## Layout

Measurements are iOS points, written as px in the frontmatter.

On iPhone the app is one column, portrait only, with 24pt side margins. Each page runs masthead, numbered sections, then the action. Sections sit 18 to 24pt apart, rows sit 8pt apart, and 104pt of bottom padding keeps content clear of the tab bar.

At 760pt wide and up (iPad in any orientation), a 196 to 220pt sidebar replaces the tab bar. Content centers in a 1120pt maximum, and outer padding grows from 24pt to 32pt past 900pt. Brew splits into two columns: roast and dose on the left, and a 360 to 420pt column for the pour card and action on the right, with a 24pt gap. Articles cap at a 680pt measure.

Large text reflows instead of truncating. Rows use `ViewThatFits` to drop from one line to stacked lines as type grows. Chrome lines stay on one line, shrink to between 62% and 78% before they'd wrap, and cap at the xxLarge size.

## Elevation & Depth

The system is flat by default, and page content never casts a shadow. Depth comes from three moves: a surface one step lighter than the page, a 1pt hairline around it, and a copper tint when it's selected. The masthead's double rule (2pt over 1pt, 2pt apart, in Hairline Strong) is the heaviest line in the system. Layers that truly float above the page, such as sheets, popovers, and menus, use iOS system materials.

### Named Rules
**The Hairline Rule.** A boundary is a 1pt line. Shadows belong only to system-owned floating layers.

## Shapes

Every rounded shape uses continuous (squircle) corners. Radii step down as elements get smaller: cards and the primary action at 18pt, rows at 16pt, controls and tab plates at 14pt, the selected segment at 10pt inside its 14pt track, and the selection mark at 2pt. The save preset is the only capsule. Rules and ruler ticks are square-ended, and ink icons use round caps and joins.

## Components

### Buttons
Typeset and quiet: a button is a line of Fraunces inside a shape, and copper goes to the one that moves the brew forward.
- **Shape:** continuous corners, 18pt for the full-width primary and 14pt for paired buttons.
- **Primary ("Begin the brew"):** copper fill with paper-colored Fraunces 18 medium text, a kettle ink icon leading, and a chevron trailing. Padding is 18pt by 22pt at full width.
- **Solid and Ghost (timer controls):** an equal-width pair. Solid is copper with 15pt medium text. Ghost is Steamed Milk with an ink label and a hairline.
- **Pressed and disabled:** pressed buttons drop to 85% opacity. Steppers at a range limit fade to 35% and disable. iOS has no hover state.
- **Save preset pill:** a capsule with a hairline and 13pt medium Fraunces. Once saved, it turns copper-tinted with a copper stroke, a check, and "Saved as my morning."

### Cards / Containers
- **Corner Style:** 18pt continuous.
- **Background:** Steamed Milk on Cafe Paper, or Dark Roast on Night Brew.
- **Shadow Strategy:** none. See Elevation & Depth.
- **Border:** 1pt Hairline.
- **Internal Padding:** 16pt by default, 18pt on the pour card, and 14pt on the timer.

### Selectable Rows
The roast list, Guide steps, and the field note index all use one row form.
- **Shape and surface:** 16pt corners, Steamed Milk fill, 1pt Hairline.
- **Selected:** Copper Tint fill, a Copper Rule stroke, and a 3pt copper mark on the leading edge. The mark's slot is always reserved, so selecting a row never shifts its text.
- **Content:** an 18pt medium Fraunces title, a copper italic value on the trailing edge (such as the ratio), and an italic dek below. Guide steps lead with a 36pt numeral, and the field note index leads with a 30pt one.

### Inputs / Fields
There are no text fields. Input happens through three custom controls, which stay custom.
- **Steppers:** 44pt squares with 14pt corners, Steamed Milk with a hairline, and plus and minus drawn as ink icons.
- **Segmented picker** (Coffee | Water and °F | °C): a 14pt track with a 3pt inset. The selected segment fills copper with paper-colored text, and the others show ink text on clear.
- **Settings rows:** a 16pt Fraunces label with an italic value on the trailing edge, copper for On and muted for Off, at least 44pt tall. Tapping the row toggles it.

### Navigation
- **Tab bar (iPhone):** a custom bar on Steamed Milk above a hairline, with four equal items (Brew, Guide, Tips, About). Each item stacks a 17pt SF Symbol over a tracked uppercase label. The active item turns copper on a 14pt Copper Tint plate. Labels cap at the large Dynamic Type size.
- **Sidebar (iPad):** a rail on Steamed Milk. "PourCraft" in tracked caps, "The Pour" at 30pt, an italic dek, and a strong rule sit above the tabs. The active item gets a Copper Tint Strong plate, a 45% copper stroke, and ink text.
- **Back:** sub-pages put a tracked-caps back label with a rotated ink chevron in the header's chrome row.

### Masthead and Section Header
The two pieces of chrome that make every screen read as a page.
- **Masthead:** a tracked-caps chrome row ("POURCRAFT" left, "THE BREW" right), a 2pt rule over a 1pt rule, and the Display title with its one copper italic word. An italic dek and an "EST. 2024" stamp follow, closed by a hairline. Sub-pages use a lighter header with one 1pt strong rule and a 38pt Headline.
- **Section header:** "No. 01" in copper tracked caps, a Copper Rule that stretches to fill, and a muted uppercase kicker on the right ("THREE OPTIONS," "GRAMS," "COMPUTED"). The section title follows in 21pt medium Fraunces.

### Dose Ruler
A measuring rule stands in for a slider. Ticks are 1pt wide: every fifth tick is 18pt tall at 85% ink, and the rest are 9pt at 35%. A 14pt by 10pt copper triangle rides above the ticks and springs to the value. Dragging anywhere on the 34pt-tall rule sets the value, and VoiceOver adjusts it one step at a time.

### Pour Card and Live Timer
- **Pour card:** a card that leads with the computed total as a 36pt Figure, beside an ink icon and an italic label. A hairline follows, then bloom, remaining water, and temperature at 22pt.
- **Live timer:** "LIVE TIMER" in tracked caps over a 34pt elapsed time, with the phase name in copper caps and "of 3:30" in italic. Below sit a 4pt capsule progress bar (Hairline track, copper fill) and a "NOW" line with the current instruction.

### Ink Icons
Fifteen hand-drawn icons: V60, kettle, scale, bloom, drop, beans, thermometer, spiral, timer, flame, check, chevron, plus, minus, and stamp. Each is a SwiftUI path on a 24-unit grid, stroked with round caps and joins at 1.4pt by default and 1.6 to 2.2pt on small controls. They're decorative, so VoiceOver skips them.

### Field Note Article
A copper 110pt Folio opens the piece, followed by a tracked-caps category line, a 34pt title, an italic 17pt dek, and a strong double rule. Body paragraphs are 16pt Fraunces with 4pt added line spacing. One Pull Quote sits between hairlines, and a reference card closes the article.

## Do's and Don'ts

### Do:
- **Do** set every value the brewer reads in Fraunces with tabular figures, and animate changes with a numeric-text transition.
- **Do** give each page title exactly one copper italic word.
- **Do** separate label parts with a middle dot ("Bloom · 30 sec," "Medium · 1:16").
- **Do** draw boundaries with a 1pt Hairline, and show selection with Copper Tint plus a 3pt copper mark.
- **Do** reserve space for a selected state in advance, so selection never shifts text.
- **Do** use `ViewThatFits` fallbacks so rows stack instead of truncating at large Dynamic Type sizes.
- **Do** keep the tab bar, segmented picker, steppers, and On/Off rows custom, and build any new control (toggles, pickers, sheets, menus) from iOS system components tinted copper.
- **Do** keep every tap target at least 44pt by 44pt.

### Don't:
- **Don't** put a shadow on page content. Sheets, popovers, and menus use iOS system materials.
- **Don't** fill anything with copper except the primary action and the selected segment.
- **Don't** use pure white (#FFFFFF) or pure black (#000000).
- **Don't** add paper grain, coffee-ring stains, kraft backgrounds, or any other faux-craft texture.
- **Don't** let a screen drift toward a utility calculator, with gray system steppers or a form layout that happens to compute.
- **Don't** add dashboard chrome: floating cards, drop shadows, charts, or metric tiles.
- **Don't** set a value or sentence-case text in the system sans.
- **Don't** put SF Symbols in page content. The body uses ink icons.
