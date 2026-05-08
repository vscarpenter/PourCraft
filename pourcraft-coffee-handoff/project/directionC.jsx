// directionC.jsx — Specialty Roaster Bag
// Personality: packaging-inspired, badge/stamp motifs, label hierarchy
// Type: Fraunces serif + Inter sans, with stamped uppercase metadata
// Accent: copper #A86B2F on a deeper cream backdrop #EBDDC3 (light) / #2A1F1A (dark)
// Vibe: feels like the back of a single-origin bag — origin block, batch number, tasting notes
// Input: Stepper + big number, restyled as a "dose" panel

function DirC({ dark = false }) {
  const brew = useBrew({ weight: 18 });
  const C = dark ? {
    bg: '#1F1612', surface: '#291D17', surface2: '#33241C',
    ink: '#EFE0C2', muted: '#B59678',
    rule: 'rgba(239,224,194,0.18)', ruleStrong: 'rgba(239,224,194,0.55)',
    accent: '#D08F4F', accentInk: '#1F1612',
    label: '#EFE0C2',
  } : {
    bg: '#EBDDC3', surface: '#F4E9D2', surface2: '#E0CFAF',
    ink: '#1F1612', muted: '#7A5A3D',
    rule: 'rgba(31,22,18,0.18)', ruleStrong: 'rgba(31,22,18,0.6)',
    accent: '#A86B2F', accentInk: '#F4E9D2',
    label: '#1F1612',
  };
  const serif = '"Fraunces", "Source Serif 4", Georgia, serif';
  const sans  = '"Inter", system-ui, sans-serif';

  // Tiny stamped metadata block
  const Meta = ({ k, v, mono }) => (
    <div style={{ display: 'flex', justifyContent: 'space-between', padding: '7px 0',
      borderBottom: `1px solid ${C.rule}`, fontFamily: sans, fontSize: 10,
      letterSpacing: 1.5, textTransform: 'uppercase', fontWeight: 600 }}>
      <span style={{ color: C.muted }}>{k}</span>
      <span style={{ color: C.ink, fontFamily: mono ? '"JetBrains Mono", ui-monospace, monospace' : sans,
        letterSpacing: mono ? 0 : 1.5 }}>{v}</span>
    </div>
  );

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink}/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 90 }}>

        {/* THE BAG LABEL — outer card */}
        <div style={{ margin: '4px 18px 0', background: C.surface,
          border: `1.5px solid ${C.ink}`, padding: '20px 18px 22px',
          position: 'relative' }}>
          {/* corner stamp */}
          <div style={{ position: 'absolute', top: -14, right: 16,
            width: 76, height: 76, borderRadius: 99, background: C.bg,
            border: `1.5px solid ${C.accent}`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            flexDirection: 'column' }}>
            <div style={{ position: 'absolute', inset: 4, borderRadius: 99,
              border: `1px solid ${C.accent}`, opacity: 0.5 }}/>
            <div style={{ fontFamily: sans, fontSize: 7, fontWeight: 700,
              letterSpacing: 2, color: C.accent, textTransform: 'uppercase' }}>Ratio</div>
            <div style={{ fontFamily: serif, fontSize: 20, fontWeight: 700,
              color: C.accent, letterSpacing: -0.5, marginTop: -2 }}>{brew.roast.label}</div>
          </div>

          <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
            letterSpacing: 3, color: C.muted, textTransform: 'uppercase' }}>
            Single-Origin Pour-Over · Lot 016
          </div>
          <div style={{ fontFamily: serif, fontSize: 38, fontWeight: 600,
            color: C.ink, letterSpacing: -1, lineHeight: 1, marginTop: 8 }}>
            Pour<span style={{ color: C.accent }}>Craft</span>
          </div>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14,
            color: C.muted, marginTop: 4 }}>
            A pour-over calculator. Roasted in code.
          </div>

          {/* batch meta */}
          <div style={{ marginTop: 18, paddingTop: 4, paddingRight: 80 }}>
            <Meta k="Batch" v="04 · 2026" mono/>
            <Meta k="Method" v="V60 · Conical"/>
          </div>
        </div>

        {/* ROAST PROFILE — three labelled badges */}
        <div style={{ padding: '22px 18px 0' }}>
          <SectionTitle C={C} serif={serif} sans={sans} num="01"
            title="Roast Profile" sub="Three blends. Pick today's."/>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr',
            gap: 10, marginTop: 14 }}>
            {ROASTS.map(r => {
              const sel = brew.roastId === r.id;
              return (
                <button key={r.id} onClick={() => brew.setRoastId(r.id)} style={{
                  all: 'unset', cursor: 'pointer',
                  background: sel ? C.accent : C.surface,
                  color: sel ? C.accentInk : C.ink,
                  border: `1.5px solid ${sel ? C.accent : C.ink}`,
                  padding: '14px 10px', textAlign: 'center',
                  display: 'flex', flexDirection: 'column', gap: 6,
                  alignItems: 'center', position: 'relative',
                }}>
                  {/* roast intensity dots at top */}
                  <div style={{ display: 'flex', gap: 3 }}>
                    {[1,2,3].map(i => (
                      <div key={i} style={{ width: 6, height: 6, borderRadius: 99,
                        background: i <= r.intensity
                          ? (sel ? C.accentInk : C.ink)
                          : (sel ? 'rgba(31,22,18,0.2)' : C.rule) }}/>
                    ))}
                  </div>
                  <div style={{ fontFamily: serif, fontSize: 18, fontWeight: 600,
                    letterSpacing: -0.4, marginTop: 4 }}>{r.name}</div>
                  <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
                    letterSpacing: 1.4, opacity: 0.75,
                    textTransform: 'uppercase', textAlign: 'center', lineHeight: 1.4 }}>
                    {r.short}
                  </div>
                  <div style={{ fontFamily: serif, fontStyle: 'italic',
                    fontSize: 13, fontWeight: 500, marginTop: 2,
                    opacity: sel ? 1 : 0.7 }}>
                    {r.label}
                  </div>
                </button>
              );
            })}
          </div>

          <div style={{ marginTop: 12, fontFamily: serif, fontStyle: 'italic',
            fontSize: 13, color: C.muted, lineHeight: 1.45 }}>
            <span style={{ fontStyle: 'normal', fontFamily: sans, fontSize: 9,
              fontWeight: 700, letterSpacing: 2, textTransform: 'uppercase',
              color: C.ink }}>Notes&nbsp;&nbsp;</span>
            {brew.roast.flavor}
          </div>
        </div>

        {/* DOSE — stepper restyled */}
        <div style={{ padding: '22px 18px 0' }}>
          <SectionTitle C={C} serif={serif} sans={sans} num="02"
            title="Dose" sub="Coffee weight, in grams."/>

          <div style={{ marginTop: 14, background: C.surface,
            border: `1.5px solid ${C.ink}`, padding: '18px 18px',
            display: 'flex', alignItems: 'center', gap: 14 }}>
            {/* minus */}
            <button onClick={() => brew.setWeight(brew.weight - 1)}
              style={stepBtn(C)}><IconMinus size={18} color={C.ink} sw={1.6}/></button>
            {/* number */}
            <div style={{ flex: 1, textAlign: 'center' }}>
              <div style={{ display: 'flex', alignItems: 'baseline',
                justifyContent: 'center', gap: 4 }}>
                <span style={{ fontFamily: serif, fontWeight: 500, fontSize: 78,
                  color: C.ink, letterSpacing: -3, lineHeight: 0.85 }}>
                  {brew.weight}
                </span>
                <span style={{ fontFamily: serif, fontStyle: 'italic',
                  fontSize: 22, color: C.muted }}>g</span>
              </div>
              <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
                letterSpacing: 2.5, color: C.muted, textTransform: 'uppercase',
                marginTop: 6 }}>Net Weight</div>
            </div>
            {/* plus */}
            <button onClick={() => brew.setWeight(brew.weight + 1)}
              style={stepBtn(C)}><IconPlus size={18} color={C.ink} sw={1.6}/></button>
          </div>

          {/* range track with quick presets */}
          <div style={{ marginTop: 12, display: 'flex', gap: 6 }}>
            {[15, 18, 20, 25, 30].map(g => {
              const sel = brew.weight === g;
              return (
                <button key={g} onClick={() => brew.setWeight(g)} style={{
                  all: 'unset', cursor: 'pointer', flex: 1, textAlign: 'center',
                  padding: '7px 0', fontFamily: sans, fontSize: 11, fontWeight: 700,
                  letterSpacing: 0.5,
                  border: `1.2px solid ${sel ? C.accent : C.rule}`,
                  background: sel ? C.accent : 'transparent',
                  color: sel ? C.accentInk : C.muted,
                }}>{g}g</button>
              );
            })}
          </div>
        </div>

        {/* BREW SPEC — bag back-label style */}
        <div style={{ padding: '22px 18px 0' }}>
          <SectionTitle C={C} serif={serif} sans={sans} num="03"
            title="Brew Spec" sub="Calculated for this dose."/>

          <div style={{ marginTop: 14, border: `1.5px solid ${C.ink}`,
            background: C.bg }}>
            {/* big total */}
            <div style={{ padding: '18px 18px 14px',
              borderBottom: `1.5px solid ${C.ink}` }}>
              <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
                letterSpacing: 2.5, color: C.muted, textTransform: 'uppercase' }}>
                Total Water
              </div>
              <div style={{ display: 'flex', alignItems: 'baseline',
                justifyContent: 'space-between', marginTop: 4 }}>
                <div style={{ display: 'flex', alignItems: 'baseline', gap: 4 }}>
                  <span style={{ fontFamily: serif, fontWeight: 600, fontSize: 56,
                    color: C.ink, letterSpacing: -2, lineHeight: 0.9 }}>
                    {brew.total}</span>
                  <span style={{ fontFamily: serif, fontStyle: 'italic',
                    fontSize: 20, color: C.muted }}>grams</span>
                </div>
                <IconV60 size={40} color={C.accent} sw={1.2}/>
              </div>
            </div>

            {/* split: bloom | spiral */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr' }}>
              <SpecCell C={C} serif={serif} sans={sans} Icon={IconBloom}
                k="Bloom" v={brew.bloom + 'g'} sub="30 sec"
                divider="right"/>
              <SpecCell C={C} serif={serif} sans={sans} Icon={IconSpiral}
                k="Spiral" v={brew.remaining + 'g'} sub="2:30 pour"/>
            </div>
            <div style={{ height: 1.5, background: C.ink }}/>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr' }}>
              <SpecCell C={C} serif={serif} sans={sans} Icon={IconThermo}
                k="Temp" v={brew.tempRange.replace(' – ', '–')}
                sub="hold 30 sec off boil" divider="right" small/>
              <SpecCell C={C} serif={serif} sans={sans} Icon={IconTimer}
                k="Total" v="3:00–4:00" sub="bloom + spiral" small/>
            </div>
          </div>

          {/* unit toggle */}
          <div style={{ display: 'flex', alignItems: 'center',
            justifyContent: 'space-between', marginTop: 12 }}>
            <span style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
              letterSpacing: 2.5, color: C.muted, textTransform: 'uppercase' }}>
              Display
            </span>
            <div style={{ display: 'flex' }}>
              {['F','C'].map((u, i) => (
                <button key={u} onClick={() => brew.setUnit(u)} style={{
                  all: 'unset', cursor: 'pointer',
                  fontFamily: sans, fontSize: 11, fontWeight: 700,
                  letterSpacing: 1.5, padding: '6px 16px',
                  border: `1.2px solid ${C.ink}`,
                  borderLeftWidth: i === 0 ? 1.2 : 0,
                  background: brew.unit === u ? C.ink : 'transparent',
                  color: brew.unit === u ? C.bg : C.ink,
                }}>°{u}</button>
              ))}
            </div>
          </div>
        </div>

        {/* CTA */}
        <div style={{ padding: '24px 18px 0' }}>
          <button style={{
            all: 'unset', cursor: 'pointer', display: 'flex', alignItems: 'center',
            justifyContent: 'space-between', width: '100%',
            boxSizing: 'border-box', background: C.accent,
            color: C.accentInk, padding: '17px 20px',
            fontFamily: serif, fontSize: 18, fontWeight: 600, letterSpacing: -0.2,
          }}>
            <span style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <IconKettle size={22} color={C.accentInk} sw={1.6}/>
              Start the Brew
            </span>
            <IconChevron size={18} color={C.accentInk} sw={1.8}/>
          </button>
          <div style={{ textAlign: 'center', marginTop: 10, fontFamily: sans,
            fontSize: 9, fontWeight: 700, letterSpacing: 3, color: C.muted,
            textTransform: 'uppercase' }}>
            Roasted · Brewed · Enjoyed
          </div>
        </div>

        <TabBarC C={C} sans={sans} active="brew"/>
      </div>
    </PCFrame>
  );
}

