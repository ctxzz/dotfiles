if !exists('g:env')
  finish
endif

" Basic UI settings
set number              " Show line numbers
set relativenumber      " Show relative line numbers
set ruler               " Show cursor position
set showcmd             " Show command in bottom bar
set showmode            " Show current mode
set laststatus=2        " Always show status line
set cursorline          " Highlight current line
set wildmenu            " Visual autocomplete for command menu
set showmatch           " Highlight matching [{()}]
set wrap                " Wrap long lines
set linebreak           " Don't break words when wrapping
set display+=lastline   " Show as much as possible of the last line
set scrolloff=5         " Keep 5 lines above/below cursor
set sidescrolloff=5     " Keep 5 columns left/right of cursor
set colorcolumn=80      " Highlight column 80
set signcolumn=yes      " Always show sign column

" Search settings
set hlsearch            " Highlight search results
set incsearch           " Incremental search
set ignorecase          " Case insensitive search
set smartcase           " Case sensitive when uppercase present

" Syntax and colors
syntax enable           " Enable syntax highlighting
set termguicolors       " Enable true color support
set background=dark     " Dark background

" Transparent background for UI elements
" Function to apply transparent backgrounds
function! s:apply_transparent_bg()
  highlight Normal guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight CursorLine guibg=NONE ctermbg=NONE
  highlight CursorLineNr guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight StatusLine guibg=NONE ctermbg=NONE
  highlight StatusLineNC guibg=NONE ctermbg=NONE
  highlight VertSplit guibg=NONE ctermbg=NONE
  highlight Pmenu guibg=NONE ctermbg=NONE
  highlight PmenuSbar guibg=NONE ctermbg=NONE
  highlight PmenuThumb guibg=NONE ctermbg=NONE
  highlight ColorColumn guibg=NONE ctermbg=NONE
  highlight Folded guibg=NONE ctermbg=NONE
  highlight FoldColumn guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight SpecialKey guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
endfunction

" Apply immediately after syntax enable
call s:apply_transparent_bg()

" Re-apply transparent backgrounds on colorscheme changes and syntax events
augroup TransparentBG
  autocmd!
  autocmd VimEnter,ColorScheme,Syntax * call s:apply_transparent_bg()
augroup END

" Split behavior
set splitbelow          " Open horizontal splits below
set splitright          " Open vertical splits to the right

" Disable all bells (audio and visual)
" Setting visualbell prevents beeping, t_vb= disables the visual flash
set visualbell          
set t_vb=

"if g:env.is_tmux_running
"  augroup titlesettings
"    autocmd!
"    autocmd BufEnter * call system("tmux rename-window " . "'[vim] " . expand("%:t") . "'")
"    autocmd VimLeave * call system("tmux rename-window ".g:env.tmux_proc)
"    autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
"  augroup END
"endif

autocmd GUIEnter * call s:gui()

function! s:gui()
  "colorscheme solarized
  "set background=light
  syntax enable

  " Tabpages
  set guitablabel=%{GuiTabLabel()}

  " Change cursor color if IME works.
  if has('multi_byte_ime') || has('xim')
    "highlight Cursor   guibg=NONE guifg=Yellow
    "highlight CursorIM guibg=NONE guifg=Red
    set iminsert=0 imsearch=0
    inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
  endif
  "autocmd VimEnter,ColorScheme * highlight Cursor   guibg=Yellow guifg=Black
  "autocmd VimEnter,ColorScheme * highlight CursorIM guibg=Red    guifg=Black
  autocmd VimEnter,ColorScheme * if &background ==# 'dark'  | highlight Cursor   guibg=Yellow guifg=Black | endif
  autocmd VimEnter,ColorScheme * if &background ==# 'dark'  | highlight CursorIM guibg=Red    guifg=Black | endif
  autocmd VimEnter,ColorScheme * if &background ==# 'light' | highlight Cursor   guibg=Black  guifg=NONE  | endif
  autocmd VimEnter,ColorScheme * if &background ==# 'light' | highlight CursorIM guibg=Red    guifg=Black | endif
  inoremap <silent> <ESC><ESC>:set iminsert=0<CR>

  " Remove all menus.
  try
    source $VIMRUNTIME/delmenu.vim
  catch
  endtry

  " Font
  if IsMac()
    set guifont=Andale\ Mono:h12
  endif
endfunction

autocmd MyAutoCmd BufReadPost *
            \ if &modifiable && !search('[^\x00-\x7F]', 'cnw')
            \ | setlocal fileencoding=
            \ | endif

nmap <silent> gZZ :set t_te= t_ti= <cr>:quit<cr>:set t_te& t_ti&<cr>
nmap <silent> gsh :set t_te= t_ti= <cr>:sh<cr>:set t_te& t_ti&<cr>

" GUI IME Cursor colors
if has('multi_byte_ime') || has('xim')
  highlight Cursor guibg=NONE guifg=Yellow
  highlight CursorIM guibg=NONE guifg=Red
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    ""set imactivatekey=s-space
  endif
  inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
endif

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
