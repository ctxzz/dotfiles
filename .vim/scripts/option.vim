if !exists('g:env')
    finish
endif

" Fast terminal connection
set ttyfast

" Enable the mode line
set modeline

" The length of the mode line
set modelines=5

" Vim internal help with the command K
set keywordprg=:help

" Language help
set helplang& helplang=ja

" Ignore case
set ignorecase

" Smart ignore case
set smartcase

" Enable the incremental search
set incsearch

" Emphasize the search pattern
set hlsearch

" Moves the cursor to the same column when cursor move
set nostartofline

" Use tabs instead of spaces
"set noexpandtab
set expandtab

" When starting a new line, indent in automatic
set autoindent

" The function of the backspace
set backspace=indent,eol,start

" When the search is finished, search again from the BOF
set wrapscan

" Emphasize the matching parenthesis
set showmatch

" Extend the command line completion
set wildmenu

" Wildmenu mode
set wildmode=longest,full

" Ignore compiled files
set wildignore&
set wildignore=.git,.hg,.svn
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=*.DS_Store

" Show line and column number
set ruler
set rulerformat=%m%r%=%l/%L

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Show current mode (insert, visual, normal, etc.)
set showmode

" Show last command in status line
set showcmd

" Lets vim set the title of the console
set notitle

" When you create a new line, perform advanced automatic indentation
set smartindent

" Blank is inserted only the number of 'shiftwidth'.
set smarttab

" History size
set history=10000
set wrap

" Make it normal in UTF-8 in Unix.
set encoding=utf-8
set fileencoding=japan
set fileencodings=utf-8,iso-2022-jp,euc-jp,ucs-2le,ucs-2,cp932

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,ucs-2le,ucs-2,cp932

" Use clipboard
if has('clipboard')
    set clipboard=unnamed
endif


" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
