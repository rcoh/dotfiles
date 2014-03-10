set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

colorscheme delek

set autoindent
set expandtab
set ts=4
set sw=4
set softtabstop=2
set textwidth=120
set tabpagemax=120

set number

set hlsearch

set pastetoggle=<F2>
filetype plugin indent on
autocmd FileType python set omnifunc=pythoncomplete#Complete

set runtimepath^=~/.vim/bundle/ctrlp.vim

:nmap ; :
nmap ss :w<CR>
nmap qq :wq<CR>

nmap <tab> :tabnext<cr>
nmap <s-tab> :tabprevious<cr>

Bundle 'derekwyatt/vim-scala'

" Python Checking
let g:syntastic_python_checker = 'pyflakes'
let g:syntastic_python_checker_args="--maxlength=160"

set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" my bundles
Bundle 'scrooloose/syntastic'
Bundle 'ervandew/supertab'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-surround'
Bundle 'SearchComplete'
Bundle 'wincent/Command-T'
Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'

filetype plugin indent on

autocmd FileType python set omnifunc=pythoncomplete#Complete
