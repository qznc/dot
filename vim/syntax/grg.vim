" Vim syntax file
" Language:     GrGen Model file
" Maintainer:   Andreas Zwinkau <beza1e1@web.de>
" URL:          

syn clear

if !exists("main_syntax")
  let main_syntax = 'grgen rules'
endif

syn keyword gmKeyWords  rule pattern using hom
syn keyword gmKeyWords  replace modify negative
syn keyword gmKeyWords  delete exec eval return if
syn region gmComment    start="/\*" end="\*/"
syn region gmComment    start="//" end="$"

hi def link gmKeyWords       Statement
hi def link gmComment       Comment

let b:current_syntax = "grg"

" vim:set ts=8 sts=2 sw=2 noet:
