---
name: stitch-project-generator
description: Use when a user wants to generate a new Vue3 project from Stitch downloads or normalized Stitch public files without manually choosing normalization and Vue generation stages.
---

# SKILL: Stitch Project Generator

## 1. Role

This is the ordinary user's one-stop entry point.
The user does not need to know the internal skill chain.
This skill detects the current project state and runs the correct path:

```txt
raw stitch* folder -> public/ -> same-name Vue3 project
```

It orchestrates `stitch-export-normalizer` and `stitch-to-vue-replica`.
It controls safety and sequencing. It does not redefine every internal conversion rule.

## 2. User Intent

Use this skill for requests like:

```txt
根据 skills 内容，把我下载的 Stitch 文件夹生成 Vue3 项目。
```

```txt
请把当前目录里的 Stitch 下载文件夹转换成 Vue3 项目。
```

```txt
根据 Stitch 生成的页面和设计文件帮我生成 Vue 系统。
```

Do not ask ordinary users to manually choose `stitch-export-normalizer` or `stitch-to-vue-replica`.
Detect the input mode and proceed unless a stop condition applies.

## 3. Detection Order

Use the current working directory as `<project-root>`.

Derive:

```txt
<project-folder-name> = basename(<project-root>)
<target-vue-project> = <project-root>/<project-folder-name>/
```

Stop if the target Vue project already exists.
Existing means `<target-vue-project>/package.json`, `<target-vue-project>/src/`, or a target directory that is clearly an existing generated Vue project.
If no target exists, detect normalized input:

```txt
public/DESIGN.md
public/*.html
```

When normalized input exists, skip normalization and run Vue generation.
When normalized input is missing, scan direct child directories whose names start with `stitch`, case-insensitively.
Do not hardcode a concrete Stitch folder name.
If a raw `stitch*` export is found, normalize first, then generate Vue.
If neither normalized public input nor raw `stitch*` export exists, stop.

## 4. Phase Delegation

When raw Stitch export is detected, run the normalization phase according to `stitch-export-normalizer`.
When normalized public input is ready, run Vue generation according to `stitch-to-vue-replica`.
The normalizer owns raw `stitch*` scanning, `DESIGN.md` standardization, `code.html` discovery, page naming, and creation of `public/DESIGN.md` plus semantic `public/*.html`.
The Vue replica stage owns high-fidelity maintainable Vue conversion, Vue SFC generation, unified Vue Router navigation, asset and CSS preservation, and build verification.
This skill owns input-mode detection, stop conditions, phase ordering, and final summary.
Do not duplicate all internal rules here.
Vue generation must remain high-fidelity and maintainable.
Do not use a mechanical conversion script.
Do not dump raw HTML into Vue.
Navigation may be unified. Page bodies must not be redesigned.

## 5. Output Contract

Successful output shape:

```txt
<project-root>/
  public/
    DESIGN.md
    *.html

  <project-folder-name>/
    package.json
    src/
```

Generated stack: Vue 3, Vite, pnpm, vue-router, Pinia, TypeScript unless the user requests JavaScript, and ordinary CSS with CSS variables, global CSS, and scoped CSS.
Do not default to UI frameworks, component libraries, or CSS frameworks.
Do not create Vue project files in the outer root.
Run from the inner project:

```bash
cd <project-root>/<project-folder-name>
pnpm dev
```

## 6. Safety Rules

- Do not overwrite an existing same-name Vue project.
- Do not update an existing same-name Vue project.
- Do not create `package.json` in the outer root.
- Do not modify, delete, or move raw Stitch source files.
- Do not delete, move, or overwrite outer `public/` source files.
- Do not require ordinary users to manually run internal skills.
- Do not hardcode Stitch folder names.
- Do not hardcode page names.
- Do not assume a fixed page count.
- Do not require `stitch-page-map.json` by default.
- Do not create `.html` routes.
- Do not use `iframe`.
- Do not use whole-page `v-html`.
- Do not copy source `.html` or `.md` files into the Vue project.
- Do not install extra UI/CSS frameworks unless explicitly requested.
- Do not report success when `pnpm build` fails.

## 7. Completion Report

On success, keep the report short:

```md
## Stitch Project Generation Summary

- Project root:
- Input mode:
- Normalization:
- Generated Vue project:
- Pages:
- Navigation:
- Verification:
  - pnpm install:
  - pnpm build:
- How to run:
```

When stopped:

```md
## Stopped

Reason:
- ...

No files were changed.
```
