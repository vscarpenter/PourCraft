// motionNote.jsx — Motion language proposal sheet
// A single artboard explaining the easing, durations, and key transitions.

function MotionNote() {
  const C = ZineColors.light;
  const serif = zineSerif, sans = zineSans;
  const accent = C.accent, ink = C.ink, muted = C.muted;

  return (
    <div style={{
      width: 540, padding: '36px 36px 48px', background: C.surface,
      fontFamily: sans, color: ink, minHeight: 866, boxSizing: 'border-box',
    }}>
      <div style={{ fontSize: 10, fontWeight: 700, letterSpacing: 3,
        textTransform: 'uppercase', color: muted }}>
        PourCraft · Editorial Zine
      </div>
      <h1 style={{ fontFamily: serif, fontWeight: 400, fontSize: 48,
        lineHeight: 0.95, letterSpacing: -2, margin: '12px 0 6px' }}>
        A note on <em style={{ color: accent }}>motion</em>.
      </h1>
      <div style={{ fontFamily: serif, fontStyle: 'italic', fontSize: 16,
        color: muted, marginBottom: 14 }}>
        Slow, paper-like. Nothing snaps.
      </div>
      <div style={{ height: 2, background: ink, opacity: 0.85 }}/>
      <div style={{ height: 1, background: ink, opacity: 0.85, marginTop: 2 }}/>

      <p style={{ fontFamily: serif, fontSize: 15, lineHeight: 1.55,
        marginTop: 22 }}>
        The visual language is editorial — heavy rules, serif numerals, nothing
        gratuitous. Motion follows. Transitions are slow enough to feel
        composed, never bouncy or "spring-loaded." Easing is asymmetric:
        ease-in for departures, ease-out for arrivals.
      </p>

      <h3 style={{ fontFamily: serif, fontWeight: 500, fontSize: 22,
        margin: '28px 0 10px', letterSpacing: -0.4 }}>
        The token set.
      </h3>
      {[
        { k: 'Duration · micro',  v: '120ms', note: 'Toggle, button press' },
        { k: 'Duration · default',v: '200ms', note: 'Selection, ruler nudge' },
        { k: 'Duration · screen', v: '320ms', note: 'Tab change, screen swap' },
        { k: 'Duration · timer',  v: '1000ms tick', note: 'Bloom countdown' },
        { k: 'Easing · in',       v: 'cubic-bezier(.4,0,.7,.2)', note: 'Departures' },
        { k: 'Easing · out',      v: 'cubic-bezier(.2,.8,.3,1)', note: 'Arrivals' },
      ].map((r, i) => (
        <div key={i} style={{ display: 'flex', alignItems: 'baseline',
          gap: 8, padding: '10px 0',
          borderBottom: '1px dotted rgba(42,31,27,0.18)' }}>
          <span style={{ fontSize: 10, fontWeight: 700, letterSpacing: 2,
            textTransform: 'uppercase', color: muted, width: 160, flexShrink: 0 }}>
            {r.k}</span>
          <span style={{ fontFamily: serif, fontStyle: 'italic',
            fontSize: 15, color: ink, flex: 1 }}>{r.v}</span>
          <span style={{ fontSize: 11, color: muted, fontStyle: 'italic',
            fontFamily: serif }}>{r.note}</span>
        </div>
      ))}

      <h3 style={{ fontFamily: serif, fontWeight: 500, fontSize: 22,
        margin: '28px 0 10px', letterSpacing: -0.4 }}>
        Key moments.
      </h3>
      {[
        { num: '01', t: 'Stepper · weight changes',
          d: 'Big numeral cross-fades between values (200ms). Computed water values follow on a 60ms stagger so the eye sees cause-then-effect.' },
        { num: '02', t: 'Roast selection',
          d: 'Selected row\'s ratio glyph fades from ink to copper; check mark draws in (path-length stroke) over 240ms.' },
        { num: '03', t: 'Begin the brew',
          d: 'Calculator scrolls up out of frame as Guide slides up beneath. The masthead\'s top rule is shared across screens — anchor element.' },
        { num: '04', t: 'Bloom timer (Guide step 4)',
          d: 'A horizontal rule fills left-to-right over 30s. Tick at every second, beat every 5s. No sound. No spring.' },
        { num: '05', t: 'Step expansion',
          d: 'Step body fades + grows from 22px to natural height (300ms ease-out). Chevron rotates 90°.' },
        { num: '06', t: 'Tip · open / close',
          d: 'Index list fades out, article fades in. Big numeral hero scales from 32px (list) to 140px (article) — same number, different stage.' },
      ].map((m, i) => (
        <div key={i} style={{ display: 'flex', gap: 14, padding: '12px 0',
          borderTop: i === 0 ? 'none' : '1px solid rgba(42,31,27,0.12)' }}>
          <span style={{ fontFamily: serif, fontWeight: 400, fontSize: 28,
            color: accent, lineHeight: 0.85, letterSpacing: -1, width: 36 }}>
            {m.num}</span>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: serif, fontWeight: 500, fontSize: 17 }}>
              {m.t}</div>
            <div style={{ fontFamily: serif, fontSize: 13.5, color: muted,
              lineHeight: 1.5, marginTop: 3 }}>{m.d}</div>
          </div>
        </div>
      ))}

      <div style={{ marginTop: 26, padding: '14px 16px',
        borderLeft: `3px solid ${accent}`, background: 'rgba(184,115,51,0.08)',
        fontFamily: serif, fontStyle: 'italic', fontSize: 14, lineHeight: 1.5,
        color: ink }}>
        Rule of thumb: if a transition feels playful, slow it down by 80ms and
        remove the bounce. Editorial motion is patient.
      </div>
    </div>
  );
}

window.MotionNote = MotionNote;
