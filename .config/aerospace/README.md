# AeroSpace Configuration

AeroSpace is a tiling window manager for macOS that provides i3-like window management with a modern approach.

## Installation

AeroSpace is installed via Homebrew:

```bash
brew install --cask aerospace
```

## Setup

After installing AeroSpace, run the setup script to deploy the configuration:

```bash
bash ~/.dotfiles/etc/init/aerospace_setup.sh
```

## Configuration Overview

### Workspace Organization

The configuration uses a semantic workspace system:

#### High-level Contexts
- **I** (Inbox) - New items, triage
- **O** (Office) - Work browser (Arc)
- **P** (Private) - Personal browser (Dia)

#### Role-based Workspaces
- **R** (Resource) - Resource management (Obsidian, GoodNotes, Preview, Acrobat)
- **W** (Web) - Web browsing (Chrome)
- **E** (Editor) - Coding (VSCode, Cursor)
- **T** (Terminal) - Terminal (Warp)

#### Generic Workspaces
- **1, 2, 3** - General purpose workspaces

## Keybindings

### Focus Navigation
- `Alt+H` - Focus left
- `Alt+J` - Focus down
- `Alt+K` - Focus up
- `Alt+L` - Focus right

### Window Movement
- `Alt+Shift+H` - Move window left
- `Alt+Shift+J` - Move window down
- `Alt+Shift+K` - Move window up
- `Alt+Shift+L` - Move window right

### Workspace Switching
- `Alt+[I|O|P]` - Switch to Inbox/Office/Private
- `Alt+[R|W|E|T]` - Switch to role-based workspaces
- `Alt+[1|2|3]` - Switch to generic workspaces
- `Alt+Tab` - Switch to previous workspace

### Window Management
- `Alt+Shift+[Letter]` - Move window to corresponding workspace
- `Alt+Shift+Tab` - Move workspace to next monitor
- `Alt+/` - Toggle horizontal/vertical layout
- `Alt+,` - Toggle accordion layout
- `Alt+Shift+-` - Decrease window size
- `Alt+Shift+=` - Increase window size

### Service Mode
- `Alt+Shift+;` - Enter service mode
  - `Esc` - Reload config and exit
  - `R` - Flatten workspace tree
  - `F` - Toggle floating/tiling
  - `Backspace` - Close all windows except current

## Application Routing

Windows are automatically routed to workspaces:

- Obsidian, GoodNotes, Preview, Acrobat → **R** (Resource)
- Google Chrome → **W** (Web)
- Arc Browser → **O** (Office)
- Dia Browser → **P** (Private)
- Notion → **P** (Private)
- VSCode, Cursor → **E** (Editor)
- Warp → **T** (Terminal)

Some apps float by default:
- Finder
- System Preferences
- QuickTime Player
- Activity Monitor
- Console
- 1Password

## Window Borders

The configuration includes integration with `borders` for visual window indication:

```bash
brew install borders
```

Borders will be automatically started with AeroSpace.

## Customization

To customize your configuration:

1. Edit `~/.config/aerospace/aerospace.toml`
2. Reload configuration: `Alt+Shift+;` then `Esc`

Or reload from command line:

```bash
aerospace reload-config
```

## Troubleshooting

### AeroSpace not responding to keybindings

1. Check if AeroSpace has accessibility permissions:
   - System Preferences → Security & Privacy → Privacy → Accessibility
   - Ensure AeroSpace is checked

2. Verify AeroSpace is running:
   ```bash
   ps aux | grep -i aerospace
   ```

3. Check configuration syntax:
   ```bash
   aerospace list-workspaces
   ```

### Configuration not loading

Reload the configuration:
```bash
aerospace reload-config
```

Or restart AeroSpace:
```bash
killall AeroSpace
open -a AeroSpace
```

## Resources

- [AeroSpace Official Documentation](https://nikitabobko.github.io/AeroSpace/guide)
- [AeroSpace GitHub Repository](https://github.com/nikitabobko/AeroSpace)

## See Also

- `SETUP.md` - Setup implementation details and alternative approaches
- `.config/aerospace/aerospace.toml` - Full configuration file
