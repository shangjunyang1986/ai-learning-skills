# Page design — domain-learn sections & components

`assets/template.html` is a complete worked example (the **3D Gaussian Splatting** page). It
is a **single self-contained HTML file** (inline CSS + JS) referencing a sibling `assets/`
folder, so it opens offline by double-click. Reuse its CSS and JS verbatim; replace content.

This is the same shell as the rest of the family (`learning-page-design.md` in the repo's
`shared/`). What's specific to `domain-learn` is the **roadmap pedagogy** and the
**interactive demo**.

## Section list (the proven order for a topic)
Adapt names to the topic; keep the journey shape.

- `0` 30-second overview (hero image/teaser, one-paragraph pitch, stat chips: venue/year, a
  headline number, a "vs the alternative" hook)
- `1` What it is & why it matters (intuition; a "vs the thing it replaces" comparison table)
- `2` **Learning roadmap** — the four-stage `.roadmap` (入门 → 进阶 → 实践 → 前沿) with
  resources mapped to each stage. This is the spine of a domain page.
- `3` Core method/principle, step by step (write it from the actual figures; `ol.steps`)
- `4` **Interactive demo** (the `.demo` component) — when the topic admits one. The killer
  feature. See `interactive-demos.md`.
- `5` Key results / numbers (a sourced comparison table)
- `6` Ecosystem & tools (grouped tables with **real GitHub-API stars**; live in-browser demos)
- `7` Hands-on pipeline (the real workflow + copy-able commands; don't necessarily install)
- `8` Frontier directions (a few representative, sourced follow-ups + a live tracker link)
- `9` Learning videos (项目/主题相关; YouTube covers + Bilibili links; honest about gaps)
- `10` Glossary (searchable, via the `GLOSSARY` array)

Keep nav order === DOM order or scroll-spy desyncs; every nav `href="#sN"` needs a matching
`id="sN"`.

## Component inventory (already styled)
Same as the family shell, plus two domain-specific patterns:
- `.roadmap` + `.rstage` — the four color-coded learning-stage cards (section 2).
- `.demo` + `.ctrl` + `<canvas>` — the interactive playground (section 4), with its IIFE in
  the `<script>`. Adapt the bundled 2D-splatting demo to your topic.
- Plus the shared: `.hero/.stats`, `.card/.grid`, `table` (with `td .s` highlighted number),
  `figure`+`figcaption` (lightbox), `.note/.note.warn/.note.ok`, `ol.steps`, `.flow`
  pipelines, `.pill` chips, `.codewrap`+copy button, `.vgrid/.vcard` video cards
  (`.vbadge.yt`/`.vbadge.bili`; `.vthumb .ph` is a gradient placeholder for cover-less
  cards, e.g. Bilibili), `.gsearch`+`#glist` glossary.

## JavaScript (keep all of it)
scroll progress + scroll-spy; lightbox on `figure img`; `cp(btn)` copy; glossary live filter
from the `GLOSSARY` array; and the interactive-demo IIFE. Edit the `GLOSSARY` array for the
topic's jargon.

## Filling rules
- Replace ALL 3DGS text, the roadmap, tables, glossary, videos, and the demo with the target
  topic's real, **sourced** content.
- Media: relative `assets/...` only; download with `scripts/fetch-media.sh`; never reference
  a file you didn't successfully download.
- Write the principle section from figures you actually viewed.
- Cite sources on the page (a "出处" link per load-bearing claim/table).
