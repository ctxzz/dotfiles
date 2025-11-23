# Project Context

Personal dotfiles repository for shell configurations, editor settings, and development tools. Manages configurations via symlinks for reproducibility across macOS and Linux systems.

## Tech Stack

- **Shells**: Zsh (primary), Bash
- **Editors**: Vim/Neovim
- **Multiplexer**: Tmux
- **Package Manager**: Homebrew (macOS)
- **Runtime Manager**: mise
- **Plugin Managers**: zinit (Zsh), vim-plug (Vim), TPM (Tmux)

## Repository Structure

```
.
├── .zsh/              # Modular Zsh configs (numbered for load order)
├── .vim/              # Vim configs and settings
├── .tmux/             # Tmux configs and plugins
├── bin/               # Custom executable scripts
├── etc/
│   ├── install        # Installation script
│   ├── init/          # OS-specific initialization
│   └── lib/           # Utility libraries
└── Makefile           # Deployment commands
```

## Key Commands

```bash
make install    # Full setup (update + deploy + init)
make deploy     # Create symlinks to home directory
make list       # Show files to be deployed
make init       # Run OS-specific initialization
make update     # Update repo and submodules
```

## Important Principles

### 1. Non-Destructive Operations
- **NEVER** overwrite files without backups
- Always use symlinks, never copy files
- Check before destructive operations
- Create timestamped backups: `.backup.YYYYMMDD_HHMMSS`

### 2. Cross-Platform Support
- Support both macOS and Linux
- Use platform detection before OS-specific operations
- Check tool availability: `command -v tool &> /dev/null`
- Graceful fallbacks for missing tools

### 3. Idempotent Scripts
- Safe to run multiple times
- Check state before making changes
- No data loss on repeated execution

## Code Standards

### Shell Scripts
```bash
#!/usr/bin/env bash
set -euo pipefail  # Fail fast

# Always quote variables
echo "$variable"

# Check tool availability
if command -v tool &> /dev/null; then
    tool --version
fi

# Platform detection
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS specific
fi
```

### Zsh Configuration
- Files prefixed with numbers for load order (00-70)
- Each file has specific purpose (functions, aliases, completion, etc.)
- Use `has()` function to check command availability

## Git Workflow

### Commit Messages
Use conventional commits format:
```
type: Brief description (50 chars max)

Detailed explanation of what and why.

- Bullet points for multiple changes
- Reference related files or issues
```

Types: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`

### Branch Naming
- `feature/description` - New features
- `fix/issue` - Bug fixes
- `config/tool` - Configuration updates
- `docs/description` - Documentation

### Safety Rules
- **NEVER** `git push --force` to main branch
- **NEVER** commit secrets (.env, keys, credentials)
- Review changes with `git diff` before commit
- Run tests/linters before commit

## Files to Never Modify

- `.git/` - Git internals
- `.gitmodules` - Submodule configuration
- `*.backup.*` - Backup files (don't commit)

## Files Requiring Extra Care

- `Makefile` - Central to deployment
- `etc/install` - Installation script with backup logic
- `etc/lib/vital.sh` - Core utilities used everywhere

## Testing Before Commit

```bash
# Lint shell scripts
shellcheck .zsh/*.zsh bin/* etc/install

# Check syntax
zsh -n .zsh/*.zsh
bash -n .bashrc

# Verify symlinks
make list
```

## Security

### Never Commit
- API keys, tokens, passwords
- SSH private keys (`id_rsa*`, `id_ed25519*`)
- SSL certificates (`*.pem`, `*.key`)
- Environment files (`.env*`)
- Credentials of any kind

### Template Files
Use template files for user-specific data:
```bash
# .tmp.gitconfig (template)
[user]
    name = YOUR_NAME
    email = YOUR_EMAIL
```

## Common Patterns

### Adding New Tool
1. Add to Brewfile (if using Homebrew)
2. Add config to appropriate `.zsh/` file:
   - Aliases → `40_alias.zsh`
   - Functions → `10_functions.zsh`
   - Initialization → `00_base.zsh`
3. Add availability check
4. Test on clean environment
5. Commit with clear message

### Tool Initialization Pattern
```bash
# Always check availability first
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi
```

## Troubleshooting

### Symlinks Not Working
```bash
make list          # Check what would be deployed
ls -la ~/.*        # Verify symlinks
make deploy        # Recreate symlinks
```

### Config Not Loading
```bash
source ~/.zshrc    # Reload
zsh -n file.zsh    # Check syntax
```

### Plugin Issues
```bash
# Update plugins
zinit update --all       # Zsh
:PlugUpdate             # Vim
git submodule update    # Tmux (TPM)
```

## Platform-Specific Notes

### macOS
- Homebrew: Install from Brewfile (`etc/init/osx/Brewfile`)
- Path: `/opt/homebrew/bin` (Apple Silicon) or `/usr/local/bin` (Intel)
- Initialization: `etc/init/osx/`

### Linux
- Package manager varies by distribution
- Manual package installation may be needed
- Initialization: `etc/init/linux/`

## Development Workflow

1. Make changes to configs
2. Test locally: `source ~/.zshrc`
3. Run linters: `/lint`
4. Review changes: `/review`
5. Commit with good message: `/commit-help`
6. Test on clean environment (if possible)

---

**Remember**: These are personal dotfiles. Always backup before deploying to new systems. Test in isolated environments when possible.
