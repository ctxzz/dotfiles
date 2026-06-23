-- plugins/treesitter.lua
-- Replaces sheerun/vim-polyglot with nvim-treesitter, the Lua-native syntax /
-- highlighting engine for Neovim.
--
-- NOTE: the old config disabled polyglot's vim-sleuth-style indent detection
-- (g:polyglot_disabled = ['autoindent']) so it wouldn't override the 2-space
-- defaults. Treesitter does NOT touch indent options, so no such guard is
-- needed; the filetype indents in core/autocmds.lua remain authoritative.
-- Treesitter indent is left disabled to keep indentation behaviour identical.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- classic API (require('nvim-treesitter.configs').setup)
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash",
        "python", "javascript", "typescript", "tsx",
        "go", "rust", "json", "yaml", "toml",
        "markdown", "markdown_inline", "html", "css",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = false }, -- keep the old explicit indent behaviour
    },
  },
}
