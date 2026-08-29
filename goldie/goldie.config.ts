import type { GoldieConfig } from "/Users/vinnycarpenter/.claude/plugins/marketplaces/goldie/src/config.ts";

const APP_ROOT = "/Users/vinnycarpenter/Projects/PourCraft";

const config: GoldieConfig = {
  appRoot: APP_ROOT,
  appPath: `${process.env.HOME}/Library/Developer/Xcode/DerivedData/PourCraft-ccdsjsgrpkxmunefkdybckczmclp/Build/Products/Release-iphonesimulator/PourCraft.app`,
  bundleId: "com.pourcraft.app",

  devices: ["iphone-6.9"],
  locales: ["en-US"],
  appearance: "light",

  // Copper bezel to match the app's #B87333 accent on the paper background.
  frame: { variant: "17-pro-orange" },

  theme: {
    // Warm paper gradient drawn from the zine palette (bg #FBF3E5, ink #2A1F1B).
    background: "linear-gradient(165deg, #FBF3E5 0%, #F4E6CE 58%, #EAD5B4 100%)",
    headlineColor: "#2A1F1B",
    subheadColor: "#6F5B49",
    fontFamily: "Merriweather, Georgia, serif",
    copyHeightRatio: 0.24,
    deviceWidthRatio: 0.84,
    template: "editorial",
    layout: "classic",
  },

  store: {
    name: "PourCraft",
    subtitle: { "en-US": "Pour-over, set in type." },
    developer: "Vinny Carpenter",
    category: "Food & Drink",
    rating: 4.9,
    ratingCount: "128 Ratings",
    ageRating: "4+",
    price: "Free",
    description: {
      "en-US":
        "PourCraft turns pour-over math into a morning ritual. Pick a roast, dial in your dose, and the app computes total water, bloom, and pour by the gram.\n\nThe built-in guide walks all eight steps with a live timer that cues bloom, pour, and drawdown. Save your recipe as a morning preset and brew the same cup every day.\n\nEight field notes cover the details that fix most cups: grind, water, temperature, and patience. No accounts, no tracking, no fuss.",
    },
  },

  scenes: [
    {
      kind: "screenshot",
      id: "brew",
      flow: "store-01-brew",
      headline: { "en-US": "Roast, ratio, ritual." },
      subhead: { "en-US": "Pick a roast and dial the dose. The water math sets itself." },
    },
    {
      kind: "screenshot",
      id: "pour",
      flow: "store-02-pour",
      headline: { "en-US": "The pour, by weight" },
      subhead: { "en-US": "Total, bloom, and spiral, computed to the gram." },
    },
    {
      kind: "screenshot",
      id: "guide",
      flow: "store-03-guide",
      headline: { "en-US": "Every pour, cued live" },
      subhead: { "en-US": "A built-in timer walks bloom, pour, and drawdown." },
    },
    {
      kind: "screenshot",
      id: "tips",
      flow: "store-04-tips",
      headline: { "en-US": "Field notes, not lectures" },
      subhead: { "en-US": "Eight short reads on grind, water, and patience." },
    },
    {
      kind: "screenshot",
      id: "article",
      flow: "store-05-article",
      headline: { "en-US": "Advice, set in type" },
      subhead: { "en-US": "Articles laid out like a magazine, not a manual." },
    },
    {
      kind: "preview",
      id: "preview",
      segments: [
        { id: "brew", flow: "store-preview-01-brew" },
        { id: "begin", flow: "store-preview-02-begin" },
        { id: "notes", flow: "store-preview-03-notes", holdSeconds: 2 },
      ],
    },
  ],
};

export default config;
