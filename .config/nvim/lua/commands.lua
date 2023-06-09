vim.cmd([[
  au BufNew,BufReadPost,BufReadPre,BufEnter *.md setlocal tw=80
  au BufNew,BufReadPost,BufReadPre,BufEnter *.md setlocal colorcolumn=80
  au BufNew,BufReadPost,BufReadPre,BufEnter * setlocal conceallevel=0
  filetype plugin indent on
  syntax on
  language en_US.utf8
]])
