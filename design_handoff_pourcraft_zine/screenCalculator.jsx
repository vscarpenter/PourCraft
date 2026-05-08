// screenCalculator.jsx — Editorial Zine · Calculator (interactive)
// Fixes: stronger selected-roast affordance (#4), drag-anywhere ruler with
// snap haptic (#3), simplified pour card (#9), unit toggle removed (#10 → About),
// 'Save preset' pill (#16), accent for "PourCraft" (#26).

function CalculatorScreen({ dark = false, brew, onStartBrew, onTabChange, onSavePreset, presetSaved }) {
  const { C, serif, sans } = useZine(dark);
  const local = useBrew();
  const b = brew || local;

  const RoastRow = ({ r, isLast }) => {
    const sel = b.roastId === r.id;
    return (
      <button onClick={() => { b.setRoastId(r.id); fireHaptic('selection'); }} style={{
        all: 'unset', cursor: 'pointer', display: 'block', width: '100%',
        padding: `${SPACE.md}px ${SPACE.md}px`,
        borderTop: `1px solid ${C.rule}`,
        borderBottom: isLast ? `1px solid ${C.rule}` : 'none',
        background: sel ? C.chip : 'transparent',
        position: 'relative',
        transition: trans(['background', 'border-color'], MOTION.short),
        minHeight: 64,
      }}>
        {/* Selected ruler-mark on the left */}
        {sel && <div style={{ position: 'absolute', left: 0, top: 8, bottom: 8,
          width: 3, background: C.accent }}/>}
        <div style={{ display: 'flex', alignItems: 'center', gap: SPACE.md }}>
          <div style={{ flex: 1 }}>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: SPACE.sm }}>
              <span style={{ fontFamily: serif, fontSize: TYPE.title3, fontWeight: 500,
                color: C.ink, letterSpacing: -0.3 }}>{r.name}</span>
              <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
                color: C.mutedSoft }}>— {r.short}</span>
            </div>
            {/* Flavor copy only on selected row (#15) */}
            {sel && <div style={{ fontFamily: sans, fontSize: 12, color: C.muted,
              marginTop: 4, lineHeight: 1.45 }}>{r.flavor}</div>}
          </div>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontWeight: 500,
            fontSize: TYPE.title3, color: sel ? C.accent : C.muted, letterSpacing: -0.5,
            transition: trans(['color']) }}>
            {r.label}
          </div>
        </div>
      </button>
    );
  };

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:41"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 110 }}>
        <ZMasthead C={C} serif={serif} sans={sans}
          title={<>The <em style={{ fontStyle: 'italic', color: C.accent }}>PourCraft</em></>}
          sub="A calculator, set in type."/>

        <ZSection n="01" title="Choose your roast." kicker="Three options"
          C={C} serif={serif} sans={sans} style={{ marginTop: SPACE.xl }}>
          <div>
            {ROASTS.map((r, i) => <RoastRow key={r.id} r={r} isLast={i === ROASTS.length - 1}/>)}
          </div>
        </ZSection>

        <ZSection n="02" title="Dial in the dose." kicker="Grams"
          C={C} serif={serif} sans={sans} style={{ marginTop: SPACE.xxl }}>
          <div style={{ display: 'flex', alignItems: 'flex-end',
            justifyContent: 'space-between', paddingBottom: SPACE.md }}>
            <div style={{ display: 'flex', alignItems: 'baseline' }}>
              <span style={{ fontFamily: serif, fontWeight: 400, fontSize: TYPE.hero,
                lineHeight: 0.85, color: C.ink, letterSpacing: -4,
                fontVariantNumeric: 'tabular-nums',
                transition: trans(['color']) }}>
                {b.weight}
              </span>
              <span style={{ fontFamily: serif, fontStyle: 'italic',
                fontSize: TYPE.title3, color: C.muted, marginLeft: 6 }}>g</span>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: SPACE.sm,
              alignItems: 'flex-end' }}>
              <button aria-label="Increase by 1g"
                onClick={() => { b.setWeight(b.weight + 1); fireHaptic('light'); }}
                style={zCircleBtn(C)}>
                <IconPlus size={16} color={C.ink} sw={1.6}/>
              </button>
              <button aria-label="Decrease by 1g"
                onClick={() => { b.setWeight(b.weight - 1); fireHaptic('light'); }}
                style={zCircleBtn(C)}>
                <IconMinus size={16} color={C.ink} sw={1.6}/>
              </button>
            </div>
          </div>

          <ZineRuler value={b.weight} onChange={b.setWeight} C={C} sans={sans}/>

          <div style={{ marginTop: SPACE.md, display: 'flex',
            justifyContent: 'space-between', alignItems: 'baseline',
            fontFamily: serif, fontStyle: 'italic', fontSize: 14, color: C.muted }}>
            <span>at a ratio of <span style={{ color: C.accent,
              fontStyle: 'normal', fontWeight: 500 }}>{b.roast.label}</span></span>
            <span style={{ fontFamily: sans, fontStyle: 'normal',
              fontSize: TYPE.caption, fontWeight: 700, letterSpacing: 1.5, color: C.mutedSoft,
              textTransform: 'uppercase' }}>10g — 60g</span>
          </div>
        </ZSection>

        <ZSection n="03" title="The pour, by weight." kicker="Computed"
          C={C} serif={serif} sans={sans} style={{ marginTop: SPACE.xxl }}>
          <div style={{ background: C.surface, padding: `${SPACE.lg}px ${SPACE.xl - 2}px`,
            border: `1px solid ${C.rule}` }}>
            <PourLine icon={IconV60} label="Total water" value={b.total} unit="g" big C={C} serif={serif}/>
            <ZRule C={C} thick={1} style={{ margin: `${SPACE.md}px 0`, background: C.rule }}/>
            <div style={{ display: 'flex', flexDirection: 'column', gap: SPACE.md }}>
              <PourLine icon={IconBloom} label="Bloom · 30 sec" value={b.bloom} unit="g" C={C} serif={serif}/>
              <PourLine icon={IconSpiral} label="Remaining · spiral" value={b.remaining} unit="g" C={C} serif={serif}/>
              <PourLine icon={IconThermo} label="Water temp" value={b.tempRange} C={C} serif={serif}/>
            </div>
          </div>
        </ZSection>

        <div style={{ padding: `${SPACE.xxl}px ${SPACE.xl}px 0` }}>
          <button onClick={() => { fireHaptic('medium'); onStartBrew && onStartBrew(); }} style={{
            all: 'unset', cursor: 'pointer', display: 'flex', alignItems: 'center',
            justifyContent: 'space-between', width: '100%', boxSizing: 'border-box',
            background: C.accent, color: C.accentInk, padding: `${SPACE.lg + 2}px ${SPACE.xl - 2}px`,
            borderRadius: 2, fontFamily: serif, fontSize: TYPE.callout + 1, fontWeight: 500,
            letterSpacing: -0.2, transition: trans(['transform','filter'], MOTION.micro),
            minHeight: 56,
          }}>
            <span style={{ display: 'flex', alignItems: 'center', gap: SPACE.md }}>
              <IconKettle size={22} color={C.accentInk} sw={1.6}/>
              Begin the brew
            </span>
            <IconChevron size={18} color={C.accentInk} sw={1.8}/>
          </button>

          {/* Save preset (#16) */}
          <div style={{ display: 'flex', justifyContent: 'center', marginTop: SPACE.md }}>
            <button onClick={() => { fireHaptic('selection'); onSavePreset && onSavePreset(); }}
              style={{
              all: 'unset', cursor: 'pointer',
              fontFamily: sans, fontSize: 12, fontWeight: 600,
              letterSpacing: 1.5, textTransform: 'uppercase',
              color: presetSaved ? C.accent : C.mutedSoft,
              padding: `${SPACE.sm}px ${SPACE.lg}px`, minHeight: 44,
              border: `1px solid ${presetSaved ? C.accent : C.rule}`,
              borderRadius: 999,
              transition: trans(['color','border-color']),
            }}>
              {presetSaved ? '✓ Saved as morning' : 'Save as my morning'}
            </button>
          </div>
          <div style={{ textAlign: 'center', marginTop: SPACE.md, fontFamily: serif,
            fontStyle: 'italic', fontSize: 12, color: C.mutedSoft }}>
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
    width: 44, height: 44, borderRadius: 99,
    border: `1px solid ${C.ink}`,
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    background: 'transparent',
    transition: `background ${MOTION.short.dur}ms ${MOTION.short.ease}`,
  };
}

