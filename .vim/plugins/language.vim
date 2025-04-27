" Language settings
if !g:plug.is_loaded('vim-polyglot')
    finish
endif

" Basic language settings
let g:polyglot_disabled = ['autoindent']
let g:jsx_ext_required = 0
let g:vim_json_syntax_conceal = 0

" Language help
set helplang& helplang=ja

" Encoding settings
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,ucs-2le,ucs-2,cp932

" Basic indentation settings
set expandtab
set autoindent
set backspace=indent,eol,start
set smartindent
set smarttab

" File type specific settings
augroup language_settings
    autocmd!
    autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4
    autocmd FileType javascript,typescript setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4
    autocmd FileType rust setlocal expandtab shiftwidth=4 tabstop=4
augroup END 