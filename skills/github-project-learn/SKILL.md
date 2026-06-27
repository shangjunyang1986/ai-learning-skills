---
name: github-project-learn
description: >-
  Turn a GitHub project or organization into an offline, visual learning website —
  a single self-contained HTML page with a left-hand table of contents, right-hand
  content, and the project's own images / diagrams / video covers downloaded locally.
  Use this whenever the user wants to LEARN, STUDY, UNDERSTAND, or "get into" a GitHub
  repo or org and finds reading the raw README slow or dry — e.g. "帮我学习这个 github 项目",
  "把这个 repo 做成学习网页/教程", "我想搞懂 github.com/x/y", "这个项目很好我想研究它",
  "give me a study page / learning guide for this repository", "下载这个项目并讲解怎么用".
  Triggers on a GitHub URL plus any intent to learn/onboard/evaluate it, even if the
  user doesn't say the words "website" or "HTML". Handles both single repos and whole
  organizations (multiple repos). Not for: fixing bugs in a repo, generic web design
  unrelated to a GitHub project, or pure API/CLI work.
---

# github-project-learn

Turn a GitHub project or organization into a **single, offline-openable learning page**:
left = table of contents, right = study content, with the project's official media
(images, architecture diagrams, video covers) downloaded into a local `assets/` folder.
The goal is to replace a slow, dry README read with something you can grasp fast and
keep — and, for a research project, to explain the architecture and principles from the
*actual diagrams*, not a paraphrase.

## When to use
The description covers triggering. In short: a GitHub URL + any "I want to learn / study /
understand / evaluate this" intent. Works for one repo or a whole org.

## Output shape
A folder (default `<repo-or-org-name>-learn/`) containing:
- `index.html` — self-contained (inline CSS+JS), double-click to open, fully offline
- `assets/` — downloaded media (images, diagrams, video covers)
- `scripts/` — generated `check-env` + `setup` helpers for the optional install step

The page is a single static HTML file on purpose: no build step, no server, trivially
shareable, and the media plays/renders offline. Don't reach for React/Vite here.

## Workflow (high level)
1. **Detect org vs single repo** and confirm the deep-dive target with the user. This
   decision reshapes the page — get it right first. In **org mode**, go three tiers:
   overview + selection map → a **detailed profile per top repo** (not just a table row)
   → one flagship deep-dive.
2. **Research** the real content with WebFetch (positioning, architecture, deploy steps,
   media URLs). Use subagents in parallel when available. Never invent facts/stars/URLs.
3. **View the architecture diagrams yourself** (Read the downloaded images) and write the
   architecture + principle sections from them. Also produce a **code-structure & tech-stack**
   section — language breakdown, key dependencies, an annotated directory tree, and a
   "read these files first" order — all from the GitHub API, no cloning (workflow.md Step 1.5).
4. **Gather** related projects (real stars + last-update via the GitHub API), learning
   videos (YouTube + Bilibili, honest about gaps), and a glossary of the jargon.
5. **Download media** with `scripts/fetch-media.sh` into `assets/` (handles Git LFS and
   blocked hosts automatically).
6. **Generate the page** by copying `assets/template.html` and replacing its content,
   keeping the CSS/JS and section scaffolding.
7. **Deploy section**: summarize the official steps; generate env-check + setup scripts
   from the templates; by default DON'T actually install — leave a backfill placeholder
   unless the user asks to really clone/run it.

Read `references/workflow.md` for the step-by-step detail, `references/page-design.md`
for the section list + styled components, and `references/media-gotchas.md` before
downloading anything (Git LFS, Bilibili TLS, proxies — these will bite otherwise).

## Bundled resources
- `assets/template.html` — the proven page (a worked OmAgent example). Copy it, keep its
  CSS + JavaScript (lightbox, scroll-spy, searchable glossary, copy buttons, video cards),
  replace all content. This is the structural template *and* a reference for how each
  component is used.
- `assets/check-env.template.ps1`, `assets/setup-project.template.ps1` — adapt for the
  target (repo URL, package name, example path) to fill the hands-on/deploy section.
- `scripts/fetch-media.sh` — `./fetch-media.sh <out>/assets name1=url1 name2=url2 …`.
  Auto-fixes Git LFS pointers and routes blocked hosts (hdslb/bilibili) through a proxy.
  Run it via the Bash tool (git-bash curl), not Windows cmd curl.

## Principles that make the page good
- **Faithful, never fabricated.** Stars, dates, media URLs, results — all from real
  fetches. If something doesn't exist (e.g. no learning video), say so plainly.
- **Diagrams over prose.** The architecture/principle sections should reflect what the
  real diagrams show; that's the value-add over the README.
- **Offline-first.** Relative `assets/` paths; verify every download is a real image
  before referencing it.
- **Confirm scope before a long run.** Org-vs-repo split, deep-dive target, and "actually
  install or just document" — check these with the user up front.
