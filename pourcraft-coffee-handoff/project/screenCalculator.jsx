// screenCalculator.jsx — Editorial Zine · Calculator (interactive)
// Uses the shared zineSystem and useBrew hook from shared.jsx.

function CalculatorScreen({ dark = false, brew, onStartBrew, onTabChange }) {
  const { C, serif, sans } = useZine(dark);
  // If no brew passed in, manage local state (for canvas previews)
  const local = useBrew();
  const b = brew || local;

  // Roast row
  const RoastRow = ({ r }) => {
    const sel = b.roastId === r.id;
    return (
      <button onClick={() => b.setRoastId(r.id)} style={{
        all: 'unset', cursor: 'pointer', display: 'block', width: '100%',
        padding: '14px 0', borderTop: `1px solid ${C.rule}`,
        transition: 'background 0.15s',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
          <div style={{ width: 22, height: 22, borderRadius: 99,
            border: `1.5px solid ${sel ? C.accent : C.muted}`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            background: sel ? C.accent : 'transparent', flexShrink: 0,
            transition: 'all 0.2s',
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
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontWeight: 500,
            fontSize: 22, color: sel ? C.accent : C.ink, letterSpacing: -0.5,
            transition: 'color 0.2s' }}>
            {r.label}
          </div>
        </div>
      </button>
    );
  };

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:41"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 90 }}>
        <ZMasthead C={C} serif={serif} sans={sans}
          title={<>The <em style={{ fontStyle: 'italic', color: C.accent }}>Pour</em></>}
          sub="A calculator, set in type."/>

        <ZSection n="01" title="Choose your roast." kicker="Three options"
          C={C} serif={serif} sans={sans} style={{ marginTop: 22 }}>
          <div style={{ borderBottom: `1px solid ${C.rule}` }}>
            {ROASTS.map(r => <RoastRow key={r.id} r={r}/>)}
          </div>
        </ZSection>

        <ZSection n="02" title="Dial in the dose." kicker="Grams"
          C={C} serif={serif} sans={sans} style={{ marginTop: 28 }}>
          <div style={{ display: 'flex', alignItems: 'flex-end',
            justifyContent: 'space-between', paddingBottom: 14 }}>
            <div style={{ display: 'flex', alignItems: 'baseline' }}>
              <span style={{ fontFamily: serif, fontWeight: 400, fontSize: 96,
                lineHeight: 0.85, color: C.ink, letterSpacing: -4,
                fontVariantNumeric: 'tabular-nums' }}>
                {b.weight}
              </span>
              <span style={{ fontFamily: serif, fontStyle: 'italic',
                fontSize: 22, color: C.muted, marginLeft: 6 }}>g</span>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8,
              alignItems: 'flex-end' }}>
              <button onClick={() => b.setWeight(b.weight + 1)} style={zCircleBtn(C)}>
                <IconPlus size={16} color={C.ink} sw={1.6}/>
              </button>
              <button onClick={() => b.setWeight(b.weight - 1)} style={zCircleBtn(C)}>
                <IconMinus size={16} color={C.ink} sw={1.6}/>
              </button>
            </div>
          </div>

          <ZineRuler value={b.weight} onChange={b.setWeight} C={C} sans={sans}/>

          <div style={{ marginTop: 14, display: 'flex',
            justifyContent: 'space-between', alignItems: 'baseline',
            fontFamily: serif, fontStyle: 'italic', fontSize: 14, color: C.muted }}>
            <span>at a ratio of <span style={{ color: C.accent,
              fontStyle: 'normal', fontWeight: 500 }}>{b.roast.label}</span></span>
            <span style={{ fontFamily: sans, fontStyle: 'normal',
              fontSize: 11, fontWeight: 600, letterSpacing: 1.5, color: C.muted,
              textTransform: 'uppercase' }}>10g — 60g</span>
          </div>
        </ZSection>

        <ZSection n="03" title="The pour, by weight." kicker="Computed"
          C={C} serif={serif} sans={sans} style={{ marginTop: 28 }}>
          <div style={{ background: C.surface, padding: '20px 22px', borderRadius: 4,
            border: `1px solid ${C.rule}` }}>
            <PourLine icon={IconV60} label="Total water" value={b.total} unit="g" big C={C} serif={serif}/>
            <ZRule C={C} thick={1} style={{ margin: '14px 0' }}/>
            <PourLine icon={IconBloom} label="Bloom · 30 sec" value={b.bloom} unit="g" C={C} serif={serif}/>
            <ZRule C={C} thick={1} style={{ margin: '12px 0', opacity: 0.5 }}/>
            <PourLine icon={IconSpiral} label="Remaining · spiral" value={b.remaining} unit="g" C={C} serif={serif}/>
            <ZRule C={C} thick={1} style={{ margin: '12px 0', opacity: 0.5 }}/>
            <PourLine icon={IconThermo} label="Water temp" value={b.tempRange} C={C} serif={serif}/>
          </div>

          <div style={{ display: 'flex', alignItems: 'center',
            justifyContent: 'space-between', marginTop: 16, paddingBottom: 4 }}>
            <span style={{ fontFamily: serif, fontStyle: 'italic',
              fontSize: 13, color: C.muted }}>Display in</span>
            <div style={{ display: 'flex', border: `1px solid ${C.ink}`,
              borderRadius: 999, overflow: 'hidden', fontFamily: sans, fontSize: 12,
              fontWeight: 600, letterSpacing: 1 }}>
              {['F','C'].map(u => (
                <button key={u} onClick={() => b.setUnit(u)} style={{
                  all: 'unset', cursor: 'pointer', padding: '6px 16px',
                  background: b.unit === u ? C.ink : 'transparent',
                  color: b.unit === u ? C.bg : C.ink,
                  transition: 'all 0.15s',
                }}>°{u}</button>
              ))}
            </div>
          </div>
        </ZSection>

        <div style={{ padding: '28px 24px 0' }}>
          <button onClick={onStartBrew} style={{
            all: 'unset', cursor: 'pointer', display: 'flex', alignItems: 'center',
            justifyContent: 'space-between', width: '100%', boxSizing: 'border-box',
            background: C.accent, color: C.accentInk, padding: '18px 22px',
            borderRadius: 2, fontFamily: serif, fontSize: 18, fontWeight: 500,
            letterSpacing: -0.2, transition: 'transform 0.1s',
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

        <ZTabBar C={C} sans={sans} active="brew" onChange={onTabChange}/>
      </div>
    </PCFrame>
  );
}

function zCircleBtn(C) {
  return {
    all: 'unset', cursor: 'pointer',
    width: 36, height: 36, borderRadius: 99,
    border: `1px solid ${C.ink}`,
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    background: 'transparent', transition: 'background 0.15s',
  };
}

function ZineRuler({ value, onChange, C, sans }) {
  const ticks = [];
  for (let i = 10; i <= 60; i++) ticks.push(i);
  const range = 50;
  const pct = (value - 10) / range;
  return (
    <div style={{ position: 'relative', height: 50, marginTop: 4 }}>
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
      <div style={{ position: 'absolute', left: 0, right: 0, top: 22,
        display: 'flex', justifyContent: 'space-between', fontFamily: sans,
        fontSize: 10, fontWeight: 600, color: C.muted, letterSpacing: 0.5 }}>
        {[10,20,30,40,50,60].map(t => <span key={t}>{t}</span>)}
      </div>
      <div style={{ position: 'absolute', top: -6, left: `${pct * 100}%`,
        transform: 'translateX(-50%)', transition: 'left 0.15s' }}>
        <svg width="14" height="10" viewBox="0 0 14 10">
          <path d="M7 10 L0 0 L14 0 Z" fill={C.accent}/>
        </svg>
      </div>
      <input type="range" min="10" max="60" step="1" value={value}
        onChange={e => onChange(+e.target.value)}
        style={{ position: 'absolute', inset: 0, opacity: 0, cursor: 'pointer', width: '100%' }}/>
    </div>
  );
}

function PourLine({ icon: Icon, label, value, unit, big, C, serif }) {
  return (
    <div style={{ display: 'flex', alignItems: 'baseline',
      justifyContent: 'space-between' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <Icon size={big ? 22 : 18} color={C.ink} sw={1.4}/>
        <span style={{ fontFamily: serif, fontSize: big ? 18 : 14,
          fontStyle: 'italic', color: C.ink }}>{label}</span>
      </div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 4 }}>
        <span style={{ fontFamily: serif, fontWeight: 500,
          fontSize: big ? 36 : 22, color: C.ink, letterSpacing: -1,
          fontVariantNumeric: 'tabular-nums', transition: 'all 0.2s' }}>
          {value}</span>
        {unit && <span style={{ fontFamily: serif, fontStyle: 'italic',
          fontSize: big ? 16 : 13, color: C.muted }}>{unit}</span>}
      </div>
    </div>
  );
}

window.CalculatorScreen = CalculatorScreen;
window.ZineRuler = ZineRuler;
window.zCircleBtn = zCircleBtn;
window.PourLine = PourLine;
