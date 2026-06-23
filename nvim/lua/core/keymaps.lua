-- core/keymaps.lua
-- Global key mappings ported from .vim/settings/keymap.vim.
-- Plugin-specific mappings (telescope, nvim-tree, git) live next to their
-- specs in lua/plugins/*.lua. Leader = <Space> (set in init.lua).

local map = vim.keymap.set

-- macOS: swap backslash and yen so ¥ types '\' (was keymap.vim) -------------
if vim.fn.has("macunix") == 1 then
  map("n", "¥", "\\", { remap = false })
  map("n", "\\", "¥", { remap = false })
end

-- Window management with the `s` prefix (was keymap.vim) --------------------
map("n", "s", "<Nop>", { silent = true })
map("n", "ss", "<Cmd>split<CR>", { silent = true })
map("n", "sv", "<Cmd>vsplit<CR>", { silent = true })
map("n", "sq", "<Cmd>q<CR>", { silent = true })

-- Move between windows (was keymap.vim) ------------------------------------
map("n", "sj", "<C-w>j", { silent = true })
map("n", "sk", "<C-w>k", { silent = true })
map("n", "sl", "<C-w>l", { silent = true })
map("n", "sh", "<C-w>h", { silent = true })

-- Tab management with the `t` prefix (was keymap.vim) -----------------------
-- NOTE: the old config also had `nnoremap [Space]t ...`, but `[Space]` was
-- never defined as a prefix there, so that mapping was dead. It is dropped.
map("n", "t", "<Nop>", { silent = true })
map("n", "tt", "<Cmd>tabnew<CR>", { silent = true })
map("n", "tT", "<Cmd>tabnew<CR><Cmd>tabprev<CR>", { silent = true })
map("n", "tq", "<Cmd>tabclose<CR>", { silent = true })
map("n", "to", "<Cmd>tabonly<CR>", { silent = true })
map("n", "tn", "gt", { silent = true })
map("n", "tp", "gT", { silent = true })

-- Delete the current buffer (was `<leader>k` in keymap.vim; it ran :bd and
-- was unrelated to fzf despite living in the fzf block). --------------------
map("n", "<leader>k", "<Cmd>bdelete<CR>", { silent = true })

-- Open a shell (was the `gsh` mapping in ui.vim; t_te/t_ti tricks are
-- Vim-only and unnecessary in Neovim's terminal). ---------------------------
map("n", "gsh", "<Cmd>terminal<CR>", { silent = true })
