// directionA.jsx — Editorial Zine
// Personality: cafe menu board × magazine layout
// Type: Fraunces serif display + Inter sans
// Accent: copper #B87333 / burnished copper #D4935A
// Vibe: numbered sections, ruled lines, asymmetric, "menu" feel
// Input: Stepper + big number, restyled

function DirA({ dark = false }) {
  const brew = useBrew();
  // palette
  const C = dark ? {
    bg: '#1A1412', surface: '#241A17', surface2: '#2C2320',
    ink: '#F0E6D6', muted: '#B89A7E', rule: 'rgba(240,230,214,0.18)',
    accent: '#D4935A', accentInk: '#1A1412',
    chip: 'rgba(212,147,90,0.14)',
  } : {
    bg: '#FBF3E5', surface: '#FFF8EC', surface2: '#F0E6D0',
    ink: '#2A1F1B', muted: '#7A5E45', rule: 'rgba(42,31,27,0.18)',
    accent: '#B87333', accentInk: '#FFF8EC',
    chip: 'rgba(184,115,51,0.10)',
  };
  const serif = '"Fraunces", "Source Serif 4", Georgia, serif';
  const sans  = '"Inter", system-ui, sans-serif';

  const Rule = ({ thick = 1, op = 1, style }) => (
    <div style={{ height: thick, background: C.rule, opacity: op, ...style }}/>
  );

  // Section header — "Nº 01 — SELECT ROAST"
  const Section = ({ n, title, kicker, children, style }) => (
    <section style={{ padding: '0 24px', ...style }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginBottom: 10 }}>
        <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
          color: C.accent, letterSpacing: 0.4 }}>Nº {n}</span>
        <Rule thick={1} style={{ flex: 1, background: C.accent, opacity: 0.5 }}/>
        {kicker && <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
          letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>{kicker}</span>}
      </div>
      <h2 style={{ fontFamily: serif, fontWeight: 500, fontSize: 26, lineHeight: 1.05,
        color: C.ink, margin: '0 0 16px', letterSpacing: -0.5 }}>{title}</h2>
      {children}
    </section>
  );

  // Roast row
  const RoastRow = ({ r }) => {
    const sel = brew.roastId === r.id;
    return (
      <button onClick={() => brew.setRoastId(r.id)} style={{
        all: 'unset', cursor: 'pointer', display: 'block', width: '100%',
        padding: '14px 0', borderTop: `1px solid ${C.rule}`,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
          {/* circle */}
          <div style={{ width: 22, height: 22, borderRadius: 99,
            border: `1.5px solid ${sel ? C.accent : C.muted}`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            background: sel ? C.accent : 'transparent', flexShrink: 0,
          }}>
            {sel && <IconCheck size={13} color={C.accentInk} sw={2.4}/>}
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
              <span style={{ fontFamily: serif, fontSize: 22, fontWeight: 500,
                color: C.ink, letterSpacing: -0.3 }}>{r.name}</span>
              <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
                color: C.muted }}>— {r.short}</span>
            </div>
            <div style={{ fontFamily: sans, fontSize: 12, color: C.muted,
              marginTop: 2, lineHeight: 1.45 }}>{r.flavor}</div>
          </div>
          {/* ratio in serif italic */}
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontWeight: 500,
            fontSize: 22, color: sel ? C.accent : C.ink, letterSpacing: -0.5 }}>
            {r.label}
          </div>
        </div>
      </button>
    );
  };

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:41"/>
      <div style={{ height: 'calc(100% - 0px)', overflow: 'auto', paddingBottom: 90 }}>
        {/* MASTHEAD */}
        <div style={{ padding: '4px 24px 0' }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            fontFamily: sans, fontSize: 10, fontWeight: 600, letterSpacing: 2.5,
            textTransform: 'uppercase', color: C.muted, paddingTop: 6 }}>
            <span>Vol. 04 · Issue 16</span>
            <span style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
              <IconStamp size={12} color={C.accent}/> Pourcraft
            </span>
            <span>April</span>
          </div>
          <Rule thick={2} style={{ marginTop: 10, background: C.ink, opacity: 0.85 }}/>
          <Rule thick={1} style={{ marginTop: 2, background: C.ink, opacity: 0.85 }}/>
          <h1 style={{ fontFamily: serif, fontWeight: 400, fontSize: 56,
            lineHeight: 0.92, color: C.ink, margin: '20px 0 4px',
            letterSpacing: -2.5 }}>
            The <em style={{ fontStyle: 'italic', color: C.accent }}>Pour</em>
          </h1>
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
            <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14,
              color: C.muted }}>A calculator, set in type.</span>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
              letterSpacing: 2, color: C.muted }}>EST. 2024</span>
          </div>
          <Rule thick={1} style={{ marginTop: 14, background: C.rule }}/>
        </div>

        {/* Nº 01 — ROAST */}
        <Section n="01" title="Choose your roast." kicker="Three options" style={{ marginTop: 22 }}>
          <div style={{ borderBottom: `1px solid ${C.rule}` }}>
            {ROASTS.map(r => <RoastRow key={r.id} r={r}/>)}
          </div>
        </Section>

        {/* Nº 02 — WEIGHT */}
        <Section n="02" title="Dial in the dose." kicker="Grams" style={{ marginTop: 28 }}>
          <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between',
            paddingBottom: 14 }}>
            <div style={{ display: 'flex', alignItems: 'baseline' }}>
              <span style={{ fontFamily: serif, fontWeight: 400, fontSize: 96,
                lineHeight: 0.85, color: C.ink, letterSpacing: -4 }}>
                {brew.weight}
              </span>
              <span style={{ fontFamily: serif, fontStyle: 'italic',
                fontSize: 22, color: C.muted, marginLeft: 6 }}>g</span>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8, alignItems: 'flex-end' }}>
              <button onClick={() => brew.setWeight(brew.weight + 1)}
                style={btnStyle(C, sans, 'circle')}>
                <IconPlus size={16} color={C.ink} sw={1.6}/>
              </button>
              <button onClick={() => brew.setWeight(brew.weight - 1)}
                style={btnStyle(C, sans, 'circle')}>
                <IconMinus size={16} color={C.ink} sw={1.6}/>
              </button>
            </div>
          </div>
          {/* Weight ruler */}
          <Ruler value={brew.weight} onChange={brew.setWeight} C={C} sans={sans}/>
          {/* Ratio caption */}
          <div style={{ marginTop: 14, display: 'flex', justifyContent: 'space-between',
            alignItems: 'baseline', fontFamily: serif, fontStyle: 'italic',
            fontSize: 14, color: C.muted }}>
            <span>at a ratio of <span style={{ color: C.accent, fontStyle: 'normal',
              fontWeight: 500 }}>{brew.roast.label}</span></span>
            <span style={{ fontFamily: sans, fontStyle: 'normal',
              fontSize: 11, fontWeight: 600, letterSpacing: 1.5, color: C.muted,
              textTransform: 'uppercase' }}>10g — 60g</span>
          </div>
        </Section>

        {/* Nº 03 — POUR */}
        <Section n="03" title="The pour, by weight." kicker="Computed" style={{ marginTop: 28 }}>
          <div style={{ background: C.surface, padding: '20px 22px', borderRadius: 4,
            border: `1px solid ${C.rule}` }}>
            <PourLine icon={IconV60}    label="Total water"       value={brew.total}     unit="g" big C={C} serif={serif} sans={sans}/>
            <Rule thick={1} style={{ margin: '14px 0', background: C.rule }}/>
            <PourLine icon={IconBloom}  label="Bloom · 30 sec"    value={brew.bloom}     unit="g" C={C} serif={serif} sans={sans}/>
            <Rule thick={1} style={{ margin: '12px 0', background: C.rule, opacity: 0.5 }}/>
            <PourLine icon={IconSpiral} label="Remaining · spiral" value={brew.remaining} unit="g" C={C} serif={serif} sans={sans}/>
            <Rule thick={1} style={{ margin: '12px 0', background: C.rule, opacity: 0.5 }}/>
            <PourLine icon={IconThermo} label="Water temp" value={brew.tempRange} C={C} serif={serif} sans={sans}/>
          </div>

          {/* Temperature toggle */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            marginTop: 16, paddingBottom: 4 }}>
            <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
              color: C.muted }}>Display in</span>
            <div style={{ display: 'flex', border: `1px solid ${C.ink}`,
              borderRadius: 999, overflow: 'hidden', fontFamily: sans, fontSize: 12,
              fontWeight: 600, letterSpacing: 1 }}>
              {['F','C'].map(u => (
                <button key={u} onClick={() => brew.setUnit(u)} style={{
                  all: 'unset', cursor: 'pointer', padding: '6px 16px',
                  background: brew.unit === u ? C.ink : 'transparent',
                  color: brew.unit === u ? C.bg : C.ink,
                }}>°{u}</button>
              ))}
            </div>
          </div>
        </Section>

        {/* CTA */}
        <div style={{ padding: '28px 24px 0' }}>
          <button style={{
            all: 'unset', cursor: 'pointer', display: 'flex', alignItems: 'center',
            justifyContent: 'space-between', width: '100%', boxSizing: 'border-box',
            background: C.accent, color: C.accentInk, padding: '18px 22px',
            borderRadius: 2, fontFamily: serif, fontSize: 18, fontWeight: 500,
            letterSpacing: -0.2,
          }}>
            <span style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <IconKettle size={22} color={C.accentInk} sw={1.6}/>
              Begin the brew
            </span>
            <IconChevron size={18} color={C.accentInk} sw={1.8}/>
          </button>
          <div style={{ textAlign: 'center', marginTop: 14, fontFamily: serif,
            fontStyle: 'italic', fontSize: 12, color: C.muted }}>
            — three minutes, give or take —
          </div>
        </div>

        {/* Tab bar */}
        <TabBar C={C} sans={sans} active="brew"/>
      </div>
    </PCFrame>
  );
}