function stepBtn(C) {
  return {
    all: 'unset', cursor: 'pointer',
    width: 44, height: 44,
    border: `1.5px solid ${C.ink}`,
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    background: 'transparent',
  };
}

function SectionTitle({ C, serif, sans, num, title, sub }) {
  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
        <span style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
          letterSpacing: 2.5, color: C.accent, textTransform: 'uppercase' }}>
          §&nbsp;&nbsp;{num}
        </span>
        <div style={{ flex: 1, height: 1, background: C.ink }}/>
      </div>
      <h2 style={{ fontFamily: serif, fontWeight: 600, fontSize: 22,
        color: C.ink, margin: '8px 0 0', letterSpacing: -0.6 }}>{title}</h2>
      <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
        color: C.muted, marginTop: 2 }}>{sub}</div>
    </div>
  );
}

function SpecCell({ C, serif, sans, Icon, k, v, sub, divider, small }) {
  return (
    <div style={{
      padding: small ? '12px 14px' : '14px 16px',
      borderRight: divider === 'right' ? `1.5px solid ${C.ink}` : 'none',
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <Icon size={small ? 14 : 16} color={C.accent} sw={1.4}/>
        <span style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
          letterSpacing: 2, color: C.muted, textTransform: 'uppercase' }}>{k}</span>
      </div>
      <div style={{ fontFamily: serif, fontSize: small ? 18 : 24, fontWeight: 600,
        color: C.ink, letterSpacing: -0.6, marginTop: 4 }}>{v}</div>
      <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 11,
        color: C.muted, marginTop: 1 }}>{sub}</div>
    </div>
  );
}

function TabBarC({ C, sans, active }) {
  const items = [
    { id: 'brew',  label: 'Brew' },
    { id: 'guide', label: 'Guide' },
    { id: 'tips',  label: 'Tips' },
    { id: 'about', label: 'About' },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0, height: 78,
      background: C.bg, borderTop: `1.5px solid ${C.ink}`,
      display: 'flex', alignItems: 'flex-start',
      paddingTop: 12, paddingLeft: 18, paddingRight: 18,
    }}>
      {items.map(it => {
        const sel = it.id === active;
        return (
          <div key={it.id} style={{ flex: 1, textAlign: 'center',
            position: 'relative', paddingTop: 4 }}>
            <div style={{ fontFamily: sans, fontSize: 11, fontWeight: 700,
              letterSpacing: 1.8, textTransform: 'uppercase',
              color: sel ? C.accent : C.muted }}>{it.label}</div>
            {sel && <div style={{ position: 'absolute',
              top: -12, left: '50%', transform: 'translateX(-50%)',
              width: 28, height: 2, background: C.accent }}/>}
          </div>
        );
      })}
    </div>
  );
}

window.DirC = DirC;
