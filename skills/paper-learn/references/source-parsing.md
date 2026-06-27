# Reading & sourcing — the make-or-break of paper-learn

A paper has one authoritative source, which helps. But the failure mode is sharp: **a reading
page that misstates an equation, inflates a result, or labels a hypothesis as a proven fact
teaches the paper wrong — and a confident reader is worse than an uninformed one.** The bar:
**every equation, number, figure, and claim-verdict must be checkable against the actual
paper, and cited to a section/equation/table.**

## Getting the paper's content

- **arXiv papers:** the cleanest path is the HTML renderings — **ar5iv**
  (`https://ar5iv.labs.arxiv.org/abs/<id>`) and arXiv's own `https://arxiv.org/html/<id>`.
  They give you the text, the equations, and (crucially) the **figures as standalone image
  files**. The abstract page (`https://arxiv.org/abs/<id>`) has the authoritative title /
  authors / dates / abstract.
- **PDF the user supplies:** read it directly (the Read tool handles PDFs). Pull the abstract,
  the method, the key equations, the results tables, and the figures (note page numbers).
- **Published-only papers:** use the venue/publisher page for the authoritative metadata; the
  arXiv preprint (if any) for full text.

## Rules

1. **Every load-bearing item carries a source.** Equations, results (BLEU/accuracy/FLOPs/
   dates), hyperparameters, and every claim-verdict come from the real paper. Cite the
   section/equation/table on the page (a "出处" link/line).
2. **Quote equations and results faithfully.** Use the paper's own form and its numbering as a
   locator (e.g. "(1)", "Table 2"). Render offline with `.eq`/`.m` + unicode — don't paraphrase
   a formula into something subtly different, and don't round a result differently than the
   paper.
3. **Get figure image URLs that actually resolve.** ar5iv/arXiv store figures under paths like
   `.../html/<id>/assets/...` or `.../<id>/xN.png`. **Confirm each returns image bytes** before
   referencing it; never guess a filename. Download with `fetch-media.sh` (it drops failures).
4. **Sort claims honestly — demonstrated vs hypothesized vs conditional.** This is the skill's
   signature, and the easiest place to mislead. If the paper *measured* it (an ablation, a
   results table) → demonstrated. If it's a motivation/design rationale with no measurement →
   hypothesized (even if plausible). If it holds with caveats (cost, scope, task) →
   conditional. Quote the paper's wording where the verdict is subtle (e.g. "we suspect…",
   "nearly identical results"). **Never upgrade a hypothesis to a fact.**
5. **Flag numbers you compute.** If a worked example or demo needs concrete numbers the paper
   doesn't print, compute them correctly **and** label them "演算示例，论文中无此例 /
   illustrative". The demo especially must say it shows the *mechanism's math*, not a trained
   model's real attention/output.
6. **Flag stats you can't fetch.** Live citation counts (Semantic Scholar / OpenAlex) are
   often rate-limited or fragmented across versions. If you can't get a trustworthy number,
   **say so on the page** ("实时引用数未能核实") rather than inventing one. A famous paper being
   "one of the most-cited" is fine as a qualitative, un-numbered statement.
7. **Dates are absolute.** arXiv v1 vs latest-version dates; venue year. Stamp any fetched
   stat with its date.

## Media sourcing

- The architecture / method diagrams are the highest-value figures — they're what the
  figure-by-figure walk is built on. ar5iv rasterizes vector figures to PNG (filenames are the
  original LaTeX export names, not "Figure1.png"); take the **real** resolved URLs from the
  rendered HTML.
- Some figures (attention heatmaps, learned plots) are great for the "what it learned"
  /critical-reading section — but caption them honestly (a *qualitative* visualization, not a
  proof).
- Verify each download is a real image (the script does, and drops failures). If you didn't
  successfully download it, don't reference it.

## A good read return looks like

Faithful method notes (figure-by-figure, each with the real caption); the key equations **with
their paper numbers**; the headline results **verbatim** from the abstract/tables; a worked
example (paper-derived; computed numbers flagged); confirmed figure image URLs; and a
**claim list pre-sorted into demonstrated / hypothesized / conditional with a source per
verdict** — plus a separate "could not verify" list (often the live citation count). If a
subagent hands back a formula with no equation number or a result with no table reference,
send it back for sources.
