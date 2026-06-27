# Page design — what's in the template and how to fill it

`assets/template.html` is a complete, working example (the OmAgent study page). It is a
**single self-contained HTML file** (inline CSS + JS) that references a sibling
`assets/` folder for media, so it opens offline by double-click. Reuse its CSS and JS
verbatim; replace the content.

## Layout
- **Left sidebar**: brand + two-tier table of contents, sticky, with scroll-spy
  highlighting and a progress bar. Collapses on narrow screens.
- **Right column**: the content sections.

## Section list (the proven order)
Org mode uses all of these; single-repo mode drops the "organization" group (0-2 become
a single short intro).

**Organization layer** (org mode only)
- `0` 30-second overview (hero: banner image, one-paragraph pitch, stat chips)
- `1` What is <org> (positioning)
- `2` Project map + selection guide (repo table, "want X → start with Y")
- `2b` **Per-repo profiles** — a detailed card/subsection for each of the top ~5-8 repos
  (what it is, features, how it differs, when to use, stars + last-update, a representative
  image, link). This is the depth users want; a table row isn't enough. Use `.card` in a
  grid, or one short subsection per repo with a `figure`.

**Deep-dive layer (the target / flagship repo)**
- `3` What it is (功能 + demos)
- `4` Target domain & highlights (novel/useful points, results table)
- `5` Architecture (architecture diagram + module cards)
- `6` Tech principle (data-flow, mechanisms; written from the actual diagrams)
- `6b` **Code structure & tech stack** — language breakdown (from `/languages` API),
  key dependencies (from the manifest file), an annotated top-level directory tree
  (`<pre>` or `.flow`), and a "read these files first, in this order" list. See
  workflow.md Step 1.5. Use a table for the stack, `<pre>`/`.flow` for the tree, `.card`s
  or `ol.steps` for the reading order.
- `7` Deploy & use — official (requirements + copy-able commands)
- `8` Hands-on record (env-check + setup scripts; placeholder to backfill — don't auto-install)

**Extension & reference**
- `9` Related GitHub projects (siblings + external comparables; function/diff/stars/last-update)
- `10` Learning videos (项目专属 vs 相关主题; honest about gaps)
- `11` Glossary (searchable)

Keep nav order === DOM order or the scroll-spy highlight desyncs. Every nav `href="#sN"`
needs a matching `id="sN"` section. (Note: in the example the video section's id is `s11`
and the glossary's is `s10`, ordered s9 → s11 → s10 in both nav and DOM — match whatever
you choose.)

## Component inventory (classes already styled)
- `.hero` + `.stats/.stat` — top hero with stat chips
- `.card` in `.grid.g2/.g3` — feature/selection cards
- `table` — repo tables, results tables (use `td .s` for the highlighted number)
- `figure` + `figcaption` — images; **all figure imgs are click-to-zoom (lightbox)**
- `.imgrow` — two-up figures
- `.note` / `.note.warn` / `.note.ok` — callouts
- `ol.steps` — numbered step lists
- `.flow` with `.node`/`.arr`/`.loop` — inline pipeline/DAG diagrams (text, no image needed)
- `.pill.a/.b/.c/.d` — colored chips (e.g. operator/algorithm tags)
- `.codewrap` + `.bar` + `<button class="copybtn" onclick="cp(this)">` — code blocks with copy
- `.vgrid` + `.vcard` — video cards (thumbnail + play overlay + platform `.vbadge.bili/.yt`)
- `.gsearch` + `#glist` driven by the `GLOSSARY` array in JS — searchable glossary

## JavaScript (keep all of it)
- scroll progress bar + scroll-spy active-link
- lightbox: clicking any `figure img` opens a full-screen zoom (Esc / click to close)
- `cp(btn)` copy-to-clipboard for code blocks
- glossary live filter from the `GLOSSARY` array — edit that array, the search is automatic

## Filling rules
- Replace ALL om-ai-lab/OmAgent text, the repo table, glossary entries, and video cards
  with the target project's real content.
- Media: relative `assets/...` paths only. Download with `scripts/fetch-media.sh`.
- Don't reference an image you didn't successfully download (verify size/header first).
- Write architecture/principle from the diagrams you actually viewed, not README prose.
