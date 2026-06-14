---
name: stitch-project-generator
description: Use when a user wants to generate a new Vue3 project from Stitch downloads or normalized Stitch public files without manually choosing normalization and Vue generation stages
---

# stitch-project-generator

## Overview

Use this skill as the ordinary user's one-stop entry point for generating a new Vue 3 + Vite + pnpm project from Stitch sources.

The user does not need to know or manually run the internal stages. This skill automatically detects the current project state and runs the correct flow:

```txt
raw stitch* folder
  -> normalize to public/
  -> generate same-name Vue3 project
```

Internally, it covers:

```txt
Phase 1: Stitch Export Normalization
Phase 2: Vue Project Generation
```

## User Requests This Skill Must Handle

Use this skill for simple natural-language requests such as:

```txt
根据 skills 内容，把我下载的 Stitch 文件夹生成对应的 Vue 文件。
```

```txt
请把当前目录里的 Stitch 下载文件夹转换成 Vue3 项目。
```

```txt
根据 Stitch 生成的页面和设计文件帮我生成 Vue 系统。
```

Do not ask ordinary users to choose `stitch-export-normalizer` or `stitch-to-vue-replica`. Automatically decide the required phases and proceed unless a stop condition requires user action.

## Project Detection Order

Use the current working directory as `<project-root>`.

### Step 1: Stop if the Same-Name Vue Project Exists

Derive:

```txt
project folder name = basename(<project-root>)
target Vue project = <project-root>/<project-folder-name>/
```

If either exists:

```txt
<project-root>/<project-folder-name>/package.json
<project-root>/<project-folder-name>/src/
```

stop immediately. Do not overwrite, update, patch, or continue generation.

Report:

```md
## Stopped

A same-name Vue project already exists:

- <path>

This generator only creates a new Vue project from Stitch sources. No files were changed.
```

### Step 2: Detect Normalized Public Input

If no same-name Vue project exists, check for:

```txt
public/DESIGN.md
public/*.html
```

If present, input mode is `Normalized public input`. Skip Phase 1 and go directly to Phase 2.

Do not rescan raw `stitch*` folders when normalized `public/` input already exists unless the user explicitly requests re-normalization.

### Step 3: Detect Raw Stitch Export Input

If normalized `public/` input is missing, scan direct child directories of `<project-root>` for names starting with `stitch`, case-insensitively.

Support:

- `stitch_xxx`
- `stitch-xxx`
- `stitchxxx`
- `Stitch_xxx`
- `STITCH_xxx`

Do not hardcode any concrete Stitch folder name. Do not treat user examples as fixed paths.

If a valid raw Stitch export exists, run Phase 1, verify `public/DESIGN.md` and `public/*.html`, then automatically run Phase 2.

### Step 4: Stop if No Valid Input Exists

If neither normalized `public/` input nor a valid raw `stitch*` export exists, report:

```md
## Stopped

No valid Stitch input was found.

Expected one of the following:

1. A normalized public input:
   - public/DESIGN.md
   - public/*.html

2. A raw Stitch export folder:
   - a direct child directory whose name starts with "stitch"

No files were changed.
```

## Phase 1: Stitch Export Normalization

Run this phase only when normalized `public/` input is missing and a valid raw `stitch*` export exists.

This phase follows the same responsibility as `stitch-export-normalizer`:

```txt
raw stitch* export -> public/
```

Required actions:

1. Scan the raw `stitch*` export directory.
2. Recursively find all `code.html`.
3. Recursively find `DESIGN.md` or `DESGIN.md`.
4. Read every `code.html`.
5. Determine each page name from real HTML navigation and page content.
6. Create the standard `public/` input structure.

Output:

```txt
<project-root>/
  public/
    DESIGN.md
    <real-page-name>.html
    <real-page-name>.html
```

Optional screenshots:

```txt
<project-root>/
  public/
    screens/
      <real-page-name>.png
      <real-page-name>.png
```

### Page Name Detection

Page names must be detected dynamically from each `code.html`. Never use fixed page lists.

Do not treat these as fixed pages:

- `首页`
- `产品中心`
- `解决方案`
- `项目案例`
- `服务体系`
- `关于我们`
- `Home`
- `Products`
- `Product Center`
- `Solutions`
- `Cases`
- `Projects`
- `Services`
- `About`
- `About Us`

Prioritize:

```txt
header > div > nav > a
```

For each page, inspect:

- `<header>`
- nested `<div>`
- nested `<nav>`
- every nav `<a>` text
- `href`
- `class`
- `style`
- `aria-current`
- `data-*`
- active/current/selected state
- style differences between the current nav item and sibling items

If one nav `<a>` clearly represents the current page, use that text as the real page name:

```txt
public/<real-page-name>.html
```

If direct active-state detection fails, compare all pages' navigation structures before using fallback signals such as `<title>`, `<h1>`, hero title, section headings, keywords, or image alt text.

### Low-Confidence Pages

If a page name cannot be determined:

- Do not force a name.
- Do not generate `_1.html`, `page1.html`, or `code.html`.
- Do not fill with example page names.
- List the page under `Unmapped Pages`.
- Skip low-confidence pages.
- If all pages are low confidence, stop and do not enter Phase 2.

### Phase 1 Boundaries

Do not:

- modify raw Stitch folders
- delete raw Stitch folders
- move raw Stitch folders
- modify original `code.html`
- modify original `screen.png`
- modify original `DESIGN.md` or `DESGIN.md`
- create a Vue project
- run pnpm
- deeply repair HTML
- unify HTML navigation CSS
- convert Vue components

Phase 1 only creates the standard `public/` input.

## Phase 2: Vue Project Generation

Run this phase when all conditions are true:

