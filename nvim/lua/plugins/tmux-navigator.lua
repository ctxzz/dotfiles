-- plugins/tmux-navigator.lua
-- Seamless movement between Neovim splits and tmux panes with one set of keys
-- (C-h/j/k/l). The tmux side is already configured in ../../.tmux.conf
-- (`set -g @plugin 'christoomey/vim-tmux-navigator'`); this adds the Neovim half.
--
-- Lazy-loads on the navigation keys/commands. When not running inside tmux the
-- same keys just move between Neovim windows, so it is harmless standalone.

return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    init = function()
      -- Define our own maps below instead of the plugin's defaults.
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", desc = "Go to left split/pane" },
      { "<C-j>", "<Cmd>TmuxNavigateDown<CR>", desc = "Go to below split/pane" },
      { "<C-k>", "<Cmd>TmuxNavigateUp<CR>", desc = "Go to above split/pane" },
      { "<C-l>", "<Cmd>TmuxNavigateRight<CR>", desc = "Go to right split/pane" },
    },
  },
}
