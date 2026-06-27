# Page design — textbook-learn sections & components

`assets/template.html` is a complete worked example (the **Dive into Deep Learning** page). It
is a **single self-contained HTML file** (inline CSS + JS) referencing a sibling `assets/`
folder, so it opens offline by double-click. Reuse its CSS and JS verbatim; replace content.

This is the same shell as the rest of the family (`learning-page-design.md` in the repo's
`shared/`). What's specific to `textbook-learn` is the **chapter-course pedagogy** and the
**quiz / worked-example / progress-tracker** interactivity.

## Section list (the proven order for a book)
Adapt names to the book; keep the shape.

- `0` 30-second overview (hero with the **book cover**, one-paragraph pitch, stat chips:
  chapters / frameworks-or-edition / a real number like stars or adoption / free-or-price; a
  source-citation note stamped with the fetch date)
- `1` What the book is & who it's for (what makes it special; prerequisites as a small `.flow`)
- `2` **Chapter map / reading path** — the whole TOC grouped into stages (the `.chapmap` +
  `.cstage` cards), deep-dive chapters marked `★`, an explicit "从这里开始读" path. The book's
  own structure figure if it has one. This is the spine of a textbook page.
- `3..N` **Deep-dive chapters** (one section each) — the heart. Each: core takeaways
  (`ul.clean`) → key figure → key equations (`.eq`) → **worked example** (`.worked`) →
  **active-recall quiz** (`.quiz` + `.recall`) → "读完本章" checkbox (`.readbar`).
- `N+1` How to run / obtain the code (install steps, notebooks, PDF link — `ol.steps` +
  `.codewrap`); honest about staleness if the source is dormant.
- `N+2` "我的学习记录" — explains the auto-tracker + a `todo`回填 placeholder list.
- `N+3` Glossary (searchable, via the `GLOSSARY` array).

Keep nav order === DOM order or scroll-spy desyncs; every nav `href="#sN"` needs a matching
`id="sN"`. Deep-dive nav links carry `data-chap="cN"` so the sidebar dot turns green when read.

## Component inventory (already styled)
Same family shell, plus these textbook-specific patterns:
- `.chapmap` + `.cstage.s1..s4` + `.chip(.hot)` — the staged chapter map (section 2).
- `.worked` + `.reveal-btn` + `.solution` — the worked example; click reveals `ol.steps` via
  `reveal(btn)`.
- `.quiz` + `.q[data-correct]` + `.qopt` + `.qexplain` — self-grading MCQs via `pick(btn,idx)`
  (marks `.correct`/`.wrong`, opens the explanation, locks the question, updates the tracker).
- `.recall` + `.rcard` (inner `.q` / `.ans`) — free-recall flip cards via `flip(card)`.
- `.readbar` + `input[data-read="cN"]` — the "mark chapter read" checkbox via `toggleRead`.
- `.tracker` — the fixed progress widget (chapters read + quiz accuracy), persisted in
  localStorage under one key; `resetProgress` clears it.
- `.eq` (block equation, right-tagged with the book's eq number) + `.m` (inline math chip) —
  **offline math rendering**, no KaTeX/MathJax CDN. Use `<sup>/<sub>` and unicode (⊤ Σ ⟹ ·).
- Plus the shared: `.hero/.stats`, `.card/.grid`, `table`, `figure`+`figcaption` (lightbox),
  `.note/.note.warn/.note.ok/.note.src`, `ol.steps`, `.flow`, `.pill`, `.codewrap`+copy,
  `.gsearch`+`#glist` glossary.

## JavaScript (keep all of it)
scroll progress + scroll-spy; lightbox on `figure img`; `cp(btn)` copy; glossary live filter
from `GLOSSARY`; **quiz grading** (`pick`); **worked reveal** (`reveal`); **flip cards**
(`flip`); **read tracking** (`toggleRead`); **progress persistence** (`saveProgress` /
`loadProgress` / `resetProgress`) and **tracker rendering** (`updateTracker`). Two things to
edit per book: the `GLOSSARY` array, and the chapter id list in `updateTracker`
(`const chaps=['c3','c4','c5','c6']`) + the "/ N" denominators — keep them in sync with your
`data-chap` / `data-read` ids.

## Filling rules
- Replace ALL d2l text, the chapter map, equations, worked examples, quizzes, glossary, and
  the cover with the target book's real, **sourced** content.
- **Math offline only** — never add a KaTeX/MathJax CDN (breaks the offline-first rule). The
  `.eq`/`.m` styles + unicode are enough for the formulas a learning page needs.
- Media: relative `assets/...` only; download with `scripts/fetch-media.sh`; never reference a
  file you didn't successfully download.
- Write each chapter's explanation from figures you actually viewed.
- Cite sources on the page (a "出处" `.note.src` link per chapter / load-bearing table).
- Keep quiz `data-correct` indices honest and the explanations correct — a wrong answer key
  teaches the wrong thing.
