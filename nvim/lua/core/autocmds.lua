-- core/autocmds.lua
-- Autocommands ported from .vim/settings/ui.vim and .vim/plugins/language.vim.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Style tweaks for a Vim-like look (was ui.vim: s:apply_transparent_bg) -----
-- Background transparency itself is handled by catppuccin's
-- `transparent_background = true` (see plugins/colorscheme.lua), which keeps
-- each group's foreground colour while clearing the background. We deliberately
-- DO NOT loop over groups calling nvim_set_hl(group, { bg = "none" }) here:
-- nvim_set_hl REPLACES the whole highlight, so that would wipe the foreground
-- colours catppuccin set (Vim's `:hi Normal guibg=NONE` preserved fg; this
-- did not). We only re-assert the old config's bold-blue statusline scheme,
-- with full fg+bg specs so nothing is clobbered.
local function apply_style()
  vim.api.nvim_set_hl(0, "StatusLine", { fg = "#87afff", bg = "none", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#4e4e4e", bg = "none" })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = "#5f5f5f", bg = "none" })
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5f5f5f", bg = "none" })
end

local style_grp = augroup("VimLikeStyle", { clear = true })
autocmd({ "VimEnter", "ColorScheme" }, {
  group = style_grp,
  callback = apply_style,
})

-- Make the helper reusable (e.g. from plugin specs after a theme switch).
_G.apply_style = apply_style

-- Drop fileencoding for pure-ASCII files (was ui.vim BufReadPost) -----------
local my_grp = augroup("MyAutoCmd", { clear = true })
autocmd("BufReadPost", {
  group = my_grp,
  callback = function()
    if vim.bo.modifiable and vim.fn.search("[^\\x00-\\x7F]", "cnw") == 0 then
      vim.bo.fileencoding = ""
    end
  end,
})

-- Filetype-specific indentation (was language.vim language_settings) --------
local lang_grp = augroup("language_settings", { clear = true })
local indent = {
  markdown = { sw = 2, ts = 2, sts = 2, expandtab = true },
  python = { sw = 4, ts = 4, expandtab = true },
  javascript = { sw = 2, ts = 2, expandtab = true },
  typescript = { sw = 2, ts = 2, expandtab = true },
  go = { sw = 4, ts = 4, expandtab = false },
  rust = { sw = 4, ts = 4, expandtab = true },
}
autocmd("FileType", {
  group = lang_grp,
  pattern = vim.tbl_keys(indent),
  callback = function(args)
    local cfg = indent[args.match]
    if not cfg then
      return
    end
    vim.bo.expandtab = cfg.expandtab
    vim.bo.shiftwidth = cfg.sw
    vim.bo.tabstop = cfg.ts
    if cfg.sts then
      vim.bo.softtabstop = cfg.sts
    end
  end,
})