// Drag-anywhere ruler with 5g snap haptic (#3)
function ZineRuler({ value, onChange, C, sans }) {
  const ref = React.useRef(null);
  const lastSnapRef = React.useRef(value);
  const dragging = React.useRef(false);

  const setFromX = (clientX) => {
    const el = ref.current; if (!el) return;
    const r = el.getBoundingClientRect();
    const pct = Math.max(0, Math.min(1, (clientX - r.left) / r.width));
    const v = Math.round(10 + pct * 50);
    if (v !== value) {
      onChange(v);
      // Snap haptic at every 5g mark
      if (v % 5 === 0 && lastSnapRef.current !== v) {
        fireHaptic('soft'); lastSnapRef.current = v;
      }
    }
  };

  const onPointerDown = (e) => {
    dragging.current = true;
    e.currentTarget.setPointerCapture && e.currentTarget.setPointerCapture(e.pointerId);
    setFromX(e.clientX);
  };
  const onPointerMove = (e) => { if (dragging.current) setFromX(e.clientX); };
  const onPointerUp   = (e) => { dragging.current = false; };

  const ticks = []; for (let i = 10; i <= 60; i++) ticks.push(i);
  const pct = (value - 10) / 50;

  return (
    <div ref={ref}
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onPointerCancel={onPointerUp}
      role="slider" aria-valuemin="10" aria-valuemax="60" aria-valuenow={value}
      style={{ position: 'relative', height: 50, marginTop: 4,
        cursor: 'ew-resize', touchAction: 'none', userSelect: 'none' }}>
      <div style={{ position: 'absolute', left: 0, right: 0, top: 0, height: 30,
        display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between',
        pointerEvents: 'none' }}>
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
        fontSize: TYPE.caption, fontWeight: 600, color: C.muted, letterSpacing: 0.5,
        pointerEvents: 'none' }}>
        {[10,20,30,40,50,60].map(t => <span key={t}>{t}</span>)}
      </div>
      <div style={{ position: 'absolute', top: -6, left: `${pct * 100}%`,
        transform: 'translateX(-50%)', transition: dragging.current ? 'none' : `left ${MOTION.short.dur}ms ${MOTION.short.ease}`,
        pointerEvents: 'none' }}>
        <svg width="14" height="10" viewBox="0 0 14 10">
          <path d="M7 10 L0 0 L14 0 Z" fill={C.accent}/>
        </svg>
      </div>
    </div>
  );
}

function PourLine({ icon: Icon, label, value, unit, big, C, serif }) {
  return (
    <div style={{ display: 'flex', alignItems: 'baseline',
      justifyContent: 'space-between' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: SPACE.md }}>
        <Icon size={big ? 22 : 18} color={C.ink} sw={1.4}/>
        <span style={{ fontFamily: serif, fontSize: big ? TYPE.callout : 14,
          fontStyle: 'italic', color: C.ink }}>{label}</span>
      </div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 4 }}>
        <span style={{ fontFamily: serif, fontWeight: 500,
          fontSize: big ? TYPE.title1 : TYPE.title3, color: C.ink, letterSpacing: -1,
          fontVariantNumeric: 'tabular-nums', transition: trans(['color']) }}>
          {value}</span>
        {unit && <span style={{ fontFamily: serif, fontStyle: 'italic',
          fontSize: big ? TYPE.lg : 13, color: C.muted }}>{unit}</span>}
      </div>
    </div>
  );
}

window.CalculatorScreen = CalculatorScreen;
window.ZineRuler = ZineRuler;
window.zCircleBtn = zCircleBtn;
window.PourLine = PourLine;
