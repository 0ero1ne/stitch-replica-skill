---
name: stitch-to-vue-replica
description: Use when explicitly running the advanced Vue generation stage from normalized public/DESIGN.md and semantic public/*.html files.
---

# SKILL: Stitch HTML to Maintainable Vue Replica

## 1. Skill Meta

This is an advanced internal stage. Ordinary users should use `stitch-project-generator`.

This skill handles only already-normalized Stitch input:

```txt
public/DESIGN.md
public/*.html
```

It does not process raw `stitch*` export folders. It does not update existing Vue projects.

Core mission:

```txt
Preserve the source visual result, but implement it as clean, maintainable Vue code.
```

## 2. Invocation Boundary

Run only when all are true:

- The current directory is the source root.
- `public/DESIGN.md` exists.
- At least one `public/*.html` page exists.
- `public/*.html` filenames are semantic normalized page names.
- Filenames are not only raw names such as `code.html`, `_1.html`, `_2.html`, or `page1.html`.
- The same-name inner Vue project does not exist.
- No previous Vue generation has created `package.json` or `src/` in that inner path.

Derive the target path from the source root folder name:

```txt
<source-root>/<source-folder-name>/
```

Stop immediately when:

- The same-name inner Vue project already exists.
- `public/DESIGN.md` is missing.
- `public/*.html` is missing.
- The HTML files are still raw or unnamed export pages.
- Only raw `stitch*` folders exist.

If raw `stitch*` input is present, tell the caller to run normalization first. If the same-name Vue project exists, report that no files were changed.

## 3. Input Contract

The outer `public/` directory is source input only.

- Do not delete, move, rename, or overwrite outer `public/`.
- Do not copy `.html` or `.md` source files into the inner Vue project.
- Do not make source `.html` files runtime pages.
- Use `public/*.html` filenames and contents as page, route, and navigation evidence.
- Use `DESIGN.md` as supporting design-system evidence.
- Do not assume fixed page names.
- Do not assume a fixed page count.
- Do not assume a fixed home page unless the source proves it.

## 4. Output Contract

Create a new same-name inner project:

```txt
<source-root>/<source-folder-name>/
```

Use Vue 3, Vite, pnpm, vue-router, Pinia, TypeScript unless the user requests JavaScript, and ordinary CSS with CSS variables, global CSS, and scoped CSS.

Do not default to extra UI frameworks, component libraries, or CSS frameworks.

Generate maintainable project structure:

```txt
src/
  assets/
  components/
  layouts/
  router/
  stores/
  styles/
  views/
```

Standard commands:

```bash
pnpm dev
pnpm build
```

Do not create `package.json`, `src/`, `index.html`, or `vite.config.ts` in the outer source root.

## 5. Conversion Doctrine

High fidelity means matching the rendered page, not dumping messy exported HTML.

The source HTML is evidence. The final code must be Vue.

Do not use a local mechanical conversion script as the main conversion method.

Do not extract `body` and `style` blocks into generated Vue files.

Do not do regex-only conversion.

Do not create raw HTML dumps wrapped in `<template>`.

Analyze every page:

- HTML structure
- CSS rules
- inline styles
- linked styles
- assets
- section order
- visual hierarchy
- responsive behavior

Preserve copy, section order, hero structure, image and icon placement, background layers, card/list/badge/button/divider counts, decorative layers, masks, gradients, overlays, shadows, radius, spacing, and responsive behavior.

Rewrite as clean Vue SFCs.

Data-drive repeated cards when it improves maintainability.

Extract components only when they preserve the rendered result.

Fix obvious export mistakes only with concrete evidence.

Navigation may be normalized. Page bodies may not be redesigned.

`DESIGN.md` supports tokens and intent; it never overrides concrete HTML/CSS/assets.

## 6. Navigation Doctrine

Use one shared navigation system.

- Create `AppHeader.vue` or `SiteHeader.vue`.
- Use a shared layout for all pages.
- Use Vue Router for all internal navigation.
- Convert `.html` links to router links.
- Provide active route state.
- Preserve the source header's visual intent.
- Derive labels and order from real HTML navigation, normalized filenames, or explicit user instruction.
- Do not assume six pages.
- Do not copy inconsistent headers into every page.
- Do not turn navigation normalization into a new visual design.

## 7. Vue Engineering Doctrine

Every page is a real `.vue` SFC.

- Use clear `<template>` hierarchy.
- Use `<script setup lang="ts">` when script is needed.
- Use scoped CSS or clean shared global CSS.
- Merge duplicate classes and duplicate styles.
- Keep the more specific duplicate `alt` value when cleanup is required.
- Do not leave invalid Vue templates.
- Do not leave duplicate attributes.
- Do not leave local absolute paths.
- Do not leave garbled paths.
- Do not use `iframe`.
- Do not use whole-page `v-html`.
- Do not remove images or sections merely to fix compilation errors.
- Componentization serves maintainability, not abstraction theater.

## 8. Asset and CSS Doctrine

Inventory all runtime assets: `<img>`, `background-image`, SVG, favicon, fonts, video, CSS `url(...)`, and remote URLs.

Copy local runtime assets into usable inner-project locations.

Preserve and report remote image URLs when they remain remote.

Report missing assets.

Do not invent placeholders.

Do not replace icons with emoji.

Do not replace background images with solid colors.

Do not keep `E:\...`, `D:\...`, `C:\...`, or `file://...` paths.

Read source CSS from style tags, inline styles, linked CSS, imports, and media queries.

Preserve visual effect while organizing CSS into maintainable files and scoped styles.

Use `DESIGN.md` for tokens, not as a substitute for real HTML/CSS.

Hide browser scrollbars globally while preserving normal page scroll; never use `overflow:hidden` on `html` or `body` to hide scrolling.

## 9. Validation Doctrine

Run inside the generated inner project:

```bash
pnpm install
pnpm build
```

Success requires `pnpm build` to pass.

Before reporting success, verify:

- every normalized HTML page has a Vue view or reported reason
- routes exist for generated pages
- no `.html` routes remain
- no iframe displays source HTML
- no whole-page `v-html` exists
- assets resolve or are reported
- source `.html` and `.md` files were not copied into the inner project
- visual structure matches the source HTML or screenshots in major first-fold and section-level details

If verification fails, report the failure reason. Do not claim completion when build fails.

## 10. Absolute Prohibitions

- Do not process an existing same-name Vue project.
- Do not update an existing Vue project.
- Do not overwrite an existing Vue project.
- Do not run directly on raw `stitch*` exports.
- Do not create Vue project files in the outer source root.
- Do not copy source `.html` or `.md` files into the inner project.
- Do not keep `.html` as runtime pages.
- Do not create `.html` routes.
- Do not use `iframe`.
- Do not use whole-page `v-html`.
- Do not dump raw `<body>` into Vue.
- Do not use a mechanical conversion script as the conversion method.
- Do not rely on regex-only page conversion.
- Do not redesign page bodies.
- Do not use `DESIGN.md` to override real HTML visuals.
- Do not assume fixed page names or page counts.
- Do not introduce UI/CSS frameworks by default.
- Do not lose images, icons, backgrounds, or fonts.
- Do not replace assets with placeholders or emoji.
- Do not remove sections or images to fix errors.
- Do not hide scrolling with `overflow:hidden`.
- Do not report success when `pnpm build` fails.

## 11. Completion Report

Keep the final report short:

```md
## Implementation Summary

- Source root:
- Generated project:
- Pages converted:
- Routes:
- Components:
- Assets copied / remote / missing:
- Navigation:
- Visual fidelity notes:
- Verification:
  - pnpm install:
  - pnpm build:
- How to run:
```

For stopped runs:

```md
## Stopped

Reason:
- ...

No files were changed.
```
