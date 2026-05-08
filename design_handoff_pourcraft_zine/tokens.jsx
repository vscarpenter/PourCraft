// tokens.jsx — Design tokens (spacing, type, motion, haptics)
// Single source of truth — shared across all screens.

const SPACE = { xs: 4, sm: 8, md: 12, lg: 16, xl: 24, xxl: 32, xxxl: 48 };

// Type scale (Fraunces serif + Inter sans)
const TYPE = {
  caption: 10, kicker: 11, body: 15, callout: 17,
  title3: 22, title2: 28, title1: 36, display: 56, hero: 96,
};

// Motion tokens
const MOTION = {
  micro:   { dur: 120, ease: 'cubic-bezier(0.2, 0, 0, 1)' },     // taps
  short:   { dur: 200, ease: 'cubic-bezier(0.2, 0, 0, 1)' },     // toggles, selects
  medium:  { dur: 320, ease: 'cubic-bezier(0.2, 0, 0, 1)' },     // page transitions
  long:    { dur: 1000, ease: 'cubic-bezier(0.4, 0, 0.2, 1)' },  // bloom timer
};
const trans = (props, m = MOTION.short) =>
  props.map(p => `${p} ${m.dur}ms ${m.ease}`).join(', ');

// Haptic intent map (documentation; the Swift side wires these up)
//   selection         -> roast / unit toggle
//   impact-light      -> stepper +/-
//   impact-soft       -> ruler snap (every 5g)
//   impact-medium     -> "Begin the brew"
//   notification-success -> bloom timer ends, brew complete
function fireHaptic(kind = 'selection') {
  if (navigator.vibrate) navigator.vibrate(kind === 'medium' ? 12 : 4);
}

// iOS safe-area insets — used so the tab bar floats above the home indicator
const SAFE = { bottom: 34, top: 0 };

Object.assign(window, { SPACE, TYPE, MOTION, trans, fireHaptic, SAFE });
