" Vim syntax file
" Language: Loogger Syntax File
" Maintainer: Alexei Matyushkin
" Latest Revision: 12 December 2012

if exists("b:current_syntax")
  finish
endif

"----------------------------------------------------------------
" loogger syntax highlighting
"----------------------------------------------------------------

" Keywords
" syn keyword syntaxElementKeyword keyword1 keyword2 nextgroup=syntaxElement2
syn keyword loogTodo containedin=loogComment TODO FIXME XXX NOTE
syn keyword loogLevel DEBUG INFO WARN ERROR FATAL UNKNOWN

" Matches
" syn match syntaxElementMatch 'regexp' contains=syntaxElement1 nextgroup=syntaxElement2 skipwhite
syn match loogComment "#.*$" contains=loogTodo

" Regions
" syn region syntaxElementRegion start='x' end='y'
syn region loogItem start='⇒' end='⇐' fold transparent

let b:current_syntax = "loogger"

hi def link loogTodo        Todo
hi def link loogLevel       Error
hi def link loogComment     Comment
" hi def link loogItem        Statement

inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

set foldmethod=syntax
