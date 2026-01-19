# AeroSpace Setup - Implementation and Alternatives

## Implemented Solution

I have created an AeroSpace setup script following the same pattern as `mise_setup.sh`:

### Files Created

1. **`etc/init/aerospace_setup.sh`** - Standalone setup script
   - Checks if AeroSpace is installed
   - Copies `.config/aerospace/aerospace.toml` to `~/.config/aerospace/`
   - Creates backup if file already exists
   - Reloads AeroSpace configuration
   - Provides helpful usage information

2. **`etc/init/osx/40_aerospace.sh`** - macOS init integration
   - Automatically runs during `make init` on macOS
   - Gracefully skips if AeroSpace is not installed
   - Calls `aerospace_setup.sh`

### Usage

```bash
# Manual execution (standalone)
bash ~/.dotfiles/etc/init/aerospace_setup.sh

# Automatic execution (during make init)
make init  # Runs on macOS after brew installation
```

## Alternative Approaches Considered

### 1. Using Symlinks Instead of Copying

**Pros:**
- Config stays in sync with the repository
- Changes can be committed to version control
- No need to re-run setup after config updates

**Cons:**
- Breaks the current pattern (`.config` is excluded from Makefile)
- Might conflict with AeroSpace's config reload behavior

**Implementation:**
```bash
ln -sfnv "$DOTPATH/.config/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
```

### 2. Integrating into Makefile Deploy

**Pros:**
- Unified deployment process
- Works like other dotfiles

**Cons:**
- Would require changing Makefile EXCLUSIONS
- `.config` contains multiple tools (mise, aerospace)
- Need selective deployment logic

**Implementation:**
Modify Makefile to deploy specific `.config` subdirectories:
```makefile
deploy-config:
	@ln -sfnv $(DOTPATH)/.config/aerospace $(HOME)/.config/aerospace
```

### 3. Selective Symlink Deployment

**Pros:**
- Best of both worlds
- Configs stay in sync
- Follows dotfiles philosophy

**Implementation:**
Add to Makefile or create a separate config deployment script:
```bash
# Deploy .config subdirectories
for dir in .config/*/; do
    name=$(basename "$dir")
    case "$name" in
        aerospace|mise)
            mkdir -p "$HOME/.config"
            ln -sfnv "$DOTPATH/.config/$name" "$HOME/.config/$name"
            ;;
    esac
done
```

## Recommendation

The current implementation (copying files) is recommended because:

1. **Consistency**: Follows the same pattern as `mise_setup.sh`
2. **Safety**: Users can modify their local configs without affecting the repository
3. **Simplicity**: Easy to understand and maintain
4. **Flexibility**: Users can customize without worrying about git conflicts

However, if you prefer configs to stay in sync with the repository, I recommend **Alternative 3 (Selective Symlink Deployment)**, which would provide a cleaner solution for managing `.config` directories.

## Additional Improvements

1. **Create a README for AeroSpace config**
   - Document keybindings
   - Explain workspace organization
   - List application routing rules

2. **Add validation script**
   - Check `aerospace.toml` syntax before deployment
   - Use `aerospace validate-config` if available

3. **Integration with borders**
   - The config references `borders` for window borders
   - Could add setup for borders as well
