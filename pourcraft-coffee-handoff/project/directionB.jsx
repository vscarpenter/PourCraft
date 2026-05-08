// directionB.jsx — Cafe Menu Board
// Personality: chalkboard/menu typography, hand-set numerals, classified-ad rhythm
// Type: Fraunces serif (humanist) + Inter sans
// Accent: terracotta #C8553D / dusk terracotta #D87560
// Vibe: posted on a wall — section banners, dot-leaders, badge stamps
// Input: Vertical slider styled like a coffee scale

function DirB({ dark = false }) {
  const brew = useBrew({ weight: 22 });
  const C = dark ? {
    bg: '#1B1411', surface: '#241A16', surface2: '#2D211C',
    ink: '#F2E6D2', muted: '#B8967A',
    rule: 'rgba(242,230,210,0.20)', ruleStrong: 'rgba(242,230,210,0.55)',
    accent: '#D87560', accentInk: '#1B1411',
    chalk: 'rgba(242,230,210,0.04)',
  } : {
    bg: '#F5EAD6', surface: '#FBF3E2', surface2: '#EFE0C2',
    ink: '#2B1F18', muted: '#8C6A4F',
    rule: 'rgba(43,31,24,0.20)', ruleStrong: 'rgba(43,31,24,0.7)',
    accent: '#C8553D', accentInk: '#FBF3E2',
    chalk: 'rgba(43,31,24,0.03)',
  };
  const serif = '"Fraunces", "Source Serif 4", Georgia, serif';
  const sans  = '"Inter", system-ui, sans-serif';

  // Section banner: "—— TODAY'S MENU ——"
  const Banner = ({ children, top = 18 }) => (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 10, padding: '0 22px',
      marginTop: top, marginBottom: 12,
    }}>
      <div style={{ flex: 1, height: 1.5, background: C.ink, opacity: 0.7 }}/>
      <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 700,
        letterSpacing: 3, textTransform: 'uppercase', color: C.ink }}>{children}</span>
      <div style={{ flex: 1, height: 1.5, background: C.ink, opacity: 0.7 }}/>
    </div>
  );

  // Roast menu line — name ··············· ratio
  const MenuLine = ({ r }) => {
    const sel = brew.roastId === r.id;
    return (
      <button onClick={() => brew.setRoastId(r.id)} style={{
        all: 'unset', cursor: 'pointer', display: 'block', width: '100%',
        padding: '12px 22px', position: 'relative',
        background: sel ? C.surface2 : 'transparent',
      }}>
        {sel && <div style={{ position: 'absolute', left: 0, top: 6, bottom: 6,
          width: 4, background: C.accent, borderRadius: 0 }}/>}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10,
          marginBottom: 4 }}>
          <span style={{ fontFamily: serif, fontWeight: 600, fontSize: 22,
            color: C.ink, letterSpacing: -0.4 }}>{r.name} Roast</span>
          {/* dotted leader */}
          <div style={{ flex: 1, height: 0, borderBottom: `1.5px dotted ${C.muted}`,
            opacity: 0.6, marginBottom: 4 }}/>
          <span style={{ fontFamily: serif, fontWeight: 700, fontSize: 22,
            color: sel ? C.accent : C.ink, letterSpacing: -0.5 }}>{r.label}</span>
        </div>
        <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
          color: C.muted, paddingRight: 70, lineHeight: 1.4 }}>
          {r.flavor}
        </div>
      </button>
    );
  };

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink}/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 90 }}>
        {/* HEADER — chalkboard style */}
        <div style={{ padding: '8px 22px 0', textAlign: 'center' }}>
          <div style={{ fontFamily: sans, fontSize: 10, fontWeight: 700,
            letterSpacing: 4, textTransform: 'uppercase', color: C.muted }}>
            ☕ Pourcraft &nbsp;·&nbsp; No. 16
          </div>
          <div style={{ fontFamily: serif, fontSize: 44, fontWeight: 600,
            color: C.ink, letterSpacing: -1.2, lineHeight: 1.05, marginTop: 8 }}>
            Today's <span style={{ fontStyle: 'italic',
              color: C.accent, fontWeight: 400 }}>Pour</span>
          </div>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
            color: C.muted, marginTop: 6 }}>
            Hand-poured, by the gram. Two taps to a useful answer.
          </div>
          {/* double rule */}
          <div style={{ marginTop: 14 }}>
            <div style={{ height: 2, background: C.ink, opacity: 0.85 }}/>
            <div style={{ height: 1, background: C.ink, opacity: 0.85, marginTop: 2 }}/>
          </div>
        </div>

        {/* ROAST */}
        <Banner>The Roast</Banner>
        <div>
          {ROASTS.map((r, i) => (
            <React.Fragment key={r.id}>
              <MenuLine r={r}/>
              {i < ROASTS.length - 1 && <div style={{ margin: '0 22px',
                height: 1, background: C.rule }}/>}
            </React.Fragment>
          ))}
        </div>

        {/* DOSE — with vertical scale slider */}
        <Banner>The Dose</Banner>
        <div style={{ padding: '0 22px', display: 'flex', alignItems: 'stretch',
          gap: 16 }}>
          <ScaleSlider value={brew.weight} onChange={brew.setWeight} C={C}
            serif={serif} sans={sans}/>
          {/* readout */}
          <div style={{ flex: 1, padding: '6px 0', display: 'flex',
            flexDirection: 'column', justifyContent: 'space-between' }}>
            <div>
              <div style={{ fontFamily: sans, fontSize: 10, fontWeight: 700,
                letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>
                Coffee weight
              </div>
              <div style={{ display: 'flex', alignItems: 'baseline', marginTop: 4 }}>
                <span style={{ fontFamily: serif, fontWeight: 500, fontSize: 84,
                  color: C.ink, letterSpacing: -3.5, lineHeight: 0.85 }}>
                  {brew.weight}
                </span>
                <span style={{ fontFamily: serif, fontStyle: 'italic',
                  fontSize: 22, color: C.muted, marginLeft: 4 }}>g</span>
              </div>
              <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
                color: C.muted, marginTop: 2 }}>
                Drag the dial. Or the +/− below.
              </div>
            </div>
            <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
              <button onClick={() => brew.setWeight(brew.weight - 1)}
                style={chalkBtn(C, sans)}>− 1g</button>
              <button onClick={() => brew.setWeight(brew.weight + 1)}
                style={chalkBtn(C, sans)}>+ 1g</button>
            </div>
          </div>
        </div>

        {/* RATIO STAMP */}
        <div style={{ padding: '18px 22px 0', display: 'flex',
          alignItems: 'center', gap: 12 }}>
          <div style={{ height: 1, background: C.rule, flex: 1 }}/>
          <RatioStamp label={brew.roast.label} C={C} serif={serif} sans={sans}/>
          <div style={{ height: 1, background: C.rule, flex: 1 }}/>
        </div>

        {/* THE POUR — menu lines */}
        <Banner top={20}>The Pour</Banner>
        <div style={{ padding: '0 22px' }}>
          <PourMenuLine label="Total water"  value={brew.total + 'g'}    big C={C} serif={serif}/>
          <PourMenuLine label="Bloom — 30 sec" value={brew.bloom + 'g'}   C={C} serif={serif}/>
          <PourMenuLine label="Spiral pour"   value={brew.remaining + 'g'} C={C} serif={serif}/>
          <PourMenuLine label="Water temp"    value={brew.tempRange}      C={C} serif={serif}/>
          <PourMenuLine label="Brew time"     value="3:00 — 4:00"         C={C} serif={serif}
            last/>
        </div>

        {/* TEMP TOGGLE */}
        <div style={{ padding: '14px 22px 0', display: 'flex',
          justifyContent: 'space-between', alignItems: 'center' }}>
          <span style={{ fontFamily: serif, fontStyle: 'italic',
            fontSize: 13, color: C.muted }}>Served in</span>
          <div style={{ display: 'flex', gap: 0 }}>
            {['F','C'].map((u, i) => (
              <button key={u} onClick={() => brew.setUnit(u)} style={{
                all: 'unset', cursor: 'pointer',
                fontFamily: sans, fontSize: 11, fontWeight: 700,
                letterSpacing: 1.5, padding: '6px 14px',
                border: `1.5px solid ${C.ink}`,
                borderLeftWidth: i === 0 ? 1.5 : 0,
                background: brew.unit === u ? C.ink : 'transparent',
                color: brew.unit === u ? C.bg : C.ink,
              }}>°{u}</button>
            ))}
          </div>
        </div>

        {/* CTA — chalk button */}
        <div style={{ padding: '22px 22px 0' }}>
          <button style={{
            all: 'unset', cursor: 'pointer', display: 'flex', alignItems: 'center',
            justifyContent: 'center', gap: 14, width: '100%',
            boxSizing: 'border-box', background: C.accent,
            color: C.accentInk, padding: '18px 22px',
            border: `1.5px solid ${C.accent}`,
            fontFamily: serif, fontSize: 19, fontWeight: 600, letterSpacing: -0.3,
            position: 'relative',
          }}>
            <IconKettle size={22} color={C.accentInk} sw={1.6}/>
            Start the Brew Guide
            <IconChevron size={18} color={C.accentInk} sw={1.8}/>
          </button>
          <div style={{ textAlign: 'center', marginTop: 10, fontFamily: sans,
            fontSize: 9, fontWeight: 700, letterSpacing: 3, color: C.muted,
            textTransform: 'uppercase' }}>
            ✺&nbsp;&nbsp; Brew with intention &nbsp;&nbsp;✺
          </div>
        </div>

        <TabBarB C={C} sans={sans} active="brew"/>
      </div>
    </PCFrame>
  );
}

