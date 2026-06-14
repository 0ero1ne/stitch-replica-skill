# stitch-replica-skill

Codex skills for turning Stitch downloads into a real Vue 3 + Vite + pnpm project.

This repository is designed as a bundled skills workflow. Install the whole `skills/` directory, then use the one-stop entry skill `stitch-project-generator`.

## Installation

### Recommended: Project-Level Manual Installation

Copy all skill directories under this repository's:

```txt
skills/
```

into your target project's:

```txt
<your-project>/.agents/skills/
```

Target structure:

```txt
my-project/
  .agents/
    skills/
      stitch-project-generator/
        SKILL.md
      stitch-export-normalizer/
        SKILL.md
      stitch-to-vue-replica/
        SKILL.md

  stitch_xxxxxxxxx/
    ...
```

Important:

- Copy all subdirectories under `skills/`.
- Do not copy only one skill.
- Do not create `.agents/skills/skills/...`.
- The correct path is `.agents/skills/stitch-project-generator/SKILL.md`.

Windows PowerShell:

```powershell
cd <your-project>
New-Item -ItemType Directory -Force .agents\skills
Copy-Item -Recurse <path-to-this-repo>\skills\* .agents\skills\
```

macOS / Linux:

```bash
cd <your-project>
mkdir -p .agents/skills
cp -R <path-to-this-repo>/skills/* .agents/skills/
```

### Optional: User-Level Global Installation

If you want the skills available in all projects, copy all skill directories to your user-level skills directory.

Windows:

```txt
%USERPROFILE%\.agents\skills\
```

macOS / Linux:

```txt
~/.agents/skills/
```

Expected structure:

```txt
~/.agents/skills/
  stitch-project-generator/
    SKILL.md
  stitch-export-normalizer/
    SKILL.md
  stitch-to-vue-replica/
    SKILL.md
```

After global installation, restart Codex or reopen Codex, then run:

```txt
/skills
```

to confirm the skills are recognized.

### Optional: Install with npx skills

`npx skills` is a community/third-party Skills CLI. It requires Node.js and npm, and is useful for users who prefer command-line installation.

This repository is meant to be installed as a whole skill set, not as a single skill. Do not use single-skill installation as the primary setup path.

Examples:

```bash
npx skills@latest add https://github.com/<your-github-username>/<your-repo-name>
```

or:

```bash
npx skills@latest add <your-github-username>/<your-repo-name>
```

If the CLI asks which skills to install, choose all skills in this repository.

If the `npx skills` command does not install all skills as expected, use the manual project-level installation above.

## Recommended Usage

After installing the whole `skills/` set, ordinary users only need to invoke the one-stop entry skill:

```txt
stitch-project-generator
```

Put the Stitch download folder in the project root, then open Codex from that project root and say:

```txt
$stitch-project-generator 根据当前目录中的 Stitch 下载文件夹生成对应的 Vue3 项目。
```

or:

```txt
根据 skills 内容，把我下载的 Stitch 文件夹生成对应的 Vue3 项目。
```

Using `$stitch-project-generator` explicitly is recommended. If Codex can match the request automatically, the `$` prefix is optional.

You do not need to manually call the two internal skills. Internally, the generator automatically runs:

```txt
raw stitch* folder
  -> normalize to public/
  -> generate same-name Vue3 project
```

If the same-name Vue project already exists, the generator stops and does not overwrite it.

## Expected Input

Your project may initially look like this:

```txt
my-project/
  stitch_xxxxxxxxx/
    ...
```

Notes:

- `stitch_xxxxxxxxx` is only an example.
- The real Stitch download folder name is not fixed.
- It only needs to be a direct child directory of the project root whose name starts with `stitch`.
- The skills do not hardcode any folder name.
- The generator scans the project root automatically.

## Generated Output

After generation, the project will look like this:

```txt
my-project/
  public/
    DESIGN.md
    <real-page-name>.html
    <real-page-name>.html
    screens/
      <real-page-name>.png

  my-project/
    package.json
    index.html
    vite.config.ts
    src/
      main.ts
      App.vue
      router/
      views/
      components/
      layouts/
      styles/
```

The outer `public/` directory is the normalized Stitch input. The inner same-name directory is the generated Vue 3 project.

Run the site from the inner Vue project directory.

## Run the Generated Vue Project

```bash
cd <project-root>/<project-folder-name>
pnpm install
pnpm dev
```

Windows example:

```bash
cd E:\work\wer\wer
pnpm install
pnpm dev
```

Do not run `pnpm dev` from the outer project root. Enter the inner same-name Vue project directory first.

## Advanced Two-Step Workflow

This section is for maintainers or debugging. Ordinary users should use `stitch-project-generator`.

### 1. Normalize Raw Stitch Exports

Internal stage:

```txt
stitch-export-normalizer
```

Input:

```txt
<project-root>/
  stitch_xxxxxxxxx/
    ...
```

Output:

```txt
<project-root>/
  public/
    DESIGN.md
    <real-page-name>.html
    <real-page-name>.html
    ...
```

### 2. Generate the Vue Project

Internal stage:

```txt
stitch-to-vue-replica
```

Input:

```txt
<project-root>/
  public/
    DESIGN.md
    *.html
```

Output:

```txt
<project-root>/<project-folder-name>/
```

These two skills are internal stages, not the normal user entry point.

## Maintainer Helper Script

This repository includes `skill.sh` for maintainers.

```bash
./skill.sh list
./skill.sh path stitch-project-generator
./skill.sh install-local
```

The script installs the whole skill set. It does not install a single skill.

Windows users should prefer the PowerShell copy commands in the Installation section.

## Troubleshooting

### Codex cannot find the skill

Check that this file exists in your project:

```txt
.agents/skills/stitch-project-generator/SKILL.md
```

Then run:

```txt
/skills
```

to confirm Codex recognizes the installed skills.

### The Stitch folder is not found

Make sure the Stitch download folder is a direct child of the project root and its name starts with `stitch`.

Example:

```txt
my-project/
  stitch_xxxxxxxxx/
    ...
```

The exact folder name is not fixed.

### Page names are wrong

The normalizer prioritizes page names from each `code.html` navigation structure:

```txt
header > div > nav > a
```

If page names are not detected correctly, review the normalization report. As a fallback, provide `stitch-page-map.json` with explicit page names.

### Vue project already exists

If the inner same-name Vue project already exists, generation stops and no files are overwritten. Move, rename, or remove the existing generated Vue project only if you intentionally want to generate a fresh one.
