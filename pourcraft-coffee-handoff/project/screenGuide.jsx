// screenGuide.jsx — Editorial Zine · Brew Guide
// 8 sequential steps with measurements, temperatures, durations.
// Uses the dose from `brew` so it's coherent with the Calculator.

function GuideScreen({ dark = false, brew, onBack, onTabChange }) {
  const { C, serif, sans } = useZine(dark);
  const local = useBrew();
  const b = brew || local;
  const [activeStep, setActiveStep] = React.useState(0);

  const steps = [
    {
      n: 1, title: 'Heat the water',
      icon: IconFlame,
      meta: b.tempPoint,
      copy: <>Bring water to <strong>{b.tempPoint}</strong>. No thermometer? Let a rolling boil rest 30–60 seconds.</>
    },
    {
      n: 2, title: 'Rinse the filter',
      icon: IconV60,
      meta: '15 sec',
      copy: <>Place the paper filter in your dripper. Rinse with hot water to wash out paper taste, then discard the rinse.</>
    },
    {
      n: 3, title: 'Add the grounds',
      icon: IconBeans,
      meta: `${b.weight}g · medium grind`,
      copy: <>Add <strong>{b.weight}g</strong> of medium-ground coffee — the texture of sea salt. Tap to level the bed.</>
    },
    {
      n: 4, title: 'Bloom',
      icon: IconBloom,
      meta: `${b.bloom}g · 0:00 → 0:30`,
      copy: <>Start the timer. Pour <strong>{b.bloom}g</strong> of water evenly over the grounds, saturating every dry spot.</>
    },
    {
      n: 5, title: 'Wait, watch',
      icon: IconTimer,
      meta: '30 sec',
      copy: <>The bed swells and bubbles as CO₂ escapes. This is the bloom. Patience here pays off in clarity.</>
    },
    {
      n: 6, title: 'Spiral pour',
      icon: IconSpiral,
      meta: `${b.remaining}g · 0:30 → 2:30`,
      copy: <>Pour the remaining <strong>{b.remaining}g</strong> in a slow, steady spiral — center out, then back in. Avoid the filter walls.</>
    },
    {
      n: 7, title: 'Drawdown',
      icon: IconDrop,
      meta: '2:30 → 3:30',
      copy: <>Let the water finish drawing through. Total brew time: <strong>3:00 to 4:00</strong>. Longer is over; shorter is under.</>
    },
    {
      n: 8, title: 'Pour, sip, study',
      icon: IconKettle,
      meta: 'Enjoy',
      copy: <>Decant. Take a moment before the first sip — the aroma is half the cup.</>
    },
  ];

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:43"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 100 }}>
        <ZSubHeader C={C} serif={serif} sans={sans}
          kicker="The Method" onBack={onBack}
          title={<>The <em style={{ color: C.accent }}>Method</em>.</>}
          sub="Eight steps, in order, by the gram."/>

        {/* SUMMARY STRIP */}
        <div style={{ margin: '18px 24px 0', padding: '14px 16px',
          background: C.surface, border: `1px solid ${C.rule}` }}>
          <div style={{ display: 'flex', justifyContent: 'space-between',
            alignItems: 'baseline', marginBottom: 8 }}>
            <span style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
              letterSpacing: 2.5, textTransform: 'uppercase', color: C.muted }}>
              Today's Recipe
            </span>
            <span style={{ fontFamily: serif, fontStyle: 'italic',
              fontSize: 13, color: C.muted }}>
              {b.roast.name} · {b.roast.label}
            </span>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr',
            gap: 8 }}>
            <SummaryCell C={C} serif={serif} sans={sans}
              k="Coffee" v={`${b.weight}g`}/>
            <SummaryCell C={C} serif={serif} sans={sans}
              k="Water" v={`${b.total}g`}/>
            <SummaryCell C={C} serif={serif} sans={sans}
              k="Temp" v={b.tempPoint}/>
          </div>
        </div>

        {/* STEPS */}
        <div style={{ padding: '24px 24px 0' }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10,
            marginBottom: 18 }}>
            <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
              color: C.accent }}>Nº 01–08</span>
            <div style={{ flex: 1, height: 1, background: C.accent, opacity: 0.5 }}/>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
              letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>
              Tap a step
            </span>
          </div>

          {steps.map((s, i) => (
            <StepRow key={s.n} step={s} active={activeStep === i}
              onTap={() => setActiveStep(activeStep === i ? -1 : i)}
              C={C} serif={serif} sans={sans}/>
          ))}
        </div>

        {/* OUTRO */}
        <div style={{ padding: '28px 24px 0', textAlign: 'center' }}>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginBottom: 16 }}/>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14,
            color: C.muted, lineHeight: 1.5 }}>
            "The pour is half the cup."
          </div>
          <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
            letterSpacing: 3, textTransform: 'uppercase', color: C.muted,
            marginTop: 6 }}>— attributed</div>
        </div>

        <ZTabBar C={C} sans={sans} active="guide" onChange={onTabChange}/>
      </div>
    </PCFrame>
  );
}

function SummaryCell({ C, serif, sans, k, v }) {
  return (
    <div>
      <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
        letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>{k}</div>
      <div style={{ fontFamily: serif, fontWeight: 500, fontSize: 22,
        color: C.ink, letterSpacing: -0.5, marginTop: 2,
        fontVariantNumeric: 'tabular-nums' }}>{v}</div>
    </div>
  );
}

function StepRow({ step, active, onTap, C, serif, sans }) {
  const Icon = step.icon;
  return (
    <button onClick={onTap} style={{
      all: 'unset', cursor: 'pointer', display: 'block', width: '100%',
      padding: '16px 0', borderBottom: `1px solid ${C.rule}`,
    }}>
      <div style={{ display: 'flex', alignItems: 'flex-start', gap: 14 }}>
        {/* big serif numeral */}
        <div style={{ width: 44, flexShrink: 0 }}>
          <div style={{ fontFamily: serif, fontWeight: 400, fontSize: 38,
            color: active ? C.accent : C.ink, lineHeight: 0.85,
            letterSpacing: -1.5,
            transition: 'color 0.2s' }}>
            {String(step.n).padStart(2, '0')}
          </div>
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10,
            marginBottom: 4 }}>
            <Icon size={18} color={active ? C.accent : C.ink} sw={1.4}/>
            <span style={{ fontFamily: serif, fontWeight: 500, fontSize: 19,
              color: C.ink, letterSpacing: -0.3 }}>{step.title}</span>
          </div>
          <div style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
            letterSpacing: 2, textTransform: 'uppercase', color: C.muted,
            marginBottom: 6 }}>
            {step.meta}
          </div>
          {/* copy: collapsed = first line clamp; expanded = full */}
          <div style={{
            fontFamily: serif, fontSize: 14, color: C.ink, lineHeight: 1.5,
            maxHeight: active ? 200 : 22, overflow: 'hidden',
            transition: 'max-height 0.3s ease',
            opacity: active ? 1 : 0.85,
          }}>
            {step.copy}
          </div>
        </div>
        <IconChevron size={14} color={C.muted} sw={1.6}
          style={{ marginTop: 10, flexShrink: 0,
            transform: active ? 'rotate(90deg)' : 'rotate(0deg)',
            transition: 'transform 0.2s' }}/>
      </div>
    </button>
  );
}

window.GuideScreen = GuideScreen;
