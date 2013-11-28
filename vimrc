set nocompatible   " disable vi compatability

" pathogen loads all plugins in .vim/bundle/
call pathogen#runtime_append_all_bundles()

filetype plugin on " enable filetype detection for plugins
syntax on          " syntax highlighting

set expandtab    " use spaces instead of tabs

set encoding=utf-8    " best default encoding
set ttyfast           " assume a fast terminal
set scrolloff=15      " keep lines around the cursor visible
set showmode          " show mode on switch
set showcmd           " show last cmd (fast terminal needed)
set hidden            " hide buffers instead of unloading
set wildmenu          " show a menu for tab completion
set visualbell        " no beep
"set cursorline        " highlight line with cursor
set ruler             " display position in file
set wildignore=*.pdf,*.o  " ignore certain file names
set wildignore+=*.aux,*.out,*.toc,*.blg,*.snm,*.vrb,*.nav " LaTeX stuff
set wildignore+=*.pyc " Python byte code
set wildignore+=*.sw? " Vim swap files

" colorscheme requirements:
set background=light
colorscheme parsimony

" automagic indentation
set autoindent
set nocindent
set nosmartindent

" tabs and spaces
set tabstop=2      " a tab equals 3 spaces
set softtabstop=2  " make backspace work right
set shiftwidth=2   " indent likewise

" searching
set ignorecase   " ignore upper/lower case
set smartcase    " ... only if search term is lower case only
set incsearch    " incremental (instant) search
set hlsearch     " highlight search results

" backup files
set backup                      " enable ~foo files
set backupdir-=.                " not in local directory
set backupdir^=~/.cache/vim/backup,/tmp  " try other directories

" use localvimrc plugin for project specific config
let g:localvimrc_ask=0

" store swap files under ~/.vim
set directory=~/.cache/vim/swp

" set shell explicitly, as e.g. fish brakes vim
set shell=/bin/sh

if version >= 730
  " persistent undo (available since vim 7.3 / Ubuntu 11.4)
  set undofile
  set undodir=~/.cache/vim/undos

  " wrapping
  "set wrap            " wrap lines
  "set textwidth=79    " insert mode auto line breaks
  set colorcolumn=80   " highlight column
  hi ColorColumn ctermbg=darkgray
endif

" display invisible chars
set list
set listchars=tab:▸\ ,extends:→,precedes:←,nbsp:×

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/

" line numbers
"set relativenumber   " show line number relative to cursor (vim 7.3)
highlight LineNr ctermfg=darkcyan

" load some plugins
"runtime macros/matchit.vim  " advanced % command, which works in LaTeX, HTML, etc.
" use `vim-addons install matchit` instead

" When editing a file, always jump to the last known cursor position.
" Also restores folds
au BufWritePost,BufLeave,WinLeave ?* mkview
au BufWinEnter ?* silent loadview

" search upwards for tags file
set tags=tags;/

au BufRead,BufNewFile *.x10 set filetype=x10

" Add some file extensions to rooter plugin
autocmd BufEnter *.h,*.c,*.py :Rooter

" If you forgot to use sudo, use the double exclamation mark
cmap w!! w !sudo tee % >/dev/null
