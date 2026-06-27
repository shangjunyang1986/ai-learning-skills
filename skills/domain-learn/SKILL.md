---
name: domain-learn
description: >-
  Research an open topic / field across the web and turn it into an offline, visual,
  beginner-to-hands-on learning page — a single self-contained HTML file with a left
  table of contents, a learning roadmap, sourced explanations, the field's real images
  and videos downloaded locally, and (when the topic admits it) an interactive in-browser
  demo that teaches the core intuition. Use this whenever the user wants to LEARN, STUDY,
  RESEARCH, "get into", or "做个从入门到实践的教程" for a TOPIC or FIELD that is NOT a
  single GitHub repo — e.g. "我想学习 3DGS / 帮我研究下扩散模型 / 给我做个 RAG 从入门到实践的
  学习教程 / I want to get up to speed on reinforcement learning / explain CRDTs end to end".
  Triggers on a topic name + intent to learn/understand it, even without the words
  "website" or "HTML". Distinguish from siblings: a GitHub URL → use github-project-learn;
  a specific book/PDF → use textbook-learn; a bare topic/field → THIS skill. Not for:
  answering a quick factual question (just answer it), or building generic web apps.
---

# domain-learn

Turn an **open topic** (a research field, a technique, a concept) into a **single,
offline-openable learning page** that takes someone from intuition → theory → hands-on →
frontier. Left = table of contents, right = a learning roadmap and sourced content, with
the field's own diagrams and videos downloaded locally and — when the topic is visual or
algorithmic — **one interactive in-browser demo** that makes the core idea click.

This is the family's sibling to `github-project-learn`. The output shell is the same; what
differs is the **source** (the open web, not one repo), the **research rigor** (everything
sourced — the web is fuzzy and we must not fabricate), the **pedagogy** (a beginner→frontier
roadmap), and the **interactivity** (a teaching demo, not just a code walkthrough).

## When to use
The description covers triggering. In short: a **topic/field name** + any "I want to learn /
research / understand this" intent, where the subject is not a single GitHub repo or a
specific book. Examples: "学习 3DGS", "研究下扩散模型", "RAG 从入门到实践", "explain CRDTs".

## Output shape
A folder (default `<topic>-learn/`) containing:
- `index.html` — self-contained (inline CSS+JS), double-click to open, fully offline
- `assets/` — the field's real images/diagrams/video covers, downloaded

## Workflow (high level)
1. **Scope the topic with the user.** Confirm the exact subject and the depth (a quick
   orientation vs a thorough入门→前沿 treatment). Tell them you'll build a single
   self-contained offline page.
2. **Research rigorously, in parallel.** Fan out (subagents when available) over three
   angles: (a) fundamentals + the seminal work, (b) the ecosystem / tools / key
   implementations, (c) learning resources + videos + a suggested path. **Every non-obvious
   claim, number, and link must come from a real fetch and carry a source.** Flag anything
   you can't verify rather than guessing. See `references/research-sourcing.md` — this is
   the make-or-break difference for an open topic.
3. **Design the learning roadmap** (入门 → 进阶 → 实践 → 前沿) and map resources to each stage.
4. **Build one interactive demo** *if the topic admits a clean visual/algorithmic intuition*
   — a self-contained, offline canvas/SVG/WebGL playground with controls that teaches ONE
   core concept. If the topic has no clean visual, skip it rather than forcing one. See
   `references/interactive-demos.md`.
5. **Download media** with `scripts/fetch-media.sh` into `assets/` (handles Git LFS and
   blocked hosts; drops broken/placeholder covers automatically).
6. **Generate the page** by copying `assets/template.html` (a complete worked example — the
   3D Gaussian Splatting page) and replacing its content, keeping the CSS, the JavaScript
   (lightbox, scroll-spy, glossary search, copy buttons, video cards), and the section
   scaffolding.

Read `references/workflow.md` for step-by-step detail, `references/page-design.md` for the
section list + components, `references/research-sourcing.md` before researching, and
`references/interactive-demos.md` before building the demo.

## Bundled resources
- `assets/template.html` — the proven page (a worked **3D Gaussian Splatting** example).
  Copy it, keep its CSS + JS (lightbox, scroll-spy, searchable glossary, copy buttons,
  video cards, and the interactive-demo pattern), replace all content.
- `scripts/fetch-media.sh` — `./fetch-media.sh <out>/assets name1=url1 …`. Auto-fixes Git
  LFS pointers, routes blocked hosts through a proxy, and drops invalid/placeholder images.
  Run via the Bash tool (git-bash curl), not Windows cmd curl.

## Principles that make the page good
- **Faithful, never fabricated — and *sourced*.** Open-web topics are full of half-truths.
  Cite the paper / official page / API for every claim; flag uncertainty; say "no good
  resource exists" when true. This is the skill's single most important rule.
- **Roadmap, not a dump.** Organize for a learner's journey (intuition first, math second,
  hands-on third, frontier last), not as an encyclopedia.
- **One great demo beats ten paragraphs.** When the topic is visual/algorithmic, an
  interactive playground is the highest-value thing on the page.
- **Offline-first.** Relative `assets/` paths; verify every download is a real image.
- **Confirm scope before a long research run.**
