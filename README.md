## Overview

Personal dotfiles for macOS, Linux, and Windows. Includes configurations for zsh, bash, vim, tmux, and development tools.

## Features

- **Shell configurations**: zsh and bash with modern plugins and aliases
- **Version management**: mise for unified tool version management (Node.js, Python, Ruby, etc.)
- **Package manager unification**: ni for working with npm/yarn/pnpm/bun seamlessly
- **Terminal multiplexer**: tmux with custom configurations
- **Editor**: vim with sensible defaults
- **Workspace management**: Unified workspace system for cloud-synced and local directories (see [WORKSPACE.md](WORKSPACE.md))
- **Automatic deployment**: Makefile-based symlink management

## Installation

### Quick installation
To quickly install:
```console
$ curl -sL dot.omata.me | sh
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

## Post-installation

### Setup mise and ni

After deploying dotfiles, set up development tools:

```bash
# Install mise via Homebrew (macOS)
brew install mise

# Run mise setup script
bash ~/.dotfiles/etc/init/mise_setup.sh

# Restart shell
exec $SHELL
```

This will install:
- Node.js LTS
- Bun (latest)
- ni (package manager unifier)

See `.config/mise/README.md` for detailed usage.

## Credits

Acknowledgments; I established this dotfiles referring to the following user's repositories. Thanks.
* [@b4b4r07's dotfiles](https://github.com/b4b4r07/dotfiles)
* [@nicknisi's dotfile](https://github.com/nicknisi/dotfiles)
