-- core/options.lua
-- Editor options. Ported from .vim/settings/base.vim, ui.vim and the encoding
-- bits of .vim/plugins/language.vim. Behaviour is kept equivalent to the old
-- Vim config; intentional changes are noted inline and in nvim/README.md.

local opt = vim.opt

-- Encoding / file handling (was base.vim + language.vim) --------------------
-- NOTE: Neovim is always UTF-8 internally, so 'encoding' is not set here.
opt.fileencoding = "utf-8"
opt.fileencodings = { "utf-8", "iso-2022-jp", "euc-jp", "ucs-2le", "ucs-2", "cp932" }
opt.fileformats = { "unix", "dos", "mac" }
opt.backspace = { "indent", "eol", "start" }
opt.autoread = true
opt.hidden = true
opt.history = 1000
opt.helplang = { "ja", "en" }

-- Backups / swap / persistent undo (was base.vim) --------------------------
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
-- CHANGED: undo lives under Neovim's own data dir (stdpath('data')/undo)
-- instead of ~/.vim/undo, so Vim and Neovim do not share undo files.
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir

-- System clipboard (was base.vim) ------------------------------------------
opt.clipboard = "unnamedplus"

-- Indentation (was base.vim) -----------------------------------------------
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true

-- Performance (was base.vim) -----------------------------------------------
-- NOTE: 'lazyredraw' is intentionally NOT set; it interacts badly with modern
-- Lua plugins/noice-style UIs. Drop it for Neovim (see README).
opt.updatetime = 300
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10

-- Completion (was base.vim) ------------------------------------------------
opt.completeopt = { "menuone", "noinsert", "noselect" }
opt.pumheight = 10

-- UI (was ui.vim) ----------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.showcmd = true
opt.showmode = true
opt.laststatus = 2
opt.wildmenu = true
opt.showmatch = true
opt.wrap = true
opt.linebreak = true
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.signcolumn = "yes"

-- Search (was ui.vim) ------------------------------------------------------
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Colors (was ui.vim) ------------------------------------------------------
opt.termguicolors = true
opt.background = "dark"
-- The colorscheme itself is applied by lua/plugins/colorscheme.lua once
-- catppuccin is installed by lazy.nvim.

-- Custom statusline (kept identical to ui.vim for behavioural parity) -------
opt.statusline = "%f %m%=%y %l:%c %p%%"
opt.fillchars:append({ stl = " ", stlnc = " ", vert = "│" })

-- Splits (was ui.vim) ------------------------------------------------------
opt.splitbelow = true
opt.splitright = true

-- Bells (was ui.vim: visualbell + t_vb=) -----------------------------------
-- CHANGED: terminal-code 't_vb' does not exist in Neovim. 'belloff=all'
-- silences every bell (audio and visual), matching the old intent.
opt.belloff = "all"
