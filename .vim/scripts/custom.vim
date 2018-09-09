if !exists('g:env')
    finish
endif

if g:plug.is_installed('fzf.vim') " {{{1
    " This is the default extra key bindings
    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

    " Default fzf layout
    " - down / up / left / right
    let g:fzf_layout = { 'down': '~40%' }

    " In Neovim, you can set up fzf window using a Vim command
    "let g:fzf_layout = { 'window': 'enew' }
    "let g:fzf_layout = { 'window': '-tabnew' }
    "let g:fzf_layout = { 'window': '10split enew' }

    " Enable per-command history.
    " CTRL-N and CTRL-P will be automatically bound to next-history and
    " previous-history instead of down and up. If you don't like the change,
    " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
    let g:fzf_history_dir = '~/.local/share/fzf-history'
endif

if g:plug.is_installed('nerdtree') " {{{1
    noremap  <c-n> :NERDTreeToggle<cr>

    "How can I close vim if the only window left open is a NERDTree?
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
    let g:NERDTreeWinPos = "left"
endif

if g:plug.is_installed('vim-airline') " {{{1
    " Enable Airline
    let g:airline#extensions#branch#enabled = 1
    " Show list of buffers in tabline
    let g:airline#extensions#tabline#enabled = 1
    " Show just the filename in tabline
    let g:airline#extensions#tabline#fnamemod = ':t'
    " Use fonts
    let g:airline_powerline_fonts = 1

    " Airline theme
    let g:airline_theme = 'base16'

    if !exists('g:airline_symbols')
     let g:airline_symbols = {}
    endif
    " Airline symbols
    " let g:airline_left_sep = "\uE0CC"
    " let g:airline_right_sep = "\uE0C2"
    let g:airline_symbols.linenr = '␤'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.paste = '∥'
    let g:airline_symbols.whitespace = 'Ξ'

endif


" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
