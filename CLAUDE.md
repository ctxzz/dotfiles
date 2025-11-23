# Dotfiles Management with Claude Code

## Project Overview

This repository contains personal dotfiles for managing shell configurations (Zsh, Bash), Vim, Tmux, Git, and development tools. The goal is to provide a reproducible development environment across macOS and Linux systems.

## Directory Structure

```
/home/user/dotfiles/
├── .bash_profile           # Bash profile configuration
├── .bashrc                 # Bash configuration
├── .gitconfig.template     # Git configuration template
├── .latexmkrc             # LaTeX build configuration
├── .tmux.conf             # Tmux configuration
├── .vimrc                 # Vim entry point
├── .zshenv                # Zsh environment variables
├── .zshrc                 # Zsh main configuration (loads .zsh/)
├── .zsh/                  # Modular Zsh configuration
│   ├── 00_base.zsh       # Base settings, environment, paths
│   ├── 10_functions.zsh  # Custom shell functions
│   ├── 20_completion.zsh # Completion system
│   ├── 30_keybind.zsh    # Key bindings
│   ├── 40_alias.zsh      # Command aliases
│   ├── 50_setopt.zsh     # Zsh options
│   ├── 60_zinit.zsh      # Plugin manager (zinit)
│   └── 70_misc.zsh       # Miscellaneous settings
├── .vim/                  # Vim configuration
│   ├── init.vim          # Main Vim configuration
│   ├── plugins/          # Plugin configurations
│   └── settings/         # Organized settings (base, file, keymap, ui)
├── .tmux/                # Tmux-related files
│   ├── bin/              # Tmux utilities
│   └── plugins/          # TPM (Tmux Plugin Manager)
├── bin/                  # Custom executable scripts
│   ├── path             # Path utility
│   └── tmuxx            # Tmux auto-attach script
├── etc/                  # Installation and initialization
│   ├── install          # Main installation script
│   ├── init/            # OS-specific initialization
│   │   ├── init.sh      # Main init orchestrator
│   │   ├── linux/       # Linux-specific scripts
│   │   └── osx/         # macOS-specific scripts (Homebrew, Brewfile)
│   ├── lib/             # Utility libraries
│   │   └── vital.sh     # Core utility functions (600+ lines)
│   └── test/            # Test scripts
├── Makefile              # Main deployment and management commands
└── README.md             # User documentation
```

## Critical Principles

### 1. Non-Destructive Operations
- **NEVER** overwrite existing configuration files without creating backups
- Always ask user before making destructive changes
- Use `etc/install` script which includes backup mechanism
- Create timestamped backups: `.backup.YYYYMMDD_HHMMSS`

### 2. Symlink-Based Deployment
- All dotfiles are managed via symbolic links (symlinks)
- **NEVER** copy files directly to home directory
- Use `make deploy` to create/update symlinks
- Symlinks allow changes to propagate immediately without reinstall
- Verify symlinks with `make list` before deploying

### 3. Modular and Independent
- Configurations should work independently (shell, vim, tmux can be installed separately)
- Use `etc/install` with arguments: `shell`, `vim`, `git`, `osx`, `linux`
- Each module can be tested in isolation
- No hard dependencies between modules

### 4. Cross-Platform Compatibility
- Support both macOS and Linux
- Use platform detection: `is_osx()`, `is_linux()` functions in `.zsh/10_functions.zsh`
- OS-specific initialization in `etc/init/{osx,linux}/`
- Check tool availability before using: `has()` function or `command -v`

### 5. Idempotent Installation
- All scripts must be safe to run multiple times
- Symlink creation should skip if already correct
- No data loss even if run multiple times on same machine
- Use checks like `[[ ! -L "$target" ]]` before creating symlinks

## Installation & Deployment

### Main Commands (via Makefile)

```bash
make install   # Full installation: update + deploy + init
make deploy    # Create symlinks from dotfiles to home directory
make init      # Run OS-specific initialization scripts
make update    # Update repository and git submodules (TPM)
make clean     # Remove symlinks and repository
make list      # Show files to be deployed
make test      # Run test suite
```

### Selective Installation

```bash
./etc/install              # Interactive installation
./etc/install all          # Install everything
./etc/install shell        # Install only shell configs
./etc/install vim          # Install only Vim configs
./etc/install git          # Install only Git configs
./etc/install osx          # Run macOS-specific initialization
./etc/install linux        # Run Linux-specific initialization
```

