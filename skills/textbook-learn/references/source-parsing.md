# Source parsing & sourcing — the make-or-break of textbook-learn

A book has a single authoritative source (unlike an open topic), which helps — but the failure
mode is sharper: **a learning page that prints a wrong formula, a misstated definition, or an
invented exercise teaches falsehoods, and the quiz then drills them in.** So the bar is:
**every formula, definition, figure, and quiz answer must be checkable against an actual
page/section of the book, and cited.**

## Getting the book's content

Pick the path that fits the input:
- **Online book (HTML site, e.g. d2l.ai, an "online edition"):** fetch the actual section
  pages. This is the cleanest — you get exact equation numbering, the real exercises at the
  end of each section, and stable figure paths.
- **PDF/EPUB the user supplies:** read it directly (the Read tool handles PDFs; for EPUB,
  unzip and read the XHTML). Pull the real TOC, the chosen chapters' text, equations, and
  end-of-chapter exercises. Note page numbers for citations.
- **Book with an official repo (many CS books ship figures/code on GitHub):** the figures
  often live there (e.g. `img/*.svg`). List the repo tree via the GitHub API
  (`/git/trees/<branch>?recursive=1`) and take **real** paths from the listing — never guess
  a filename.

## Rules

1. **Every load-bearing item carries a source.** Equations, definitions, theorems, headline
   numbers (adoption, edition year, stars), and every quiz answer come from the real book.
   Put the source on the page (a "出处" link to the section / a page number).
2. **Quote equations and definitions faithfully.** Use the book's own form and its equation
   numbering as a locator (e.g. "(4.1.10)"). Render offline with `.eq`/`.m` + unicode — don't
   paraphrase a formula into something subtly different.
3. **Exercises are gold — use the real ones.** Most textbooks end sections with exercises.
   They are the faithful seed for active-recall questions. Turn a real exercise into an MCQ or
   a flip card; cite it ("原书练习 5a"). Don't invent exercises the book doesn't have.
4. **Flag any numbers you compute.** If a worked example needs a concrete calculation the book
   doesn't print (e.g. softmax of a specific vector), do the math correctly **and** label it
   "演算示例，书中未印此数 / illustrative computation". Never present your numbers as the book's.
5. **Flag uncertainty; never paper over it.** Can't confirm an edition date, an adoption
   figure, whether a figure exists? Say "未核实 / unverified" rather than inventing a plausible
   value. A short honest gap is fine; a confident fabrication is not.
6. **Dates are absolute, and note staleness.** Convert "recently" to real dates; stamp fetched
   data ("⭐ as of <date>"). If the book's repo is dormant (last push long ago), say so where
   it matters (e.g. pinned version numbers in the install section).

## Media sourcing

- **Figures:** the book's site (`_images/<name>`) or its official repo's `img/` are the best
  stills. Many are **SVG** — `fetch-media.sh` accepts SVG (and fixes Git LFS pointers for
  raster). Verify each download is a real image (the script does, and drops failures).
- **Status-check before relying.** Guessed image paths 404. Take figure names from the real
  TOC/section or the repo tree listing; if you didn't successfully download it, don't
  reference it.
- **Auto-generated plots are not stable files.** Some books render activation curves / fitted
  lines from live code at build time — those have hashed `output_*.svg` names that aren't
  durable. Don't hard-link them; use the hand-drawn named diagrams instead.
- **The cover** is a nice hero image — usually under the site's `static/` or the repo root.
  Confirm it's a real image, not a placeholder.

## A good parse return looks like

Per chapter: title + source URL/page; 3–5 faithful takeaways; the key equations **with their
book numbers**; one worked example (book-derived, numbers flagged if yours); the **real
exercises** verbatim-ish with citations; and the figure path(s) confirmed to exist — plus a
separate "could not verify" list. If a subagent hands back confident prose with no citations
or a formula with no equation number, send it back for sources.
