# Vim Configuration

This directory contains my Vim configuration files.

## File Structure

```
.vim/
├── autoload/           # Auto-loaded scripts (created automatically)
│   └── plug.vim       # vim-plug plugin manager script
├── init.vim              # Main configuration file
├── plugins/              # Plugin configurations
│   └── init.vim         # Plugin manager settings
├── settings/            # Vim settings
│   ├── base.vim        # Basic settings and utility functions
│   ├── file.vim        # File-related settings
│   ├── keymap.vim      # Key mappings
│   └── ui.vim          # UI settings
└── README.md           # This documentation
```

## Key Features

- Plugin management using vim-plug
- Organized configuration structure
- Custom key mappings
- Utility functions for common tasks

## Recent Changes (2024-04-27)

- Fixed plugin initialization order
- Added OS detection functions (IsMac, IsLinux, IsWindows)
- Improved plugin management with vim-plug
- Organized settings into separate files
- Added utility functions for file operations

## Requirements

- Vim 8.0 or later
- Git (for plugin installation)
- curl (for vim-plug installation)

## Installation

1. Clone this repository to your home directory:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```

2. Create symbolic links:
   ```bash
   ln -s ~/.dotfiles/.vim ~/.vim
   ln -s ~/.dotfiles/.vimrc ~/.vimrc
   ```

3. Start Vim and install plugins:
   ```bash
   vim +PlugInstall +qall
   ```

## Customization

- To add new plugins, edit `plugins/init.vim`
- To modify key mappings, edit `settings/keymap.vim`
- To change UI settings, edit `settings/ui.vim`
- To add custom functions, edit `settings/base.vim`

## Troubleshooting

If you encounter any issues:

1. Check the Vim startup messages for errors
2. Verify that all required plugins are installed
3. Ensure that the configuration files are properly linked
4. Check the file permissions of the configuration files

## License

MIT License 