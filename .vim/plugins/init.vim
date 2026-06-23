" vim:ft=vim

" Initialize plugin manager
if !exists('g:plug')
    let g:plug = {}
endif

function! g:plug.is_installed(name) abort
    return isdirectory(expand('~/.vim/plugged/' . a:name))
endfunction

function! g:plug.is_loaded(name) abort
    return has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
endfunction

" Install vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" NOTE: vim-polyglot のインデント自動検出(vim-sleuth相当)を無効化する。
" これを切らないとファイル内容から推測した値(例:4)で tabstop/shiftwidth が
" 上書きされ、base.vim の 2 スペース設定が効かなくなる。
" g:polyglot_disabled は polyglot 読み込み(plug#end)より前に設定する必要がある。
let g:polyglot_disabled = ['autoindent']
call plug#begin('~/.vim/plugged')

" Color scheme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Language support
Plug 'sheerun/vim-polyglot'

" Markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'


" Initialize plugin system
call plug#end()

" Load plugin-specific configuration (this directory's other *.vim files).
" plug#end() の後に source することで g:plugs が埋まり、各ファイル冒頭の
" g:plug.is_loaded() ガードが正しく機能する。
for s:cfg in split(glob('~/.vim/plugins/*.vim'), '\n')
    if s:cfg !~# '/init\.vim$'
        execute 'source' fnameescape(s:cfg)
    endif
endfor
unlet! s:cfg
