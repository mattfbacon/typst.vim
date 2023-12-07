" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

function! s:declare_option(option, value)
    if !exists('g:' . a:option)
        if type(a:value) == type(1)
            exec 'let g:'.a:option.' = '.a:value
        elseif type(a:value) == type('')
            exec 'let g:'.a:option.' = "'.a:value.'"'
        endif
    endif
endfunction

call s:declare_option('typst_cmd', 'typst')
call s:declare_option('typst_pdf_viewer', '')
call s:declare_option('typst_conceal', 0)
call s:declare_option('typst_conceal_math', g:typst_conceal)
call s:declare_option('typst_auto_close_toc', 0)
call s:declare_option('typst_auto_open_quickfix', 1)

let b:did_ftplugin = 1

let s:cpo_orig = &cpo
set cpo&vim

compiler typst

" " If you're on typst <v0.8, workaround for https://github.com/typst/typst/issues/1937
" set errorformat^=\/%f:%l:%c:%m

if g:typst_conceal
    setlocal conceallevel=2
endif

setlocal commentstring=//%s
setlocal comments=s1:/*,mb:*,ex:*/,://

setlocal formatoptions+=croq
setlocal iskeyword=a-z,A-Z,48-57,_,-

setlocal suffixesadd=.typ

command! -nargs=* -buffer TypstWatch call typst#TypstWatch(<f-args>)

command! -buffer Toc call typst#Toc('vertical')
command! -buffer Toch call typst#Toc('horizontal')
command! -buffer Tocv call typst#Toc('vertical')
command! -buffer Toct call typst#Toc('tab')

let &cpo = s:cpo_orig
unlet s:cpo_orig
" vim: tabstop=8 shiftwidth=4 softtabstop=4 expandtab
