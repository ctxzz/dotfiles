"
" Note: Skip initialization for vim-tiny or vim-small.
"
if 1
  if $DEBUG ==# ''
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vim/init.vim'
  endif
  " execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vim/rc/init.vim'
endif