### Quick Install (from remote)

```bash
curl -sL dot.omata.me | sh
```

## Code Style & Conventions

### Shell Scripts

- **Shebang**: Use `#!/usr/bin/env bash` for bash scripts
- **Error Handling**: Use `set -e` for critical scripts (installation, deployment)
- **Variable Quoting**: Always quote variables: `"$var"` not `$var`
- **Constants**: Use UPPER_CASE for constants and environment variables
- **Functions**: Use lowercase with underscores: `my_function()`
- **Conditionals**: Use `[[ ]]` for bash, `[ ]` for POSIX
- **Comments**: Required for complex logic, prefer Japanese for personal notes

### Zsh Configuration Conventions

- **File Naming**: Numbered prefixes control load order (00-70)
- **Load Order**: 00_base → 10_functions → 20_completion → 30_keybind → 40_alias → 50_setopt → 60_zinit → 70_misc
- **Modular**: Each file has a specific purpose, keep concerns separated
- **Conditionals**: Skip configuration when inappropriate (e.g., running from Vim, as sudo)

### Vim Configuration

- **Entry Point**: `.vimrc` sources `.vim/init.vim`
- **Plugin Manager**: vim-plug
- **Organization**: Settings split into `settings/{base,file,keymap,ui}.vim`
- **Plugins**: Defined in `plugins/init.vim`

## Plugin Management

- **Zsh**: zinit (auto-installs if missing)
- **Vim**: vim-plug
- **Tmux**: TPM (Tmux Plugin Manager) - managed as git submodule

## Testing Requirements

### Before Committing

1. **Shellcheck Linting**: All shell scripts must pass
   ```bash
   shellcheck .zsh/*.zsh bin/* etc/install etc/init/**/*.sh
   ```

2. **Syntax Validation**: Source Zsh files to check for errors
   ```bash
   zsh -n .zsh/*.zsh
   ```

3. **Symlink Verification**: Ensure all symlinks are correct
   ```bash
   make list
   ```

4. **Manual Testing**: Test on clean environment if possible
   - Use Docker container for isolated testing
   - Test on both macOS and Linux when possible

## Git Workflow

### Branch Naming
- `feature/description` - New features or enhancements
- `fix/issue` - Bug fixes
- `config/tool` - Configuration updates for specific tools
- `docs/description` - Documentation improvements

### Commit Messages
- Use imperative mood: "Add mise support", not "Added mise support"
- Be descriptive: Explain what and why, not just what
- Reference tools/files changed: "Add mise aliases to .zsh/40_alias.zsh"
- Multi-line for complex changes:
  ```
  Add mise (polyglot runtime manager) support

  - Added mise to Brewfile for Homebrew installation
  - Added mise activation in .zsh/00_base.zsh
  - Added 15 convenient aliases in .zsh/40_alias.zsh
  - Added 4 utility functions in .zsh/10_functions.zsh
  ```

### Commit Safety
- **NEVER** use `git commit --force` or `git push --force`
- **ALWAYS** review changes with `git diff` before committing
- Run `git status` to confirm staged files
- Verify no secrets in `.env`, credentials, API keys before committing

## Key Files - Special Handling

### DO NOT Modify Directly
- `.gitmodules` - Git submodule configuration (TPM)
- `.git/` - Git internal directory
- `*.backup.*` - Backup files (should not be committed)

### Requires Careful Review
- `Makefile` - Central to deployment, test thoroughly
- `etc/install` - Installation script, backup mechanism critical
- `etc/lib/vital.sh` - Core utilities used by multiple scripts
- `.zsh/00_base.zsh` - Base configuration, affects all Zsh sessions

### Template Files (User Must Customize)
- `.tmp.gitconfig` - Template for Git configuration (user must set name/email)

## Environment-Specific Considerations

### macOS Specific
- Homebrew installation: `etc/init/osx/10_brew.sh`
- Brewfile: `etc/init/osx/Brewfile` (contains all brew packages)
- Bundle installation: `etc/init/osx/20_bundle.sh`
- macOS defaults: `etc/init/osx/macos_defaults.sh`
- Path: `/opt/homebrew/bin` (Apple Silicon) or `/usr/local/bin` (Intel)

### Linux Specific
- Package installation: `etc/init/linux/linux_install.sh`
- System settings: `etc/init/linux/linux_settings.sh`
- May need to install dependencies manually on some distributions

