set encoding=utf-8
set fileencodings=utf-8
set termencoding=utf-8

set paste

if has("syntax")
	syntax on
endif

set tabstop=8
set softtabstop=8
set shiftwidth=8
" set expandtab

set cindent
set autoindent
set smartindent

set number
set ruler

set cursorline
set showmatch

set laststatus=2
set statusline=%F\ %y%m%r\ %=Line:\ %l/%L\ [%p%%]\ Col:%c\ Buf:%n
