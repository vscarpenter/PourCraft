// screenAbout.jsx — Editorial Zine · About / Colophon
// "About" laid out as the back-of-book colophon page in a literary magazine.

function AboutScreen({ dark = false, onTabChange }) {
  const { C, serif, sans } = useZine(dark);

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:55"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 100 }}>
        <ZSubHeader C={C} serif={serif} sans={sans}
          kicker="Colophon"
          title={<>The <em style={{ color: C.accent }}>Colophon</em>.</>}
          sub="A note on what this is, and who made it."/>

        {/* Manifesto */}
        <div style={{ padding: '24px 24px 0' }}>
          <div style={{ fontFamily: serif, fontStyle: 'italic',
            fontSize: 22, lineHeight: 1.3, color: C.ink, letterSpacing: -0.4 }}>
            Pourcraft is a small calculator that takes coffee seriously
            without taking itself too seriously.
          </div>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginTop: 18 }}/>
        </div>

        {/* Body — two short paragraphs */}
        <div style={{ padding: '20px 24px 0' }}>
          <p style={{ fontFamily: serif, fontSize: 15, lineHeight: 1.55,
            color: C.ink, margin: '0 0 14px', textAlign: 'justify' }}>
            We built this because the apps we tried were either spreadsheets
            in disguise or so simplified they hid the parts that actually
            matter — the ratio, the temperature, the rhythm of the pour.
          </p>
          <p style={{ fontFamily: serif, fontSize: 15, lineHeight: 1.55,
            color: C.ink, margin: '0 0 14px', textAlign: 'justify' }}>
            Everything here lives on one page. Choose a roast. Set the dose.
            The numbers fall out. Then we get out of the way and let you brew.
          </p>
        </div>

        {/* Stats strip — magazine "by the numbers" */}
        <div style={{ padding: '10px 24px 0' }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10,
            marginBottom: 14 }}>
            <span style={{ fontFamily: serif, fontStyle: 'italic',
              fontSize: 13, color: C.accent }}>Nº 04</span>
            <div style={{ flex: 1, height: 1, background: C.accent, opacity: 0.5 }}/>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
              letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>
              By the numbers
            </span>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr',
            gap: 0, border: `1px solid ${C.rule}`, background: C.surface }}>
            <StatCell C={C} serif={serif} sans={sans} k="Cups poured" v="04.2M"/>
            <StatCell C={C} serif={serif} sans={sans} k="Ratios" v="1:14–1:18" left/>
            <StatCell C={C} serif={serif} sans={sans} k="Roasts on file" v="03" top/>
            <StatCell C={C} serif={serif} sans={sans} k="App size" v="2.4mb" top left/>
          </div>
        </div>

        {/* Credits — TOC-style with leader dots */}
        <div style={{ padding: '28px 24px 0' }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10,
            marginBottom: 14 }}>
            <span style={{ fontFamily: serif, fontStyle: 'italic',
              fontSize: 13, color: C.accent }}>Nº 05</span>
            <div style={{ flex: 1, height: 1, background: C.accent, opacity: 0.5 }}/>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
              letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>
              Masthead
            </span>
          </div>
          {[
            { k: 'Editor at large', v: 'M. Halloway' },
            { k: 'Design', v: 'The Pourcraft Studio' },
            { k: 'Type', v: 'Fraunces & Inter' },
            { k: 'Engineering', v: 'A small team' },
            { k: 'Recipe research', v: 'A. Tanaka' },
          ].map((c, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'baseline',
              gap: 8, padding: '10px 0',
              borderBottom: `1px dotted ${C.rule}` }}>
              <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 700,
                letterSpacing: 2, textTransform: 'uppercase', color: C.muted,
                flexShrink: 0 }}>{c.k}</span>
              <div style={{ flex: 1, borderBottom: `1px dotted ${C.rule}`,
                margin: '0 6px 4px', height: 1 }}/>
              <span style={{ fontFamily: serif, fontStyle: 'italic',
                fontSize: 15, color: C.ink }}>{c.v}</span>
            </div>
          ))}
        </div>

        {/* Settings */}
        <div style={{ padding: '28px 24px 0' }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10,
            marginBottom: 14 }}>
            <span style={{ fontFamily: serif, fontStyle: 'italic',
              fontSize: 13, color: C.accent }}>Nº 06</span>
            <div style={{ flex: 1, height: 1, background: C.accent, opacity: 0.5 }}/>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
              letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>
              Preferences
            </span>
          </div>
          {[
            { k: 'Default unit',          v: 'Fahrenheit' },
            { k: 'Default ratio',         v: 'Suggested by roast' },
            { k: 'Haptic feedback',       v: 'On' },
            { k: 'Auto-start bloom timer',v: 'On' },
          ].map((c, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'baseline',
              justifyContent: 'space-between', padding: '14px 0',
              borderBottom: `1px solid ${C.rule}` }}>
              <span style={{ fontFamily: serif, fontSize: 16, color: C.ink }}>
                {c.k}
              </span>
              <span style={{ fontFamily: serif, fontStyle: 'italic',
                fontSize: 14, color: C.accent }}>{c.v}</span>
            </div>
          ))}
        </div>

        {/* Footer */}
        <div style={{ padding: '32px 24px 0', textAlign: 'center' }}>
          <ZRule C={C} thick={2} style={{ background: C.ink, opacity: 0.85 }}/>
          <ZRule C={C} thick={1} style={{ background: C.ink, opacity: 0.85,
            marginTop: 2 }}/>
          <div style={{ display: 'flex', justifyContent: 'center',
            margin: '20px 0 8px' }}>
            <IconStamp size={28} color={C.accent} sw={1.4}/>
          </div>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14,
            color: C.muted, lineHeight: 1.5 }}>
            Made for people who weigh their coffee, and own a kettle with a
            spout that looks slightly silly.
          </div>
          <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
            letterSpacing: 3, textTransform: 'uppercase', color: C.muted,
            marginTop: 14 }}>
            v1.0 · April 2024 · pourcraft.coffee
          </div>
        </div>

        <ZTabBar C={C} sans={sans} active="about" onChange={onTabChange}/>
      </div>
    </PCFrame>
  );
}

function StatCell({ C, serif, sans, k, v, top, left }) {
  return (
    <div style={{
      padding: '16px 18px',
      borderTop: top ? `1px solid ${C.rule}` : 'none',
      borderLeft: left ? `1px solid ${C.rule}` : 'none',
    }}>
      <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
        letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>{k}</div>
      <div style={{ fontFamily: serif, fontWeight: 500, fontSize: 28,
        color: C.ink, letterSpacing: -1, marginTop: 2,
        fontVariantNumeric: 'tabular-nums' }}>{v}</div>
    </div>
  );
}

window.AboutScreen = AboutScreen;