function btnStyle(C, sans, kind) {
  return {
    all: 'unset', cursor: 'pointer',
    width: 36, height: 36, borderRadius: 99,
    border: `1px solid ${C.ink}`,
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    background: 'transparent',
  };
}

function Ruler({ value, onChange, C, sans }) {
  // 51 ticks, 10..60. Major every 5.
  const ticks = [];
  for (let i = 10; i <= 60; i++) ticks.push(i);
  const range = 50;
  const pct = (value - 10) / range;
  return (
    <div style={{ position: 'relative', height: 50, marginTop: 4 }}>
      {/* tick row */}
      <div style={{ position: 'absolute', left: 0, right: 0, top: 0, height: 30,
        display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between' }}>
        {ticks.map(t => {
          const major = t % 5 === 0;
          return <div key={t} style={{
            width: 1, height: major ? 18 : 9, background: C.ink,
            opacity: major ? 0.85 : 0.35,
          }}/>;
        })}
      </div>
      {/* labels */}
      <div style={{ position: 'absolute', left: 0, right: 0, top: 22,
        display: 'flex', justifyContent: 'space-between', fontFamily: sans,
        fontSize: 10, fontWeight: 600, color: C.muted, letterSpacing: 0.5 }}>
        {[10,20,30,40,50,60].map(t => <span key={t}>{t}</span>)}
      </div>
      {/* indicator triangle */}
      <div style={{ position: 'absolute', top: -6, left: `${pct * 100}%`,
        transform: 'translateX(-50%)' }}>
        <svg width="14" height="10" viewBox="0 0 14 10">
          <path d="M7 10 L0 0 L14 0 Z" fill={C.accent}/>
        </svg>
      </div>
      {/* invisible drag track */}
      <input type="range" min="10" max="60" step="1" value={value}
        onChange={e => onChange(+e.target.value)}
        style={{ position: 'absolute', inset: 0, opacity: 0, cursor: 'pointer', width: '100%' }}/>
    </div>
  );
}

function PourLine({ icon: Icon, label, value, unit, big, C, serif, sans }) {
  return (
    <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <Icon size={big ? 22 : 18} color={C.ink} sw={1.4}/>
        <span style={{ fontFamily: serif, fontSize: big ? 18 : 14,
          fontStyle: 'italic', color: C.ink }}>{label}</span>
      </div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 4 }}>
        <span style={{ fontFamily: serif, fontWeight: 500,
          fontSize: big ? 36 : 22, color: C.ink, letterSpacing: -1 }}>
          {value}</span>
        {unit && <span style={{ fontFamily: serif, fontStyle: 'italic',
          fontSize: big ? 16 : 13, color: C.muted }}>{unit}</span>}
      </div>
    </div>
  );
}

function TabBar({ C, sans, active }) {
  const items = [
    { id: 'brew',  label: 'Brew',  Icon: IconV60 },
    { id: 'guide', label: 'Guide', Icon: IconKettle },
    { id: 'tips',  label: 'Tips',  Icon: IconBeans },
    { id: 'about', label: 'About', Icon: IconStamp },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0, height: 78,
      background: C.bg, borderTop: `1px solid ${C.rule}`,
      display: 'flex', alignItems: 'flex-start', justifyContent: 'space-around',
      paddingTop: 10,
    }}>
      {items.map(it => {
        const sel = it.id === active;
        return (
          <div key={it.id} style={{ display: 'flex', flexDirection: 'column',
            alignItems: 'center', gap: 4, padding: '4px 8px' }}>
            <it.Icon size={22} color={sel ? C.accent : C.muted} sw={1.4}/>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
              letterSpacing: 1, textTransform: 'uppercase',
              color: sel ? C.accent : C.muted }}>{it.label}</span>
          </div>
        );
      })}
    </div>
  );
}

window.DirA = DirA;