function chalkBtn(C, sans) {
  return {
    all: 'unset', cursor: 'pointer',
    flex: 1, padding: '10px 0', textAlign: 'center',
    border: `1.5px solid ${C.ink}`,
    fontFamily: sans, fontSize: 13, fontWeight: 600,
    letterSpacing: 0.3, color: C.ink, background: 'transparent',
  };
}

// Vertical scale — feels like a coffee scale's tick rail
function ScaleSlider({ value, onChange, C, serif, sans }) {
  const min = 10, max = 60, h = 240;
  const ticks = [];
  for (let i = min; i <= max; i++) ticks.push(i);
  // Map value -> y. value=min -> bottom, value=max -> top
  const yFor = (v) => h - ((v - min) / (max - min)) * h;
  const indicatorY = yFor(value);

  const onPointer = (e) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const y = Math.max(0, Math.min(h, e.clientY - rect.top));
    const pct = 1 - y / h;
    onChange(min + pct * (max - min));
  };

  return (
    <div style={{
      width: 96, padding: 10, position: 'relative',
      background: C.surface, border: `1.5px solid ${C.ink}`,
      borderRadius: 4, userSelect: 'none',
    }}>
      <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
        letterSpacing: 2, textTransform: 'uppercase', color: C.muted,
        textAlign: 'center', marginBottom: 6 }}>Grams</div>

      <div onPointerDown={(e) => { e.currentTarget.setPointerCapture(e.pointerId); onPointer(e); }}
        onPointerMove={(e) => { if (e.buttons) onPointer(e); }}
        style={{
          position: 'relative', height: h, marginLeft: 18,
          cursor: 'ns-resize', touchAction: 'none',
        }}>
        {/* main rail */}
        <div style={{ position: 'absolute', left: 0, top: 0, bottom: 0,
          width: 1.5, background: C.ink }}/>
        {/* ticks */}
        {ticks.map(t => {
          const y = yFor(t);
          const major = t % 5 === 0;
          return (
            <React.Fragment key={t}>
              <div style={{
                position: 'absolute', left: 0, top: y - 0.5,
                width: major ? 16 : 8, height: 1, background: C.ink,
                opacity: major ? 0.85 : 0.4,
              }}/>
              {major && (
                <div style={{ position: 'absolute', left: 20, top: y - 7,
                  fontFamily: serif, fontSize: 11, fontWeight: 600,
                  color: C.muted }}>{t}</div>
              )}
            </React.Fragment>
          );
        })}
        {/* indicator — terracotta arrow */}
        <div style={{
          position: 'absolute', left: -10, top: indicatorY - 6,
          transition: 'top 0.12s',
        }}>
          <svg width="46" height="14" viewBox="0 0 46 14">
            <path d="M0 7 L7 0 L46 0 L46 14 L7 14 Z" fill={C.accent}/>
          </svg>
          <div style={{ position: 'absolute', left: 12, top: 0, width: 34,
            height: 14, display: 'flex', alignItems: 'center',
            justifyContent: 'center', fontFamily: serif, fontWeight: 700,
            fontSize: 10, color: C.accentInk }}>
            {value}g
          </div>
        </div>
      </div>
    </div>
  );
}

