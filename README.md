## Overview

Personal dotfiles for managing shell configurations (Zsh, Bash), Vim, Tmux, Git, and development tools. Supports macOS and Linux with symlink-based deployment.

## Installation

### Quick installation
To quickly install:
```console
$ curl -sL dot.omata.me | sh
```

### Manual installation
```bash
# Clone repository
git clone https://github.com/ctxzz/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Full installation (update + deploy + init)
make install

# Or install specific components
./etc/install shell    # Shell configs only
./etc/install vim      # Vim configs only
./etc/install git      # Git configs only
```

### Available commands
```bash
make list      # Show dot files in this repo
make deploy    # Create symlinks to home directory
make init      # Setup environment settings
make update    # Update repository and submodules
make clean     # Remove symlinks
```

## Claude Code Integration

This repository includes Claude Code configuration for AI-assisted development.

### Available Custom Commands

- `/review` - Review staged changes for quality and security
- `/lint` - Run appropriate linters on code files
- `/commit-help` - Get help crafting good commit messages

### Configuration Files

- `CLAUDE.md` - Project context and guidelines
- `.claude/commands/` - Custom slash commands
- `.claude/settings.json` - Project settings

See `CLAUDE.md` for detailed repository guidelines.

## Credits

Acknowledgments; I established this dotfiles referring to the following user's repositories. Thanks.
* [@b4b4r07's dotfiles](https://github.com/b4b4r07/dotfiles)
* [@nicknisi's dotfile](https://github.com/nicknisi/dotfiles)
