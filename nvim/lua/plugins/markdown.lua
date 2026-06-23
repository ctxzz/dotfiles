-- plugins/markdown.lua
-- Markdown editing. Ported from .vim/plugins/init.vim + language.vim.
--   godlygeek/tabular   -> kept (works in Neovim; provides :Tabularize and is
--                          a dependency of vim-markdown's :TableFormat).
--   preservim/vim-markdown -> kept (works in Neovim).
--
-- The polyglot-era settings g:jsx_ext_required and g:vim_json_syntax_conceal
-- are dropped: those belonged to vim-polyglot, now replaced by treesitter.

return {
  {
    "preservim/vim-markdown",
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    init = function()
      -- Was language.vim: indent markdown list items by 2 spaces.
      vim.g.vim_markdown_new_list_item_indent = 2
    end,
  },
}