function RatioStamp({ label, C, serif, sans }) {
  return (
    <div style={{
      width: 78, height: 78, borderRadius: 99,
      border: `2px solid ${C.accent}`, position: 'relative',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      flexShrink: 0,
    }}>
      <div style={{
        position: 'absolute', inset: 4, borderRadius: 99,
        border: `1px dashed ${C.accent}`, opacity: 0.5,
      }}/>
      <div style={{ textAlign: 'center' }}>
        <div style={{ fontFamily: sans, fontSize: 7, fontWeight: 700,
          letterSpacing: 2, color: C.accent, textTransform: 'uppercase' }}>Ratio</div>
        <div style={{ fontFamily: serif, fontSize: 22, fontWeight: 600,
          color: C.accent, letterSpacing: -0.5, marginTop: -2 }}>{label}</div>
      </div>
    </div>
  );
}

function PourMenuLine({ label, value, big, last, C, serif }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'baseline', padding: big ? '8px 0' : '6px 0',
      borderBottom: last ? 'none' : `1px dotted ${C.muted}`,
      opacity: last ? 1 : 1,
    }}>
      <span style={{ fontFamily: serif, fontStyle: big ? 'normal' : 'italic',
        fontWeight: big ? 600 : 400, fontSize: big ? 18 : 15, color: C.ink,
        letterSpacing: -0.2 }}>{label}</span>
      <div style={{ flex: 1 }}/>
      <span style={{ fontFamily: serif, fontWeight: big ? 700 : 600,
        fontSize: big ? 28 : 18, color: big ? C.accent : C.ink,
        letterSpacing: -0.5 }}>{value}</span>
    </div>
  );
}

function TabBarB({ C, sans, active }) {
  const items = [
    { id: 'brew',  label: 'Brew',  Icon: IconV60 },
    { id: 'guide', label: 'Guide', Icon: IconKettle },
    { id: 'tips',  label: 'Tips',  Icon: IconBeans },
    { id: 'about', label: 'About', Icon: IconStamp },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0, height: 78,
      background: C.bg, borderTop: `1.5px solid ${C.ink}`,
      display: 'flex', alignItems: 'flex-start', justifyContent: 'space-around',
      paddingTop: 10,
    }}>
      {items.map(it => {
        const sel = it.id === active;
        return (
          <div key={it.id} style={{ display: 'flex', flexDirection: 'column',
            alignItems: 'center', gap: 4, padding: '4px 8px', position: 'relative' }}>
            <it.Icon size={22} color={sel ? C.accent : C.muted} sw={1.4}/>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 700,
              letterSpacing: 1.5, textTransform: 'uppercase',
              color: sel ? C.accent : C.muted }}>{it.label}</span>
            {sel && <div style={{ position: 'absolute', bottom: -10,
              width: 24, height: 2, background: C.accent }}/>}
          </div>
        );
      })}
    </div>
  );
}

window.DirB = DirB;
