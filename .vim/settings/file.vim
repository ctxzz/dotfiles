if !exists('g:env')
    finish
endif

" File operations
function! s:rm(...) "{{{1
    let files = []
    for file in a:0 ? map(copy(a:000), 'expand(v:val)') : split(simplify(expand('%:p')))

        let file = fnamemodify(file, ":p")
        if isdirectory(file)
            let dest = "/tmp/".Random(20)
            if rename(file, dest) == 0
                call add(files, file)
            else
                return Error("not support a directory")
            endif
        elseif filereadable(file)
            if delete(file) == 0
                call add(files, file)
                let bufname = bufname(fnamemodify(file, ':p'))
                if bufexists(bufname) && buflisted(bufname)
                    execute "bwipeout" bufname
                endif
            endif
        else
            echohl WarningMsg | echo "The '" . file . "' does not exist" | echohl NONE
        endif
    endfor

    echo len(files) ? "Removed " . string(files) . "!" : "Removed nothing"
endfunction

" File listing
command! -nargs=? -complete=file -bang Ls2 call s:ls('<args>', '<bang>')
function! s:ls(path, bang)
    let path = empty(a:path) ? getcwd() : expand(a:path)
    if filereadable(path)
        if executable("ls")
            echo system("ls -l " . path)
            return v:shell_error ? g:false : g:true
        else
            return s:error('ls: command not found')
        endif
    endif

    if !isdirectory(path)
        return s:error(path.":No such file or directory")
    endif

    let save_ignore = &wildignore
    set wildignore=
    let filelist = glob(path . "/*")
    if !empty(a:bang)
        let filelist .= "\n".glob(path . "/.*[^.]")
    endif
    let &wildignore = save_ignore
    let filelist = substitute(filelist, '', '^M', 'g')

    if empty(filelist)
        return s:error("no file")
    endif

    let lists = []
    for file in split(filelist, "\n")
        if isdirectory(file)
            call add(lists, fnamemodify(file, ":t") . "/")
        else
            if executable(file)
                call add(lists, fnamemodify(file, ":t") . "*")
            elseif getftype(file) == 'link'
                call add(lists, fnamemodify(file, ":t") . "@")
            else
                call add(lists, fnamemodify(file, ":t"))
            endif
        endif
    endfor

    echohl WarningMsg | echon len(lists) . ":\t" | echohl None
    highlight LsDirectory  cterm=bold ctermfg=NONE ctermfg=26        gui=bold guifg=#0096FF   guibg=NONE
    highlight LsExecutable cterm=NONE ctermfg=NONE ctermfg=Green     gui=NONE guifg=Green     guibg=NONE
    highlight LsSymbolick  cterm=NONE ctermfg=NONE ctermfg=LightBlue gui=NONE guifg=LightBlue guibg=NONE

    let max = 0
    for item in lists
        let max += len(item)
        if max > &columns * 1.5
            echon "...more"
            break
        endif
        if item =~ '/'
            echohl LsDirectory | echon item[:-2] | echohl NONE
            echon item[-1:-1] . " "
        elseif item =~ '*'
            echohl LsExecutable | echon item[:-2] | echohl NONE
            echon item[-1:-1] . " "
        elseif item =~ '@'
            echohl LsSymbolick | echon item[:-2] | echohl NONE
            echon item[-1:-1] . " "
        else
            echon item . " "
        endif
    endfor

    return g:true
endfunction

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3: 