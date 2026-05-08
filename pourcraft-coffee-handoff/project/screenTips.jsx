// screenTips.jsx — Editorial Zine · Pro Tips index
// 8 entries laid out as a magazine TOC. Tap a tip to open detail.

const TIPS = [
  {
    id: 'grind',
    n: 1, num: '01',
    cat: 'Technique',
    title: 'Grind matters more than beans.',
    dek: 'A great roast destroyed by a stale blade grinder is just brown water. Burrs first, beans second.',
    body: [
      "Of every variable in the cup, grind size accounts for the most variance. Two of the same grams from the same bag, ground differently, will produce drinks that taste like different coffees entirely.",
      "Why? Surface area. The water doesn't see beans — it sees particles. Smaller particles extract faster and more completely. The trick is uniformity: a wide spread of sizes means some grounds over-extract while others under-extract, and the cup arrives muddled.",
      "Burr grinders crush beans between two ridged surfaces, producing particles of consistent size. Blade grinders chop, producing dust and boulders in equal measure. The difference is not subtle.",
      "If you buy one piece of equipment, buy a hand burr grinder. You will taste it on the first cup."
    ],
    pull: '"Two of the same grams, ground differently, are different coffees."',
    refs: [
      { k: 'Recommended', v: 'Hand burr grinder' },
      { k: 'Setting', v: 'Medium · sea-salt texture' },
      { k: 'Replace burrs', v: 'Every 1,000 lb' },
    ]
  },
  {
    id: 'water',
    n: 2, num: '02', cat: 'Chemistry',
    title: 'Water is 98% of the cup.',
    dek: "If your tap tastes good, brew with it. If it doesn't, neither will your coffee.",
    body: [
      "By weight, a cup of coffee is roughly 98.5% water. Whatever character that water has — chlorinated, mineral-heavy, soft — finds its way into the brew.",
      "Filtered water is the cheapest upgrade you can make. A simple carbon filter pitcher pulls out chlorine and most off-flavors. For the obsessed, mineral packets reproduce the SCA's recommended brewing water profile at home.",
      "Distilled water is too clean — minerals participate in extraction. Skip it.",
      "If your tap is potable and pleasant on its own, it's probably fine for coffee. Trust your tongue."
    ],
    pull: '"By weight, a cup of coffee is 98.5% water."',
    refs: [
      { k: 'Target hardness', v: '~150 ppm' },
      { k: 'Avoid', v: 'Distilled, softened' },
      { k: 'Easy fix', v: 'Carbon-filter pitcher' },
    ]
  },
  {
    id: 'bloom',
    n: 3, num: '03', cat: 'Method',
    title: 'Bloom is not optional.',
    dek: 'Skip the bloom and you trap CO₂ that fights your pour. The first thirty seconds set up the rest.',
    body: [
      "Fresh coffee is full of carbon dioxide. When hot water hits, the gas erupts — that mesmerizing dome of bubbles. If you don't let it escape, it forms channels in the bed and your subsequent pours race past instead of brewing.",
      "Pour twice the weight of your dose, evenly, and wait thirty seconds. Watch the bed swell. Watch it deflate. Then pour.",
      "The fresher the bean, the more dramatic the bloom. A flat bloom usually means stale beans — or a roast more than four weeks past its date."
    ],
    pull: '"Skip the bloom; trap the gas; ruin the pour."',
    refs: [
      { k: 'Bloom water', v: '2× dose' },
      { k: 'Duration', v: '30 sec' },
      { k: 'Sign of life', v: 'Visible dome' },
    ]
  },
  {
    id: 'temp',
    n: 4, num: '04', cat: 'Chemistry',
    title: 'Hotter for light, cooler for dark.',
    dek: 'Roast level decides the temperature. Pulling against it is the difference between bright and bitter.',
    body: [
      "Light-roasted beans are dense and require more energy to extract their sugars and acids. Pour at 205–210°F.",
      "Dark roasts are porous and extract easily — too easily. Cooler water (195–200°F) keeps them from going bitter and ashy.",
      "Medium roasts split the difference at 200–205°F. When in doubt, that's the safe target.",
      "An off-boil kettle, rested 30–60 seconds, lands roughly at 205°F. No thermometer needed for most homes."
    ],
    pull: '"Light wants hot. Dark wants restraint."',
    refs: [
      { k: 'Light', v: '205–210°F' },
      { k: 'Medium', v: '200–205°F' },
      { k: 'Dark', v: '195–200°F' },
    ]
  },
  {
    id: 'ratio',
    n: 5, num: '05', cat: 'Method',
    title: 'A ratio, not a recipe.',
    dek: '1:15 to 1:17. Memorize the band, scale the dose, and stop measuring with a scoop.',
    body: [
      "Recipes lie. Ratios scale. One gram of coffee to fifteen grams of water makes a strong cup; 1:17 makes a clean one. Anywhere in between is good coffee.",
      "Volume measurements (scoops, tablespoons) vary with bean size and grind. A scoop of light Ethiopian and a scoop of dark Sumatra are not the same dose.",
      "A $15 kitchen scale ends every argument. Weigh the dose, weigh the water, taste, adjust. The whole thing takes ten seconds longer."
    ],
    pull: '"Recipes lie. Ratios scale."',
    refs: [
      { k: 'Strong', v: '1:15' },
      { k: 'Balanced', v: '1:16' },
      { k: 'Clean', v: '1:17' },
    ]
  },
  {
    id: 'pour',
    n: 6, num: '06', cat: 'Technique',
    title: 'Pour slowly, in a spiral.',
    dek: 'A gooseneck kettle is half technique, half jewelry. The spiral pour is what it buys you.',
    body: [
      "Direct, fast pours blast a hole through the center of the bed and channel water past the grounds. The result tastes thin and uneven.",
      "A spiral pour — center out to the edge, then back in — saturates the entire bed evenly. Keep the stream pencil-thin.",
      "Avoid the filter walls. Water touching paper instead of grounds is wasted; worse, it dilutes the cup.",
      "Aim for a steady tempo over the full pour window. Two-minute spirals feel slow; they taste correct."
    ],
    pull: '"Center out, then back in. Never the walls."',
    refs: [
      { k: 'Tool', v: 'Gooseneck kettle' },
      { k: 'Pattern', v: 'Spiral, center out' },
      { k: 'Pour window', v: '2:00 from bloom' },
    ]
  },
  {
    id: 'fresh',
    n: 7, num: '07', cat: 'Beans',
    title: 'Fresh, but not too fresh.',
    dek: 'Beans need a week to settle. After four, they fade. Read the roast date, not the sell-by.',
    body: [
      "Roasted beans off-gas CO₂ for several days. Brew them too early and the gas crowds out the water; the cup tastes flat or sour.",
      "Wait 7 to 14 days from roast date. The flavors round out, the bloom becomes lively but controllable.",
      "After about 30 days, the volatile aromatics — the things that make coffee smell like coffee — start to disappear. The cup becomes muted.",
      "The only date that matters is the roast date. 'Best by' is marketing."
    ],
    pull: '"Read the roast date. Ignore the rest."',
    refs: [
      { k: 'Best window', v: '7–28 days post-roast' },
      { k: 'Storage', v: 'Sealed, dark, cool' },
      { k: 'Avoid', v: 'Freezer, fridge' },
    ]
  },
  {
    id: 'taste',
    n: 8, num: '08', cat: 'Practice',
    title: 'Taste, then adjust — one variable at a time.',
    dek: "Bitter? Grind coarser. Sour? Grind finer. Don't change three things at once and call it a method.",
    body: [
      "Coffee diagnostics are simple if you isolate the variable. Bitter and dry on the back of the tongue means over-extraction — coarsen the grind or shorten the pour.",
      "Sour, sharp, lemony? Under-extracted. Grind finer or pour slower. Watery and thin? Often a dose problem; weigh again.",
      "Change one thing per brew. Two changes and you can't tell which fixed it. Three and you're guessing.",
      "Keep a tasting note for each new bag. Within a week you'll have your dialed-in recipe."
    ],
    pull: '"One variable at a time. Always."',
    refs: [
      { k: 'Bitter', v: 'Coarsen' },
      { k: 'Sour', v: 'Finer' },
      { k: 'Thin', v: 'Re-weigh' },
    ]
  },
];

