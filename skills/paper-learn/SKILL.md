---
name: paper-learn
description: >-
  Turn a single research paper (an arXiv link / PDF / paper title) into an offline, visual
  PAPER-READING page — a self-contained HTML file with a left table of contents that walks
  the paper the way you should read it: problem & motivation → the method broken down
  FIGURE BY FIGURE with the paper's own diagrams downloaded locally and key equations
  rendered offline → a step-by-step worked example of the core mechanism → an honest
  interactive demo of that mechanism → results → how to reproduce / read the code → and a
  CRITICAL-READING pass that separates what the paper actually demonstrated from what it only
  hypothesized. Use this whenever the user wants to UNDERSTAND, READ, or "精读" a specific
  PAPER — e.g. "帮我精读 Attention Is All You Need / 把这篇 arXiv 讲明白 / explain this paper /
  这篇论文靠不靠谱、能不能落地 / make me a study page for arxiv.org/abs/XXXX". Triggers on an
  arXiv URL or a paper title/PDF + intent to understand/evaluate it. Distinguish from
  siblings: a GitHub repo URL → github-project-learn; a whole book/PDF textbook → textbook-learn;
  a bare topic/field → domain-learn; ONE paper → THIS skill. Not for: answering a single
  factual question about a paper (just answer it), or building generic web apps.
---

# paper-learn

Turn **one paper** into a **single, offline-openable reading page** that teaches it the way a
good advisor would walk you through it: why it exists → the method **figure by figure** (the
paper's own diagrams, downloaded; the key equations, rendered offline) → **a worked example**
of the core mechanism you can reveal step by step → **an interactive demo** of that mechanism
→ what it actually proved → how to reproduce it → and a **critical-reading pass** that sorts
the paper's claims into *demonstrated / hypothesized / conditional*.

This is the family's fourth sibling. The output shell is the same as `github-project-learn`,
`domain-learn`, and `textbook-learn`; what differs is the **source** (one paper), the
**research** (faithful figure/equation/result extraction sourced to a section), the
**pedagogy** (read-a-paper: motivation → method → critique, not a course or a roadmap), and
the **interactivity** (a mechanism demo + critical-reading "claim check" cards).

## When to use
The description covers triggering. In short: an **arXiv link / paper title / PDF** + any
"help me understand / read / 精读 / evaluate this paper" intent. Examples: "精读 Attention Is
All You Need", "把这篇 arXiv 讲明白", "explain arxiv.org/abs/XXXX", "这论文能不能落地".

## Output shape
A folder (default `<paper-slug>-learn/`) containing:
- `index.html` — self-contained (inline CSS+JS), double-click to open, fully offline
- `assets/` — the paper's real figures (architecture diagrams, plots), downloaded

## Workflow (high level)
1. **Identify the paper & confirm scope.** Pin down the exact paper + version (arXiv id +
   version). Tell the user you'll build a single self-contained offline reading page with the
   paper's figures, an interactive demo of the core mechanism, and a critical-reading pass.
2. **Read the paper, sourced.** Extract — faithfully, each cited to a section/equation — the
   problem & contribution, the method (figure by figure: what each figure shows), the key
   equations (verbatim form + the paper's numbering), the headline results (real numbers from
   the abstract/tables), the hyperparameters, and the limitations. Get the real, downloadable
   **figure image URLs** (ar5iv / arXiv HTML expose them). See `references/source-parsing.md`
   — this is the make-or-break.
3. **Sort the claims.** As you read, tag the load-bearing claims as **demonstrated**
   (shown by an experiment), **hypothesized** (asserted/motivated but not measured), or
   **conditional** (true with caveats). This is the skill's signature critical-reading layer.
4. **Write the page** as: motivation → method (figure-by-figure + offline equations) → a
   **worked example** of the core mechanism (revealed step by step) → an **interactive demo**
   of that mechanism (honest: it teaches the math, it is not a trained model's real output) →
   results → reproduce/read-the-code → **claim-check cards** (the demonstrated/hypothesized/
   conditional sort) → glossary. See `references/figures-and-claims.md`.
5. **Download media** with `scripts/fetch-media.sh` into `assets/` (handles SVG/PNG; drops
   anything that isn't a real image). Use relative `assets/...` paths.
6. **Generate the page** by copying `assets/template.html` (a complete worked example — the
   *Attention Is All You Need* page) and replacing its content, keeping the CSS, the
   JavaScript (interactive demo, worked-example reveal, claim-check flip cards, lightbox,
   scroll-spy, glossary search), and the section scaffolding.
7. **Verify it renders.** Open the page (a headless browser if available); confirm every
   figure loads, the equations render, the demo responds to its controls, the worked example
   reveals, and a claim card flips. Fix before calling it done.

Read `references/workflow.md` for step-by-step detail, `references/page-design.md` for the
section list + components, `references/source-parsing.md` before reading the paper, and
`references/figures-and-claims.md` before writing the method walk, the demo, and the critique.

## Bundled resources
- `assets/template.html` — the proven page (a worked **Attention Is All You Need** example).
  Copy it, keep its CSS + JS (interactive scaled-dot-product-attention demo, worked-example
  reveal, claim-check flip cards, lightbox, scroll-spy, searchable glossary, copy buttons),
  replace all content.
- `scripts/fetch-media.sh` — `./fetch-media.sh <out>/assets name.ext=url …`. Accepts SVG/PNG/
  JPG, fixes Git LFS pointers, drops invalid images. Run via the Bash tool (git-bash curl).

## Principles that make the page good
- **Faithful, never fabricated — and *sourced to the paper*.** Every equation, number, and
  figure must be checkable against the actual paper (cite section/equation). If a worked
  example or demo uses numbers the paper doesn't print, **say so** ("演算示例，论文中无此例").
  If you can't fetch a stat (e.g. a live citation count), **don't invent one** — say it's
  unverified.
- **Read it the right way.** Motivation before method, method before results, and always end
  with critique. A paper page that's just a prettier abstract is a waste.
- **Figure by figure.** The paper's own diagrams, downloaded and explained from what they
  actually show — not a paraphrase of the abstract.
- **Separate demonstrated from hypothesized.** The single most valuable reading skill. The
  claim-check cards are the heart of paper-learn; get the verdicts right and source them.
- **One honest demo beats ten paragraphs** — but it must be honest about being a teaching
  simplification of the *mechanism*, not a trained model's real behavior.
- **Offline-first.** Relative `assets/` paths; render math without a CDN; verify every
  download is a real image before referencing it.
- **Confirm the paper & scope before a long read.**