- same-name Vue project does not exist
- `public/DESIGN.md` exists
- `public/*.html` contains at least one normalized page

This phase follows the same responsibility as `stitch-to-vue-replica`:

```txt
public/ -> same-name Vue3 project
```

Create:

```txt
<project-root>/<project-folder-name>/
```

Default stack:

- Vue 3
- Vite
- pnpm
- vue-router
- Pinia
- TypeScript unless the user explicitly requests JavaScript
- ordinary CSS, CSS variables, global CSS, and scoped CSS

Do not mention, install, or introduce extra UI frameworks or CSS frameworks unless the user explicitly requests them.

### Vue Project Structure

Recommended structure:

```txt
<project-root>/<project-folder-name>/
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
      *.vue
```

### Dynamic Page Generation

Read:

```txt
public/DESIGN.md
public/*.html
```

Generate Vue views and routes from actual normalized page names and HTML content.

Rules:

- Use `.html` filenames as important page-name evidence.
- Use HTML navigation as page and route evidence.
- Use `DESIGN.md` as the design-system source.
- Convert real page names into safe Vue file names, route names, component names, and route paths.
- Keep navigation labels as the real page names from the HTML.
- Chinese page names may map to readable Chinese routes or safe semantic slugs, but display labels must remain the real page names.
- Report every `public/<page>.html -> src/views/<ViewName>.vue -> /<route>` mapping.

Do not assume fixed page names, fixed routes, or exactly six pages.

### Unified Navigation

Extract navigation from all `public/*.html` files and build one shared navigation component, such as `AppHeader.vue` or `SiteHeader.vue`.

Requirements:

- Do not copy each HTML page's header separately.
- Use one shared header for all pages.
- Navigation labels come from real HTML navigation items.
- Navigation order comes from real HTML navigation structure.
- Do not substitute example navigation labels.
- Do not link to `.html`.
- Use Vue Router.
- Active state must reflect the current route.
- Keep header style, font, spacing, height, and position consistent.
- If source navigation differs across pages, use the most complete and stable structure shared by most pages, then report the decision.

### HTML to Vue Conversion

Convert each normalized HTML file into a real `.vue` page.

Forbidden:

- iframe
- whole-page `v-html`
- redirecting to `.html`
- `.html` routes
- copying source HTML into the Vue project as runtime pages
- generating only one page when multiple pages exist
- mechanically preserving obviously wrong navigation links
- unrelated UI frameworks
- sacrificing visual fidelity for shorter code

Required:

- preserve Stitch visual structure
- preserve major sections
- preserve main copy
- preserve card counts and visual hierarchy
- read and apply `DESIGN.md`
- create CSS variables and global styles
- unify header/navigation
- convert `.html` links to Vue Router routes
- correct obvious navigation, button-link, and asset-path errors
- handle images, SVGs, favicon, fonts, and other static assets
- run `pnpm install` and `pnpm build` when possible

## Complete Workflow

Follow this sequence:

1. Identify project root.
2. Stop if the same-name Vue project already exists.
3. Check normalized `public/` input.
4. If no public input exists, detect a raw `stitch*` export folder.
5. If raw `stitch*` exists, normalize it into `public/`.
6. Verify `public/DESIGN.md` and `public/*.html` exist.
7. Generate the same-name Vue3 project.
8. Convert HTML pages to Vue views.
9. Create router, layout, components, and styles.
10. Normalize navigation.
11. Fix asset paths.
12. Run `pnpm install` and `pnpm build` when possible.
13. Output the final report.

## Final Report

On success, output:

````md
## Stitch Project Generation Summary

### Project Root
- ...

### Input Mode Detected
- Raw Stitch export / Normalized public input

### Raw Stitch Export
- Folder: ...
- Used: yes / no

### Normalization
- Status: completed / skipped
- Design file: ...
- Public files created:
  - public/DESIGN.md
  - public/<real-page-name>.html
  - ...

### Page Name Detection
- source: ...
  detectedPageName: ...
  confidence: high / medium / low
  evidence:
    - current nav item from header > nav > a: ...
    - title: ...
    - h1: ...

### Generated Vue Project
- Path: ...

### Vue Pages Created
- public/<real-page-name>.html -> src/views/<ViewName>.vue -> /<route>

### Navigation
- Unified nav component: ...
- Nav items:
  - label: ...
    route: ...

### Components Created
- ...

### Style System
- DESIGN.md used: yes
- CSS files: ...

### Assets
- ...

### Verification
- pnpm install: passed / failed / skipped
- pnpm build: passed / failed / skipped

### How to Run
```bash
cd <project-root>/<project-folder-name>
pnpm dev
```

### Remaining TODOs
- ...
````

If stopped, output:

```md
## Stopped

Reason:
- ...

No files were changed.
```

## Forbidden Actions

- Do not require ordinary users to know the internal skill chain.
- Do not require ordinary users to manually run the normalizer before the Vue replica skill.
- Do not hardcode any Stitch folder name.
- Do not hardcode any page name.
- Do not treat user example page names as fixed pages.
- Do not require `stitch-page-map.json` by default.
- Do not overwrite an existing same-name Vue project.
- Do not create Vue project `package.json` in the outer project root.
- Do not modify raw Stitch export files.
- Do not delete raw Stitch export files.
- Do not move raw Stitch export files.
- Do not iframe HTML.
- Do not use `v-html` for whole-page HTML injection.
- Do not create `.html` routes.
- Do not copy `.html` or `.md` source files into the Vue project.
- Do not process only one page when multiple pages exist.
- Do not ignore `DESIGN.md`.
- Do not install extra style frameworks or UI frameworks unless explicitly requested.
- Do not invent missing pages.
- Do not force-name low-confidence pages.
