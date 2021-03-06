vim.api.nvim_command [[:syntax on]]
vim.api.nvim_command [[:filetype plugin indent on]]

vim.api.nvim_command [[:highlight StatusLineBold guifg=#313633 guibg=#ccdc90 gui=bold]]

vim.opt.compatible = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.showbreak = '+++'
vim.opt.textwidth = 100
vim.opt.showmatch = true

vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2

vim.opt.ruler = true
vim.opt.showtabline = 2

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand '~/.config/nvim/undo'
vim.opt.undolevels = 100
vim.opt.backspace = { 'indent' , 'eol' , 'start' }
vim.opt.mouse = 'a'

vim.opt.hidden = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.foldenable = false
vim.opt.backupcopy = 'yes'
vim.opt.cmdheight = 2
vim.opt.updatetime = 200
vim.opt.shortmess:append { c = true }
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.timeoutlen = 1000
vim.opt.conceallevel = 0
vim.opt.lcs = { 'tab:| ' }
vim.opt.completeopt = { 'menuone', 'noselect' , 'noinsert' }
vim.opt.scrolloff = 4
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.statusline = "%-10.10(%#StatusLineBold#%{mode()}%#StatusLine# %m%) %= %#StatusLineBold# %0.80f %#StatusLine# %= %10.10(%H%W%R%)"

vim.cmd [[
  au BufNew,BufReadPost,BufReadPre,BufEnter *.md setlocal tw=80
  au BufNew,BufReadPost,BufReadPre,BufEnter *.md setlocal colorcolumn=80
  au BufNew,BufReadPost,BufReadPre,BufEnter * setlocal conceallevel=0
]]
