" vim-plug config

set nocompatible
filetype off

call plug#begin(stdpath('data') . '/plugged')

Plug 'arthurxavierx/vim-caser'
Plug 'editorconfig/editorconfig-vim'
Plug 'famiu/bufdelete.nvim'
Plug 'ggandor/lightspeed.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'kdheepak/lazygit.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'L3MON4D3/LuaSnip'
Plug 'machakann/vim-highlightedyank'
Plug 'mbbill/undotree'
Plug 'mcchrish/nnn.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'phaazon/hop.nvim'
Plug 'pwntester/octo.nvim'
Plug 'rafamadriz/friendly-snippets'
Plug 'romgrk/barbar.nvim'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'Shougo/context_filetype.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tyru/caw.vim'
Plug 'vim-airline/vim-airline'

Plug 'chriskempson/base16-vim'
Plug 'dracula/vim'

Plug 'ElmCast/elm-vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'cespare/vim-toml'
Plug 'elzr/vim-json'
Plug 'habamax/vim-godot'
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'
Plug 'rust-lang/rust.vim'
Plug 'tbastos/vim-lua'

call plug#end()

filetype plugin indent on

" Standard options

syntax on
color base16-dracula

set number relativenumber
set nowrap
set linebreak
set showbreak=+++
set textwidth=100
set showmatch

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2

set ruler
set showtabline=2

set undofile
set undodir=~/.config/nvim/undo
set undolevels=100
set backspace=indent,eol,start
set mouse=a

set hidden
set nobackup
set noswapfile
set nowritebackup
set nofoldenable
set backupcopy=yes
set cmdheight=2
set updatetime=200
set shortmess+=c
set signcolumn=yes
set termguicolors
set noshowmode
set timeoutlen=1000
set conceallevel=0
set list lcs=tab:\|\ 
set completeopt=menuone,noselect,noinsert
set scrolloff=4
set cursorline

" Keybindings config

execute 'source' stdpath('config').'/keybindings.vim'

" Telescope

lua require('telescope-config')

" NNN config

let g:nnn#set_default_mappings = 0
let g:nnn#layout = { 'window': { 'width': 0.8, 'height': 0.7, 'highlight': 'Debug' } }
let g:nnn#action = {
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit' }

" Yank config

let g:highlightedyank_highlight_duration = 100

" Hop

lua require'hop'.setup()

" Octo

lua require'octo'.setup()

" LSP config

lua require('lsp-config')

" LSP completion config

lua require('cmp-config')

" Treesitter config

lua require('treesitter-config')

" Language config

let g:vue_pre_processors = []
let g:vim_json_syntax_conceal = 0
let g:elm_setup_keybindings = 0
let g:vim_svelte_plugin_use_typescript = 1
let g:vim_svelte_plugin_use_sass = 1

" Lightspeed

lua require'lightspeed'.opts.exit_after_idle_msecs = { labeled = nil, unlabeled = nil }
lua require'lightspeed'.opts.jump_to_first_match = false

" MD file type config

au BufNew,BufReadPost,BufReadPre,BufEnter *.md setlocal tw=80
au BufNew,BufReadPost,BufReadPre,BufEnter *.md setlocal colorcolumn=80
au BufNew,BufReadPost,BufReadPre,BufEnter * setlocal conceallevel=0
