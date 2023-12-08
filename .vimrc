" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

Plug 'Chiel92/vim-autoformat'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-highlightedyank'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'sainnhe/sonokai'
Plug 'markvincze/panda-vim'
Plug 'sheerun/vim-polyglot'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'scrooloose/nerdtree'
Plug 'leshill/vim-json'

call plug#end()

set shell=/bin/bash

" Setting the leader
let mapleader=","
noremap <leader>, ,

" set the clipboard
set clipboard=unnamed

" Copy to the system clipboard
vnoremap <Leader>y "+y

" Code formatting with black
" Apply formatter on save
augroup black_on_save
  autocmd!
  autocmd BufWritePre *.py Black
augroup end

" Disable fallback to vim's indent file, retabbing and removing trailing whitespace
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

" Use better code folding
let g:SimpylFold_docstring_preview = 1

" Use black formatter
let g:formatters_python=['black']

" Vim pane switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Hybrid line numbers
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Searching within a file
set hlsearch  " highlight search results
set incsearch " show search results as you type
nnoremap <silent> <CR> :nohlsearch<Bar>:echo<CR> " Clear search results with enter

" Nerdtree open/close toggle
map <C-n> :NERDTreeToggle<CR>


" Tab spacing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab " use spaces instead of tabs.
set smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rules.
" Color
" Important!!
if has('termguicolors')
  set termguicolors
endif

" The configuration options should be placed before `colorscheme sonokai`.
let g:sonokai_style = 'andromeda'
let g:sonokai_better_performance = 1

colorscheme sonokai

let g:lightline = {}
let g:lightline.colorscheme = 'sonokai'

syntax enable
set background=dark

" Language Specific
" Python
" Yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab


" Additional vim options
set encoding=utf-8                       " Set encoding
set ruler                                " Show line, column number
set viminfo='20,<1000                    " Increase the copy/paste-buffer
set noerrorbells visualbell t_vb=        " Get rid of bell sound on error
set nowrap                               " Turn off text wrapping
set colorcolumn=88                       " Column number for vertical line
set cursorline                           " Highlight the line of the cursor
set t_Co=256                             " Required for vim colorscheme show up in tmux
" We have VCS -- we don't need this stuff.
set nobackup " We have vcs, we don't need backups.
set nowritebackup " We have vcs, we don't need backups.
set noswapfile " They're just annoying. Who likes them?
" don't nag me when hiding buffers
set hidden " allow me to have buffers with unsaved changes.
set autoread " when a file has changed on disk, just load it. Don't ask.
" Make search more sane
set ignorecase " case insensitive search
set smartcase " If there are uppercase letters, become case-sensitive.
set incsearch " live incremental searching
set showmatch " live match highlighting
set hlsearch " highlight matches
set gdefault " use the `g` flag by default.
" allow the cursor to go anywhere in visual block mode.
set virtualedit+=block

" Keybindings
" So we don't have to reach for escape to leave insert mode.
inoremap jk <esc>