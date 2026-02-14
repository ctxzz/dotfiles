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

" Initialize plugin system
call plug#end() 