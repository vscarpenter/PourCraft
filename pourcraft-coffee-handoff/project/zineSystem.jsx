// zineSystem.jsx — Editorial Zine design system
// Shared palette, type, and atoms used by every PourCraft screen.

const ZineColors = {
  light: {
    bg: '#FBF3E5', surface: '#FFF8EC', surface2: '#F0E6D0',
    ink: '#2A1F1B', muted: '#7A5E45',
    rule: 'rgba(42,31,27,0.18)', ruleStrong: 'rgba(42,31,27,0.85)',
    accent: '#B87333', accentInk: '#FFF8EC',
    chip: 'rgba(184,115,51,0.10)',
  },
  dark: {
    bg: '#1A1412', surface: '#241A17', surface2: '#2C2320',
    ink: '#F0E6D6', muted: '#B89A7E',
    rule: 'rgba(240,230,214,0.18)', ruleStrong: 'rgba(240,230,214,0.6)',
    accent: '#D4935A', accentInk: '#1A1412',
    chip: 'rgba(212,147,90,0.14)',
  },
};

const zineSerif = '"Fraunces", "Source Serif 4", Georgia, serif';
const zineSans  = '"Inter", system-ui, sans-serif';

function useZine(dark) {
  return {
    C: ZineColors[dark ? 'dark' : 'light'],
    serif: zineSerif, sans: zineSans, dark,
  };
}

// ─── Atoms ───────────────────────────────────────────────────

function Rule({ thick = 1, op = 1, color, style, C }) {
  return <div style={{ height: thick, background: color || C.rule, opacity: op, ...style }}/>;
}

// Section header — "Nº 01 — kicker"
function Section({ n, title, kicker, children, style, C, serif, sans }) {
  return (
    <section style={{ padding: '0 24px', ...style }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginBottom: 10 }}>
        <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 13,
          color: C.accent, letterSpacing: 0.4 }}>Nº {n}</span>
        <div style={{ flex: 1, height: 1, background: C.accent, opacity: 0.5 }}/>
        {kicker && <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
          letterSpacing: 2, textTransform: 'uppercase', color: C.muted }}>{kicker}</span>}
      </div>
      <h2 style={{ fontFamily: serif, fontWeight: 500, fontSize: 26, lineHeight: 1.05,
        color: C.ink, margin: '0 0 16px', letterSpacing: -0.5 }}>{title}</h2>
      {children}
    </section>
  );
}

// Masthead — magazine top
function Masthead({ vol = '04', issue = '16', month = 'April', sub, title, C, serif, sans }) {
  return (
    <div style={{ padding: '4px 24px 0' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        fontFamily: sans, fontSize: 10, fontWeight: 600, letterSpacing: 2.5,
        textTransform: 'uppercase', color: C.muted, paddingTop: 6 }}>
        <span>Vol. {vol} · Issue {issue}</span>
        <span style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
          <IconStamp size={12} color={C.accent}/> Pourcraft
        </span>
        <span>{month}</span>
      </div>
      <Rule C={C} thick={2} style={{ marginTop: 10, background: C.ink, opacity: 0.85 }}/>
      <Rule C={C} thick={1} style={{ marginTop: 2, background: C.ink, opacity: 0.85 }}/>
      <h1 style={{ fontFamily: serif, fontWeight: 400, fontSize: 56,
        lineHeight: 0.92, color: C.ink, margin: '20px 0 4px', letterSpacing: -2.5 }}>
        {title}
      </h1>
      <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <span style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14, color: C.muted }}>
          {sub}
        </span>
        <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
          letterSpacing: 2, color: C.muted }}>EST. 2024</span>
      </div>
      <Rule C={C} thick={1} style={{ marginTop: 14, background: C.rule }}/>
    </div>
  );
}

// Smaller sub-page header (used on Guide/Tips/About)
function SubHeader({ kicker, title, sub, C, serif, sans, onBack }) {
  return (
    <div style={{ padding: '4px 24px 0' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        fontFamily: sans, fontSize: 10, fontWeight: 600, letterSpacing: 2.5,
        textTransform: 'uppercase', color: C.muted, paddingTop: 6 }}>
        <button onClick={onBack} style={{
          all: 'unset', cursor: onBack ? 'pointer' : 'default',
          display: 'flex', alignItems: 'center', gap: 4, color: C.muted,
        }}>
          {onBack && <IconChevron size={11} color={C.muted} sw={1.6} style={{ transform: 'rotate(180deg)' }}/>}
          {onBack ? 'Back' : 'Pourcraft'}
        </button>
        <span>{kicker}</span>
        <span>April</span>
      </div>
      <Rule C={C} thick={2} style={{ marginTop: 10, background: C.ink, opacity: 0.85 }}/>
      <Rule C={C} thick={1} style={{ marginTop: 2, background: C.ink, opacity: 0.85 }}/>
      <h1 style={{ fontFamily: serif, fontWeight: 400, fontSize: 44,
        lineHeight: 0.95, color: C.ink, margin: '18px 0 4px', letterSpacing: -2 }}>
        {title}
      </h1>
      <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 14, color: C.muted,
        marginBottom: 14 }}>{sub}</div>
      <Rule C={C} thick={1} style={{ background: C.rule }}/>
    </div>
  );
}

// Tab bar — same chrome on every screen
function ZineTabBar({ C, sans, active, onChange }) {
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
      paddingTop: 10, zIndex: 5,
    }}>
      {items.map(it => {
        const sel = it.id === active;
        return (
          <button key={it.id} onClick={() => onChange && onChange(it.id)} style={{
            all: 'unset', cursor: 'pointer',
            display: 'flex', flexDirection: 'column',
            alignItems: 'center', gap: 4, padding: '4px 8px',
          }}>
            <it.Icon size={22} color={sel ? C.accent : C.muted} sw={1.4}/>
            <span style={{ fontFamily: sans, fontSize: 10, fontWeight: 600,
              letterSpacing: 1, textTransform: 'uppercase',
              color: sel ? C.accent : C.muted }}>{it.label}</span>
          </button>
        );
      })}
    </div>
  );
}

Object.assign(window, {
  ZineColors, zineSerif, zineSans, useZine,
  ZRule: Rule, ZSection: Section, ZMasthead: Masthead,
  ZSubHeader: SubHeader, ZTabBar: ZineTabBar,
});
