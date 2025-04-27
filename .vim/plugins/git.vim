" Git settings
if !g:plug.is_loaded('vim-fugitive') || !g:plug.is_loaded('vim-gitgutter')
    finish
endif

" vim-fugitive settings
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Gpush<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>

" vim-gitgutter settings
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_highlight_lines = 0
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_signs = 1
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_sign_added = '│'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '│'
let g:gitgutter_sign_removed_first_line = '│'
let g:gitgutter_sign_modified_removed = '│'

" Git gutter key mappings
nnoremap <silent> <leader>hu :GitGutterUndoHunk<CR>
nnoremap <silent> <leader>hp :GitGutterPreviewHunk<CR>
nnoremap <silent> <leader>hs :GitGutterStageHunk<CR>
nnoremap <silent> <leader>hr :GitGutterRevertHunk<CR>
nnoremap <silent> <leader>hn :GitGutterNextHunk<CR>
nnoremap <silent> <leader>hN :GitGutterPrevHunk<CR> 