function TipsScreen({ dark = false, onOpenTip, onTabChange }) {
  const { C, serif, sans } = useZine(dark);

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:48"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 100 }}>
        <ZSubHeader C={C} serif={serif} sans={sans}
          kicker="Field Notes"
          title={<>Field <em style={{ color: C.accent }}>Notes</em>.</>}
          sub="Eight pieces of advice we'd give a friend."/>

        {/* Pull-quote up top */}
        <div style={{ padding: '20px 24px 4px' }}>
          <div style={{ fontFamily: serif, fontStyle: 'italic',
            fontSize: 22, lineHeight: 1.25, color: C.ink, letterSpacing: -0.4 }}>
            Most great cups fail on a small detail. These are the small details.
          </div>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginTop: 18 }}/>
        </div>

        {/* TOC */}
        <div style={{ padding: '4px 24px 0' }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10,
            padding: '14px 0' }}>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 700,
              letterSpacing: 2.5, textTransform: 'uppercase', color: C.muted }}>
              Contents
            </span>
            <div style={{ flex: 1, height: 1, background: C.rule }}/>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
              letterSpacing: 1.5, color: C.muted }}>
              {TIPS.length} entries
            </span>
          </div>

          {TIPS.map(t => (
            <TipRow key={t.id} tip={t}
              onTap={() => onOpenTip && onOpenTip(t.id)}
              C={C} serif={serif} sans={sans}/>
          ))}

          <ZRule C={C} thick={2} style={{ background: C.ink, opacity: 0.85,
            marginTop: 18 }}/>
          <ZRule C={C} thick={1} style={{ background: C.ink, opacity: 0.85,
            marginTop: 2 }}/>

          <div style={{ textAlign: 'center', padding: '20px 0 0',
            fontFamily: serif, fontStyle: 'italic', fontSize: 12, color: C.muted }}>
            — end of contents —
          </div>
        </div>

        <ZTabBar C={C} sans={sans} active="tips" onChange={onTabChange}/>
      </div>
    </PCFrame>
  );
}

