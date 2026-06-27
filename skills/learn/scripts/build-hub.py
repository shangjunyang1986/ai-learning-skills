#!/usr/bin/env python3
"""build-hub.py — generate an offline "learning library" index over *-learn pages.

Scans one or more ROOT dirs for learning pages (folders containing an index.html
produced by the ai-learning-skills family), classifies each by its source type,
and writes OUTDIR/index.html (the hub) from assets/hub-template.html, with
relative links + thumbnails to each page. Fully offline, no deps beyond stdlib.

Usage:
  python build-hub.py [ROOT ...] [--out OUTDIR] [--title TITLE] [--date YYYY-MM-DD]

Examples:
  python build-hub.py samples --out samples/learn-hub --title "学习库 · 样例"
  python build-hub.py ~/learning --out ~/learning/_hub

Classification order (first hit wins):
  1. <meta name="learn:type" content="paper-learn"> in the page (explicit, future-proof)
  2. an ancestor folder named like a known skill (the canonical samples/<skill>/<name>/ layout)
  3. content heuristics (tell-tale markup/strings of each page type)
  4. "other"
Pages may carry <meta name="learn:source" content="..."> to set the card subtitle;
otherwise a short source is derived from the <title>.
"""
import os, sys, re, json, argparse, datetime

SKILLS = ['github-project-learn', 'domain-learn', 'textbook-learn', 'paper-learn']

# (regex on lowercased html) -> type, tried in order as a fallback
HEURISTICS = [
    (r'vd-hyp|claim-check|声明核查|缩放点积|attention\(q', 'paper-learn'),
    (r'data-correct|主动回忆|读完本章|class="tracker"|chapmap', 'textbook-learn'),
    (r'class="roadmap"|rstage|学习路线|入门\s*→\s*进阶', 'domain-learn'),
    (r'相关\s*github\s*项目|github\s*组织|项目全景|组织全景', 'github-project-learn'),
]
IMG_EXT = ('.png', '.jpg', '.jpeg', '.webp', '.svg', '.gif')
THUMB_PRIORITY = ('cover', 'hero', 'banner', 'front', 'fig1', 'architecture')


def read(path):
    try:
        with open(path, 'r', encoding='utf-8', errors='ignore') as f:
            return f.read()
    except OSError:
        return ''


def classify(html, page_dir):
    m = re.search(r'<meta\s+name=["\']learn:type["\']\s+content=["\']([^"\']+)["\']', html, re.I)
    if m and m.group(1).strip() in SKILLS:
        return m.group(1).strip()
    parts = os.path.normpath(page_dir).replace('\\', '/').split('/')
    for p in reversed(parts):
        if p in SKILLS:
            return p
    low = html.lower()
    for pat, t in HEURISTICS:
        if re.search(pat, low):
            return t
    return 'other'


def title_of(html, fallback):
    m = re.search(r'<title>(.*?)</title>', html, re.S | re.I)
    t = re.sub(r'\s+', ' ', m.group(1)).strip() if m else ''
    return t or fallback


def source_of(html, title):
    m = re.search(r'<meta\s+name=["\']learn:source["\']\s+content=["\']([^"\']+)["\']', html, re.I)
    if m:
        return m.group(1).strip()
    # derive: drop a trailing "· 副标题" and common suffixes
    s = re.split(r'\s[·|]\s', title)[0]
    for suf in ('学习手册', '学习页', '精读', 'Learning'):
        s = s.replace(suf, '')
    return s.strip()


def pick_thumb(page_dir):
    assets = os.path.join(page_dir, 'assets')
    if not os.path.isdir(assets):
        return None
    imgs = [f for f in sorted(os.listdir(assets)) if f.lower().endswith(IMG_EXT)]
    if not imgs:
        return None
    for key in THUMB_PRIORITY:
        for f in imgs:
            if f.lower().startswith(key):
                return os.path.join(assets, f)
    return os.path.join(assets, imgs[0])


def rel(path, start):
    return os.path.relpath(path, start).replace('\\', '/')


def find_pages(roots, outdir):
    out_abs = os.path.abspath(outdir)
    seen = []
    for root in roots:
        for dirpath, dirnames, filenames in os.walk(root):
            if os.path.abspath(dirpath).startswith(out_abs):
                dirnames[:] = []
                continue
            if 'index.html' in filenames:
                idx = os.path.join(dirpath, 'index.html')
                html = read(idx)
                if '<!--learn-hub' in html:          # never index another hub
                    continue
                if 'class="wrap"' not in html and 'learning-page' not in html and \
                   not re.search(r'<aside class="side"', html):
                    # crude family-page sniff; skip unrelated index.html files
                    if classify(html, dirpath) == 'other' and 'lcard' not in html:
                        pass  # keep going — still index it as "other" if it has a title
                seen.append((idx, dirpath, html))
                dirnames[:] = [d for d in dirnames if d != 'assets']
    return seen


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('roots', nargs='*', default=['.'])
    ap.add_argument('--out', default=None, help='output dir for the hub (default: <first root>/learn-hub)')
    ap.add_argument('--title', default='我的学习库')
    ap.add_argument('--date', default=datetime.date.today().isoformat())
    a = ap.parse_args()
    roots = a.roots or ['.']
    outdir = a.out or os.path.join(roots[0], 'learn-hub')
    os.makedirs(outdir, exist_ok=True)

    entries = []
    for idx, page_dir, html in find_pages(roots, outdir):
        title = title_of(html, os.path.basename(page_dir))
        t = classify(html, page_dir)
        thumb = pick_thumb(page_dir)
        entries.append({
            'id': rel(page_dir, outdir),
            'title': title,
            'type': t,
            'source': source_of(html, title),
            'href': rel(idx, outdir),
            'thumb': rel(thumb, outdir) if thumb else None,
        })
    order = {s: i for i, s in enumerate(SKILLS)}
    entries.sort(key=lambda e: (order.get(e['type'], 99), e['title']))

    here = os.path.dirname(os.path.abspath(__file__))
    tpl = read(os.path.join(here, '..', 'assets', 'hub-template.html'))
    tpl = tpl.replace('/*__LIBRARY__*/[]', json.dumps(entries, ensure_ascii=False))
    tpl = tpl.replace('/*__GENDATE__*/', a.date)
    tpl = tpl.replace('/*__TITLE__*/', a.title.replace('"', '\\"'))
    with open(os.path.join(outdir, 'index.html'), 'w', encoding='utf-8') as f:
        f.write(tpl)

    by = {}
    for e in entries:
        by[e['type']] = by.get(e['type'], 0) + 1
    print('hub ->', os.path.join(outdir, 'index.html'))
    print('indexed', len(entries), 'pages:', ', '.join(f'{k}={v}' for k, v in sorted(by.items())))


if __name__ == '__main__':
    main()
