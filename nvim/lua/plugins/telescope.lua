-- plugins/telescope.lua
-- Replaces junegunn/fzf + junegunn/fzf.vim with the Lua-native
-- nvim-telescope/telescope.nvim (depends on plenary.nvim).
--
-- Mapping parity with the old .vim/settings/keymap.vim + .vim/plugins/fzf.vim:
--   <C-p> Files     -> find_files
--   <C-g> GFiles    -> git_files
--   <C-f> Rg        -> live_grep
--   <leader>b Buffers   -> buffers
--   <leader>x Commands  -> commands
--   <leader>f GFiles    -> git_files
--   <leader>a Ag        -> live_grep
--   <leader>r FZFMru    -> oldfiles
--   <leader>k :bd       -> kept as plain :bdelete (was not an fzf mapping)

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<C-g>", "<Cmd>Telescope git_files<CR>", desc = "Git files" },
      { "<C-f>", "<Cmd>Telescope live_grep<CR>", desc = "Live grep (ripgrep)" },
      { "<leader>b", "<Cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>x", "<Cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>f", "<Cmd>Telescope git_files<CR>", desc = "Git files" },
      { "<leader>a", "<Cmd>Telescope live_grep<CR>", desc = "Live grep (ripgrep)" },
      { "<leader>r", "<Cmd>Telescope oldfiles<CR>", desc = "Recent files (MRU)" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.5 },
      },
    },
  },
}
