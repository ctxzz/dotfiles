if !exists('g:env')
    finish
endif

" Use backslash
if IsMac()
    noremap ¥ \
    noremap \ ¥
endif

" Define mapleader
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" Windows
nnoremap s <Nop>
nnoremap sp :<C-u>split<CR>
nnoremap vs :<C-u>vsplit<CR>

function! s:vsplit_or_wincmdw()
    if winnr('$') == 1
        return ":vsplit\<CR>"
    else
        return ":wincmd w\<CR>"
    endif
endfunction
nnoremap <expr><silent> ss <SID>vsplit_or_wincmdw()
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h

nnoremap t <Nop>
nnoremap <silent> [Space]t :<C-u>tabclose<CR>:<C-u>tabnew<CR>
nnoremap <silent> tt :<C-u>tabnew<CR>
nnoremap <silent> tT :<C-u>tabnew<CR>:<C-u>tabprev<CR>
nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> to :<C-u>tabonly<CR>


if g:plug.is_installed('fzf.vim') " {{{1
    " Mapping selecting mappings
    nmap <leader><tab> <plug>(fzf-maps-n)
    xmap <leader><tab> <plug>(fzf-maps-x)
    omap <leader><tab> <plug>(fzf-maps-o)

    " Insert mode completion
    imap <c-x><c-k> <plug>(fzf-complete-word)
    imap <c-x><c-f> <plug>(fzf-complete-path)
    imap <c-x><c-j> <plug>(fzf-complete-file-ag)
    imap <c-x><c-l> <plug>(fzf-complete-line)

    nnoremap <Leader>b :Buffers<CR>
    nnoremap <Leader>x :Commands<CR>
    nnoremap <Leader>f :GFiles<CR>
    nnoremap <Leader>a :Ag<CR>
    nnoremap <Leader>k :bd<CR>
    command! FZFMru call fzf#run({
    \  'source':  v:oldfiles,
    \  'sink':    'e',
    \  'options': '-m -x +s',
    \  'down':    '40%'})
    nnoremap <Leader>r :FZFMru<CR>
endif

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:
