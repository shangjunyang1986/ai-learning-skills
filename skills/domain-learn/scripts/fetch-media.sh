#!/usr/bin/env bash
# fetch-media.sh — robust media downloader for the github-project-learn skill.
# Handles the two gotchas that bite every run:
#   1. GitHub images are often Git LFS -> raw.githubusercontent.com returns a tiny
#      pointer file. Auto-detect and re-fetch from media.githubusercontent.com.
#   2. Some hosts (e.g. bilibili i*.hdslb.com) refuse direct TLS in this env.
#      Route those through the weserv image proxy.
#
# Usage:
#   ./fetch-media.sh <out_dir> <name1=url1> [name2=url2 ...]
# Example:
#   ./fetch-media.sh assets banner=https://raw.githubusercontent.com/o/r/main/docs/img/b.png
#
# Run in the Bash tool (git-bash curl), NOT Windows cmd curl — schannel blocks some hosts.

set -u
OUT="${1:?usage: fetch-media.sh <out_dir> name=url ...}"; shift
mkdir -p "$OUT"

is_lfs_pointer() {  # $1=file -> 0 if it's a git-lfs pointer (tiny text stub)
  [ -f "$1" ] && [ "$(stat -c%s "$1" 2>/dev/null || echo 0)" -lt 300 ] && \
    head -c 60 "$1" | grep -q "git-lfs.github.com"
}

lfs_url() {  # rewrite raw.githubusercontent.com -> media.githubusercontent.com/media
  echo "$1" | sed 's#raw\.githubusercontent\.com#media.githubusercontent.com/media#'
}

proxify() {  # wrap a blocked host in the weserv proxy (strip scheme; drop @-resize suffix)
  local u="${1#http://}"; u="${u#https://}"; u="${u%%@*}"
  echo "https://images.weserv.nl/?url=${u}&w=640&output=jpg"
}

for pair in "$@"; do
  name="${pair%%=*}"; url="${pair#*=}"; dest="$OUT/$name"
  curl -sSL --max-time 40 -o "$dest" "$url"

  # Fix Git LFS pointers
  if is_lfs_pointer "$dest"; then
    curl -sSL --max-time 40 -o "$dest" "$(lfs_url "$url")"
  fi

  # If still tiny/failed and it's a known-blocked host, try the image proxy
  sz=$(stat -c%s "$dest" 2>/dev/null || echo 0)
  if [ "$sz" -lt 1024 ] && echo "$url" | grep -qE 'hdslb\.com|bilibili'; then
    curl -sSL --max-time 40 -o "$dest" "$(proxify "$url")"
    sz=$(stat -c%s "$dest" 2>/dev/null || echo 0)
  fi

  # YouTube thumbnails: maxresdefault often 404s -> a ~1KB gray placeholder. Walk down
  # the resolution ladder and accept the first that's a real image (>2KB).
  if [ "$sz" -lt 2048 ] && echo "$url" | grep -q 'img\.youtube\.com/vi/'; then
    vid=$(echo "$url" | sed -E 's#.*/vi/([^/]+)/.*#\1#')
    for res in maxresdefault sddefault hqdefault mqdefault; do
      curl -sSL --max-time 30 -o "$dest" "https://img.youtube.com/vi/$vid/$res.jpg"
      sz=$(stat -c%s "$dest" 2>/dev/null || echo 0)
      [ "$sz" -gt 2048 ] && break
    done
  fi

  # Validate: real image magic AND not a tiny placeholder. Drop failures so the page
  # never references a broken/gray cover. Magic check via hex (robust on binary).
  magic=$(head -c4 "$dest" 2>/dev/null | od -An -tx1 | tr -d ' \n')
  case "$magic" in
    89504e47|47494638|52494646) is_img=1 ;;   # PNG | GIF | RIFF(webp)
    ffd8ff*)                    is_img=1 ;;   # JPEG
    *) head -c64 "$dest" 2>/dev/null | grep -qiE '<svg|<\?xml' && is_img=1 || is_img=0 ;;
  esac
  if [ "$sz" -gt 2048 ] && [ "$is_img" = 1 ]; then
    echo "OK    $name  ${sz}B  (magic:${magic})"
  else
    rm -f "$dest"
    echo "DROP  $name  ${sz}B  (not a valid image; removed) url=$url"
  fi
done
echo "Note: any DROP lines above were removed — do NOT reference them in the page."
