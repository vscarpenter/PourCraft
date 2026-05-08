// shared.jsx — Common atoms for all three PourCraft directions
// Includes:
//   - Hand-drawn ink line icons (V60 dripper, kettle, scale, bloom, drop, beans, thermometer, spiral, flame)
//   - PCFrame: a bare iPhone shell that overlays our own translucent status bar
//   - Roast data
//   - useBrew(): little hook with weight + roast + temp unit + computed water values

const ROASTS = [
  { id: 'light',  name: 'Light',  ratio: 17, label: '1:17',
    flavor: 'Bright, floral, tea-like. Origin flavors shine through.',
    short:  'Bright · Floral',
    intensity: 1 },
  { id: 'medium', name: 'Medium', ratio: 16, label: '1:16',
    flavor: 'Balanced sweetness, clean body. The specialty sweet spot.',
    short:  'Balanced · Sweet',
    intensity: 2 },
  { id: 'dark',   name: 'Dark',   ratio: 15, label: '1:15',
    flavor: 'Bold, rich, full-bodied. Chocolate and caramel forward.',
    short:  'Bold · Rich',
    intensity: 3 },
];

function useBrew(initial = {}) {
  const [roastId, setRoastId] = React.useState(initial.roast || 'medium');
  const [weight,  setWeight]  = React.useState(initial.weight ?? 20);
  const [unit,    setUnit]    = React.useState(initial.unit  || 'F');

  const roast = ROASTS.find(r => r.id === roastId);
  const total = +(weight * roast.ratio).toFixed(0);
  const bloom = +(weight * 2).toFixed(0);
  const remaining = total - bloom;
  const tempRange = unit === 'F' ? '194° – 204° F' : '90° – 96° C';
  const tempPoint = unit === 'F' ? '200° F' : '93° C';

  const setWeightClamped = (v) => setWeight(Math.min(60, Math.max(10, Math.round(v))));

  return { roastId, setRoastId, roast, weight, setWeight: setWeightClamped,
    unit, setUnit, total, bloom, remaining, tempRange, tempPoint };
}

// ─────────────────────────────────────────────────────────────
// Hand-drawn ink line icons
// All 24×24 viewBox, stroke-based, slightly imperfect to feel hand-drawn
// ─────────────────────────────────────────────────────────────
const Ink = ({ children, size = 22, color = 'currentColor', style, sw = 1.4 }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none"
    stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"
    style={{ flexShrink: 0, ...style }}>{children}</svg>
);

const IconV60 = (p) => <Ink {...p}>
  {/* cone dripper sitting on a server */}
  <path d="M5.2 5.5 L18.8 5.5 L13 15 L11 15 Z"/>
  <path d="M11 15 L11 17.2 L13 17.2 L13 15"/>
  <path d="M8 19.5 Q12 21.5 16 19.5"/>
  <path d="M7.5 5.5 Q12 3.8 16.5 5.5" />
  {/* ridges */}
  <path d="M8 8 L16 8" opacity=".5"/>
  <path d="M9 11 L15 11" opacity=".5"/>
</Ink>;

const IconKettle = (p) => <Ink {...p}>
  {/* gooseneck kettle */}
  <path d="M5 11 L5 17 Q5 19 7 19 L15 19 Q17 19 17 17 L17 11"/>
  <path d="M5 11 L17 11"/>
  <path d="M17 12.5 Q21 11 21 8 Q21 6.5 19.5 6.5"/>
  <path d="M9 11 L9 8 Q9 6 11 6 L13 6 Q15 6 15 8 L15 11"/>
  <path d="M10 8 L14 8" opacity=".5"/>
</Ink>;

const IconScale = (p) => <Ink {...p}>
  <rect x="3.5" y="6" width="17" height="13" rx="1.6"/>
  <circle cx="12" cy="13" r="3.2"/>
  <path d="M12 11.2 L12 13"/>
  <path d="M9 4 L15 4" />
  <path d="M10 4 L10 6 M14 4 L14 6"/>
</Ink>;

const IconBloom = (p) => <Ink {...p}>
  {/* concentric ripples */}
  <ellipse cx="12" cy="14" rx="8" ry="3"/>
  <ellipse cx="12" cy="13" rx="5.2" ry="1.9" opacity=".7"/>
  <ellipse cx="12" cy="12" rx="2.8" ry="1.1" opacity=".5"/>
  {/* drop above */}
  <path d="M12 4 Q14 7 14 8.5 Q14 10 12 10 Q10 10 10 8.5 Q10 7 12 4 Z"/>
</Ink>;

const IconDrop = (p) => <Ink {...p}>
  <path d="M12 3 Q17 9 17 14 Q17 19 12 19 Q7 19 7 14 Q7 9 12 3 Z"/>
  <path d="M9.5 14.5 Q10 16.5 12 17" opacity=".6"/>
</Ink>;

const IconBeans = (p) => <Ink {...p}>
  <ellipse cx="9" cy="12" rx="4" ry="6" transform="rotate(-25 9 12)"/>
  <path d="M7.6 8.5 Q9.5 12 8.2 16" opacity=".6" transform="rotate(-25 9 12)"/>
  <ellipse cx="16" cy="13" rx="3.2" ry="5" transform="rotate(20 16 13)"/>
  <path d="M15 9.5 Q16.5 13 15.5 16.5" opacity=".6" transform="rotate(20 16 13)"/>
