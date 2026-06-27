# Page design — paper-learn sections & components

`assets/template.html` is a complete worked example (the **Attention Is All You Need** page).
It is a **single self-contained HTML file** (inline CSS + JS) referencing a sibling `assets/`
folder, so it opens offline by double-click. Reuse its CSS and JS verbatim; replace content.

Same family shell as the rest (`learning-page-design.md` in the repo's `shared/`). What's
specific to `paper-learn` is the **read-a-paper pedagogy** (motivation → figure-by-figure
method → critique) and the **mechanism demo + claim-check** interactivity.

## Section list (the proven order for one paper)
Adapt names to the paper; keep the reading shape.

- `0` 30-second overview (hero: title, **full author list + venue/year**, the one-line
  contribution in the paper's framing, stat chips of real numbers; a source-citation note —
  and if a stat like a live citation count can't be fetched, **say so** rather than guessing)
- `1` What problem it solves (the pain in prior approaches + the paper's claim)
- `2` Background / why this design (any complexity or comparison table the paper provides)
- `3..` **Method, figure by figure** — the paper's real diagrams (lightbox), each explained
  from what it shows, interleaved with the **key equations** (`.eq`, tagged with the paper's
  equation numbers) and "why" callouts. This is the spine of a paper page.
- **Worked example** (`.worked`) — the core mechanism on a tiny case, revealed step by step.
- **Interactive demo** (`.demo` + `.ctrl`) — one widget that makes the mechanism tangible.
- Results (a sourced table + training cost + hyperparameters as `.pill`s)
- Reproduce / read the code (`.card`s + a reading-order `.codewrap`)
- **Impact & critical reading** — a short labeled "what came after" + the **claim-check
  cards** (`.recall` + `.rcard` with a `.verdict`).
- Glossary (searchable, via the `GLOSSARY` array).

Keep nav order === DOM order or scroll-spy desyncs; every nav `href="#sN"` needs a matching
`id="sN"`.

## Component inventory (already styled)
Same family shell, plus these paper-specific patterns:
- `.eq` (block equation, right-tagged with the paper's eq number) + `.m` (inline math chip) —
  **offline math rendering**, no KaTeX/MathJax CDN. Use `<sup>/<sub>` and unicode (⊤ Σ √ ≈ −).
- `.worked` + `.reveal-btn` + `.solution` — the worked example; `reveal(btn)` toggles the
  `ol.steps` solution.
- `.demo` + `.demogrid` + `.ctrl` + `.viz` — the interactive mechanism demo. The bundled one
  is a scaled-dot-product-attention playground (`runDemo()` reads sliders + a scaling toggle,
  recomputes softmax weight bars and the output vector). Adapt the IIFE to your mechanism.
- `.recall` + `.rcard` (`.claim` / `.verdict.vd-ok|vd-hyp|vd-part` / `.ans`) — the
  **claim-check cards**; `flip(card)` reveals the verdict's reasoning. `vd-ok` = demonstrated,
  `vd-hyp` = hypothesized, `vd-part` = conditional.
- Plus the shared: `.hero/.stats`, `.card/.grid`, `table` (with `td .s`/`td .mono`),
  `figure`+`figcaption` (lightbox), `.imgrow` two-up figures, `.note/.note.warn/.note.ok/
  .note.src`, `ol.steps`, `.flow`, `.pill`, `.codewrap`+copy, `.gsearch`+`#glist` glossary.

## JavaScript (keep all of it)
scroll progress + scroll-spy; lightbox on `figure img`; `cp(btn)` copy; glossary live filter
from `GLOSSARY`; **worked reveal** (`reveal`); **claim-check flip** (`flip`); and the
**interactive demo** (`runDemo` + its fixed data). Two things to edit per paper: the
`GLOSSARY` array, and the demo's data/logic to match the paper's mechanism.

## Filling rules
- Replace ALL Transformer text, figures, equations, the demo, the worked example, the claim
  cards, and the glossary with the target paper's real, **sourced** content.
- **Math offline only** — never add a KaTeX/MathJax CDN (breaks offline-first). The `.eq`/`.m`
  styles + unicode are enough for a reading page's formulas.
- Media: relative `assets/...` only; download with `scripts/fetch-media.sh`; never reference a
  file you didn't successfully download. Get figure URLs from ar5iv/arXiv HTML, not guesses.
- Write the method section from figures you actually viewed.
- Cite sources on the page (a "出处" `.note.src` link per section / load-bearing table).
- **Claim-check verdicts must be honest and sourced.** Don't label a hypothesis "demonstrated"
  — the whole point is teaching the reader to tell them apart.
- The demo's caption must state it's a teaching simplification of the mechanism, not a trained
  model's real output.
