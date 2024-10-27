vim.cmd([[
" -----------------------------------------------
" 全体的な設定
set encoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac
let $LANG = 'en_US.UTF-8'
" lang en_US.UTF-8
set guifont=UDEV\ Gothic\ NFLG:h14
set number
set belloff=all
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set fenc=utf-8
set nobackup
set noswapfile
set hidden
set cursorline
set virtualedit=onemore
set hlsearch
set backspace=indent,eol,start
set autoread
" 検索するときに大文字小文字を区別しない
set ignorecase
" 小文字で検索すると大文字と小文字を無視して検索
set smartcase
" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索
set wrapscan
" インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set incsearch
" 対応する括弧やブレースを表示
set showmatch matchtime=1
" ステータス行を常に表示
set laststatus=2
" ウィンドウの右下にまだ実行していない入力中のコマンドを表示
set showcmd
" タイトルを表示
set title
set clipboard+=unnamed,unnamedplus
set showmatch
set wildmenu wildmode=list:longest,full
syntax on
set mouse=a
" set shellslash

" -----------------------------------------------
" keymap
let mapleader = "\<space>"
inoremap <silent> jk <ESC>
nnoremap <Leader>w :w<CR>
nnoremap <Esc><Esc> :nohlsearch<CR>
noremap <Leader>e $
noremap <Leader>s ^
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap <Leader>q :bd
noremap <c-j> :bprevious<CR>
noremap <c-k> :bnext<CR>
noremap <Leader>h <c-w>h
noremap <Leader>j <c-w>j
noremap <Leader>k <c-w>k
noremap <Leader>l <c-w>l

tnoremap <ESC> <c-\><c-n>
]])
