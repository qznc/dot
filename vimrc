set nocompatible   " disable vi compatability
filetype plugin on " enable filetype detection for plugins
syntax on          " syntax highlighting

set encoding=utf-8    " best default encoding
set ttyfast           " assume a fast terminal
set scrolloff=4       " keep 4 lines around the cursor visible
set showmode          " show mode on switch
set showcmd           " show last cmd (fast terminal needed)
set hidden            " hide buffers instead of unloading
set wildmenu          " show a menu for tab completion
set visualbell        " no beep
"set cursorline        " highlight line with cursor
set ruler             " display position in file
set wildignore=*.pdf,*.o  " ignore certain file names
"set relativenumber   " vim 7.3! show line number relative to cursor
"set undofile         " vim 7.3! store undo in file

" automagic indentation
set autoindent
set nocindent
set nosmartindent

" tabs and spaces
set tabstop=3      " a tab equals 3 spaces
"set expandtab      " use spaces instead of tabs
set noexpandtab    " use tabs instead of spaces
set softtabstop=3  " make backspace work right
set shiftwidth=3   " indent likewise

" searching
set ignorecase   " ignore upper/lower case
set smartcase    " ... only if search term is lower case only
set incsearch    " incremental (instant) search
set hlsearch     " highlight search results

" wrapping
"set wrap            " wrap lines
"set textwidth=79    " insert mode auto line breaks

" display invisible chars
set list
set listchars=tab:▸\ ,eol:↵

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+\%#\@<!$/

" load some plugins
"runtime macros/matchit.vim  " advanced % command, which works in LaTeX, HTML, etc.
" use `vim-addons install matchit` instead

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif

" search upwards for tags file
set tags=tags;/
