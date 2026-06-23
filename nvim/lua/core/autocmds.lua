-- core/autocmds.lua
-- Autocommands ported from .vim/settings/ui.vim and .vim/plugins/language.vim.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Transparent background (was ui.vim: s:apply_transparent_bg) ---------------
-- Re-applied on ColorScheme so it survives catppuccin loading / reloads.
local transparent_groups = {
  "Normal", "LineNr", "CursorLine", "CursorLineNr", "SignColumn",
  "Pmenu", "PmenuSbar", "PmenuThumb", "ColorColumn", "Folded",
  "FoldColumn", "NonText", "SpecialKey", "EndOfBuffer",
}

local function apply_transparent_bg()
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
  -- Statusline colours matched the old config's bold blue / grey scheme.
  vim.api.nvim_set_hl(0, "StatusLine", { fg = "#87afff", bg = "none", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#4e4e4e", bg = "none" })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = "#5f5f5f", bg = "none" })
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5f5f5f", bg = "none" })
end

local transparent_grp = augroup("TransparentBG", { clear = true })
autocmd({ "VimEnter", "ColorScheme" }, {
  group = transparent_grp,
  callback = apply_transparent_bg,
})

-- Make the helper reusable (e.g. from plugin specs after a theme switch).
_G.apply_transparent_bg = apply_transparent_bg

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
