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

-- Vim handling

nnoremap('<space>fs', '<cmd>w<CR>')
nnoremap('<space>fS', '<cmd>wq<CR>')
nnoremap('<space>qq', '<cmd>qa<CR>')
nnoremap('<space>zz', '<cmd>wqa<CR>')

-- Barbar

nnoremapSilent('<space>bc', '<cmd>bufdo :BufferWipeout<CR>')
nnoremapSilent('<space>bd', '<cmd>BufferClose<CR>')
nnoremapSilent('<space>bh', '<cmd>BufferMovePrevious<CR>')
nnoremapSilent('<space>bl', '<cmd>BufferMoveNext<CR>')
nnoremapSilent('<space>bo', '<cmd>BufferCloseAllButCurrent<CR>')
nnoremapSilent('gt', '<cmd>BufferNext<CR>')
nnoremapSilent('gT', '<cmd>BufferPrevious<CR>')
nnoremapSilent('<space>T', '<cmd>tabnext<CR>')
nnoremapSilent('<space><tab>', '<cmd>BufferPick<CR>')
nnoremapSilent('<space>1', '<cmd>BufferGoto 1<CR>')
nnoremapSilent('<space>2', '<cmd>BufferGoto 2<CR>')
nnoremapSilent('<space>3', '<cmd>BufferGoto 3<CR>')
nnoremapSilent('<space>4', '<cmd>BufferGoto 4<CR>')

-- Function keys

nnoremapSilent('<F3>', '<cmd>noh<CR>')
nnoremapSilent('<F4>', '<cmd>NnnPicker %:p:h<CR>')

-- Hop

nnoremapSilent('<space>j0', '<cmd>HopLineStart<CR>')
nnoremapSilent('<space>jw', '<cmd>HopWordMW<CR>')

nnoremapSilent('/', '<cmd>HopPattern<CR>')
vnoremapSilent('/', '<cmd>HopPattern<CR>')
onoremapSilent('/', '<cmd>HopPattern<CR>')

local hopCommands = {
  f = [[<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false, inclusive_jump = false })<cr>]],
  F = [[<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false, inclusive_jump = false })<cr>]],
  s = [[<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false, inclusive_jump = true })<cr>]],
  S = [[<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false, inclusive_jump = true })<cr>]], 
  t = [[<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false, inclusive_jump = true })<cr>]],
  T = [[<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false, inclusive_jump = true })<cr>]],
}

nnoremapSilent('f', hopCommands.f)
nnoremapSilent('F', hopCommands.F)
nnoremapSilent('s', hopCommands.s)
nnoremapSilent('S', hopCommands.S)
nnoremapSilent('t', hopCommands.t)
nnoremapSilent('T', hopCommands.T)

vnoremapSilent('f', hopCommands.f)
vnoremapSilent('F', hopCommands.F)
vnoremapSilent('s', hopCommands.s)
vnoremapSilent('S', hopCommands.S)
vnoremapSilent('t', hopCommands.t)
vnoremapSilent('T', hopCommands.T)

onoremapSilent('f', hopCommands.f)
onoremapSilent('F', hopCommands.F)
onoremapSilent('z', hopCommands.s)
onoremapSilent('Z', hopCommands.S)
onoremapSilent('t', hopCommands.t)
onoremapSilent('T', hopCommands.T)

-- Leader operations

nnoremapSilent('<leader>f', '<cmd>EslintFixAll<CR>')
nnoremapSilent('<leader>p', '<cmd>Format<CR>')

-- Telescope

nnoremapSilent('<F1>', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
nnoremapSilent('gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]])
nnoremapSilent('gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]])
nnoremapSilent('<space>ca', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]])
nnoremapSilent('<space>cd', [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]])
nnoremapSilent('<space>co', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
nnoremapSilent('<space>cO', [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>]])
nnoremapSilent('<space>ct', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>]])
nnoremapSilent('<space>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
nnoremapSilent('<space>ff', [[<cmd>lua require('telescope.builtin').registers()<CR>]])
nnoremapSilent('<space>fg', [[<cmd>lua require('telescope.builtin').git_status()<CR>]])
nnoremapSilent('<space>fp', [[<cmd>lua require('telescope-config').search_config()<CR>]])
nnoremapSilent('<space>fr', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
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

-- Ex commands to fill

nnoremap('<space>ss', ':<C-u>%s/')
vnoremap('<space>ss', ':<C-u>\'<,\'>s/')
nnoremap('<space>x', ':<C-u>')
vnoremap('<space>x', ':<C-u>')

-- Terminal

tnoremap('<Esc>', '<C-\\><C-n>')
