-- Helpers

local nnoremapSilent = function(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true })
end

local nnoremap = function(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = false })
end

local vnoremapSilent = function(key, cmd)
  vim.api.nvim_set_keymap('v', key, cmd, { noremap = true, silent = true })
end

local vnoremap = function(key, cmd)
  vim.api.nvim_set_keymap('v', key, cmd, { noremap = true, silent = false })
end

local onoremapSilent = function(key, cmd)
  vim.api.nvim_set_keymap('o', key, cmd, { noremap = true, silent = true })
end

local onoremap = function(key, cmd)
  vim.api.nvim_set_keymap('o', key, cmd, { noremap = true, silent = false })
end

local inoremapSilent = function(key, cmd)
  vim.api.nvim_set_keymap('i', key, cmd, { noremap = true, silent = true })
end

local tnoremap = function(key, cmd)
  vim.api.nvim_set_keymap('t', key, cmd, { noremap = true, silent = false })
end

-- File handling

nnoremap('<space>fs', '<cmd>w<CR>')
nnoremap('<space>fS', '<cmd>wq<CR>')
nnoremap('<space>qq', '<cmd>qa<CR>')
nnoremap('<space>zz', '<cmd>wqa<CR>')

-- Barbar

nnoremapSilent('<space>bc', '<cmd>bufdo :BufferWipeout<CR>')
nnoremapSilent('<space>bd', '<cmd>BufferClose<CR>')
nnoremapSilent('<space>bD', '<cmd>BufferClose!<CR>')
nnoremapSilent('<space>bp', '<cmd>BufferPin<CR>')
nnoremapSilent('<space>bh', '<cmd>BufferMovePrevious<CR>')
nnoremapSilent('<space>bl', '<cmd>BufferMoveNext<CR>')
nnoremapSilent('<space>bo', '<cmd>BufferCloseAllButCurrent<CR>')
nnoremapSilent('gt', '<cmd>BufferNext<CR>')
nnoremapSilent('gT', '<cmd>BufferPrevious<CR>')
nnoremapSilent('<space><tab>', '<cmd>BufferPick<CR>')
nnoremapSilent('<space>1', '<cmd>BufferGoto 1<CR>')
nnoremapSilent('<space>2', '<cmd>BufferGoto 2<CR>')
nnoremapSilent('<space>3', '<cmd>BufferGoto 3<CR>')
nnoremapSilent('<space>4', '<cmd>BufferGoto 4<CR>')

-- Function keys

nnoremapSilent('<F3>', '<cmd>noh<CR>')
nnoremapSilent('<F4>', '<cmd>NnnPicker %:p:h<CR>')

-- Hop

nnoremapSilent('<space>jl', '<cmd>HopLineStartMW<CR>')
nnoremapSilent('<space>jj', '<cmd>HopWordMW<CR>')
nnoremapSilent('<space>j/', '<cmd>HopPatternMW<CR>')

-- Pounce

nnoremapSilent('s', [[<cmd>Pounce<CR>]])
nnoremapSilent('S', [[<cmd>PounceRepeat<CR>]])
vnoremapSilent('s', [[<cmd>Pounce<CR>]])
onoremapSilent('z', [[<cmd>Pounce<CR>]])

-- Leader operations

nnoremapSilent('<leader>p', [[<cmd>lua vim.lsp.buf.format { async = true }<CR>]])
nnoremapSilent('<leader>t', '<cmd>terminal<CR>')
nnoremapSilent('<leader>g', '<cmd>LazyGit<CR>')

-- External operations

nnoremapSilent('<space>k', '"+')
vnoremapSilent('<space>k', '"+')

-- Telescope

nnoremapSilent('<F1>', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
nnoremapSilent('gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]])
nnoremapSilent('gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]])
nnoremapSilent('<space>ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
nnoremapSilent('<space>cd', [[<cmd>lua require('telescope.builtin').diagnostics({ bufnr = 0 })<CR>]])
nnoremapSilent('<space>cD', [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]])
nnoremapSilent('<space>co', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
nnoremapSilent('<space>cO', [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>]])
nnoremapSilent('<space>ct', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>]])
nnoremapSilent('<space>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
nnoremapSilent('<space>ff', [[<cmd>lua require('telescope.builtin').registers()<CR>]])
nnoremapSilent('<space>fg', [[<cmd>lua require('telescope.builtin').git_status()<CR>]])
nnoremapSilent('<space>fp', [[<cmd>lua require('telescope-config').search_config()<CR>]])
nnoremapSilent('<space>fr', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
nnoremapSilent('<space>fq', [[<cmd>lua require('telescope.builtin').quickfix()<CR>]])
nnoremapSilent('<space>fd', [[<cmd>lua require('telescope.builtin').treesitter()<CR>]])
nnoremapSilent('<space>fo', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
nnoremapSilent('<space>f/', [[<cmd>lua require('telescope.builtin').search_history()<CR>]])
nnoremapSilent('<space>.', [[<cmd>lua require('telescope.builtin').find_files({ hidden = true, follow = true, cwd = require('telescope.utils').buffer_dir('.') })<CR>]])
nnoremapSilent('<space>/', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
nnoremapSilent('<space><bs>', [[<cmd>lua require('telescope.builtin').resume()<CR>]])
nnoremapSilent('<space><return>', [[<cmd>lua require('telescope.builtin').commands()<CR>]])
nnoremapSilent('<space><space>', [[<cmd>lua require('telescope.builtin').find_files({ find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' } })<CR>]])

-- Windows

nnoremapSilent('<space>wc', '<C-w>c')
nnoremapSilent('<space>wh', '<C-w>h')
nnoremapSilent('<space>wH', '<C-w>H')
nnoremapSilent('<space>wj', '<C-w>j')
nnoremapSilent('<space>wJ', '<C-w>J')
nnoremapSilent('<space>wk', '<C-w>k')
nnoremapSilent('<space>wK', '<C-w>K')
nnoremapSilent('<space>wl', '<C-w>l')
nnoremapSilent('<space>wL', '<C-w>L')
nnoremapSilent('<space>wq', '<C-w>q')
nnoremapSilent('<space>ww', '<C-w>w')

-- Undo markers

inoremapSilent('!', '!<C-g>u')
inoremapSilent(',', ',<C-g>u')
inoremapSilent('.', '.<C-g>u')
inoremapSilent('?', '?<C-g>u')

-- Line moving

vnoremapSilent('<M-j>', ':m \'>+1<CR>gv=gv')
vnoremapSilent('<M-k>', ':m \'<-2<CR>gv=gv')
nnoremapSilent('<M-j>', ':m .+1<CR>==')
nnoremapSilent('<M-k>', ':m .-2<CR>==')

-- Quicklist

nnoremapSilent('<C-j>', '<cmd>cnext<CR>')
nnoremapSilent('<C-k>', '<cmd>cprev<CR>')

-- Text operations

vnoremapSilent('<space>tr', '!tac<CR>')
vnoremapSilent('<space>ts', '!sort<CR>')

-- Ex commands

nnoremap('<space>ss', ':<C-u>%s/')
vnoremap('<space>ss', ':<C-u>\'<,\'>s/')

nnoremap('<space>so', [[:<C-u>so<CR>]])
vnoremap('<space>so', [[:<C-u>'<,'>so<CR>]])

nnoremap('<space>x', ':<C-u>')
vnoremap('<space>x', ':<C-u>')

-- Terminal

-- tnoremap('<Esc>', '<C-\\><C-n>')
