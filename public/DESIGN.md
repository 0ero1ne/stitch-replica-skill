---
name: Agro-Tech Kinetic
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c3c9af'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#8d937b'
  outline-variant: '#434935'
  surface-tint: '#a1d80e'
  primary: '#ffffff'
  on-primary: '#253500'
  primary-container: '#bcf537'
  on-primary-container: '#506e00'
  inverse-primary: '#4b6700'
  secondary: '#88d982'
  on-secondary: '#003909'
  secondary-container: '#005b14'
  on-secondary-container: '#81d27c'
  tertiary: '#ffffff'
  on-tertiary: '#203526'
  tertiary-container: '#d0e9d3'
  on-tertiary-container: '#536a59'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#bcf537'
  primary-fixed-dim: '#a1d80e'
  on-primary-fixed: '#141f00'
  on-primary-fixed-variant: '#384e00'
  secondary-fixed: '#a3f69c'
  secondary-fixed-dim: '#88d982'
  on-secondary-fixed: '#002204'
  on-secondary-fixed-variant: '#005312'
  tertiary-fixed: '#d0e9d3'
  tertiary-fixed-dim: '#b4cdb8'
  on-tertiary-fixed: '#0b2013'
  on-tertiary-fixed-variant: '#364c3c'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-md:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1.2'
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  margin-desktop: 64px
  margin-tablet: 32px
  margin-mobile: 20px
  gutter: 24px
  unit-xs: 4px
  unit-sm: 8px
  unit-md: 16px
  unit-lg: 32px
  unit-xl: 64px
---

## Brand & Style

The design system is engineered for a premium, high-tech agricultural ecosystem. It bridges the gap between raw earth and advanced data science, evoking a sense of "precision nature." The target audience includes enterprise farmers, agronomists, and bio-tech investors who require sophisticated data visualization and reliable operational tools.

The visual style is **Futuristic Glassmorphism** layered over a **Minimalist** foundation. It utilizes deep, atmospheric backgrounds to allow high-vibrancy accents to "pop," mimicking the glow of a cockpit or a high-end laboratory interface. Sublte high-fidelity grain textures are applied to surfaces to add a tactile, organic feel to an otherwise digital environment, preventing the UI from feeling sterile.

**Emotional Response:**
- **Professional:** Through rigorous alignment and generous whitespace.
- **Futuristic:** Via neon accents, translucent layers, and kinetic blurs.
- **Reliable:** Using high-contrast typography and clear information density.

## Colors

The palette is optimized for low-light environments and high-contrast data legibility. 

- **Primary Backgrounds:** Deep Charcoal (#121212) serves as the base canvas, with Midnight Green (#0a1f12) used for structural containers and navigation panels to provide subtle tonal depth.
- **Action Colors:** Vibrant Lime (#c5ff41) is the primary interactive color. It is used for CTA buttons, active states, and critical data points. Emerald (#2e7d32) acts as a secondary "growth" indicator and for success states.
- **Accents:** Use a subtle bloom effect (a soft outer glow) on Primary Lime elements to simulate a high-tech illuminated display.
- **Text:** Pure white is avoided to reduce eye strain; use a 90% opacity white for primary headers and 65% for secondary body text.

## Typography

This design system uses **Hanken Grotesk** exclusively to maintain a cohesive, ultra-modern look. The typographic hierarchy relies on extreme weight variance—pairing ExtraBold headers with Regular body text—to create clear visual anchors.

- **Scale:** High-contrast sizing is preferred. Display text should feel monumental, while body text remains breathable.
- **Legibility:** For data-heavy tables, use `label-sm` with slightly increased tracking to ensure clarity at small sizes.
- **Utility:** All labels and captions should utilize the Medium or Semibold weights to remain distinct from body paragraphs.

## Layout & Spacing

The design system follows a **Fluid Grid** model with a "Wide-Gutter" philosophy. The objective is to provide maximum "air" around complex data visualizations to prevent cognitive overload.

- **Desktop:** 12-column grid with 64px outside margins and 24px gutters.
- **Tablet:** 8-column grid with 32px margins.
- **Mobile:** 4-column grid with 20px margins.
- **Rhythm:** An 8px linear scaling system is used for all internal component spacing (padding, gaps).
- **Reflow:** Cards should stack vertically on mobile but utilize horizontal "swipeable" carousels for metrics to maintain density without clutter.

## Elevation & Depth

Depth is conveyed through **Glassmorphism** and light-based hierarchy rather than traditional dropshadows.

- **Base Layer:** #121212 (Solid).
- **Surface Layer (Cards/Modals):** Use a semi-transparent Midnight Green (#0a1f12 at 60% opacity) with a `backdrop-filter: blur(20px)`. 
- **Borders:** Surfaces are defined by a 1px inner stroke. Use `rgba(255, 255, 255, 0.1)` for top and left borders, and `rgba(0, 0, 0, 0.2)` for bottom and right to simulate a subtle etched glass effect.
- **Glow/Bloom:** Interactive elements at higher elevations (like primary buttons) utilize a soft outer glow (`box-shadow: 0 0 15px rgba(197, 255, 65, 0.4)`) to appear as if they are emitting light.
- **Texture:** Apply a subtle 5% opacity noise/grain overlay to the entire background to add a high-fidelity "premium material" feel.

## Shapes

The shape language is **Soft-Technical**. We avoid fully round "pill" shapes for primary containers to maintain a serious, professional tone.

- **Standard Radius:** 0.25rem (4px) for small utility components (inputs, checkboxes).
- **Large Radius:** 0.5rem (8px) for cards and main containers to soften the high-tech edge.
- **Interactive Elements:** Buttons utilize the 4px radius to feel precise and mechanical.

## Components

- **Buttons:** Primary buttons use a solid Lime Green (#c5ff41) background with black text. On hover, they trigger a "bloom" effect. Ghost buttons use a 1px Lime stroke with a background blur.
- **Chips/Status Tags:** Use a "dot" indicator for status (e.g., a pulsing Emerald dot for "Healthy Crop"). Backgrounds should be low-opacity versions of the status color.
- **Input Fields:** Dark backgrounds (#0a1f12) with a 1px border. On focus, the border transitions to Lime Green with a subtle glow.
- **Cards:** Glassmorphic with a backdrop blur of 20px. Content is separated by thin 1px dividers with 10% white opacity.
- **Data Visualizations:** Charts should use Lime Green for primary data lines and Emerald for historical/average lines. Use gradients under lines that fade from 30% opacity to 0% at the X-axis.
- **Lists:** High-contrast rows with 16px vertical padding. Use "Chevron" icons in Lime Green to indicate drill-down capabilities.