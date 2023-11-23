set nocompatible   " disable vi compatability

" pathogen loads all plugins in .vim/bundle/
execute pathogen#infect()

filetype plugin indent on " enable filetype detection for plugins and indentation
syntax on          " syntax highlighting

set encoding=utf-8    " best default encoding
set ttyfast           " assume a fast terminal
"set lazyredraw        " no redraw within macros etc
set scrolloff=5       " keep lines around the cursor visible
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
set wildignore+=*.tuc,*.bbl " ConTeXt

" colorscheme requirements:
"set background=light
"colorscheme parsimony

" automagic indentation
set autoindent
set nocindent
set nosmartindent

" tabs and spaces
set expandtab      " use spaces instead of tabs by default
set tabstop=2      " a tab equals n spaces
set softtabstop=2  " make backspace work right
set shiftwidth=2   " indent likewise
" to overrule for certain filetypes, use after/ftplugin/*.vim

" searching
set ignorecase   " ignore upper/lower case
set smartcase    " ... only if search term is lower case only
set incsearch    " incremental (instant) search
set hlsearch     " highlight search results

" backup files
set backup                      " enable ~foo files
set backupdir-=.                " not in local directory
set backupdir^=~/.cache/vim/backup,/tmp  " try other directories

" store swap files under ~/.vim
set directory=~/.cache/vim/swp

" set shell explicitly, as e.g. fish brakes vim
set shell=/bin/sh

if has('persistent_undo')
    set undodir=~/.cache/vim/undos " Save all undo files in a single location
    set undolevels=5000 " Save a lot of back-history...
    set undofile " Actually switch on persistent undo
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

if has("gui_running")
  " GUI is running or is about to start.
  set lines=999 columns=82
endif
