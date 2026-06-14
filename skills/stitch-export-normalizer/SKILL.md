---
name: stitch-export-normalizer
description: Use when explicitly running the advanced normalization stage for raw Stitch export folders whose names start with stitch before Vue generation
---

# stitch-export-normalizer

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
raw stitch* export -> public/
```

It does not create Vue projects. After this stage, `stitch-to-vue-replica` can consume the normalized `public/` input.

## Overview

Use this skill to normalize raw Stitch export folders into the standard input expected by `stitch-to-vue-replica`.

The skill scans the project root for direct child directories whose names start with `stitch`, reads each raw export's `code.html`, `screen.png`, and `DESIGN.md` or `DESGIN.md`, then creates or updates:

```txt
<project-root>/
  public/
    DESIGN.md
    <page-name-from-real-navigation>.html
    <page-name-from-real-navigation>.html
```

This skill does not create Vue projects, Vue files, routes, components, `package.json`, `src/`, or Vite config. It only copies and standardizes Stitch source files for the next skill.

## Scope

Use the current working directory as `<project-root>`.

Raw Stitch export folder names are not fixed. Scan direct child directories case-insensitively for names that start with `stitch`, including:

- `stitch_xxx`
- `stitch-xxx`
- `stitchxxx`
- `Stitch_xxx`
- `STITCH_xxx`

Do not hardcode any example folder name. Do not treat user examples as fixed paths.

## Stop Conditions

Stop before changing files when:

- No direct child directory starts with `stitch`.
- More than one valid `stitch*` export folder is found.
- No design file is found in the selected export folder.
- Multiple candidate design files exist and a single source cannot be chosen safely.
- No recursive `code.html` files are found.
- `stitch-page-map.json` exists but is invalid.
- Multiple high-confidence pages map to the same page name.
- A target `public/*.html`, `public/DESIGN.md`, or `public/screens/*.png` already exists and cannot be confirmed safe to overwrite.

No Stitch export files may be modified during stop handling.

If no export folder is found, report:

```md
## Stopped

No Stitch export folder was found.

Expected a direct child directory of the project root whose name starts with "stitch".

No files were changed.
```

If multiple valid export folders are found, report:

```md
## Stopped

Multiple Stitch export folders were found and more than one appears valid.

Please keep only one Stitch export folder in the project root, or specify which one should be used.

Candidates:
- ...
- ...

No files were changed.
```

## Finding the Raw Export

For each direct `stitch*` candidate, recursively inspect whether it appears to be a Stitch export.

Evidence includes:

- one or more child page directories
- recursive `code.html` files
- same-directory `screen.png` files next to `code.html`
- recursive `DESIGN.md`, `DESGIN.md`, `design.md`, or `desgin.md`
- design-system folders or metadata
- multiple parseable pages

If exactly one candidate is valid, use it. If none are valid, stop and report no valid Stitch export structure.

## Finding Pages

Recursively find every file named exactly:

```txt
code.html
```

Each `code.html` parent directory is a candidate page directory. Page directory names may be `_1`, `_2`, `_3`, generated IDs, or any other name. Do not assume page directory names or page count.

If a sibling file exists:

```txt
screen.png
```

treat it as an optional visual reference for the same page.

## Finding the Design File

Recursively search the chosen Stitch export folder for:

```txt
DESIGN.md
DESGIN.md
design.md
desgin.md
```

`DESGIN.md` is a known misspelling. If it is the selected source, copy it to `public/DESIGN.md` but do not rename or modify the original file.

If multiple candidate design files exist, choose only when one is clearly the root-level or canonical design file. If ambiguous, stop and list all candidates.

## Page Name Detection

The page name must come from real HTML content. Do not write page names from examples into the rules or output.

Never use fixed default page lists such as:

- `首页`, `产品中心`, `解决方案`, `项目案例`, `服务体系`, `关于我们`
- `Home`, `Products`, `Product Center`, `Solutions`, `Cases`, `Projects`, `Services`, `About`, `About Us`

These are examples only. The source of truth is each `code.html`.

### Primary Signal: `header > div > nav > a`

For every `code.html`, prioritize navigation analysis:

1. Find `<header>`.
2. Inside it, inspect nested `<div>` and `<nav>` structures.
3. Extract all `<nav>` descendant `<a>` elements.
4. For each `<a>`, record text, `href`, `class`, `style`, `aria-current`, `data-*`, and visual state clues.
5. Determine which `<a>` represents the current page.

The current navigation item text becomes the page name.

### Active State Detection

Highest-confidence evidence includes:

- class contains `active`
- class contains `selected`
- class contains `current`
- `aria-current="page"`
- class or style indicates a highlighted color, background, border, underline, weight, opacity, or transform that differs from sibling links
- generated Stitch classes visibly mark one nav item as current
- `href` aligns with the page's current semantics

If a clear active/current/selected nav link exists, its text is the page name.

### Cross-Page Navigation Comparison

If no single page has an explicit active state, compare all pages together before falling back to title or headings:

1. Extract each page's header and nav links.
2. Compare nav link text sequences across all pages.
3. Compare each link's class, style, attributes, and visual-state markers across pages.
4. Find the link that differs on exactly one page or has a likely highlighted state.
5. Use that link text as the page name when evidence is strong enough.

Stitch exports often encode the current page only as a class, color, border, underline, or font-weight difference.

### Fallback Signals

Only after navigation cannot identify the page, inspect:

- `<title>`
- `<h1>`
- `<h2>`
- hero headline
- first-screen large text
- section headings
- CTA text
- page keywords
- image `alt`
- meta tags

Fallback signals must not override clear active navigation. If title or heading conflicts with active navigation, use the active nav item and report the conflict.

## Confidence Rules

Every page mapping must have confidence:

| Confidence | Criteria |
| --- | --- |
| `high` | Explicit active/current/selected nav item; cross-page nav difference clearly identifies current item; or nav item, title, and heading all agree. |
| `medium` | No explicit active state, but title, h1, hero, or content strongly matches a nav item. |
| `low` | Missing or incomplete nav; no active/current/selected evidence; title cannot map to nav; duplicate or test-like content; multiple pages look identical. |

Copy only high and medium confidence pages. Do not copy low-confidence pages into `public/`; list them under `Unmapped Pages`.

If one page name has multiple high-confidence candidates, stop instead of guessing.

## Optional `stitch-page-map.json`

`stitch-page-map.json` is only a fallback when automatic inference fails. It is not required by default.

If `<project-root>/stitch-page-map.json` exists, it may override automatic names because it represents explicit user intent.

Supported formats:

```json
{
  "relative/path/to/page-folder": "Actual Page Name",
  "_2": "Another Page Name"
}
```

Validate before use:

- each mapped directory exists
- each mapped directory contains `code.html`
- target page names are non-empty
- target page names are unique
- target page names can be converted to safe filenames

If validation fails, stop and report all mapping errors. Do not continue with a partially invalid map.

## Safe Filename Rules

Convert detected page names into filenames:

- Preserve Chinese, English letters, and digits.
- Trim leading and trailing whitespace.
- Collapse repeated whitespace.
- Remove or replace Windows-illegal characters: `<`, `>`, `:`, `"`, `/`, `\`, `|`, `?`, `*`.
- Do not generate if the cleaned name is empty.
- Detect duplicate filenames before copying.

Outputs:

```txt
public/<safe-page-name>.html
public/screens/<safe-page-name>.png
```

Do not generate generic names such as:

- `public/_1.html`
- `public/_2.html`
- `public/code.html`
- `public/page1.html`

## Public Directory Rules

If `<project-root>/public/` does not exist, create it.

If it exists:

- Do not delete it.
- Do not overwrite user-maintained files.
- Before writing `public/DESIGN.md`, `public/<page>.html`, or `public/screens/<page>.png`, check for existing files.
- Overwrite only when the file is clearly generated by this normalization process or the user explicitly allows it.
- If ownership is unclear, stop and report conflicts.

Do not create extra markdown report files by default. Report normalization results in the final assistant response instead of writing `stitch-normalization-report.md` or `public/normalization-report.md`.

## Copy Rules

Allowed:

- `code.html` -> `public/<real-page-name>.html`
- `screen.png` -> `public/screens/<real-page-name>.png`
- `DESIGN.md` -> `public/DESIGN.md`
- `DESGIN.md` -> `public/DESIGN.md`

Forbidden:

- low-confidence pages
- unmapped pages
- duplicate/conflicting pages
- entire raw Stitch export folders
- test files
- temporary files
- `.DS_Store`
- unrelated files

Do not modify:

- raw Stitch export folder
- original `code.html`
- original `screen.png`
- original `DESIGN.md`
- original `DESGIN.md`
- existing Vue projects
- unrelated business files

## HTML Processing Boundary

This skill reads HTML to infer page names. It does not repair or redesign HTML.

Do not:

- rewrite HTML content
- repair navigation CSS
- normalize HTML navigation markup
- convert HTML to Vue
- change routes
- delete sections
- redesign pages
- run `pnpm install`
- run `pnpm build`
- create `package.json`
- create `src/`
- create `vite.config.ts`

Those responsibilities belong to `stitch-to-vue-replica` after normalization.

## Workflow

1. Treat the current working directory as `<project-root>`.
2. Scan direct children for case-insensitive `stitch*` directories.
3. Validate candidate directories and select exactly one raw Stitch export.
4. Recursively find design files and choose one unambiguous source.
5. Recursively find all `code.html` files and sibling `screen.png` files.
6. If `stitch-page-map.json` exists, validate it and use it for mapped pages.
7. Otherwise, parse each `code.html` and extract navigation, active-state evidence, title, headings, and fallback signals.
8. Compare navigation across all pages before relying on title or h1 fallback.
9. Assign page names and confidence.
10. Detect duplicate names, low-confidence pages, and output conflicts.
11. Create `public/` and `public/screens/` only when safe.
12. Copy the selected design file to `public/DESIGN.md`.
13. Copy high and medium confidence pages to semantic HTML filenames.
14. Copy matching screenshots when present.
15. Prepare a normalization summary for the final assistant response.
16. Report the next step: use `stitch-to-vue-replica` on the generated `public/`.

## Report Requirements

Report normalization results in the final assistant response. Do not generate `stitch-normalization-report.md` or `public/normalization-report.md` by default.

The final response summary must include:

- project root
- selected Stitch export folder
- design file source
- output design file path
- whether `DESGIN.md` misspelling was normalized
- candidate `code.html` pages
- each page's nav `<a>` list
- detected current nav item
- detection method
- confidence
- evidence
- copied files
- skipped low-confidence pages
- conflicts
- files not modified
- next skill to run

After execution, output:

````md
## Stitch Export Normalization Summary

### Project Root
- ...

### Stitch Export Folder
- ...

### Design File
- Found: ...
- Output: public/DESIGN.md
- Note: ...

### Candidate HTML Pages
- ...

### Navigation Analysis
- source: ...
  navItems:
    - ...
    - ...
  detectedCurrentNavItem: ...
  method:
    - active class / aria-current / style difference / title fallback / h1 fallback
  confidence: high / medium / low

### Page Mapping
- source: ...
  output: public/<real-page-name>.html
  confidence: high / medium
  evidence:
    - current nav item from header > nav > a: ...
    - title: ...
    - h1: ...

### Screenshots
- source: ...
  output: public/screens/<real-page-name>.png

### Unmapped Pages
- ...

### Conflicts
- ...

### Files Created
- ...

### Files Not Modified
- Original Stitch export folder was not modified.
- Original code.html files were not modified.
- Original screen.png files were not modified.
- Original DESIGN.md / DESGIN.md was not modified.
- No Vue project was created.

### Next Step
Run the Vue generation Skill after normalization:

Use `stitch-to-vue-replica` on this normalized structure:

```txt
<project-root>/
  public/
    DESIGN.md
    <real-page-name>.html
    <real-page-name>.html
```
````

If recognized pages were copied but low-confidence pages were skipped, output:

```md
## Partial Normalization

Some pages could not be mapped with enough confidence.

Recognized pages were normalized.
Low-confidence pages were skipped.

Please review the report and optionally provide `stitch-page-map.json` only if needed.
```

## Forbidden Actions

- Do not hardcode any Stitch export folder name.
- Do not hardcode any page name.
- Do not treat example page names as fixed pages.
- Do not use `首页`, `产品中心`, `解决方案`, `项目案例`, `服务体系`, `关于我们` as a default page list.
- Do not use `Home`, `Products`, `Solutions`, `About`, or similar English examples as a default page list.
- Do not assume page directories are `_1`, `_2`, or `_3`.
- Do not assume there are exactly 6 pages.
- Do not require `stitch-page-map.json` by default.
- Do not create a Vue project.
- Do not run pnpm.
- Do not modify raw Stitch export files.
- Do not delete raw Stitch export files.
- Do not move raw Stitch export files.
- Do not overwrite existing `public/` files when ownership is unclear.
- Do not force-name low-confidence pages.
- Do not invent missing pages.
- Do not treat example paths as fixed paths.
- Do not encode a user example folder name into the rules.
- Do not generate `stitch-normalization-report.md` or `public/normalization-report.md` by default. Report normalization results in the final assistant response instead of writing extra report files.
