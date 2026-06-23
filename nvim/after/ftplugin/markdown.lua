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

-- Continue list items on <Enter>/o/O. vim-markdown normally sets this up, but
-- it is lazy-loaded so the timing is unreliable; set it explicitly here (this
-- file runs after every markdown ftplugin) so a `- ` / `* ` / `1.` line keeps
-- its marker on the next line instead of dropping to a bare new line.
vim.opt_local.comments = { "b:>", "b:*", "b:+", "b:-" }
vim.opt_local.formatoptions:append("r") -- insert comment/list leader after <Enter>
vim.opt_local.formatoptions:append("o") -- ...and after o/O
vim.opt_local.formatoptions:append("n") -- recognise numbered lists (formatlistpat)
vim.opt_local.formatlistpat = [[^\s*\d\+[.)]\s\+\|^\s*[-*+]\s\+]]
