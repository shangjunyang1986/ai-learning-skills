# Library hub — build & refresh

The hub is a single offline page that **indexes every learning page you've generated**, grouped
by source type, with search and a per-page learn-status toggle. It's built by a script so it
stays in sync with whatever's actually on disk — re-run it any time to refresh.

## Build it

```bash
python skills/learn/scripts/build-hub.py <root> [<root2> …] \
    --out <root>/learn-hub --title "我的学习库" [--date YYYY-MM-DD]
```

- **`<root>`** — one or more folders to scan for learning pages. Each page is a folder with an
  `index.html` (and usually an `assets/`). Defaults to `.`.
- **`--out`** — where to write the hub (default `<first root>/learn-hub`). The hub's own folder
  is excluded from the scan so it never indexes itself.
- **`--title`** — the header title shown on the hub.
- **`--date`** — stamp shown in the footer (default: today). Pass it explicitly for
  reproducible output.

Output: `<out>/index.html` — self-contained, double-click to open. It links to each page with
**relative** paths, so keep the hub under the same root as the pages (or re-run after moving
them).

## How pages are classified (first hit wins)

1. **Explicit meta** — `<meta name="learn:type" content="paper-learn">` in the page. The most
   robust; future family templates can emit this. (`learn:source` sets the card subtitle.)
2. **Folder layout** — an ancestor folder named like a skill: `…/paper-learn/<name>/index.html`.
   This is the canonical `samples/<skill>/<name>/` layout and classifies cleanly with no meta.
3. **Content heuristics** — tell-tale markup/strings (a claim-check / scaled-dot-product →
   paper; quizzes / a progress tracker → textbook; a roadmap → domain; org/repo overview →
   github).
4. **`other`** — couldn't tell. Shown under "其它"; fix by adding a `learn:type` meta or moving
   the page under a `<skill>/` folder.

**Recommended layout** for clean auto-classification when you keep pages outside `samples/`:
group them by type — `~/learning/<skill>/<name>-learn/` — or let future pages carry the
`learn:type` meta.

## What the hub can and can't track

- **Per-page learn status** (未开始 / 在学 / 学完) is stored in the **hub's own** localStorage,
  keyed by the page's relative path. It persists across reloads of the hub.
- It **cannot** read a textbook page's internal quiz/chapter progress — those live in *that*
  page's localStorage under a different file origin, unreadable from the hub. So the hub tracks
  library-level status you set on the hub, not the fine-grained in-page progress. That's a real
  browser limitation, stated honestly rather than faked.

## Thumbnails

The script picks one image from each page's `assets/` — preferring `cover*` / `hero*` /
`banner*` / `front*` / `fig1*`, else the first image. SVG/PNG/JPG/GIF all work. If a page has
no `assets/`, the card shows a colored gradient placeholder with the title's first character.

## Refreshing

Re-run the same command after generating new pages or changing status-worthy content. The hub
is regenerated from scratch each run; the user's learn-status (in localStorage) is preserved
because it's keyed by page path, not baked into the file.
