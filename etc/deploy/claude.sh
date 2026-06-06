#!/usr/bin/env bash
#
# Deploy ~/.claude from this repo WITHOUT clobbering Claude Code's runtime state
# (projects/, todos/, history/, shell-snapshots/, ...). Only selected config
# items are symlinked; everything else under ~/.claude is left untouched.
#
# Usage:
#   DOTPATH=/path/to/dotfiles bash etc/deploy/claude.sh           # deploy
#   DOTPATH=/path/to/dotfiles bash etc/deploy/claude.sh --clean   # remove links
#
set -euo pipefail

: "${DOTPATH:?DOTPATH must be set}"

CLAUDE_SRC="$DOTPATH/.claude"
CLAUDE_DST="$HOME/.claude"
BACKUP_DIR="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup}/claude-$(date +%Y%m%d%H%M%S)"

# Items to symlink into ~/.claude. settings.local.json / backups / logs and the
# runtime dirs are intentionally NOT listed so they stay local.
ITEMS=(CLAUDE.md settings.json skills ai.env)

if [ "${1:-}" = "--clean" ]; then
  for item in "${ITEMS[@]}"; do
    dst="$CLAUDE_DST/$item"
    if [ -L "$dst" ]; then
      rm -f "$dst"
      echo "remove: $dst"
    fi
  done
  exit 0
fi

echo "==> Deploy .claude config to $CLAUDE_DST (runtime state preserved)."
mkdir -p "$CLAUDE_DST"

for item in "${ITEMS[@]}"; do
  src="$CLAUDE_SRC/$item"
  dst="$CLAUDE_DST/$item"

  if [ ! -e "$src" ]; then
    echo "skip (missing in repo): $item"
    continue
  fi

  # Already the correct symlink: nothing to do.
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok:   $dst -> $src"
    continue
  fi

  # Back up an existing real file/dir before replacing it.
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
    echo "backup: $dst -> $BACKUP_DIR/$item"
  fi

  ln -sfn "$src" "$dst"
  echo "link: $dst -> $src"
done
