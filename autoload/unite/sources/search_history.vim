let s:source = { 
    \ 'name' : 'search_history' ,
    \ 'description' : 'candidates from search history',
    \ }

function! s:get_search_history()
    augroup unite_search_history_hacky_group
        autocmd!
        autocmd CmdwinEnter * :let s:histlist = getline(0,line('$'))
    augroup END
    execute "normal! q/"
    call reverse(s:histlist)
    augroup unite_search_history_hacky_group
        autocmd!
    augroup END
    " call map(s:histlist, '"''". v:val ."''"')
    " call map(s:histlist, '"escape(".v:val.", ''\'')"')
    return s:histlist
endfunction

function! s:source.gather_candidates(args, context)
    let search_hist = s:get_search_history()
    return map(search_hist, '{
                \"word" : v:val,
                \"kind" : "command",
                \"action__command" : "let @/=''".v:val."''|normal! n"
                \}')
endfunction

function! unite#sources#search_history#define()
    return [s:source]
endfunction
