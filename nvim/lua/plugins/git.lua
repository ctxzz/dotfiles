-- plugins/git.lua
-- Git integration. Ported from .vim/plugins/git.vim.
--   tpope/vim-fugitive   -> kept (works natively in Neovim).
--   airblade/vim-gitgutter -> replaced by lewis6991/gitsigns.nvim (Lua native).
--
-- NOTE: fugitive's old command names (:Gstatus, :Gcommit, :Gblame, :Gdiff,
-- :Glog, :Gpush) are deprecated. The mappings below use the current ones
-- (:Git, :Git commit, :Git blame, :Gdiffsplit, :Git log, :Git push).

return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gedit" },
    keys = {
      { "<leader>gs", "<Cmd>Git<CR>", desc = "Git status" },
      { "<leader>gd", "<Cmd>Gdiffsplit<CR>", desc = "Git diff" },
      { "<leader>gc", "<Cmd>Git commit<CR>", desc = "Git commit" },
      { "<leader>gb", "<Cmd>Git blame<CR>", desc = "Git blame" },
      { "<leader>gl", "<Cmd>Git log<CR>", desc = "Git log" },
      { "<leader>gp", "<Cmd>Git push<CR>", desc = "Git push" },
      { "<leader>gr", "<Cmd>Gread<CR>", desc = "Git checkout file" },
      { "<leader>gw", "<Cmd>Gwrite<CR>", desc = "Git add file" },
      { "<leader>ge", "<Cmd>Gedit<CR>", desc = "Git edit" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- Reproduce the old gitgutter '│' signs.
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "│" },
        topdelete = { text = "│" },
        changedelete = { text = "│" },
      },
      numhl = true, -- was g:gitgutter_highlight_linenrs = 1
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        -- Mapping parity with the old gitgutter <leader>h* bindings.
        map("<leader>hu", gs.reset_hunk, "Undo hunk")    -- GitGutterUndoHunk
        map("<leader>hp", gs.preview_hunk, "Preview hunk")
        map("<leader>hs", gs.stage_hunk, "Stage hunk")
        map("<leader>hr", gs.reset_hunk, "Revert hunk")
        map("<leader>hn", function() gs.nav_hunk("next") end, "Next hunk")
        map("<leader>hN", function() gs.nav_hunk("prev") end, "Prev hunk")
      end,
    },
  },
}
