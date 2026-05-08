// screenTipDetail.jsx — Editorial Zine · Tip article view
// Full article layout with masthead, drop cap, pull quote, references.

function TipDetailScreen({ dark = false, tipId, onBack, onTabChange }) {
  const { C, serif, sans } = useZine(dark);
  const tip = TIPS.find(t => t.id === tipId) || TIPS[0];

  return (
    <PCFrame bg={C.bg} dark={dark}>
      <PCStatusBar color={C.ink} time="6:51"/>
      <div style={{ height: '100%', overflow: 'auto', paddingBottom: 100 }}>
        {/* Header */}
        <div style={{ padding: '4px 24px 0' }}>
          <div style={{ display: 'flex', alignItems: 'center',
            justifyContent: 'space-between', fontFamily: sans, fontSize: 10,
            fontWeight: 600, letterSpacing: 2.5, textTransform: 'uppercase',
            color: C.muted, paddingTop: 6 }}>
            <button onClick={onBack} style={{ all: 'unset', cursor: 'pointer',
              display: 'flex', alignItems: 'center', gap: 4, color: C.muted }}>
              <IconChevron size={11} color={C.muted} sw={1.6}
                style={{ transform: 'rotate(180deg)' }}/>
              Field Notes
            </button>
            <span>Nº {tip.num}</span>
            <span>{tip.cat}</span>
          </div>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginTop: 10 }}/>
        </div>

        {/* Big number + title */}
        <div style={{ padding: '24px 24px 0' }}>
          <div style={{ fontFamily: serif, fontWeight: 400, fontSize: 140,
            color: C.accent, lineHeight: 0.8, letterSpacing: -6,
            marginBottom: 4 }}>
            {tip.num}
          </div>
          <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
            letterSpacing: 3, textTransform: 'uppercase', color: C.muted,
            marginBottom: 6 }}>
            Tip · {tip.cat}
          </div>
          <h1 style={{ fontFamily: serif, fontWeight: 400, fontSize: 38,
            lineHeight: 0.95, color: C.ink, margin: 0, letterSpacing: -1.5 }}>
            {tip.title}
          </h1>
          <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 17,
            color: C.muted, lineHeight: 1.4, marginTop: 14 }}>
            {tip.dek}
          </div>
          <ZRule C={C} thick={2} style={{ background: C.ink, opacity: 0.85,
            marginTop: 22 }}/>
          <ZRule C={C} thick={1} style={{ background: C.ink, opacity: 0.85,
            marginTop: 2 }}/>
        </div>

        {/* Body — drop cap on first paragraph */}
        <div style={{ padding: '24px 24px 0' }}>
          {tip.body.map((para, i) => {
            if (i === 0) {
              const first = para.charAt(0);
              const rest  = para.slice(1);
              return (
                <p key={i} style={{ fontFamily: serif, fontSize: 16,
                  lineHeight: 1.55, color: C.ink, margin: '0 0 14px',
                  textAlign: 'justify', hyphens: 'auto' }}>
                  <span style={{ fontFamily: serif, fontWeight: 400,
                    fontSize: 64, lineHeight: 0.85, color: C.accent,
                    float: 'left', padding: '6px 8px 0 0', letterSpacing: -2 }}>
                    {first}
                  </span>
                  {rest}
                </p>
              );
            }
            // pull-quote inserted between paragraphs 1 and 2
            if (i === 1) {
              return (
                <React.Fragment key={i}>
                  <PullQuote text={tip.pull} C={C} serif={serif} sans={sans}/>
                  <p style={{ fontFamily: serif, fontSize: 16, lineHeight: 1.55,
                    color: C.ink, margin: '0 0 14px',
                    textAlign: 'justify', hyphens: 'auto' }}>{para}</p>
                </React.Fragment>
              );
            }
            return (
              <p key={i} style={{ fontFamily: serif, fontSize: 16,
                lineHeight: 1.55, color: C.ink, margin: '0 0 14px',
                textAlign: 'justify', hyphens: 'auto' }}>{para}</p>
            );
          })}
        </div>

        {/* References / spec block */}
        <div style={{ padding: '8px 24px 0' }}>
          <ZRule C={C} thick={1} style={{ background: C.rule, marginBottom: 14 }}/>
          <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
            letterSpacing: 2.5, textTransform: 'uppercase', color: C.muted,
            marginBottom: 12 }}>
            By the numbers
          </div>
          <div style={{ background: C.surface, border: `1px solid ${C.rule}`,
            padding: '4px 16px' }}>
            {tip.refs.map((r, i) => (
              <div key={i} style={{
                display: 'flex', justifyContent: 'space-between',
                alignItems: 'baseline', padding: '12px 0',
                borderBottom: i < tip.refs.length - 1
                  ? `1px dotted ${C.rule}` : 'none',
              }}>
                <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 700,
                  letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>
                  {r.k}
                </span>
                <span style={{ fontFamily: serif, fontWeight: 500, fontSize: 17,
                  color: C.ink, letterSpacing: -0.3 }}>{r.v}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Next-tip link */}
        <div style={{ padding: '24px 24px 0' }}>
          <ZRule C={C} thick={2} style={{ background: C.ink, opacity: 0.85 }}/>
          <ZRule C={C} thick={1} style={{ background: C.ink, opacity: 0.85,
            marginTop: 2 }}/>
          <div style={{ display: 'flex', alignItems: 'baseline',
            justifyContent: 'space-between', padding: '18px 0 0' }}>
            <div>
              <div style={{ fontFamily: sans, fontSize: 9, fontWeight: 700,
                letterSpacing: 2.5, textTransform: 'uppercase', color: C.muted }}>
                Continued in
              </div>
              <div style={{ fontFamily: serif, fontStyle: 'italic',
                fontSize: 18, color: C.accent, marginTop: 2 }}>
                Nº {String(((tip.n) % 8) + 1).padStart(2,'0')} —{' '}
                {(TIPS[(tip.n) % 8] || TIPS[0]).title.split('.')[0]}
              </div>
            </div>
            <IconChevron size={16} color={C.accent} sw={1.8}/>
          </div>
        </div>

        <ZTabBar C={C} sans={sans} active="tips" onChange={onTabChange}/>
      </div>
    </PCFrame>
  );
}

function PullQuote({ text, C, serif, sans }) {
  return (
    <div style={{ margin: '8px 0 22px', padding: '4px 0',
      borderTop: `1px solid ${C.rule}`, borderBottom: `1px solid ${C.rule}` }}>
      <div style={{ fontFamily: serif, fontStyle: 'italic',
        fontWeight: 400, fontSize: 24, lineHeight: 1.25,
        color: C.accent, padding: '14px 0', letterSpacing: -0.5,
        textAlign: 'center' }}>
        {text}
      </div>
    </div>
  );
}

window.TipDetailScreen = TipDetailScreen;
