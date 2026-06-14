---
name: stitch-to-vue-replica
description: Use when explicitly running the advanced Vue generation stage from normalized public/DESIGN.md and semantic public/*.html files
---

# stitch-to-vue-replica

## For Ordinary Users

Ordinary users do not need to call this skill directly.

Recommended entry point:

```txt
stitch-project-generator
```

It automatically detects whether the current directory contains a raw Stitch export folder or a normalized `public/` input, then runs the complete generation flow.

## Internal / Advanced Use

Use this skill directly only as an advanced or maintenance stage:

```txt
public/ -> Vue3 project
```

It expects `public/DESIGN.md` and semantic `public/*.html` files to already exist. If the project only contains a raw `stitch*` export folder, use `stitch-project-generator` or `stitch-export-normalizer` first.

## Overview

Use this skill to initialize a brand-new Vue 3 + Vite + pnpm project from a normalized Stitch source project.

The input must already be normalized into:

```txt
<project-root>/
  public/
    DESIGN.md
    *.html
```

The `public/*.html` filenames should come from the preceding `stitch-export-normalizer` skill, which extracts real page names from the raw Stitch export's navigation. Do not assume fixed page names or a fixed page count.

The outer `public/` directory is input only. The generated Vue project must be created inside the project root as a same-name inner directory:

```txt
<source-root>/<source-folder-name>/
```

Example:

```txt
wer/
  public/
    DESIGN.md
    <real-page-name>.html
    <real-page-name>.html

  wer/
    package.json
    index.html
    vite.config.ts
    src/
```

This skill does not update existing Vue projects. If the same-name inner Vue project already exists, stop immediately and report that no files were changed.

If the project root only contains a raw `stitch*` export folder and does not contain standardized `public/DESIGN.md` plus `public/*.html`, do not run this skill yet. Run `stitch-export-normalizer` first, then return to this skill.

## Applicability Gate

Run this skill only when all conditions are true:

- The current target is a source root like `<source-root>/`.
- `<source-root>/public/` exists.
- `<source-root>/public/DESIGN.md` exists.
- `<source-root>/public/*.html` contains at least one normalized Stitch HTML page.
- `public/*.html` filenames are semantic page names from the normalized source, not raw `code.html`, `_1.html`, `_2.html`, or `page1.html`.
- `<source-root>/<source-folder-name>/` does not exist.
- No same-name Vue project has already been generated.

The same-name Vue project path is derived from the source root folder name. If the source root is `wer/`, the target Vue project is `wer/wer/`.

## Stop Conditions

Stop before modifying files when any stop condition is detected.

| Stop condition | Required response |
| --- | --- |
| `<source-root>/<source-folder-name>/` exists | Same-name Vue project already exists. No files changed. |
| `<source-root>/<source-folder-name>/package.json` exists | Vue system has already been generated. No files changed. |
| `<source-root>/<source-folder-name>/src/` exists | Vue system has already been generated. No files changed. |
| `<source-root>/public/` is missing | Missing outer Stitch source directory. No files changed. |
| `<source-root>/public/DESIGN.md` is missing | Missing design specification file. No files changed. |
| No `<source-root>/public/*.html` files exist | No Stitch HTML pages are available to convert. No files changed. |
| Only raw `<source-root>/stitch*/` export folders exist | Run `stitch-export-normalizer` before this skill. No files changed. |
| `public/*.html` contains only raw names such as `code.html`, `_1.html`, `_2.html`, or `page1.html` | Input is not normalized. Run `stitch-export-normalizer` or provide explicit page mapping. No files changed. |

If a same-name Vue project exists, report exactly:

```md
This skill only supports projects that have not generated the Vue system yet. A same-name Vue project already exists, so no files were changed.
```

Do not update, patch, overwrite, merge into, or continue converting an existing same-name Vue project.

## Core Invariants

- Outer `public/` is the Stitch source input, not the final Vue project's `public/`.
- Final pages must be `.vue` single-file components in the inner Vue project.
- Do not keep Stitch `.html` as final website pages.
- Do not copy `.html` or `.md` source files into the inner Vue project.
- Do not delete, move, rename, or overwrite outer `public/` source files.
- Do not display Stitch HTML through `iframe`, links, redirects, `window.location.href`, or whole-page HTML injection.
- Do not use `v-html` or equivalent raw HTML injection to dump an entire Stitch page into Vue.
- Do not create `.html` routes such as `/products.html`, `/code.html`, `/首页.html`, or `/产品中心.html`.
- Convert the HTML structure into real Vue templates, components, router entries, layout, navigation, and CSS.
- Process every normalized Stitch HTML page in outer `public/`; do not only build one page.
- Derive pages, routes, and navigation from the actual `public/*.html` filenames, HTML content, navigation structure, and `DESIGN.md`.
- Do not assume pages are named `首页`, `产品中心`, `解决方案`, `项目案例`, `服务体系`, or `关于我们`.
- Do not assume pages are named `Home`, `Products`, `Solutions`, `Cases`, `Services`, or `About`.
- Do not assume there are exactly 6 pages.
- Use high-fidelity / 1:1 source replica mode by default.
- Navigation may be normalized. Everything else must be replicated from the source HTML as literally as possible.
- `DESIGN.md` may assist with tokens and interpretation, but it must not override concrete source HTML visuals, DOM, CSS, images, icons, backgrounds, or layout.

## High-Fidelity Replica Rules

The highest principle is:

```txt
Navigation may be normalized. Everything else must be replicated from the source HTML as literally as possible.
```

Conversion priority:

1. User request.
2. Source HTML DOM, CSS, images, icons, backgrounds, and layout.
3. Inline styles, `<style>` tags, class styles, and linked CSS.
4. `DESIGN.md`.
5. Vue organization and component abstraction.

`DESIGN.md` is a supporting reference only. Use it to understand design tokens, colors, spacing, typography, and intent, but never use it to replace or redesign visuals that are concretely present in HTML/CSS/assets.

For page bodies, perform a 1:1 conversion of the source body:

- Preserve section count, order, and hierarchy.
- Preserve card, list, image, icon, button, badge, divider, and decorative-layer counts.
- Preserve text content except for explicit user changes or obvious export mistakes.
- Preserve hero composition, background layers, overlays, masks, gradients, z-index, position, gaps, margins, padding, radius, shadows, and responsive behavior.
- Preserve image/icon placement, proportions, crops, object-fit, masks, opacity, and layering.
- Preserve layout mechanics such as flex/grid structure, absolute positioning, sticky/fixed positioning, width constraints, and first-fold composition.
- Keep component abstraction subordinate to fidelity. When there is a conflict between maintainability and visual fidelity, visual fidelity wins.

## Project Creation Rules

When the applicability gate passes:

1. Derive `<source-folder-name>` from the outer source root directory name.
2. Create the inner Vue project at `<source-root>/<source-folder-name>/`.
3. Use Vue 3, Vite, pnpm, vue-router, Pinia, and TypeScript unless the user explicitly requests JavaScript.
4. Use ordinary CSS, CSS variables, global CSS, scoped CSS, and shared classes by default.
5. Do not introduce unrelated UI frameworks, CSS frameworks, or component libraries unless the user explicitly asks for them.
6. Do not use npm as the default package manager.
7. Do not generate `package-lock.json`.
8. Default run command must be `pnpm dev`.
9. Default build command must be `pnpm build`.
10. Create Vue project files only inside the inner same-name project directory.

Do not create these in the outer source root:

```txt
package.json
src/
index.html
vite.config.ts
```

Those files belong only in:

```txt
<source-root>/<source-folder-name>/
```

## Source File Reading Rules

Read all source files from:

```txt
<source-root>/public/
```

Required inputs:

- `public/DESIGN.md`
- all `public/*.html`
- all other `public/*.md`

Treat these files as conversion inputs only:

- Do not copy `.html` or `.md` source files.
- Do not move `.html` or `.md` source files.
- Do not delete `.html` or `.md` source files.
- Do not place source `.html` or `.md` files in the inner Vue project's `public/`.
- Do not make source `.html` files final runtime pages.
- Do not link final pages to `../public/*.html`.

## HTML to Vue Page Mapping

Scan every HTML file in outer `public/` and infer the target Vue view from:

- file name
- `<title>`
- main page heading
- navigation labels
- `DESIGN.md`
- page content semantics

The filename produced by `stitch-export-normalizer` is the primary page-name signal because it was derived from real Stitch navigation. Use it together with the HTML content to create clean Vue view filenames and route paths.

Do not use a fixed mapping table. Examples such as `首页 -> /`, `产品中心 -> /products`, or `关于我们 -> /about` are allowed only when those exact normalized filenames and page meanings are actually present.

Mapping rules:

- Map every `public/*.html` file to one `.vue` view.
- Infer the home/root page dynamically from normalized filename, nav order, page content, and user instructions.
- If no root page can be identified confidently, choose the first/highest-priority navigation page as `/` and report the decision.
- Generate clean route paths from actual page meaning, not from the `.html` extension.
- Never use `.html` filenames as final routes.
- If the user explicitly provides page structure, route slugs, or page names, follow the user instruction.

## Vue Project Structure

The generated inner project should use this maintainable structure:

```txt
<source-root>/<source-folder-name>/
  package.json
  pnpm-lock.yaml
  index.html
  vite.config.ts
  tsconfig.json
  src/
    main.ts
    App.vue
    assets/
    components/
      AppHeader.vue
      AppFooter.vue
      BaseButton.vue
      BaseCard.vue
    layouts/
      DefaultLayout.vue
    router/
      index.ts
    stores/
      index.ts
    styles/
      main.css
      variables.css
      layout.css
    views/
      <GeneratedPage>.vue
      <GeneratedPage>.vue
```

Rules:

- Pages go in `src/views/`.
- Shared components go in `src/components/`.
- Router setup goes in `src/router/`.
- Styles go in `src/styles/`.
- Layouts go in `src/layouts/`.
- Pinia stores go in `src/stores/` when needed.
- Create additional section components only when they improve reuse or clarity without harming visual fidelity.

## Router Rules

Use Vue Router. Build routes dynamically from the actual normalized pages.

```ts
[
  { path: '/', name: '<RootPageName>', component: RootPage },
  { path: '/<semantic-route>', name: '<PageName>', component: PageComponent }
]
```

Use `<RouterLink />` or standard Vue Router APIs for internal navigation.

Rules:

- Use the normalized page names and HTML navigation structure to define route labels and order.
- Use the user's explicit route structure when provided.
- Create human-readable route slugs from the actual page meaning.
- Keep route names unique.
- If multiple pages produce the same route slug, resolve the conflict before implementation and report the decision.

Forbidden:

- `.html` routes.
- `/products.html`.
- `/code.html`.
- `/首页.html`.
- Plain `<a href="xxx.html">` links for page navigation.
- `window.location.href` navigation to Stitch HTML.
- `iframe` display of HTML.
- Whole-page HTML injection.

## Navigation Normalization / Unified Navigation

Do not directly reuse each Stitch HTML page's separate navigation markup. Stitch pages often contain small inconsistencies; normalize them into one shared navigation component.

Navigation normalization is allowed for routing and consistency, but it must not become a full visual redesign of the header.

Required:

- Create one shared header component, normally `src/components/AppHeader.vue` or `src/components/SiteHeader.vue`.
- Use the same header through `src/layouts/DefaultLayout.vue` for all pages.
- Do not copy different header variants into each page.
- Do not create duplicate headers.
- Do not allow page-to-page differences in header height, position, font size, spacing, active state, hover state, logo region, or CTA treatment.
- Do not let navigation links point to `.html` files.
- Use Vue Router for route changes.
- Provide an active state for the current route.
- Provide responsive mobile behavior that does not break layout.

Default navigation must be generated from actual normalized pages and their HTML navigation structures. Do not assume a default six-page navigation.

Navigation consistency requirements:

- Same labels.
- Same order.
- Same route paths.
- Same font sizes.
- Same header height.
- Same horizontal margins.
- Same hover state.
- Same active state.
- Same logo region.
- Same CTA button, if one exists.

When source pages disagree, choose the final navigation by this priority:

1. User-provided navigation or route instructions.
2. The shared source HTML navigation structure and visual style.
3. The normalized `public/*.html` filenames created by `stitch-export-normalizer`.
4. The most complete, reasonable, visually polished HTML page.
5. `DESIGN.md` design-system guidance.

## Source Cleanup and Semantic Correction

Stitch HTML may contain incorrect links, invalid asset paths, duplicated export wrappers, or page-level inconsistencies. Cleanup is narrow and conversion-oriented.

Cleanup is allowed only when it is necessary for Vue runtime correctness, asset resolution, navigation routing, or obvious export mistakes. Cleanup must not become redesign.

Allowed cleanup:

- Convert `.html` navigation links to Vue Router links.
- Fix invalid or relocated asset paths.
- Remove scripts that cannot or should not run in Vue.
- Remove redundant export wrappers only when they do not affect visual layout.
- Resolve invalid HTML that prevents Vue template compilation.
- Correct obvious export mistakes, placeholder fragments, or broken references.
- Normalize the shared header/navigation for routing and consistency.

Correction rules:

- Do not rewrite body copy by default.
- Do not change page body layout by default.
- Do not change image, icon, card, hero, background, or section structure by default.
- Do not remove decorative layers, masks, gradients, overlays, or absolute-positioned elements unless they are broken and the removal is explicitly reported.
- Correct obvious mistakes only when evidence is concrete.
- Normalize navigation, buttons, routes, titles, and section names.
- If uncertain whether copy is wrong, preserve it and mention it in the final report.
- Do not delete major sections just to simplify implementation.
- Do not reduce card counts, module counts, or major visual hierarchy.
- List meaningful corrections in the final report.
- Keep the visual result as close to the source HTML/CSS/assets as possible.

## Design System and CSS Rules

Read `public/DESIGN.md` and convert its design system into the inner Vue project's CSS system.

Extract:

- colors
- fonts
- backgrounds
- page widths
- content containers
- card styles
- button styles
- navigation styles
- spacing system
- radius tokens
- shadows
- glassmorphism effects
- motion
- responsive rules

Implementation preference:

- CSS variables in `src/styles/variables.css`.
- Global base styles in `src/styles/main.css`.
- Layout styles in `src/styles/layout.css`.
- Scoped CSS for page-specific styles.
- Shared classes for repeated section, card, button, and surface patterns.
- Base components such as `BaseButton.vue`, `BaseCard.vue`, `AppHeader.vue`, and `AppFooter.vue`.

Style rules:

- Do not repeat shared style blocks in every page.
- Abstract navigation, buttons, cards, sections, and backgrounds when reuse is clear.
- Keep page-specific styling in the corresponding `.vue` file when appropriate.
- Do not introduce unrelated UI frameworks.
- Do not use a third-party component library to recreate Stitch visuals unless the user explicitly requests it.
- Do not pile up meaningless inline styles.
- Do not sacrifice visual fidelity for shorter code.
- Do not ignore `DESIGN.md`.

## Asset Path Handling

Inspect every runtime asset reference in the source, including:

- `<img src>` and `srcset`
- `<source src>` and `srcset`
- `<video src>` and `<poster>`
- `<link href>` for favicon, stylesheet, preload, and fonts
- favicon and touch icon references
- inline `style` URLs
- `<style>` tag `url(...)` references
- external CSS `url(...)` references
- SVG `<image href>` and `xlink:href`
- `@font-face` files
- relative paths, absolute paths, root-relative paths, Windows paths, and remote URLs
- file types such as `png`, `jpg`, `jpeg`, `webp`, `gif`, `svg`, `ico`, `avif`, `mp4`, `webm`, `woff`, `woff2`, `ttf`, `otf`, and `css`

Rules:

- If an asset exists in outer `public/` and the Vue page needs it, copy only that necessary static asset into the inner Vue project.
- Prefer copying runtime static assets into `<inner>/public/assets/` for URL-addressed files, or `src/assets/` when imported by Vue/CSS.
- Rewrite every copied asset reference so runtime and build paths resolve inside the inner Vue project.
- Allowed copied assets include images, SVGs, fonts, videos, favicon files, and similar runtime static assets.
- Do not copy `.html` or `.md` source files.
- Do not copy `DESIGN.md` into the inner project.
- Do not make final pages depend on outer `.html` files.
- Do not invent missing images or assets.
- Do not leave invalid paths that break build or runtime rendering.
- Do not leave local machine paths such as `E:\...`, `D:\...`, `C:\...`, or `file://...` in generated Vue code.
- Do not silently delete or omit referenced assets.
- If an asset is missing, list it in the final report.
- If an asset is remote, preserve it only when appropriate and report it; otherwise copy/download only with user permission or explicit project policy.
- Remove or replace external CDN dependencies only when doing so preserves the intended visual result and avoids build/runtime risk.

## Source CSS Preservation Rules

Read and preserve source CSS from:

- `<style>` tags.
- inline `style` attributes.
- linked external CSS files.
- CSS referenced by `@import`.
- classes and selectors used by source DOM.
- media queries, keyframes, variables, fonts, pseudo-elements, masks, gradients, filters, transforms, transitions, and responsive rules.

Convert source CSS into the Vue project without changing the visual result:

- Put reusable tokens and base rules in `src/styles/variables.css` and `src/styles/main.css`.
- Put layout-level shared rules in `src/styles/layout.css`.
- Put page-specific converted rules in each `.vue` file's scoped or module-local style when appropriate.
- Preserve selectors and class intent when it helps fidelity.
- Do not ignore HTML CSS because `DESIGN.md` exists.
- Do not simplify CSS if simplification changes layout, spacing, colors, backgrounds, shadows, masks, gradients, typography, or responsive behavior.

## Literal Conversion Strategy

Before converting, build these inventories from the source:

- Source DOM inventory: page, header, body sections, major wrappers, repeated structures, text nodes, buttons, forms, cards, icons, images, footer.
- Source CSS inventory: inline styles, style tags, linked CSS, media queries, selectors, tokens, animations, backgrounds, masks, gradients, shadows.
- Source asset inventory: all runtime files and URLs, including missing and remote assets.
- Source visual hierarchy inventory: first fold, hero, section order, layering, z-index, spacing rhythm, image/card counts, CTA placement.

Convert in this order:

1. Migrate the source body DOM into Vue template structure.
2. Replace navigation links with Vue Router links.
3. Rewrite asset paths.
4. Fix Vue template legality.
5. Extract only minimal components that do not change the visual output.

Forbidden conversion strategies:

- Redesigning from overall impression.
- Rebuilding from `DESIGN.md` while ignoring concrete HTML/CSS.
- Replacing the source page with abstract marketing cards.
- Ignoring DOM, CSS, or assets because a simpler implementation is available.
- Creating an approximate page when exact DOM, CSS, and assets exist.

## Visual Fidelity Verification

Compare the generated Vue page against the original public page or `public/screens/*.png` when available.

Check:

- first fold composition
- backgrounds, masks, gradients, overlays, and decorative layers
- title, subtitle, button, and CTA positions
- section order and major visual hierarchy
- card, image, icon, badge, and button counts
- section heights, widths, gaps, margins, padding, and responsive spacing
- colors, fonts, font weights, radius, shadows, borders, opacity, z-index, and layering
- header visual style after navigation normalization

If exact visual verification cannot be run, perform a manual source-to-output checklist and report what was checked or skipped.

## Workflow

### Step 1: Identify the Outer Source Root

Confirm the working source root is already normalized:

```txt
<source-root>/
  public/
    DESIGN.md
    *.html
```

If this structure is missing but a raw `stitch*` directory exists, stop and tell the user to run `stitch-export-normalizer` first.

Derive:

```txt
source folder name = basename(<source-root>)
target Vue project = <source-root>/<source-folder-name>/
```

Example:

```txt
wer/wer/
```

### Step 2: Check for an Existing Same-Name Vue Project

If any of these exist, stop:

```txt
<source-root>/<source-folder-name>/
<source-root>/<source-folder-name>/package.json
<source-root>/<source-folder-name>/src/
```

Do not update an existing Vue project. Do not overwrite it. Do not continue conversion.

Final stopped message:

```md
This skill only supports source projects that have not generated the Vue system yet. A same-name Vue project already exists, so no files were changed.
```

### Step 3: Scan Outer `public/` Sources

Read:

- `public/DESIGN.md`
- `public/*.html`
- `public/*.md`

Build:

- page inventory
- design-token inventory
- navigation inventory
- section inventory
- source DOM inventory
- source CSS inventory
- asset inventory
- source visual hierarchy inventory
- issue inventory
- source-to-Vue mapping table

The source-to-Vue mapping table must be based on actual normalized file names, page titles, page content, navigation labels, and `DESIGN.md`. Do not fill it from a fixed page list.

### Step 4: Create the Same-Name Vue Project

Create a modern Vue 3 + Vite + pnpm project inside:

```txt
<source-root>/<source-folder-name>/
```

Do not create Vue project files in the outer source root.

### Step 5: Convert `DESIGN.md` to CSS System

Translate the design system into:

- CSS variables
- global styles
- base component styles
- layout styles
- component styles

Use `DESIGN.md` as supporting design-system input only. It must not override concrete CSS, layout, assets, or visual details found in the source HTML.

### Step 6: Analyze All HTML Pages

For every HTML page, inspect:

- body DOM structure
- title
- hero section
- section structure
- card count
- buttons
- navigation
- footer
- image assets
- icon assets
- background assets
- inline styles
- `<style>` tags
- linked CSS
- motion
- CSS
- obvious errors
- inconsistencies with other pages

### Step 7: Normalize Navigation

Generate the shared navigation component and route list. Normalize:

- labels
- routes
- fonts
- dimensions
- spacing
- position
- active state
- hover state
- mobile behavior
- logo
- CTA button

All pages must receive navigation through the shared layout. The final navigation items must come from actual normalized inputs or explicit user instructions, not hardcoded examples.

### Step 8: Convert HTML to Vue Views

Convert each HTML page into a real `.vue` page.

Requirements:

- Preserve the source body DOM structure as literally as possible.
- Preserve all major and minor sections unless explicitly broken.
- Preserve source copy except explicit user changes or obvious export mistakes.
- Preserve card, image, icon, button, badge, divider, and decorative-layer counts.
- Preserve source CSS, inline styles, style-tag rules, linked CSS effects, backgrounds, masks, gradients, overlays, z-index, positioning, spacing, radius, shadows, and responsive behavior.
- Preserve design hierarchy from the source HTML/CSS/assets.
- Correct obvious source errors.
- Remove export noise and redundant wrappers only when they do not affect visual output.
- Replace static HTML with Vue templates.
- Componentize repeated structures only when it does not change the visual result.
- When there is a conflict between maintainability and visual fidelity, visual fidelity wins.
- Do not put an entire HTML page into Vue unchanged.
- Do not use HTML injection.
- Do not use iframe.

### Step 9: Create Layout, Router, Styles, and Components

At minimum create:

- `src/App.vue`
- `src/main.ts`
- `src/router/index.ts`
- `src/layouts/DefaultLayout.vue`
- `src/components/AppHeader.vue`
- `src/components/AppFooter.vue`
- `src/styles/main.css`
- `src/styles/variables.css`
- `src/views/*.vue`

Create additional base or section components when they preserve clarity and fidelity.
Do not over-componentize page bodies if doing so changes DOM order, CSS applicability, layout, or visual fidelity.

### Step 10: Fix Asset Paths

Ensure the generated Vue project:

- loads images correctly
- loads icons correctly
- loads backgrounds correctly
- loads fonts correctly
- preserves copied CSS asset URLs
- does not reference missing HTML files
- does not keep broken paths
- does not keep local machine paths such as `E:\...`, `D:\...`, `C:\...`, or `file://...`
- can build without asset resolution errors

### Step 11: Verify

Inside the inner same-name Vue project, run:

```bash
pnpm install
pnpm build
```

If environment allows, also start or describe:

```bash
pnpm dev
```

Final instructions must tell the user to run `pnpm dev` inside the inner Vue project directory:

```bash
cd <source-root>/<source-folder-name>
pnpm dev
```

Do not tell them to run `pnpm dev` from the outer source root.

## Verification Checklist

Before reporting completion, confirm:

- Same-name project did not already exist before creation.
- Vue files were generated only inside `<source-root>/<source-folder-name>/`.
- No outer `public/*.html` or `public/*.md` files were moved, deleted, overwritten, or copied into the inner project.
- Every outer `public/*.html` page has a mapped `.vue` page or a clearly reported reason.
- Page names, route names, and navigation labels came from actual normalized inputs or explicit user instructions.
- No `.html` route was created.
- No iframe displays Stitch HTML.
- No whole-page `v-html` or raw HTML injection is used.
- Navigation is shared through one component.
- Active route state exists.
- `DESIGN.md` informed the CSS variables and style system.
- Asset references are valid or reported as missing.
- Source DOM, CSS, and asset inventories were used during conversion.
- Page body section/card/image/icon/button counts match the source unless explicitly reported.
- Source backgrounds, masks, gradients, overlays, and decorative layers were preserved unless explicitly reported.
- First fold composition and key spacing were compared against the source HTML or screenshots when available.
- `DESIGN.md` did not override concrete source HTML/CSS/assets.
- `pnpm install` and `pnpm build` were run or explicitly marked skipped with reasons.

## Final Report Format

After successful execution, report:

````md
## Implementation Summary

### Source Root
- ...

### Generated Vue Project
- ...

### Source Files Read
- ...

### Source Files Copied
- No HTML or MD source files were copied. Source files were used as input only.
- Static assets copied: ...

### Source Replica Fidelity
- Mode: high-fidelity / 1:1 source replica
- Navigation normalized only: yes / no
- Page body redesigned: no
- `DESIGN.md` used to override concrete HTML visuals: no

### Source DOM Preservation
- Body DOM inventory created: yes / no
- Section counts preserved: yes / no
- Card/image/icon/button counts preserved: yes / no
- Decorative layers preserved: yes / no

### Runtime Assets
- Asset inventory created: yes / no
- Assets copied to inner project: ...
- Asset paths rewritten: yes / no
- Missing assets: ...
- Remote assets: ...
- Local machine paths removed: yes / no

### Vue Pages Created
- ...

### Route Mapping
- ...

### Components Created
- ...

### Layout Created
- ...

### Navigation Normalization
- ...

### Visual Fidelity Check
- Compared against source HTML/screens: yes / no
- First fold checked: yes / no
- Backgrounds/masks/gradients/overlays checked: yes / no
- Counts checked: yes / no
- Spacing/colors/fonts/radius/shadows checked: yes / no
- Known fidelity gaps: ...

### Style System
- ...

### HTML Issues Fixed
- ...

### Assets
- ...

### Verification
- pnpm install: passed / failed / skipped
- pnpm build: passed / failed / skipped

### How to Run
```bash
cd <source-root>/<source-folder-name>
pnpm dev
```

### Remaining TODOs
- ...
````

If stopped because the same-name Vue project already exists, report:

```md
## Stopped

This skill only supports source projects that have not generated the Vue system yet.

A same-name Vue project already exists:

- ...

No files were changed.
```

If stopped because the project has only raw Stitch exports and no normalized `public/`, report:

```md
## Stopped

This skill requires a normalized Stitch input structure:

- public/DESIGN.md
- public/*.html

Raw Stitch export folders were found, but normalized public input was not found.

Run `stitch-export-normalizer` first, then run `stitch-to-vue-replica`.

No files were changed.
```

## Forbidden Actions

- Do not process projects that have already generated a Vue system.
- If the same-name Vue project exists, stop.
- Do not update an existing Vue project.
- Do not overwrite an existing Vue project.
- Do not iframe Stitch HTML.
- Do not link to Stitch HTML.
- Do not redirect to Stitch HTML.
- Do not use whole-page HTML injection.
- Do not keep `.html` as final pages.
- Do not create `/products.html`, `/code.html`, `/首页.html`, or similar routes.
- Do not copy `.html` or `.md` source files into the inner Vue project.
- Do not delete outer `public/` source files.
- Do not move outer `public/` source files.
- Do not overwrite outer `public/` source files.
- Do not create Vue project `package.json` in the outer source root unless the user explicitly asks.
- Do not copy each page's navigation into separate inconsistent versions.
- Do not ignore `DESIGN.md`.
- Do not use `DESIGN.md` to override concrete HTML visuals.
- Do not build only the home page when multiple HTML files exist.
- Do not mechanically copy obviously wrong navigation text, links, titles, or routes.
- Do not assume the normalized page names are `首页`, `产品中心`, `解决方案`, `项目案例`, `服务体系`, or `关于我们`.
- Do not assume the normalized page names are `Home`, `Products`, `Solutions`, `Cases`, `Services`, or `About`.
- Do not assume there are exactly 6 pages.
- Do not run directly on raw `stitch*` export folders; run `stitch-export-normalizer` first.
- Do not introduce unrelated UI frameworks.
- Do not use third-party component libraries to recreate Stitch visuals unless explicitly requested.
- Do not modify unrelated files.
- Do not break visual fidelity merely to make code shorter.
- Do not prioritize component abstraction over fidelity.
- Do not invent nonexistent asset files.
- Do not silently ignore missing assets.
- Do not redesign the page body.
- Do not replace images with CSS drawings.
- Do not replace icons with placeholders.
- Do not replace image/icon assets with emoji, CSS boxes, CSS icons, or placeholders.
- Do not replace source backgrounds with solid colors.
- Do not remove decorative layers, masks, gradients, overlays, or source `background-image` rules unless broken and explicitly reported.
- Do not change hero layout unless the change is limited to navigation normalization.
- Do not change card layout, count, or proportions.
- Do not simplify spacing in a way that changes the visual result.
- Do not create pages based only on text when exact DOM, CSS, and assets exist.
- Do not generate approximate pages when exact DOM, CSS, and assets exist.
