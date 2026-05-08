// screenGuide.jsx — Editorial Zine · Brew Guide
// Fixes: separate currentStep vs expandedStep (#5), no justify (#2),
// timer affordance hint (#17 — full feature is in Brewing mode).

function GuideScreen({ dark = false, brew, onBack, onTabChange }) {
  const { C, serif, sans } = useZine(dark);
  const local = useBrew();
  const b = brew || local;
  const [currentStep, setCurrentStep] = React.useState(0);
  const [expandedStep, setExpandedStep] = React.useState(0);

  const steps = [
    { n: 1, title: 'Heat the water', icon: IconFlame, meta: b.tempPoint,
      copy: <>Bring water to <strong>{b.tempPoint}</strong>. No thermometer? Let a rolling boil rest 30–60 seconds.</> },
    { n: 2, title: 'Rinse the filter', icon: IconV60, meta: '15 sec',
      copy: <>Place the paper filter in your dripper. Rinse with hot water to wash out paper taste, then discard the rinse.</> },
    { n: 3, title: 'Add the grounds', icon: IconBeans, meta: `${b.weight}g · medium grind`,
      copy: <>Add <strong>{b.weight}g</strong> of medium-ground coffee — the texture of sea salt. Tap to level the bed.</> },
    { n: 4, title: 'Bloom', icon: IconBloom, meta: `${b.bloom}g · 0:00 → 0:30`,
      copy: <>Start the timer. Pour <strong>{b.bloom}g</strong> of water evenly over the grounds, saturating every dry spot.</> },
    { n: 5, title: 'Wait, watch', icon: IconTimer, meta: '30 sec',
      copy: <>The bed swells and bubbles as CO₂ escapes. This is the bloom. Patience here pays off in clarity.</> },
    { n: 6, title: 'Spiral pour', icon: IconSpiral, meta: `${b.remaining}g · 0:30 → 2:30`,
      copy: <>Pour the remaining <strong>{b.remaining}g</strong> in a slow, steady spiral — center out, then back in. Avoid the filter walls.</> },
    { n: 7, title: 'Drawdown', icon: IconDrop, meta: '2:30 → 3:30',
      copy: <>Let the water finish drawing through. Total brew time: <strong>3:00 to 4:00</strong>. Longer is over; shorter is under.</> },
    { n: 8, title: 'Pour, sip, study', icon: IconKettle, meta: 'Enjoy',
      copy: <>Decant. Take a moment before the first sip — the aroma is half the cup.</> },
  ];

  const advance = () => {
    if (currentStep < steps.length - 1) {
      setCurrentStep(currentStep + 1);
      setExpandedStep(currentStep + 1);
      fireHaptic('light');
    } else {
      fireHaptic('success');
    }
  };

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:43"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 110 }}>
        <ZSubHeader C={C} serif={serif} sans={sans}
          kicker="The Method" onBack={onBack}
          title={<>The <em style={{ color: C.accent }}>Method</em>.</>}
          sub="Eight steps, in order, by the gram."/>

        {/* SUMMARY STRIP */}
        <div style={{ margin: `${SPACE.lg}px ${SPACE.xl}px 0`,
          padding: `${SPACE.md}px ${SPACE.lg}px`,
          background: C.surface, border: `1px solid ${C.rule}` }}>
          <div style={{ display: 'flex', justifyContent: 'space-between',
            alignItems: 'baseline', marginBottom: SPACE.sm }}>
            <span style={{ fontFamily: sans, fontSize: TYPE.kicker, fontWeight: 700,
              letterSpacing: 2.5, textTransform: 'uppercase', color: C.muted }}>
              Today's Recipe
            </span>
            <span style={{ fontFamily: serif, fontStyle: 'italic',
              fontSize: 13, color: C.muted }}>
              {b.roast.name} · {b.roast.label}
            </span>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: SPACE.sm }}>
            <SummaryCell C={C} serif={serif} sans={sans} k="Coffee" v={`${b.weight}g`}/>
            <SummaryCell C={C} serif={serif} sans={sans} k="Water" v={`${b.total}g`}/>
            <SummaryCell C={C} serif={serif} sans={sans} k="Temp" v={b.tempPoint}/>
          </div>
        </div>

        {/* Progress meter */}
        <div style={{ padding: `${SPACE.xl}px ${SPACE.xl}px 0` }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: SPACE.md,
            marginBottom: SPACE.md }}>
            <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
              color: C.accent }}>Nº 0{currentStep + 1} / 08</span>
            <div style={{ flex: 1, height: 2, background: C.rule, position: 'relative' }}>
              <div style={{ position: 'absolute', left: 0, top: 0, bottom: 0,
                width: `${((currentStep + 1) / steps.length) * 100}%`,
                background: C.accent,
                transition: trans(['width'], MOTION.medium) }}/>
            </div>
            <span style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
              letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>
              In progress
            </span>
          </div>

          {steps.map((s, i) => (
            <StepRow key={s.n} step={s}
              expanded={expandedStep === i}
              isCurrent={currentStep === i}
              isDone={i < currentStep}
              onTap={() => setExpandedStep(expandedStep === i ? -1 : i)}
              onMarkDone={i === currentStep ? advance : null}
              C={C} serif={serif} sans={sans}/>
          ))}
        </div>

        {/* OUTRO */}
        <div style={{ padding: `${SPACE.xxl}px ${SPACE.xl}px 0`, textAlign: 'center' }}>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginBottom: SPACE.lg }}/>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14,
            color: C.muted, lineHeight: 1.5 }}>
            "The pour is half the cup."
          </div>
        </div>

        <ZTabBar C={C} sans={sans} active="guide" onChange={onTabChange}/>
      </div>
    </PCFrame>
  );
}

