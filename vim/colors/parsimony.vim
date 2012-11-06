" Vim color file without much coloring
" Maintainer:   Andreas Zwinkau
" Last Change:  2012-11-05
" URL:          http://beza1e1.tuxen.de


" developer's help topics:
" :he group-name
" :he highlight-groups
" :he cterm-colors

hi clear
if exists("syntax_on")
	syntax reset
endif
let g:colors_name="parsimony"

if &background == "light"
	hi Normal ctermfg=black

	" Search
	hi Search    ctermfg=white ctermbg=darkgreen
	hi IncSearch ctermfg=darkcyan

	" syntax highlighting groups
	hi Comment    ctermfg=black cterm=bold
	hi Constant   ctermfg=darkblue
	hi Identifier ctermfg=black
	hi Statement  ctermfg=black
	hi PreProc    ctermfg=black
	hi Type       ctermfg=black
	hi Special    ctermfg=black
	hi Ignore     ctermfg=black
	hi Todo       ctermfg=black
	hi Label      ctermfg=black

	" meta information
	hi NonText    ctermfg=darkyellow
	hi SpecialKey ctermfg=darkyellow
	hi ModeMsg    ctermfg=darkyellow
else
	hi Normal ctermfg=grey

	" Search
	hi Search    ctermfg=black ctermbg=darkgreen
	hi IncSearch ctermfg=cyan

	" syntax highlighting groups
	hi Comment    ctermfg=yellow
	hi Constant   ctermfg=blue
	hi Identifier ctermfg=grey
	hi Statement  ctermfg=grey
	hi PreProc    ctermfg=grey
	hi Type       ctermfg=grey
	hi Special    ctermfg=grey
	hi Ignore     ctermfg=grey
	hi Todo       ctermfg=grey
	hi Label      ctermfg=grey

	" meta information
	hi NonText    ctermfg=darkmagenta
	hi SpecialKey ctermfg=darkmagenta
	hi ModeMsg    ctermfg=darkmagenta
endif
