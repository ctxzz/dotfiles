#!/usr/bin/env bash
#
# Symlink selected ~/.claude config from this repo, using the same `ln -sfnv`
# convention as `make deploy`. Claude Code's runtime state under ~/.claude
# (projects/, todos/, history/, shell-snapshots/, settings.local.json, ...) is
# left untouched: config files are linked individually, and skills are linked
# per-directory so runtime/global skills already in ~/.claude/skills (e.g.
# session-start-hook) are preserved alongside the repo's skills.
#
# Usage:
#   DOTPATH=/path/to/dotfiles bash etc/deploy/claude.sh           # deploy
#   DOTPATH=/path/to/dotfiles bash etc/deploy/claude.sh --clean   # remove links
#
set -euo pipefail

: "${DOTPATH:?DOTPATH must be set}"

CLAUDE_SRC="$DOTPATH/.claude"
CLAUDE_DST="$HOME/.claude"

# Single-file config linked directly into ~/.claude. *.local.json is omitted so
# it stays machine-local.
FILES=(CLAUDE.md settings.json ai.env)
SKILLS_SRC="$CLAUDE_SRC/skills"
SKILLS_DST="$CLAUDE_DST/skills"

if [ "${1:-}" = "--clean" ]; then
  for f in "${FILES[@]}"; do
    [ -L "$CLAUDE_DST/$f" ] && rm -vf "$CLAUDE_DST/$f"
  done
  if [ -d "$SKILLS_SRC" ]; then
    for d in "$SKILLS_SRC"/*/; do
      [ -L "$SKILLS_DST/$(basename "$d")" ] && rm -vf "$SKILLS_DST/$(basename "$d")"
    done
  fi
  exit 0
fi

mkdir -p "$CLAUDE_DST"
for f in "${FILES[@]}"; do
  src="$CLAUDE_SRC/$f"
  [ -e "$src" ] || { echo "skip (missing in repo): $f"; continue; }
  ln -sfnv "$src" "$CLAUDE_DST/$f"
done

if [ -d "$SKILLS_SRC" ]; then
  mkdir -p "$SKILLS_DST"
  for d in "$SKILLS_SRC"/*/; do
    ln -sfnv "${d%/}" "$SKILLS_DST/$(basename "$d")"
  done
fi
