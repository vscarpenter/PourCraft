// screenTipDetail.jsx — Editorial Zine · Tip article
// Fixes: drop justify (#2), shrink hero numeral + add "TIP" label (#14),
// no fragile drop-cap (#11), wrap-aware "Continued in" (#12), no rivers.

function TipDetailScreen({ dark = false, tipId, onBack, onTabChange, onOpenTip }) {
  const { C, serif, sans } = useZine(dark);
  const tip = TIPS.find(t => t.id === tipId) || TIPS[0];
  const isLast = tip.n === TIPS.length;
  const next = isLast ? null : TIPS[tip.n]; // tip.n is 1-indexed

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:51"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 110 }}>
        {/* Header */}
        <div style={{ padding: `${SPACE.xs}px ${SPACE.xl}px 0` }}>
          <div style={{ display: 'flex', alignItems: 'center',
            justifyContent: 'space-between', fontFamily: sans, fontSize: TYPE.kicker,
            fontWeight: 700, letterSpacing: 2.5, textTransform: 'uppercase',
            color: C.muted, paddingTop: SPACE.sm, minHeight: 44 }}>
            <button onClick={onBack} aria-label="Back to Field Notes" style={{
              all: 'unset', cursor: 'pointer', display: 'flex',
              alignItems: 'center', gap: 4, color: C.muted, minHeight: 44, paddingRight: 12 }}>
              <IconChevron size={11} color={C.muted} sw={1.6}
                style={{ transform: 'rotate(180deg)' }}/>
              Field Notes
            </button>
            <span>Nº {tip.num}</span>
            <span style={{ color: C.mutedSoft, width: 80, textAlign: 'right' }}>{tip.cat}</span>
          </div>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginTop: SPACE.sm }}/>
        </div>

        {/* Hero — number with "TIP" label (#14) */}
        <div style={{ padding: `${SPACE.xl}px ${SPACE.xl}px 0` }}>
          <div style={{ fontFamily: serif, fontWeight: 400, fontSize: 110,
            color: C.accent, lineHeight: 0.8, letterSpacing: -5,
            marginBottom: 0 }}>
            {tip.num}
          </div>
          <div style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
            letterSpacing: 3, textTransform: 'uppercase', color: C.mutedSoft,
            marginTop: 6, marginBottom: SPACE.md }}>
            Tip · {tip.cat}
          </div>
          <h1 style={{ fontFamily: serif, fontWeight: 400, fontSize: TYPE.title1,
            lineHeight: 1.0, color: C.ink, margin: 0, letterSpacing: -1.4,
            textWrap: 'balance' }}>
            {tip.title}
          </h1>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: TYPE.callout,
            color: C.muted, lineHeight: 1.4, marginTop: SPACE.md, textWrap: 'pretty' }}>
            {tip.dek}
          </div>
          <ZRule C={C} thick={1} style={{ background: C.ruleStrong, opacity: 0.65,
            marginTop: SPACE.xl }}/>
        </div>

        {/* Body — left-aligned, no drop cap (#2, #11) */}
        <div style={{ padding: `${SPACE.xl}px ${SPACE.xl}px 0` }}>
          {tip.body.map((para, i) => {
            // Pull-quote between paragraphs 1 and 2
            if (i === 1) {
              return (
                <React.Fragment key={i}>
                  <PullQuote text={tip.pull} C={C} serif={serif} sans={sans}/>
                  <p style={{ fontFamily: serif, fontSize: TYPE.callout - 1,
                    lineHeight: 1.6, color: C.ink, margin: `0 0 ${SPACE.md}px`,
                    textAlign: 'left', textWrap: 'pretty' }}>{para}</p>
                </React.Fragment>
              );
            }
            return (
              <p key={i} style={{ fontFamily: serif, fontSize: TYPE.callout - 1,
                lineHeight: 1.6, color: C.ink, margin: `0 0 ${SPACE.md}px`,
                textAlign: 'left', textWrap: 'pretty' }}>{para}</p>
            );
          })}
        </div>

        {/* References */}
        <div style={{ padding: `${SPACE.sm}px ${SPACE.xl}px 0` }}>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginBottom: SPACE.md }}/>
          <div style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
            letterSpacing: 2.5, textTransform: 'uppercase', color: C.muted,
            marginBottom: SPACE.md }}>
            By the numbers
          </div>
          <div style={{ background: C.surface, border: `1px solid ${C.rule}`,
            padding: `${SPACE.xs}px ${SPACE.lg}px` }}>
            {tip.refs.map((r, i) => (
              <div key={i} style={{
                display: 'flex', justifyContent: 'space-between',
                alignItems: 'baseline', padding: `${SPACE.md}px 0`,
                borderBottom: i < tip.refs.length - 1 ? `1px dotted ${C.rule}` : 'none',
              }}>
                <span style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
                  letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>
                  {r.k}
                </span>
                <span style={{ fontFamily: serif, fontWeight: 500, fontSize: TYPE.callout,
                  color: C.ink, letterSpacing: -0.3 }}>{r.v}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Continued / End — fixed for last tip (#12) */}
        <div style={{ padding: `${SPACE.xl}px ${SPACE.xl}px 0` }}>
          <ZRule C={C} thick={1} style={{ background: C.ruleStrong, opacity: 0.65 }}/>
          {next ? (
            <button onClick={() => onOpenTip && onOpenTip(next.id)}
              style={{ all: 'unset', cursor: 'pointer', display: 'flex',
                alignItems: 'baseline', justifyContent: 'space-between',
                width: '100%', padding: `${SPACE.lg}px 0 0`, minHeight: 44 }}>
              <div>
                <div style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 700,
                  letterSpacing: 2.5, textTransform: 'uppercase', color: C.muted }}>
                  Continued in
                </div>
                <div style={{ fontFamily: serif, fontStyle: 'italic',
                  fontSize: TYPE.lg || 18, color: C.accent, marginTop: 2,
                  textWrap: 'balance' }}>
                  Nº {next.num} — {next.title.replace(/\.$/, '')}
                </div>
              </div>
              <IconChevron size={16} color={C.accent} sw={1.8}/>
            </button>
          ) : (
            <button onClick={onBack} style={{
              all: 'unset', cursor: 'pointer', display: 'block', width: '100%',
              padding: `${SPACE.lg}px 0 0`, textAlign: 'center', minHeight: 44 }}>
              <div style={{ fontFamily: serif, fontStyle: 'italic',
                fontSize: TYPE.callout, color: C.muted, marginBottom: 4 }}>
                — end of contents —
              </div>
              <div style={{ fontFamily: sans, fontSize: 12, fontWeight: 700,
                letterSpacing: 2, textTransform: 'uppercase', color: C.accent }}>
                Back to Field Notes
              </div>
            </button>
          )}
        </div>

        <ZTabBar C={C} sans={sans} active="tips" onChange={onTabChange}/>
      </div>
    </PCFrame>
  );
}

function PullQuote({ text, C, serif }) {
  return (
    <div style={{ margin: `${SPACE.sm}px 0 ${SPACE.xl - 2}px`, padding: '4px 0',
      borderTop: `1px solid ${C.rule}`, borderBottom: `1px solid ${C.rule}` }}>
      <div style={{ fontFamily: serif, fontStyle: 'italic',
        fontWeight: 400, fontSize: TYPE.title3 + 2, lineHeight: 1.3,
        color: C.accent, padding: `${SPACE.md + 2}px 0`, letterSpacing: -0.5,
        textAlign: 'center', textWrap: 'balance' }}>
        {text}
      </div>
    </div>
  );
}

window.TipDetailScreen = TipDetailScreen;
