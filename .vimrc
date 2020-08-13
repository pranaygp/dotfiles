if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'stephpy/vim-yaml'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
Plug 'tpope/vim-markdown'
Plug 'elzr/vim-json'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'sickill/vim-pasta'
Plug 'editorconfig/editorconfig-vim'
Plug 'rust-lang/rust.vim'
Plug 'alampros/vim-styled-jsx'
Plug 'lifepillar/vim-mucomplete'
Plug 'rhysd/vim-color-spring-night'
Plug '~/github/windsor/windsor-vim'
call plug#end()

" Required:
filetype plugin indent on

" Turn on syntax highlighting
syntax enable

" Requires for 256 colors in OS X iTerm(2)
set t_Co=256

set modelines=0

set ttimeout
set ttimeoutlen=50

" Tabbing settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set clipboard=unnamed
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set gdefault
set ttyfast
set ruler
set backspace=indent,eol,start
set iskeyword-=

" Status bar
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? 'OK' : printf(
  \   '%dW %dE',
  \   all_non_errors,
  \   all_errors
  \)
endfunction

set laststatus=2
set statusline=%F\ %m\ %{fugitive#statusline()}\ %y%=%l,%c\ %P
set statusline+=%#warningmsg#
set statusline+=%{LinterStatus()}
set statusline+=%*

" Hide line numbers
set nonumber

" Disable swap files
set noswapfile

" Enable undo after closing files, but keep the files away from VCSs
set undofile
set undodir=~/.vim-undo

let mapleader = ","

" Ale options
let g:ale_completion_enabled = 1
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_prettier_executable = 'prettier_d'

let g:ale_linters = {
\   'jsx': ['eslint'],
\}
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'c': ['clang-format'],
\}

" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 1

" Default search with \v
nnoremap / /\v
vnoremap / /\v

" Search/Highlight tweaks
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" Make leader space clear up highlighting
nnoremap <leader><space> :noh<cr>

nnoremap <tab> %
vnoremap <tab> %

" Wrap column settings
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=75

" Show list chars
set list

" List chars same as Textmate
set listchars=tab:▸\ ,eol:¬

" Make F2 toggle paste indenting with visual feedback
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Disable moving with arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap ; :

nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
nnoremap <leader>v V`]
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>v :vs<CR>
nnoremap <leader>h :split<CR>

" configure vim with clipper
nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" select all
map <Leader>a ggVG
"
" next in ALE
map <Leader>l :ALENext<cr>

" disable super annoying man lookup
map <S-k> <Nop>

" Set syntax highlighting for node shell scripts
au! BufNewFile,BufRead,BufWrite * if getline(1) =~ '^\#!.*node' | setf javascript | endif

" Disable vim-json concealing
let g:vim_json_syntax_conceal = 0

" Color scheme
colorscheme spring-night

" jsx indent / highlight
let g:jsx_ext_required = 0

" autocompletion
set completeopt+=menuone
set completeopt+=noselect
set completeopt+=noinsert
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

let g:mucomplete#enable_auto_at_startup = 1

" make sure to only enable autochdir in insert mode
" authochdir makes autocompletion of paths work
" nicely with relative paths
autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)
