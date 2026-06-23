-- ~/.config/nvim/init.lua
-- Neovim entry point. Migrated from the legacy Vim config (.vimrc / .vim/*).
-- Layout:
--   lua/core/options.lua   -- vim.opt settings (was settings/base.vim + ui.vim)
--   lua/core/keymaps.lua   -- global key mappings (was settings/keymap.vim)
--   lua/core/autocmds.lua  -- autocommands (was ui.vim + plugins/language.vim)
--   lua/core/lazy.lua      -- lazy.nvim bootstrap + plugin spec loader
--   lua/plugins/*.lua      -- per-plugin lazy.nvim specs

-- Leader keys must be set before plugins load so their mappings pick them up.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")
