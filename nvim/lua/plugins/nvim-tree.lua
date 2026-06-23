-- plugins/nvim-tree.lua
-- File explorer. The old Vim config had no dedicated file tree (it relied on
-- fzf for navigation), so this is a NEW addition requested for the migration.
-- Depends on nvim-web-devicons for filetype icons.

return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
    opts = {
      sort = { sorter = "case_sensitive" },
      view = { width = 30 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
    },
  },
}