function SummaryCell({ C, serif, sans, k, v }) {
  return (
    <div>
      <div style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
        letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>{k}</div>
      <div style={{ fontFamily: serif, fontWeight: 500, fontSize: TYPE.title3,
        color: C.ink, letterSpacing: -0.5, marginTop: 2,
        fontVariantNumeric: 'tabular-nums' }}>{v}</div>
    </div>
  );
}

function StepRow({ step, expanded, isCurrent, isDone, onTap, onMarkDone, C, serif, sans }) {
  const Icon = step.icon;
  const numColor = isDone ? C.mutedSoft : (isCurrent ? C.accent : C.ink);
  return (
    <div style={{
      borderBottom: `1px solid ${C.rule}`,
      background: isCurrent ? C.chip : 'transparent',
      transition: trans(['background']),
    }}>
      <button onClick={onTap} aria-expanded={expanded} style={{
        all: 'unset', cursor: 'pointer', display: 'block', width: '100%',
        padding: `${SPACE.lg}px ${SPACE.md}px`, minHeight: 64, position: 'relative',
      }}>
        {isCurrent && <div style={{ position: 'absolute', left: 0, top: 8, bottom: 8,
          width: 3, background: C.accent }}/>}
        <div style={{ display: 'flex', alignItems: 'flex-start', gap: SPACE.md }}>
          <div style={{ width: 44, flexShrink: 0 }}>
            <div style={{ fontFamily: serif, fontWeight: 400, fontSize: 38,
              color: numColor, lineHeight: 0.85, letterSpacing: -1.5,
              transition: trans(['color']),
              textDecoration: isDone ? 'line-through' : 'none',
              textDecorationThickness: '1px',
            }}>
              {String(step.n).padStart(2, '0')}
            </div>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: SPACE.sm + 2,
              marginBottom: 4 }}>
              <Icon size={18} color={isCurrent ? C.accent : C.ink} sw={1.4}/>
              <span style={{ fontFamily: serif, fontWeight: 500, fontSize: 19,
                color: C.ink, letterSpacing: -0.3 }}>{step.title}</span>
            </div>
            <div style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
              letterSpacing: 2, textTransform: 'uppercase', color: C.muted,
              marginBottom: 6 }}>
              {step.meta}
            </div>
            <div style={{
              fontFamily: serif, fontSize: 14, color: C.ink, lineHeight: 1.55,
              maxHeight: expanded ? 200 : 22, overflow: 'hidden',
              transition: `max-height ${MOTION.medium.dur}ms ${MOTION.medium.ease}`,
              opacity: expanded ? 1 : 0.8, textWrap: 'pretty',
            }}>
              {step.copy}
            </div>
          </div>
          <IconChevron size={14} color={C.muted} sw={1.6}
            style={{ marginTop: 10, flexShrink: 0,
              transform: expanded ? 'rotate(90deg)' : 'rotate(0deg)',
              transition: trans(['transform']) }}/>
        </div>
      </button>
      {/* Mark done CTA — only on the current step when expanded */}
      {expanded && onMarkDone && (
        <div style={{ padding: `0 ${SPACE.md}px ${SPACE.md}px`, paddingLeft: 60 }}>
          <button onClick={onMarkDone} style={{
            all: 'unset', cursor: 'pointer',
            fontFamily: sans, fontSize: 12, fontWeight: 700,
            letterSpacing: 2, textTransform: 'uppercase',
            color: C.accent, padding: `${SPACE.sm}px ${SPACE.lg}px`,
            border: `1px solid ${C.accent}`, borderRadius: 999,
            display: 'inline-flex', alignItems: 'center', gap: 6,
            minHeight: 44,
          }}>
            <IconCheck size={12} color={C.accent} sw={2}/> Mark done
          </button>
        </div>
      )}
    </div>
  );
}

window.GuideScreen = GuideScreen;
