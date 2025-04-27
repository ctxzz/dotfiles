# Zsh Configuration Files

This directory contains the Zsh configuration files for the dotfiles setup.

## File Structure

```
.zsh/
├── .zshenv                # Environment variables and basic settings
├── 00_base.zsh           # Basic shell settings
├── 10_functions.zsh      # Custom shell functions
├── 20_completion.zsh     # Completion settings
├── 30_keybind.zsh        # Key bindings
├── 40_alias.zsh          # Shell aliases
├── 50_setopt.zsh         # Shell options
├── 60_zinit.zsh          # Plugin manager (zinit) configuration
├── 70_misc.zsh           # Miscellaneous settings
└── README.md             # This documentation
```

## Key Features

### Plugin Management (zinit)
- zsh-completions: Enhanced completion system
- zsh-syntax-highlighting: Command syntax highlighting
- zsh-history-substring-search: Enhanced history search
- zsh-autosuggestions: Command suggestions based on history
- fzf: Fuzzy finder integration
- enhancd: Enhanced directory navigation
- pure: Minimal and fast prompt theme

### Key Bindings
- `^P`/`^N`: History navigation
- `^F`/`^B`: Word movement
- `^A`/`^E`: Line movement
- `^R`/`^S`: Incremental search
- `^_`/`^X^U`: Undo/Redo
- `^X^E`: Edit command line

### Functions
- `fd`: Fuzzy directory navigation
- `fda`: Fuzzy directory navigation (including hidden)
- `fe`: Fuzzy file search and edit
- `devpath`: Development directory navigation
- `gcd`: Git repository navigation
- `fh`: Recent file search
- `fgb`: Git branch navigation
- `fkill`: Process management
- `dex`: Docker Compose execution
- `dlogs`: Docker container logs
- `fbr`: Git branch navigation
- `fcd`: Directory stack navigation

## Recent Changes

### 2024-04-27
- Simplified key bindings configuration
- Removed duplicate and unused key bindings
- Streamlined plugin configuration
- Removed redundant syntax highlighting plugin
- Removed unused 256-color support plugin
- Optimized plugin loading order

## Requirements

- Zsh 5.9 or later
- zinit plugin manager
- fzf
- ghq (for repository management)
- Docker (for container-related functions)

## Installation

1. Clone this repository
2. Run the installation script
3. Restart your terminal

## Customization

To customize the configuration:

1. Edit the respective configuration files
2. Add your own functions to `10_functions.zsh`
3. Add your own aliases to `40_alias.zsh`
4. Modify key bindings in `30_keybind.zsh`

## Troubleshooting

If you encounter any issues:

1. Check the loading order of configuration files
2. Verify plugin dependencies
3. Ensure all required tools are installed
4. Check for conflicting key bindings 