# Shared learning-page design system

Every skill in this family produces the same kind of artifact: a **single
self-contained HTML page** (inline CSS + JS) with a left TOC and right content, that
opens offline by double-click and references a sibling `assets/` folder for media.
`template.html` in this folder is the canonical shell — copy it, keep its CSS and JS,
replace the content. This doc explains what's in it so any new skill stays consistent.

## Why one shell
The value of a *family* is that a learner recognizes the experience instantly, whatever
the source. Don't reinvent the layout per skill — vary the **content and pedagogy**, not
the chrome.

## Layout
- **Left sidebar**: brand + (optionally multi-tier) table of contents, sticky, with
  scroll-spy highlighting and a top progress bar. Collapses on narrow screens.
- **Right column**: the content sections. Each `<section id="sN">` matches a nav
  `href="#sN"`. Keep nav order === DOM order or scroll-spy desyncs.

## Component inventory (classes already styled in template.html)
- `.hero` + `.stats/.stat` — top hero with stat chips
- `.card` in `.grid.g2/.g3` — feature / selection / profile cards
- `table` — comparison and data tables (`td .s` for a highlighted number)
- `figure` + `figcaption` — images; **all figure imgs are click-to-zoom (lightbox)**
- `.imgrow` — two-up figures
- `.note` / `.note.warn` / `.note.ok` — callouts
- `ol.steps` — numbered step lists (reading orders, install steps)
- `.flow` with `.node`/`.arr`/`.loop` — inline pipeline / DAG / tree diagrams (text, no image)
- `.pill.a/.b/.c/.d` — colored chips (tags, operators, categories)
- `.codewrap` + `.bar` + `<button class="copybtn" onclick="cp(this)">` — code blocks with copy
- `.vgrid` + `.vcard` — video cards (thumbnail + play overlay + platform `.vbadge`)
- `.gsearch` + `#glist` driven by the `GLOSSARY` array in JS — searchable glossary
- `<pre>` — annotated directory trees / file layouts

## Interaction JS (keep all of it)
- scroll progress bar + scroll-spy active-link
- **lightbox**: clicking any `figure img` opens a full-screen zoom (Esc / click to close)
- `cp(btn)` copy-to-clipboard for code blocks
- glossary live filter from the `GLOSSARY` array — edit the array, search is automatic

## Extending for a new skill
Add new section types by composing existing components — e.g. a "quiz" for
`textbook-learn` can be a `.card` with a JS reveal; an interactive demo for
`domain-learn` is a `<canvas>`/WebGL block inside a `figure`-like container with its own
inline script. Keep the shell, the TOC behavior, and the offline-first rule.

## The non-negotiables
- Self-contained: inline CSS+JS, no external CDN. Relative `assets/...` paths only.
- Verify every downloaded media file is a real image before referencing it (see
  `fetch-media.sh`).
- Faithful, never fabricated. If a thing doesn't exist, say so on the page.
