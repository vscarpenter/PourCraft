// screenAbout.jsx — Editorial Zine · About / Colophon
// Adds: global °F/°C toggle (#10), App Store actions (#19), no justify (#2),
// links use minHeight 44 for tap target.

function AboutScreen({ dark = false, onTabChange, brew }) {
  const { C, serif, sans } = useZine(dark);
  const local = useBrew();
  const b = brew || local;

  const credits = [
    { k: 'Created by',  v: 'Vinny Carpenter',  href: 'https://vinny.dev/' },
    { k: 'Inspired by', v: 'Kristin Carpenter' },
    { k: 'Developer',   v: 'Katie Carpenter' },
    { k: 'Type',        v: 'Fraunces & Inter' },
  ];

  const actions = [
    { id: 'rate',     label: 'Rate PourCraft',   detail: 'on the App Store' },
    { id: 'share',    label: 'Share with a friend', detail: '' },
    { id: 'feedback', label: 'Send feedback',    detail: 'feedback@pourcraft.coffee' },
    { id: 'privacy',  label: 'Privacy policy',   detail: '' },
  ];

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:55"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 110 }}>
        <ZSubHeader C={C} serif={serif} sans={sans} kicker="Colophon"
          title={<>The <em style={{ color: C.accent }}>Colophon</em>.</>}
          sub="A note on what this is, and who made it."/>

        {/* Manifesto */}
        <div style={{ padding: `${SPACE.xl + 4}px ${SPACE.xl}px 0` }}>
          <div style={{ fontFamily: serif, fontStyle: 'italic',
            fontSize: TYPE.title3, lineHeight: 1.3, color: C.ink, letterSpacing: -0.4,
            textWrap: 'pretty' }}>
            PourCraft is a small calculator that takes coffee seriously
            without taking itself too seriously.
          </div>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginTop: SPACE.xl - 2 }}/>
        </div>

        {/* Body */}
        <div style={{ padding: `${SPACE.lg + 4}px ${SPACE.xl}px 0` }}>
          <p style={{ fontFamily: serif, fontSize: TYPE.body, lineHeight: 1.6,
            color: C.ink, margin: 0, textAlign: 'left', textWrap: 'pretty' }}>
            Choose a roast. Set the dose. The numbers fall out. Then we get
            out of the way and let you brew.
          </p>
        </div>

        {/* Settings */}
        <div style={{ padding: `${SPACE.xxl}px ${SPACE.xl}px 0` }}>
          <ColSection n="01" kicker="Settings" C={C} serif={serif} sans={sans}/>
          <SettingRow C={C} serif={serif} sans={sans}
            label="Display temperature in"
            control={
              <div style={{ display: 'flex', border: `1px solid ${C.ink}`,
                borderRadius: 999, overflow: 'hidden', fontFamily: sans, fontSize: 12,
                fontWeight: 700, letterSpacing: 1 }}>
                {['F','C'].map(u => (
                  <button key={u} onClick={() => { b.setUnit(u); fireHaptic('selection'); }} style={{
                    all: 'unset', cursor: 'pointer', padding: `${SPACE.sm}px ${SPACE.lg}px`,
                    minHeight: 36, display: 'inline-flex', alignItems: 'center',
                    background: b.unit === u ? C.ink : 'transparent',
                    color: b.unit === u ? C.bg : C.ink,
                    transition: trans(['background','color'], MOTION.short),
                  }}>°{u}</button>
                ))}
              </div>
            }/>
          <SettingRow C={C} serif={serif} sans={sans}
            label="Haptic feedback" rightItalic="On"/>
          <SettingRow C={C} serif={serif} sans={sans}
            label="Auto-advance brew steps" rightItalic="On"/>
        </div>

        {/* App Store actions */}
        <div style={{ padding: `${SPACE.xxl}px ${SPACE.xl}px 0` }}>
          <ColSection n="02" kicker="The Reading Room" C={C} serif={serif} sans={sans}/>
          {actions.map((a, i) => (
            <button key={a.id} style={{
              all: 'unset', cursor: 'pointer', display: 'flex', width: '100%',
              alignItems: 'baseline', justifyContent: 'space-between',
              padding: `${SPACE.md + 2}px 0`,
              borderBottom: `1px solid ${C.rule}`, minHeight: 44,
            }}>
              <span style={{ fontFamily: serif, fontSize: TYPE.body + 1, color: C.ink }}>
                {a.label}
              </span>
              <span style={{ display: 'flex', alignItems: 'baseline', gap: SPACE.sm }}>
                {a.detail && <span style={{ fontFamily: serif, fontStyle: 'italic',
                  fontSize: 13, color: C.mutedSoft }}>{a.detail}</span>}
                <IconChevron size={12} color={C.muted} sw={1.6}/>
              </span>
            </button>
          ))}
        </div>

        {/* Masthead */}
        <div style={{ padding: `${SPACE.xxl}px ${SPACE.xl}px 0` }}>
          <ColSection n="03" kicker="Masthead" C={C} serif={serif} sans={sans}/>
          {credits.map((c, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'baseline',
              gap: SPACE.sm, padding: `${SPACE.md}px 0`,
              borderBottom: `1px dotted ${C.rule}`, minHeight: 44 }}>
              <span style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
                letterSpacing: 2, textTransform: 'uppercase', color: C.muted,
                flexShrink: 0 }}>{c.k}</span>
              <div style={{ flex: 1, borderBottom: `1px dotted ${C.rule}`,
                margin: '0 6px 4px', height: 1 }}/>
              {c.href ? (
                <a href={c.href} target="_blank" rel="noopener noreferrer"
                  style={{ fontFamily: serif, fontStyle: 'italic',
                    fontSize: TYPE.lg || 16, color: C.accent, textDecoration: 'none',
                    borderBottom: `1px solid ${C.accent}`,
                    display: 'inline-flex', alignItems: 'center', minHeight: 44 }}>
                  {c.v}
                </a>
              ) : (
                <span style={{ fontFamily: serif, fontStyle: 'italic',
                  fontSize: TYPE.lg || 16, color: C.ink }}>{c.v}</span>
              )}
            </div>
          ))}
        </div>

        {/* Footer */}
        <div style={{ padding: `${SPACE.xxxl - 8}px ${SPACE.xl}px 0`, textAlign: 'center' }}>
          <ZRule C={C} thick={1} style={{ background: C.ruleStrong, opacity: 0.65 }}/>
          <div style={{ display: 'flex', justifyContent: 'center',
            margin: `${SPACE.xl}px 0 ${SPACE.sm + 2}px` }}>
            <IconStamp size={28} color={C.accent} sw={1.4}/>
          </div>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14,
            color: C.muted, lineHeight: 1.5 }}>
            Made for people who weigh their coffee.
          </div>
          <div style={{ fontFamily: sans, fontSize: TYPE.caption - 1, fontWeight: 700,
            letterSpacing: 3, textTransform: 'uppercase', color: C.mutedSoft,
            marginTop: SPACE.md }}>
            v1.0 · pourcraft.coffee
          </div>
        </div>

        <ZTabBar C={C} sans={sans} active="about" onChange={onTabChange}/>
      </div>
    </PCFrame>
  );
}

function ColSection({ n, kicker, C, serif, sans }) {
  return (
    <div style={{ display: 'flex', alignItems: 'baseline', gap: SPACE.md,
      marginBottom: SPACE.md }}>
      <span style={{ fontFamily: serif, fontStyle: 'italic',
        fontSize: 13, color: C.accent }}>Nº {n}</span>
      <div style={{ flex: 1, height: 1, background: C.accent, opacity: 0.5 }}/>
      <span style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
        letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>{kicker}</span>
    </div>
  );
}

function SettingRow({ C, serif, sans, label, control, rightItalic }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center',
      justifyContent: 'space-between', padding: `${SPACE.md + 2}px 0`,
      borderBottom: `1px solid ${C.rule}`, minHeight: 56 }}>
      <span style={{ fontFamily: serif, fontSize: TYPE.lg || 16, color: C.ink }}>
        {label}
      </span>
      {control || (
        <span style={{ fontFamily: serif, fontStyle: 'italic',
          fontSize: 14, color: C.accent }}>{rightItalic}</span>
      )}
    </div>
  );
}

window.AboutScreen = AboutScreen;
