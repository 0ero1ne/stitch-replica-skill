---
name: stitch-export-normalizer
description: Normalize a raw stitch* export folder into public/DESIGN.md and semantic public/*.html files for later Vue generation.
---

# SKILL: Stitch Export Normalizer

## 1. Role

This is an internal / advanced stage. Ordinary users should use `stitch-project-generator`.
This skill only normalizes raw Stitch exports:

```txt
raw stitch* export -> public/
```

It does not create a Vue project. It prepares input for `stitch-to-vue-replica`.

## 2. Input Boundary

Treat the current working directory as `<project-root>`.
Scan only direct child directories whose names start with `stitch`, case-insensitively.
Do not hardcode a concrete Stitch folder name.
Stop if no valid raw Stitch export is found.
Stop if multiple valid raw Stitch exports are found; require the user to specify one.

Inside the chosen export, recursively find:

- `code.html`
- sibling `screen.png`
- `DESIGN.md`
- `DESGIN.md`
- case variants of the design filename

Do not scan unrelated project trees as Stitch sources.
Do not require `stitch-page-map.json` by default.

## 3. Detection Rules

Each `code.html` parent directory is one candidate page directory.
A same-directory `screen.png` is the optional screenshot for that page.
`DESGIN.md` is a known misspelling. Copy it as `public/DESIGN.md`; do not rename or edit the original file.

Stop when:

- no `code.html` files exist
- no design file exists
- multiple design files exist without a unique canonical source
- `stitch-page-map.json` exists but is invalid
- multiple high-confidence pages produce the same final page name
- an existing `public/` file's ownership is unclear

If `stitch-page-map.json` exists, treat it as explicit fallback intent and validate it before use. Do not partially apply it.

## 4. Page Naming Doctrine

Page names must come from real HTML evidence.
Do not use preset page lists.
Do not assume page names.
Do not assume page count.

Primary signal:

```txt
header > div > nav > a
```

For each page, inspect nav link text, `href`, `class`, `style`, `aria-current`, `data-*`, and visual-state clues.
Use active/current/selected evidence to identify the current page.
Style differences count when they mark one link as current: color, background, border, underline, font weight, opacity, transform, or generated Stitch class changes.
If one page is unclear, compare navigation across all pages before using title or heading fallback.

Fallback only after navigation fails:

- `<title>`
- `<h1>`
- hero headline
- first major section heading
- strong content keywords
- image `alt`
- meta tags

Clear active navigation beats title, h1, and hero text.
Use `stitch-page-map.json` only when automatic inference is insufficient or the user provided it intentionally.
Copy only high or medium confidence pages.
Skip low-confidence pages and report them.
Never generate generic output names such as `_1.html`, `_2.html`, `page1.html`, or `code.html`.

## 5. Output Contract

Create only the standard normalized input:

```txt
public/DESIGN.md
public/<real-page-name>.html
public/screens/<real-page-name>.png
```

Use safe filenames derived from detected page names.
Preserve Chinese, English letters, and digits.
Trim whitespace and collapse repeated spaces.
Remove Windows-illegal filename characters: `<`, `>`, `:`, `"`, `/`, `\`, `|`, `?`, `*`.
Do not write an output file if the safe filename is empty.
Do not overwrite existing `public/` files unless they are clearly from this normalization flow or the user explicitly allows it.
Do not generate extra markdown report files, including `stitch-normalization-report.md` or `public/normalization-report.md`.
Report results only in the final assistant response.

## 6. Safety Rules

- Do not modify raw Stitch folders.
- Do not delete raw Stitch folders.
- Do not move raw Stitch folders.
- Do not modify original `code.html`.
- Do not modify original `screen.png`.
- Do not modify original `DESIGN.md` or `DESGIN.md`.
- Do not create a Vue project.
- Do not run pnpm.
- Do not create `package.json`.
- Do not create `src/`.
- Do not repair or rewrite HTML content.
- Do not force-name low-confidence pages.
- Do not invent missing pages.
- Do not overwrite public files with unclear ownership.

## 7. Completion Report

On success, keep the report short:

```md
## Stitch Export Normalization Summary

- Project root:
- Stitch export folder:
- Design file:
- Pages normalized:
- Screenshots copied:
- Skipped / unmapped pages:
- Conflicts:
- Files created:
- Files not modified:
- Next step:
```

When stopped:

```md
## Stopped

Reason:
- ...

No files were changed.
```
