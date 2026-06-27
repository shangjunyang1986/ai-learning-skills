# Detailed workflow

## Step 0 — Scope the topic

The input is a **topic**, not a URL. Pin down:
- The exact subject (e.g. "3D Gaussian Splatting", not just "gaussian stuff"). If broad
  (e.g. "machine learning"), ask the user to narrow it — a learning page needs a focused
  subject.
- Depth: a quick orientation, or a thorough 入门→前沿 treatment (the default for "从入门到
  实践" requests).
- Their starting point if relevant (total beginner vs already knows adjacent things) — it
  shapes how much intuition-building the 入门 section needs.

Tell the user you'll produce a single self-contained offline HTML page (double-click to
open) with downloaded media and, if the topic suits it, an interactive demo.

## Step 1 — Research (parallel, sourced)

**This is where domain-learn lives or dies.** Open-web topics are full of half-truths,
outdated numbers, and confident-sounding nonsense. Read `research-sourcing.md` first.

Fan out over three angles (use subagents in parallel when available; each returns sourced,
structured data — not prose):

1. **Fundamentals + seminal work.** What it is, the intuition, how it contrasts with the
   thing it replaced/competes with; the seminal paper(s) (exact title, authors, venue,
   year, arXiv id, project page); the core method step by step; headline results with real
   numbers; a short timeline of notable follow-ups. Plus direct media URLs (project-page
   figures, repo teaser images, official demo videos).
2. **Ecosystem / tools / implementations.** The key codebases and tools, with **real stars
   and last-update from the GitHub API** (`api.github.com/repos/<o>/<r>`), grouped by use
   ("to train", "to view", "to integrate", "to preprocess"). Live in-browser demos if any.
3. **Learning resources + a path.** Beginner→advanced written explainers, video tutorials
   (YouTube video IDs for thumbnails; Bilibili BV links for Chinese), surveys, and a
   suggested 入门→进阶→实践→前沿 ordering that maps the resources to stages.

Have each agent **flag what it could not verify**. Prefer fewer, correct facts over a
confident-but-wrong wall of text.

## Step 2 — View the key figures yourself

Download and Read the core diagrams (method/architecture figures). Write the "核心原理"
section from what the figure actually shows, not a paraphrase of an abstract.

## Step 3 — Design the learning roadmap

Lay out four stages and assign the researched resources:
- **入门 (intuition)** — the gentlest explainer(s), an overview video, the interactive demo.
- **进阶 (theory)** — the paper, a math-focused explainer, an author talk.
- **实践 (hands-on)** — the official code / a friendly framework, a step-by-step pipeline,
  hands-on tutorials.
- **前沿 (frontier)** — a survey + a couple of representative follow-up directions + a live
  tracker (e.g. an "awesome-X" list).

## Step 4 — Build the interactive demo (when it fits)

If the topic has a clean visual or algorithmic core, build ONE self-contained, offline
playground that teaches it (canvas/SVG/WebGL + sliders/buttons + live feedback). See
`interactive-demos.md`. If the topic is abstract with no clean visual, **skip it** — a
forced, meaningless widget is worse than none. Say so rather than faking it.

## Step 5 — Download media

Use `scripts/fetch-media.sh <out>/assets name=url …`. It fixes Git LFS pointers, proxies
blocked hosts (e.g. Bilibili covers), walks the YouTube thumbnail resolution ladder, and
**drops** anything that isn't a real image. Never reference a dropped file. Watch sizes —
some official GIFs are huge (tens of MB); skip or note rather than committing a giant file.

## Step 6 — Generate the page

Copy `assets/template.html` to `<out>/index.html` and replace its content. Keep the CSS,
the JavaScript (lightbox, scroll-spy, glossary search via the `GLOSSARY` array, copy
buttons, video cards, and the interactive-demo scaffolding), and the section structure.
Use relative `assets/...` paths so the page opens offline. See `page-design.md`.

Confirm scope with the user before the long research run, and tell them which approach
you're using (single self-contained HTML + assets folder, offline).
