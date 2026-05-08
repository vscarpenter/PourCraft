// zineSystem.jsx — Editorial Zine design system
// Fixes applied: dark muted contrast (#13), simpler SubHeader (#7),
// safe-area inset tab bar (#1), brand name (#8, #26).

const ZineColors = {
  light: {
    bg: '#FBF3E5', surface: '#FFF8EC', surface2: '#F0E6D0',
    ink: '#2A1F1B', muted: '#6B5239', mutedSoft: '#8A6F52',
    rule: 'rgba(42,31,27,0.18)', ruleStrong: 'rgba(42,31,27,0.85)',
    accent: '#B87333', accentInk: '#FFF8EC',
    chip: 'rgba(184,115,51,0.12)', chipStrong: 'rgba(184,115,51,0.18)',
  },
  dark: {
    bg: '#221915', surface: '#2C211C', surface2: '#352721',
    ink: '#F0E6D6', muted: '#C4A88A', mutedSoft: '#A38A6E',
    rule: 'rgba(240,230,214,0.20)', ruleStrong: 'rgba(240,230,214,0.65)',
    accent: '#D4935A', accentInk: '#221915',
    chip: 'rgba(212,147,90,0.16)', chipStrong: 'rgba(212,147,90,0.24)',
  },
};
const zineSerif = '"Fraunces", "Source Serif 4", Georgia, serif';
const zineSans  = '"Inter", system-ui, sans-serif';

function useZine(dark) {
  return { C: ZineColors[dark ? 'dark' : 'light'], serif: zineSerif, sans: zineSans, dark };
}

function Rule({ thick = 1, op = 1, color, style, C }) {
  return <div style={{ height: thick, background: color || C.rule, opacity: op, ...style }}/>;
}

// Section header — "Nº 01 — kicker"
function Section({ n, title, kicker, children, style, C, serif, sans }) {
  return (
    <section style={{ padding: `0 ${SPACE.xl}px`, ...style }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: SPACE.md, marginBottom: SPACE.md }}>
        <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
          color: C.accent, letterSpacing: 0.4 }}>Nº {n}</span>
        <div style={{ flex: 1, height: 1, background: C.accent, opacity: 0.5 }}/>
        {kicker && <span style={{ fontFamily: sans, fontSize: TYPE.kicker, fontWeight: 600,
          letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>{kicker}</span>}
      </div>
      <h2 style={{ fontFamily: serif, fontWeight: 500, fontSize: TYPE.title2, lineHeight: 1.05,
        color: C.ink, margin: `0 0 ${SPACE.lg}px`, letterSpacing: -0.5, textWrap: 'pretty' }}>{title}</h2>
      {children}
    </section>
  );
}

// Brew-screen masthead — only used on the home screen now (#7)
function Masthead({ sub, title, C, serif, sans }) {
  return (
    <div style={{ padding: `${SPACE.xs}px ${SPACE.xl}px 0` }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        fontFamily: sans, fontSize: TYPE.kicker, fontWeight: 700, letterSpacing: 2.5,
        textTransform: 'uppercase', color: C.muted, paddingTop: SPACE.sm }}>
        <span style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
          <IconStamp size={12} color={C.accent}/> PourCraft
        </span>
        <span style={{ color: C.mutedSoft }}>The Brew</span>
      </div>
      <Rule C={C} thick={2} style={{ marginTop: SPACE.md, background: C.ink, opacity: 0.85 }}/>
      <Rule C={C} thick={1} style={{ marginTop: 2, background: C.ink, opacity: 0.85 }}/>
      <h1 style={{ fontFamily: serif, fontWeight: 400, fontSize: TYPE.display,
        lineHeight: 0.92, color: C.ink, margin: `${SPACE.xl}px 0 ${SPACE.xs}px`,
        letterSpacing: -2.5, textWrap: 'balance' }}>{title}</h1>
      <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14, color: C.muted,
        marginBottom: SPACE.md }}>{sub}</div>
      <Rule C={C} thick={1} style={{ background: C.rule }}/>
    </div>
  );
}

