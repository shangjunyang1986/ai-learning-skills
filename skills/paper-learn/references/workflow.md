# Detailed workflow

## Step 0 — Identify the paper & confirm scope

The input is **one paper** — an arXiv link, a title, or a PDF. Pin down:
- The exact paper + version (e.g. "Attention Is All You Need, arXiv:1706.03762"). If given a
  title, find the authoritative source (arXiv abstract page, the publisher/venue page). If a
  PDF, open it.
- The reader's goal: pure understanding, or "is it legit / can we use it" (an evaluation
  read). This shifts how much weight the critical-reading section carries.

Tell the user you'll produce a single self-contained offline reading page (double-click to
open) with the paper's figures downloaded, an interactive demo of the core mechanism, and a
critical-reading pass.

## Step 1 — Read the paper, sourced

**This is where paper-learn lives or dies.** A page that misstates the method or invents a
result is worse than the abstract. Read `source-parsing.md` first. Fan out with subagents when
available — split the work into three reads:

1. **Facts & results.** Title, authors + affiliations, venue/year, arXiv id + dates; the
   one-sentence contribution (the paper's own framing); the headline results **verbatim from
   the abstract/tables** (real numbers); hyperparameters; the official code URL. Try a live
   citation count (Semantic Scholar / OpenAlex) but **flag it if you can't get it** — never
   fabricate.
2. **Method deep-read.** Figure by figure: what each figure actually shows (with the real
   caption). The key equations **in the paper's own form, with its numbering**. The core
   mechanism explained from the figures, not the abstract. The method's moving parts and how
   data flows through them.
3. **Figure image URLs.** The real, downloadable image files. arXiv's HTML renderer and
   **ar5iv** (`ar5iv.labs.arxiv.org/html/<id>/...`) expose the paper's figures as PNG/SVG —
   list them and **confirm each returns image bytes** before using it. Never guess a path.

Have each read **flag what it couldn't verify**. Prefer fewer, correct facts over confident
prose.

## Step 2 — View the figures yourself

Download and Read the core figures (architecture, the method diagram) before writing about
them. Write the method section from what the figure shows.

## Step 3 — Sort the claims (the signature critical-reading layer)

As you read, collect the paper's load-bearing claims and tag each:
- **demonstrated** — backed by an experiment/result in the paper (cite the table/section);
- **hypothesized** — asserted or used as motivation but **not measured** (e.g. "this choice
  may help X" with no ablation showing it);
- **conditional** — true with caveats (cost, scope, "only on task Y").

This sort becomes the claim-check cards. Getting the verdicts right (and sourced) is the most
valuable thing on the page.

## Step 4 — Write the page (the pedagogy)

Follow the reading order:
1. **Motivation** — what problem, why prior approaches fell short, the paper's claim.
2. **Background / why this design** — any complexity/comparison table the paper gives.
3. **Method, figure by figure** — the real diagrams (lightbox-zoomable) + the key equations
   rendered offline (`.eq`/`.m`, NOT a KaTeX CDN), each tagged with the paper's equation
   number and cited.
4. **Worked example** — narrate the core mechanism on a tiny concrete case, revealed step by
   step (`.worked` + `reveal`). Flag any numbers the paper doesn't itself print.
5. **Interactive demo** — one self-contained, offline widget that lets the reader *feel* the
   core mechanism (sliders/toggles + live readout). Be explicit in a caption that it teaches
   the mechanism's math, not a trained model's real outputs.
6. **Results** — the real numbers in a table; the training cost; the hyperparameters.
7. **Reproduce / read the code** — the official repo + a good walkthrough + a reading order.
8. **Impact & critical reading** — a short, clearly-labeled "what came after" (context, not
   the paper's claim) + the **claim-check cards** (demonstrated/hypothesized/conditional).
9. **Glossary**.

See `figures-and-claims.md` for how to build the figure walk, the demo, and the claim cards.

## Step 5 — Download media

Use `scripts/fetch-media.sh <out>/assets name.ext=url …`. Pass filenames **with extensions**.
It accepts SVG/PNG/JPG and **drops** anything that isn't a real image. Never reference a
dropped file. Watch sizes — some architecture figures are large; that's usually fine, but skip
anything absurd.

## Step 6 — Generate the page

Copy `assets/template.html` to `<out>/index.html` and replace its content. Keep the CSS and
**all** the JavaScript: the interactive demo IIFE (`runDemo`), worked-example reveal
(`reveal`), claim-check flip cards (`flip`), lightbox, scroll-spy, copy buttons, and the
glossary filter. Adapt the demo to your paper's mechanism (or, if the paper has no clean
mechanism to make tangible, replace the demo with a stronger figure walk and say why). Edit
the `GLOSSARY` array. Use relative `assets/...` paths. See `page-design.md`.

## Step 7 — Verify it renders

Open the page in a headless browser if you have one. Confirm: every figure loads, the
equations render, the demo responds to its controls (and the readout changes), the worked
example expands, and a claim card flips. Fix anything broken before calling it done.

Confirm the paper & scope with the user before the long read, and tell them which approach
you're using (single self-contained HTML + assets folder, offline).
