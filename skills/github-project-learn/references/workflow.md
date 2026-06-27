# Detailed workflow

## Step 0 — Identify the target: organization vs single repo

A GitHub URL can be an **organization** (`github.com/<org>`) or a **single repo**
(`github.com/<owner>/<repo>`). This changes the page shape, so detect it first.

- Fetch the URL. If it lists multiple repositories / has no single README as the
  main content, it's an **organization**.
- If unsure, ask the user: "这是一个组织（多个项目）还是单个项目？" — getting this
  wrong wastes a lot of work.

**Org mode** → build THREE tiers, not two. A table-row-per-repo is not enough; users
want to actually understand each project:
1. *Organization overview*: positioning + a full repo map with a "start here" selection guide.
2. *Per-repo profiles*: for the top ~5-8 repos (by stars and relevance to the user's
   stated goal), give each its own **detailed profile** — not a table row. Each profile:
   what it is (2-3 sentences), key features / what's novel, how it differs from the org's
   other repos, when you'd reach for it, stars + last-update, a representative image, and
   the link. Use a card or a short subsection per repo. Say honestly which repos you're
   profiling and why (e.g. "top 8 by stars; the long tail is in the map above").
3. *One flagship deep-dive*: pick the most relevant repo and give it the full deep-dive
   sections (3-8 below), including the code-structure section.

**Single-repo mode** → skip the org overview + per-repo tiers; the page is just the
deep-dive sections for that one repo (including code structure).

## Step 1 — Research (use subagents in parallel when available)

Gather real content with WebFetch. Do **not** invent facts, stars, dates, or media URLs.

For the **organization** (org mode only):
- positioning / mission (one paragraph)
- a table of all repos: name, one-line purpose, stars, domain, URL
- a selection map: "want to do X → start with repo Y"
- official media: website images, demo links, paper links

For the **deep-dive repo** (both modes), collect enough for these sections:
1. What it is (plain terms) + license + venue/paper if any
2. Target domain & highlights: what's novel/useful, key features, reported results
3. Architecture: modules, components, data flow (grab architecture diagrams!)
4. Tech principle: core mechanisms under the hood
5. Deploy & usage: requirements, install commands, quickstart, how to run examples
6. Media inventory: **direct URLs** of every image/gif/video/diagram in the README
   and docs (see media-gotchas.md for how GitHub serves these)
7. Code structure & tech stack (see Step 1.5)

Fetch the **raw** README to get exact asset paths:
`https://raw.githubusercontent.com/<owner>/<repo>/<branch>/README.md` (try `main` then `master`).

**View the architecture diagrams yourself** (Read the downloaded image). Writing the
architecture/principle sections from the actual diagram — not a paraphrase of the
README prose — is what makes the page worth more than the README.

## Step 1.5 — Code structure & tech stack (section: 代码结构与技术栈)

A learner wants to know "how is this codebase actually built and where do I start
reading?" You can answer this **without cloning** — the GitHub API exposes everything:

- **Language breakdown** (tech stack by bytes):
  `curl -sSL https://api.github.com/repos/<owner>/<repo>/languages`
  → `{"Python": 123456, "Cuda": 4567, ...}`. Turn into a "技术栈" bar/table with percentages.
- **Key dependencies / frameworks**: fetch the manifest via raw and extract the notable
  deps (don't dump the whole lockfile): `pyproject.toml` / `setup.py` / `requirements.txt`
  (Python), `package.json` (JS/TS), `Cargo.toml` (Rust), `go.mod` (Go). Name the 5-10
  that matter (e.g. torch, transformers, fastapi) and what each is for.
- **Annotated directory tree**: `curl -sSL "https://api.github.com/repos/<owner>/<repo>/git/trees/<branch>?recursive=1"`
  gives every path. Summarize the **top 1-2 levels** into a tree and annotate what each
  top dir/module does (don't list every file). Render with a `<pre>` block or the `.flow`
  component.
- **Key files / reading order**: identify entry points (CLI `__main__`, `app.py`, `cli.ts`),
  core modules, and config. Tell the learner **which files to open first and in what order**
  — this is the highest-value part. A short "从这里开始读" list of 4-8 files with one line each.

Build this as a deep-dive section for the flagship repo (org mode) or the repo
(single-repo mode). It pairs naturally with the architecture section: architecture =
concepts, code structure = where those concepts live in the tree.

## Step 2 — Related projects (section: 相关 GitHub 项目)

Use the GitHub API for **real** stars + last-update, not guesses:
`curl -sSL https://api.github.com/repos/<owner>/<repo>` → `stargazers_count`, `pushed_at`, `description`.
Cover both: (a) sibling repos in the same org that pair well, and (b) external
comparable frameworks. For each: function, **difference vs the target**, stars, last update.
A stale `pushed_at` is a signal worth surfacing honestly (research project vs active product).

## Step 3 — Learning videos (section: 学习视频)

Search YouTube and Bilibili. Be honest: niche research projects often have **no**
dedicated videos — say so rather than padding with unrelated content. Separate
"项目专属" from "相关主题", and label how each related video connects to the project.
See media-gotchas.md for how to pull Bilibili titles/covers (direct TLS is blocked).

## Step 4 — Glossary (section: 术语表)

Learning a new project means hitting unfamiliar jargon. Collect every non-obvious
term that appears in the page (model types, methods, middleware, tools, venues) and
explain each in plain language **tied to how this project uses it** — not a generic
dictionary definition. The template's glossary is searchable; just edit the
`GLOSSARY` array in the JS.

## Step 5 — Generate the page

Copy `assets/template.html` to `<out>/index.html` and replace its content. The
template is a fully-worked example (the OmAgent page) — keep its CSS, its JavaScript
(lightbox, scroll-spy, glossary search, copy buttons, video cards), and the section
scaffolding; replace ALL text, images, glossary entries, video cards, and the repo
table with the target project's real content. See page-design.md for the section list
and component inventory.

Download media into `<out>/assets/` with `scripts/fetch-media.sh` and reference it
with relative `assets/...` paths so the page opens offline by double-click.

## Step 6 — Deploy section (怎么部署使用 + 实操记录)

Split deploy into two sections so learning and doing stay distinct:
- **官方怎么说**: summarize the official install/quickstart, with copy-able commands.
- **我的实操记录**: by default DON'T actually install (research repos are heavy and may
  fail on the user's OS). Generate `check-env` + `setup` scripts from the templates in
  `assets/` (adapt repo URL, package name, example path) and leave a "回填占位" for the
  real install log. Only actually clone/install if the user explicitly asks.

Always confirm the org-vs-repo split and the deep-dive target with the user before a
long research run, and tell them which webpage approach you're using (self-contained
single-file HTML + assets folder, for offline double-click).