// Sub-page header — simplified per #7. Just kicker + title + thin rules.
function SubHeader({ kicker, title, sub, C, serif, sans, onBack, action }) {
  return (
    <div style={{ padding: `${SPACE.xs}px ${SPACE.xl}px 0` }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        fontFamily: sans, fontSize: TYPE.kicker, fontWeight: 700, letterSpacing: 2.5,
        textTransform: 'uppercase', color: C.muted, paddingTop: SPACE.sm, minHeight: 16 }}>
        {onBack ? (
          <button onClick={onBack} aria-label="Back" style={{
            all: 'unset', cursor: 'pointer', display: 'flex', alignItems: 'center',
            gap: 4, color: C.muted, minHeight: 44, paddingRight: 12,
          }}>
            <IconChevron size={11} color={C.muted} sw={1.6} style={{ transform: 'rotate(180deg)' }}/>
            Back
          </button>
        ) : (<span style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
          <IconStamp size={12} color={C.accent}/> PourCraft
        </span>)}
        <span style={{ color: C.mutedSoft }}>{kicker}</span>
        {action || <span style={{ width: 60 }}/>}
      </div>
      <Rule C={C} thick={1} style={{ background: C.ruleStrong, marginTop: SPACE.md, opacity: 0.65 }}/>
      <h1 style={{ fontFamily: serif, fontWeight: 400, fontSize: TYPE.title1,
        lineHeight: 0.95, color: C.ink, margin: `${SPACE.lg}px 0 ${SPACE.xs}px`,
        letterSpacing: -1.5, textWrap: 'balance' }}>{title}</h1>
      {sub && <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14,
        color: C.muted, marginBottom: SPACE.md }}>{sub}</div>}
      <Rule C={C} thick={1} style={{ background: C.rule }}/>
    </div>
  );
}

// Tab bar — safe-area aware (#1), simpler tab icons (#20)
const TabIcon = ({ id, color, sel }) => {
  const sw = sel ? 1.8 : 1.4;
  if (id === 'brew')  return <Ink size={22} color={color} sw={sw}><path d="M5 7 L19 7 L13 17 L11 17 Z"/><path d="M9 21 Q12 22.5 15 21"/></Ink>;
  if (id === 'guide') return <Ink size={22} color={color} sw={sw}><path d="M5 4 L5 19 L12 17 L19 19 L19 4 L12 6 Z"/><path d="M12 6 L12 17"/></Ink>;
  if (id === 'tips')  return <Ink size={22} color={color} sw={sw}><path d="M12 4 L13.5 9.5 L19 11 L13.5 12.5 L12 18 L10.5 12.5 L5 11 L10.5 9.5 Z"/></Ink>;
  return <Ink size={22} color={color} sw={sw}><circle cx="12" cy="12" r="9"/><path d="M12 8 L12 13 M12 16.5 L12 16.6"/></Ink>;
};

function ZineTabBar({ C, sans, active, onChange }) {
  const items = [
    { id: 'brew',  label: 'Brew' },
    { id: 'guide', label: 'Guide' },
    { id: 'tips',  label: 'Tips' },
    { id: 'about', label: 'About' },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0,
      paddingBottom: SAFE.bottom, // home indicator inset
      background: C.bg, borderTop: `1px solid ${C.rule}`, zIndex: 5,
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-around',
        paddingTop: SPACE.sm + 2, paddingBottom: SPACE.sm }}>
        {items.map(it => {
          const sel = it.id === active;
          return (
            <button key={it.id} onClick={() => onChange && onChange(it.id)}
              aria-label={it.label} style={{
              all: 'unset', cursor: 'pointer', minHeight: 44, minWidth: 44,
              display: 'flex', flexDirection: 'column',
              alignItems: 'center', gap: 4, padding: '4px 8px',
            }}>
              <TabIcon id={it.id} color={sel ? C.accent : C.muted} sel={sel}/>
              <span style={{ fontFamily: sans, fontSize: TYPE.caption, fontWeight: 600,
                letterSpacing: 1, textTransform: 'uppercase',
                color: sel ? C.accent : C.muted }}>{it.label}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
}

Object.assign(window, {
  ZineColors, zineSerif, zineSans, useZine,
  ZRule: Rule, ZSection: Section, ZMasthead: Masthead,
  ZSubHeader: SubHeader, ZTabBar: ZineTabBar,
});
