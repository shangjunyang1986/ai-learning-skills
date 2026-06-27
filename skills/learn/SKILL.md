---
name: learn
description: >-
  The front door to the ai-learning-skills family. Two jobs. (1) ROUTER: given anything the
  user wants to learn — a GitHub repo/org URL, an arXiv link / paper / PDF, a technical book,
  or a bare topic/field — detect the source type and hand off to the right family skill
  (github-project-learn / paper-learn / textbook-learn / domain-learn). (2) LIBRARY HUB: build
  or refresh an offline "learning library" index page that aggregates every learning page
  you've generated, grouped by type, with per-page learn status. Use this when the user types
  /learn, says "我想学这个 / 帮我学习…" without it being obvious which skill fits, asks to learn
  something but isn't sure how, or asks to "建/打开我的学习库 / build my learning hub / show all
  my learning pages / 把我做的学习页汇总". If the user's input ALREADY clearly matches one
  specific family skill (a plain GitHub URL, a clear arXiv link, a named textbook, a bare
  field name), that skill can trigger directly — this router is for the unified entry point,
  ambiguous inputs, and the hub. Not for: generic web apps or answering a one-off question.
---

# learn — family front door (router + library hub)

The single entry point to the `ai-learning-skills` family. It does two things: **routes** any
"I want to learn X" to the right sibling skill, and **builds the offline library hub** that
collects everything you've generated.

The four siblings, by source:
- **github-project-learn** — a GitHub repo or whole organization.
- **paper-learn** — a single paper / arXiv link / paper PDF.
- **textbook-learn** — a technical book / textbook PDF / EPUB.
- **domain-learn** — an open topic or field (not one repo, paper, or book).

## Mode A — Route to the right skill

1. **Detect the source type** from the user's input (see `references/routing.md` for the full
   decision table + disambiguation). Quick version:
   - Contains a **github.com** URL → `github-project-learn`.
   - Contains an **arxiv.org / ar5iv** link, or names a **paper** ("精读…", "这篇论文"), or a
     PDF that looks like one paper (abstract + references, ~8–20 pages) → `paper-learn`.
   - Names a **book** / a PDF or EPUB that's a textbook (chapters, a TOC, many pages) →
     `textbook-learn`.
   - A **bare topic/field** with no URL and not a specific book/paper ("学习 3DGS", "研究下
     扩散模型") → `domain-learn`.
2. **If ambiguous, ask one quick question** rather than guessing (e.g. a PDF that could be a
   book or a paper; a GitHub URL that's actually a paper's official code; a topic that's
   really one famous paper). One AskUserQuestion, then route.
3. **Hand off** by invoking the chosen skill via the Skill tool, passing the user's source.
   That skill owns the actual build (research → page → verify). Don't re-implement it here.
4. **After it finishes**, offer to add the new page to the library hub (Mode B).

## Mode B — Build / refresh the library hub

When the user asks to build/open their learning library, or after generating pages:

1. **Find the library root** — the folder under which their `*-learn/` pages live (ask if
   unknown; default to the current project or a `~/learning` style folder).
2. **Run the builder:**
   ```bash
   python skills/learn/scripts/build-hub.py <root> --out <root>/learn-hub --title "我的学习库"
   ```
   It scans `<root>` for family pages, classifies each (by an explicit `learn:type` meta, else
   the `…/<skill>/<name>/` folder layout, else content heuristics), picks a thumbnail from each
   page's `assets/`, and writes `<root>/learn-hub/index.html` — a self-contained offline index
   with type filters, search, and a per-page learn-status toggle (未开始 / 在学 / 学完) saved in
   the hub's own localStorage.
3. **Open it** (`start` / `open` the generated `index.html`) and tell the user it refreshes by
   re-running the script.

See `references/hub.md` for the builder's options, classification rules, and the layout that
makes auto-classification clean.

## Bundled resources
- `scripts/build-hub.py` — the offline hub generator (Python stdlib only; no deps).
- `assets/hub-template.html` — the hub page shell (same family design system); the script
  injects the page list into its `LIBRARY` array.

## Principles
- **Route, don't re-implement.** This skill picks the right sibling and hands off; the sibling
  does the faithful research + build. Keep the routing logic thin and the disambiguation
  honest (ask when unsure, don't guess wrong).
- **The hub is just an index.** It links to real pages and tracks *library-level* status in its
  own storage. It can't read another page's localStorage (separate file origins), so it tracks
  "started / done" at the page level on the hub itself — honest about what it can know.
- **Offline-first, faithful, consistent** — same as the rest of the family. The hub is a
  self-contained page with relative links; it never invents pages that aren't there.
