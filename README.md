## Overview

Personal dotfiles for macOS, Linux, and Windows. Includes configurations for zsh, bash, vim, tmux, and development tools.

## Features

- **Shell configurations**: zsh and bash with modern plugins and aliases
- **Version management**: mise for unified tool version management (Node.js, Python, Ruby, etc.)
- **Package manager unification**: ni for working with npm/yarn/pnpm/bun seamlessly
- **Terminal multiplexer**: tmux with custom configurations
- **Editor**: Neovim (Lua + lazy.nvim, see [`nvim/`](nvim/))
- **Workspace management**: Unified workspace system for cloud-synced and local directories (see [WORKSPACE.md](WORKSPACE.md))
- **Claude Code config**: `claude/` (CLAUDE.md, settings, custom skills) deployed into `~/.claude` without touching runtime state
- **Automatic deployment**: Makefile-based symlink management

## Installation

### Quick installation
To quickly install:
```console
curl -sL dot.omata.me | bash
```

The installer is a bash script ([`etc/install`](etc/install)); piping it to `sh`
(dash on Debian/Ubuntu) does not work. To review it before running:

```console
curl -sL dot.omata.me -o /tmp/dotfiles-install
less /tmp/dotfiles-install
bash /tmp/dotfiles-install
```

It clones this repo to `~/.dotfiles` and runs `make deploy`. Append `-s init`
(`curl -sL dot.omata.me | bash -s init`) to also run `make init`.

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

`make install` runs `update` (git pull + submodules) → `deploy` → `init`.
On macOS, `init` runs `brew update` / `brew upgrade` and installs the Brewfile.

### Deploy / uninstall

- `make deploy` symlinks dotfiles into `$HOME`. If a real (non-symlink) file or
  directory already exists at a target path, it is moved to
  `<path>.bak.<timestamp>` before linking — nothing is overwritten.
- `make clean` removes only symlinks that point into this repo; real files,
  backups and links owned by anything else are left alone.
- `make uninstall` runs `make clean` and then deletes the repo itself.

### Tests

- `make test` is read-only: ShellCheck (bash/sh scripts incl. `etc/install`,
  `etc/lib`, `bin/`), `zsh -n` (`.zshrc`, `.zshenv`, `.zsh/`), and deploy tests.
- `make lint-fix` applies ShellCheck's auto-fixes (modifies files).

## Claude Code config

`make deploy` also symlinks `claude/` into `~/.claude` directly from the Makefile,
using the same `ln -sfnv` convention as the rest. Config files (`CLAUDE.md`,
`settings.json`, `ai.env`) and each skill under `skills/` are linked individually,
so Claude Code's runtime state (`projects/`, `history/`, `settings.local.json`,
global skills, …) is left untouched. The source directory is deliberately
dot-less so Claude Code does not pick it up as project config while you are
editing the dotfiles repo itself.

The `gen-image` / `review-image` skills resolve their API keys at run time from
1Password references in `claude/ai.env` (no secrets in the repo):

```bash
op signin                       # once per session
# skills call: op run --env-file=$HOME/.claude/ai.env -- python3 ...
```

## Credits

Acknowledgments; I established this dotfiles referring to the following user's repositories. Thanks.
* [@b4b4r07's dotfiles](https://github.com/b4b4r07/dotfiles)
* [@nicknisi's dotfile](https://github.com/nicknisi/dotfiles)
