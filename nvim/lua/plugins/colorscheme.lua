-- plugins/colorscheme.lua
-- Replaces catppuccin/vim with the Lua-native catppuccin/nvim.
-- Old config used `colorscheme catppuccin_mocha` on a dark background.

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000, -- load before other plugins so colours are ready
    opts = {
      flavour = "mocha",
      transparent_background = true, -- mirrors the old transparent-bg setup
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
      -- Re-assert the manual transparency tweaks from core/autocmds.lua.
      if _G.apply_transparent_bg then
        _G.apply_transparent_bg()
      end
    end,
  },
}
