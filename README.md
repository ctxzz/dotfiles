## Overview

Personal dotfiles for macOS, Linux, and Windows. Includes configurations for zsh, bash, vim, tmux, and development tools.

## Features

- **Shell configurations**: zsh and bash with modern plugins and aliases
- **Version management**: mise for unified tool version management (Node.js, Python, Ruby, etc.)
- **Package manager unification**: ni for working with npm/yarn/pnpm/bun seamlessly
- **Terminal multiplexer**: tmux with custom configurations
- **Editor**: Neovim (Lua + lazy.nvim, see [`nvim/`](nvim/)); legacy Vim config kept under `.vim/`
- **Workspace management**: Unified workspace system for cloud-synced and local directories (see [WORKSPACE.md](WORKSPACE.md))
- **Claude Code config**: `.claude/` (CLAUDE.md, settings, custom skills) deployed into `~/.claude` without touching runtime state
- **Automatic deployment**: Makefile-based symlink management

## Installation

### Quick installation
To quickly install:
```console
curl -sL dot.omata.me | sh
```

### Manual installation

```bash
# Clone the repository
git clone https://github.com/ctxzz/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Deploy dotfiles (create symlinks)
make deploy

# Run initialization scripts (macOS)
make init

# Or do everything at once
make install
```

## Claude Code config

`make deploy` also symlinks `.claude/` into `~/.claude` directly from the Makefile,
using the same `ln -sfnv` convention as the rest. Config files (`CLAUDE.md`,
`settings.json`, `ai.env`) and each skill under `skills/` are linked individually,
so Claude Code's runtime state (`projects/`, `history/`, `settings.local.json`,
global skills, …) is left untouched.

The `gen-image` / `review-image` skills resolve their API keys at run time from
1Password references in `.claude/ai.env` (no secrets in the repo):

```bash
op signin                       # once per session
# skills call: op run --env-file=$HOME/.claude/ai.env -- python3 ...
```

## Credits

Acknowledgments; I established this dotfiles referring to the following user's repositories. Thanks.
* [@b4b4r07's dotfiles](https://github.com/b4b4r07/dotfiles)
* [@nicknisi's dotfile](https://github.com/nicknisi/dotfiles)
