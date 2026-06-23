-- after/ftplugin/markdown.lua
-- Use vim-markdown's (Vim-era) syntax for markdown instead of Neovim's
-- built-in treesitter highlighting. Neovim's core ftplugin/markdown.lua calls
-- vim.treesitter.start(); this file runs right after it (same FileType cycle,
-- before the first redraw) and stops treesitter, then loads the Vim syntax so
-- markdown looks like it did under Vim (vim-polyglot / vim-markdown).
pcall(vim.treesitter.stop)
if vim.bo.syntax ~= "markdown" then
  vim.bo.syntax = "markdown"
end