</Ink>;

const IconThermo = (p) => <Ink {...p}>
  <path d="M12 4 Q14 4 14 6 L14 13.5 Q16 14.5 16 16.5 Q16 19 13 19.5 Q9 19.5 9 16.5 Q9 14.5 11 13.5 L11 6 Q11 4 12 4 Z"/>
  <circle cx="12.5" cy="16.7" r="1.4"/>
  <path d="M14 8 L16 8 M14 10.5 L16 10.5"/>
</Ink>;

const IconSpiral = (p) => <Ink {...p}>
  <path d="M12 12 Q12 8 15 8 Q18 8 18 12 Q18 17 12 17 Q5.5 17 5.5 11 Q5.5 4 13 4"/>
</Ink>;

const IconTimer = (p) => <Ink {...p}>
  <circle cx="12" cy="13.5" r="6.5"/>
  <path d="M12 13.5 L12 9.5 M12 13.5 L15 14.5"/>
  <path d="M10 4 L14 4"/>
  <path d="M16 5 L18 7" />
</Ink>;

const IconFlame = (p) => <Ink {...p}>
  <path d="M12 4 Q9 8 9 11 Q9 13 11 13 Q11 11 12 10 Q14 12 14 14 Q14 17 12 19 Q15 19 16.5 16.5 Q18 14 17 11 Q16 8 12 4 Z"/>
</Ink>;

const IconCheck = (p) => <Ink {...p}><path d="M5 12 L10 17 L19 7"/></Ink>;
const IconChevron = (p) => <Ink {...p}><path d="M9 5 L16 12 L9 19"/></Ink>;
const IconPlus = (p) => <Ink {...p}><path d="M12 5 L12 19 M5 12 L19 12"/></Ink>;
const IconMinus = (p) => <Ink {...p}><path d="M5 12 L19 12"/></Ink>;
const IconStamp = (p) => <Ink {...p}><circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="6.5" opacity=".6"/></Ink>;

// Status bar tinted to background — minimalist iOS time + signal
function PCStatusBar({ color = '#3B2F2F', time = '6:41' }) {
  return (
    <div style={{
      display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      padding: '18px 28px 8px', position: 'relative', zIndex: 5,
      fontFamily: 'system-ui, -apple-system', fontSize: 16, fontWeight: 600,
      color, letterSpacing: 0.2,
    }}>
      <span>{time}</span>
      <span style={{ display: 'flex', gap: 6, alignItems: 'center', opacity: 0.85 }}>
        <svg width="16" height="11" viewBox="0 0 16 11"><rect x="0" y="7" width="2.5" height="4" rx=".5" fill={color}/><rect x="4" y="5" width="2.5" height="6" rx=".5" fill={color}/><rect x="8" y="3" width="2.5" height="8" rx=".5" fill={color}/><rect x="12" y="1" width="2.5" height="10" rx=".5" fill={color}/></svg>
        <svg width="22" height="11" viewBox="0 0 22 11"><rect x="0.5" y="0.5" width="18" height="10" rx="2.5" stroke={color} fill="none" opacity=".4"/><rect x="2" y="2" width="14" height="7" rx="1.2" fill={color}/><rect x="19.5" y="3.5" width="1.5" height="4" rx=".4" fill={color} opacity=".4"/></svg>
      </span>
    </div>
  );
}

// Bare phone shell — black bezel, rounded screen, dynamic island, home bar
function PCFrame({ children, bg = '#FFF8F0', dark = false, w = 390, h = 844 }) {
  return (
    <div style={{
      width: w, height: h,
      borderRadius: 52,
      background: dark ? '#0a0606' : '#1a1410',
      padding: 11, boxSizing: 'border-box',
      boxShadow: dark
        ? '0 30px 80px rgba(0,0,0,0.6), inset 0 0 0 1.5px rgba(255,255,255,0.08)'
        : '0 30px 80px rgba(50,30,15,0.22), 0 8px 24px rgba(50,30,15,0.10), inset 0 0 0 1.5px rgba(255,255,255,0.04)',
      position: 'relative',
      fontFamily: 'system-ui, -apple-system',
    }}>
      <div style={{
        width: '100%', height: '100%', borderRadius: 42, overflow: 'hidden',
        background: bg, position: 'relative',
      }}>
        {/* Dynamic island */}
        <div style={{
          position: 'absolute', top: 10, left: '50%', transform: 'translateX(-50%)',
          width: 110, height: 32, borderRadius: 20, background: '#000', zIndex: 100,
        }}/>
        {children}
        {/* Home bar */}
        <div style={{
          position: 'absolute', bottom: 7, left: '50%', transform: 'translateX(-50%)',
          width: 124, height: 4.5, borderRadius: 99, zIndex: 100,
          background: dark ? 'rgba(240,230,214,0.55)' : 'rgba(59,47,47,0.32)',
        }}/>
      </div>
    </div>
  );
}

Object.assign(window, {
  ROASTS, useBrew,
  Ink, IconV60, IconKettle, IconScale, IconBloom, IconDrop, IconBeans,
  IconThermo, IconSpiral, IconTimer, IconFlame, IconCheck, IconChevron,
  IconPlus, IconMinus, IconStamp,
  PCStatusBar, PCFrame,
});