function TipRow({ tip, onTap, C, serif, sans }) {
  return (
    <button onClick={onTap} style={{
      all: 'unset', cursor: 'pointer', display: 'block', width: '100%',
      padding: '16px 0', borderBottom: `1px dotted ${C.rule}`,
    }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 14 }}>
        <span style={{ fontFamily: serif, fontWeight: 400, fontSize: 32,
          color: C.accent, letterSpacing: -1, lineHeight: 0.9, flexShrink: 0,
          width: 38 }}>
          {tip.num}
        </span>
        <div style={{ flex: 1 }}>
          <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
            letterSpacing: 2.5, textTransform: 'uppercase', color: C.muted,
            marginBottom: 4 }}>
            {tip.cat}
          </div>
          <div style={{ fontFamily: serif, fontWeight: 500, fontSize: 19,
            color: C.ink, letterSpacing: -0.3, lineHeight: 1.15,
            marginBottom: 6 }}>
            {tip.title}
          </div>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
            color: C.muted, lineHeight: 1.4 }}>
            {tip.dek}
          </div>
        </div>
        <IconChevron size={14} color={C.muted} sw={1.6}
          style={{ flexShrink: 0, marginTop: 14 }}/>
      </div>
    </button>
  );
}

window.TipsScreen = TipsScreen;
window.TIPS = TIPS;
