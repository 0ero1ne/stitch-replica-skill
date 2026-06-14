---
name: stitch-to-vue-replica
description: Convert Stitch-generated HTML and DESIGN.md into faithful Vue project pages instead of standalone HTML, iframe, link-based, or raw HTML implementations.
---

---

# stitch-to-vue-replica

## Purpose

Use this skill when converting Stitch-generated `.html` files and `DESIGN.md` into real Vue project pages.

The goal is faithful visual replication and Vue project integration, not redesign.

This skill is designed for Vue projects, especially Vue 3 / Vite projects. If the project uses Tailwind, keep using Tailwind. If the project uses another styling system, follow the existing styling system.

## Expected Inputs

The project may contain:

- `DESIGN.md`
- Stitch-generated `.html` files
- `code.html`
- existing Vue project files
- existing router files
- existing pages/views/components
- existing layout, navigation, and style files

If Stitch exports a file named `code.html`, treat it only as an input source file. Do not keep `code.html` as the final page name, route name, or runtime file.

## Core Rules

- Stitch HTML is the visual source file.
- `DESIGN.md` is the design specification file.
- Final implementation must be Vue files, usually `.vue` single-file components.
- Do not link to the Stitch HTML.
- Do not iframe the Stitch HTML.
- Do not redirect to the Stitch HTML.
- Do not keep standalone `.html` pages as the final implementation.
- Do not use `code.html` as a final route or page.
- Do not create routes such as `code.html`, `products.html`, or other static HTML routes unless the existing project explicitly uses that routing style.
- Do not use `v-html` or raw HTML injection to dump the Stitch page into Vue.
- Do not replace the page with an external link.
- Do not simplify, omit, or invent sections.
- Do not redesign unless required for technical integration.
- Preserve the original section order, text content, visual hierarchy, images, cards, buttons, navigation, colors, spacing, and layout as much as possible.
- Reuse existing Vue components, router, layout, navigation, and style system when available.
- Do not remove Tailwind if the project already uses Tailwind.
- Do not introduce unnecessary dependencies.
- Do not modify unrelated features.

## Workflow

### Step 1: Scan the Vue Project

Before editing code, inspect:

- `package.json`
- `vite.config.*` if present
- Vue entry files, such as `src/main.js` or `src/main.ts`
- router files, such as `src/router/index.js` or `src/router/index.ts`
- existing pages or views, such as `src/views/` or `src/pages/`
- shared components, such as `src/components/`
- shared layout files
- navigation/header/footer components
- style files and Tailwind configuration if present
- `DESIGN.md`
- Stitch-generated HTML files

Identify:

- Vue version
- route structure
- page directory
- component structure
- styling method
- asset folder
- source HTML files
- target Vue files

Do not edit code until the source-to-target mapping is clear.

### Step 2: Extract the Stitch Page Structure

For each Stitch HTML file, extract:

- page title
- navigation items
- all major sections
- headings
- paragraphs
- buttons
- cards
- images
- icons
- backgrounds
- colors
- typography
- spacing
- section order
- responsive layout clues
- footer content

Build a source section inventory before converting.

The section inventory should include each source section and its intended Vue target section.

### Step 3: Map HTML Files to Vue Pages

Map each Stitch HTML file to a final Vue page.

Examples:

- `home.html` → `src/views/Home.vue`
- `about.html` → `src/views/About.vue`
- `product.html` → `src/views/ProductCenter.vue`
- `solution.html` → `src/views/Solution.vue`
- `code.html` → infer the target page from `DESIGN.md` or the user request

Never use `code.html` as the final page or route name.

If the user gives a target page name, follow the user instruction.

If no target page is specified, infer from `DESIGN.md`, the HTML title, route structure, or project navigation.

### Step 4: Convert HTML into Vue

Convert the Stitch HTML into Vue single-file components.

Rules:

- Use `<template>`, `<script setup>` if needed, and `<style>` only when appropriate.
- Preserve the original section order.
- Preserve all visible text unless the user asks to rewrite it.
- Preserve the number and order of major cards, buttons, blocks, and content groups.
- Preserve visual hierarchy and spacing as faithfully as possible.
- Use the project’s existing styling method.
- If Tailwind is already used, use Tailwind classes.
- If plain CSS or SCSS is used, follow the existing pattern.
- Reuse existing Header, Nav, Footer, Button, Card, or Layout components when available.
- Use Vue arrays and `v-for` only when it keeps the original content and layout intact.
- Do not dump the entire source HTML into Vue as raw HTML.
- Do not create unrelated new components unless reuse is clearly beneficial.
- Do not rewrite the whole project.

### Step 5: Handle Assets

For images, icons, fonts, and other assets:

- Check whether the assets already exist in the project.
- If assets are referenced by the Stitch HTML, map them to the correct Vue project asset path.
- Use `public/` or `src/assets/` according to the project convention.
- Do not leave broken image references.
- Do not replace missing assets with unrelated stock images unless the user explicitly allows it.
- If an asset is missing, keep a clear TODO and report it.

### Step 6: Integrate with Vue Router and Navigation

Integrate the Vue page into the existing Vue project:

- update router files if needed
- update navigation links if needed
- reuse existing shared navigation/header/footer components
- keep route names consistent with the project
- do not create static `.html` routes
- do not add duplicate navigation systems

If the project already has a navigation bar, preserve and reuse it unless the user specifically asks to replace it.

### Step 7: Verify the Replication

After implementation, check:

- no final `code.html` page remains
- no standalone Stitch HTML route is created
- no iframe/link/redirect is used to display Stitch HTML
- no `v-html` shortcut is used to dump the page
- every source section exists in the Vue page
- main text content is preserved
- card and block counts are preserved
- buttons and navigation are preserved
- images and assets are not broken
- layout and visual hierarchy match the Stitch source as closely as possible
- the existing styling system is preserved
- the project can run or build using its existing commands

Use the project’s package manager and scripts. If the project uses `pnpm`, prefer `pnpm dev` or `pnpm build`. If it uses npm or yarn, follow the existing scripts.

### Step 8: Final Report

At the end, report:

- source Stitch HTML files used
- target Vue files created or changed
- router files changed
- navigation files changed
- assets added or missing
- sections converted
- any intentional deviations from the Stitch source
- verification result
- remaining TODOs