### Tool Availability
- **ALWAYS** check if tools exist before using:
  ```bash
  if command -v mise &> /dev/null; then
      eval "$(mise activate zsh)"
  fi
  ```
- Graceful fallback if tools are missing
- Document required tools in README.md

## Backup Strategy

### Automatic Backups
- `etc/install` creates timestamped backups of existing files
- Format: `.backup.YYYYMMDD_HHMMSS`
- Location: Same directory as original file

### Manual Backups
- Before major changes, manually backup: `cp file file.backup`
- Keep backups outside repository for safety
- Consider using version control for important configs

## Testing with Claude Code

### Recommended Workflow
1. Make changes to dotfiles
2. Run `/test-configs` to validate
3. Run `/symlink-check` to verify symlinks
4. Run `/dotfiles-review` before committing
5. Commit with descriptive message
6. Test on clean system (Docker/VM) before deploying to production

### Custom Commands Available
- `/dotfiles-install` - Guide through installation process
- `/test-configs` - Run comprehensive tests (shellcheck, syntax validation)
- `/symlink-check` - Verify all symlinks are correct
- `/dotfiles-review` - Review changes for best practices

## Special Notes

### Japanese Language Support
- Comments in configuration files may be in Japanese
- LaTeX configuration supports Japanese (platex/uplatex with dvipdfmx)
- Maintain Japanese comments when present

### Current Tools Managed
- **Runtime Managers**: mise (polyglot), direnv
- **Shell**: Zsh (with zinit), Bash
- **Editor**: Vim (with vim-plug)
- **Multiplexer**: Tmux (with TPM)
- **CLI Tools**: fzf, ripgrep, bat, eza, delta, fd, ghq, gh
- **Development**: Git, Docker, Kubernetes tools
- **Package Manager**: Homebrew (macOS)

### Common Patterns

#### Adding New Tool Configuration
1. Check if tool is already in Brewfile (macOS)
2. Add configuration to appropriate `.zsh/` file based on type:
   - Aliases → `40_alias.zsh`
   - Functions → `10_functions.zsh`
   - Base settings → `00_base.zsh`
   - Plugin → `60_zinit.zsh`
3. Add initialization with availability check
4. Document in CLAUDE.md
5. Test on clean environment

#### Adding New Alias
1. Open `.zsh/40_alias.zsh`
2. Add to appropriate section (git, docker, kubernetes, etc.)
3. Follow existing naming conventions
4. Test: `source ~/.zshrc` and verify alias works
5. Commit with clear message

#### Adding New Function
1. Open `.zsh/10_functions.zsh`
2. Add function with:
   - Availability checks for required tools
   - Error handling (`return 1` on failure)
   - Clear purpose and documentation
3. Test thoroughly
4. Commit

## Security Considerations

### Sensitive Data
- **NEVER** commit secrets, API keys, tokens, passwords
- Use `.gitignore` for sensitive files
- Template files (`.tmp.gitconfig`) for user-specific data
- Review diffs carefully before committing

### Safe Scripting
- Use `set -e` in critical scripts to fail fast
- Validate user input before using
- Check for dangerous operations (rm -rf, etc.)
- Use absolute paths when possible to avoid ambiguity

## Troubleshooting

### Symlinks Not Working
```bash
make list          # Check what would be deployed
make deploy        # Recreate symlinks
ls -la ~/.*        # Verify symlinks point to correct location
```

### Zsh Configuration Not Loading
```bash
source ~/.zshrc    # Reload configuration
zsh -n .zsh/*.zsh  # Check for syntax errors
echo $ZDOTDIR      # Verify Zsh directory
```

### Plugin Issues
```bash
# Zsh (zinit)
zinit self-update
zinit update --all

# Vim (vim-plug)
:PlugUpdate
:PlugClean

# Tmux (TPM)
git submodule update --init --recursive
~/.tmux/plugins/tpm/bin/install_plugins
```

### Homebrew Issues
```bash
brew doctor        # Diagnose issues
brew update        # Update Homebrew
brew upgrade       # Upgrade packages
brew bundle --file=etc/init/osx/Brewfile  # Install from Brewfile
```

## Additional Resources

- Repository: https://github.com/ctxzz/dotfiles
- Quick Install: https://dot.omata.me
- Documentation: README.md in repository root

---

**Remember**: Safety first! Always create backups, verify changes, and test in isolated environments when possible. These dotfiles manage critical development environment configurations.
