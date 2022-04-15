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

-- Barbar

nnoremapSilent('<space>bd', '<cmd>BufferClose<CR>')
nnoremapSilent('<space>bh', '<cmd>BufferMovePrevious<CR>')
nnoremapSilent('<space>bl', '<cmd>BufferMoveNext<CR>')
nnoremapSilent('<space>bO', '<cmd>BufferCloseAllButCurrent<CR>')
nnoremapSilent('<space>bC', '<cmd>bufdo :BufferWipeout<CR>')
nnoremapSilent('gt', '<cmd>BufferNext<CR>')
nnoremapSilent('gT', '<cmd>BufferPrevious<CR>')
nnoremapSilent('<space>t', '<cmd>tabnext<CR>')
nnoremapSilent('<space>T', '<cmd>tabprevious<CR>')
nnoremapSilent('<space><tab>', '<cmd>BufferPick<CR>')

-- Function keys

nnoremapSilent('<F3>', '<cmd>noh<CR>')
nnoremapSilent('<F4>', '<cmd>NnnPicker %:p:h<CR>')

-- Hop

nnoremapSilent('<leader>f', '<cmd>HopChar1<CR>')
nnoremapSilent('<leader>s', '<cmd>HopChar2<CR>')
nnoremapSilent('<leader>w', '<cmd>HopWord<CR>')
nnoremapSilent('<leader>/', '<cmd>HopPattern<CR>')
nnoremapSilent('<leader>l', '<cmd>HopLineStart<CR>')
nnoremapSilent('<leader>L', '<cmd>HopLine<CR>')

-- Formatting

nnoremapSilent('<leader>p', '<cmd>Format<CR>')

-- Telescope

nnoremapSilent('<space><space>', [[<cmd>lua require('telescope.builtin').find_files({ find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' } })<CR>]])
nnoremapSilent('<space>ff', [[<cmd>lua require('telescope.builtin').file_browser({ cwd = require('telescope.utils').buffer_dir() })<CR>]])
nnoremapSilent('<space>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
nnoremapSilent('<space>fp', [[<cmd>lua require('telescope-config').search_config()<CR>]])
nnoremapSilent('<space>fr', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
nnoremapSilent('<space>ca', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]])
nnoremapSilent('<space>co', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
nnoremapSilent('<space>fd', [[<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<CR>]])
nnoremapSilent('gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]])
nnoremapSilent('<space>pp', [[<cmd>lua require('telescope.builtin').registers()<CR>]])
nnoremapSilent('<space>gs', [[<cmd>lua require('telescope.builtin').git_status()<CR>]])
nnoremapSilent('<space><BS>', [[<cmd>lua require('telescope.builtin').resume()<CR>]])
nnoremapSilent('<space>/', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
nnoremapSilent('<F1>', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
nnoremapSilent('<space><return>', [[<cmd>lua require('telescope.builtin').commands()<CR>]])

-- Windows

nnoremapSilent('<space>wc', '<cmd>q<CR>')

-- Undo markers

inoremapSilent(',', ',<C-g>u')
inoremapSilent('.', '.<C-g>u')
inoremapSilent('!', '!<C-g>u')
inoremapSilent('?', '?<C-g>u')

-- Line moving

vnoremapSilent('J', ':m \'>+1<CR>gv=gv')
vnoremapSilent('K', ':m \'<-2<CR>gv=gv')
nnoremapSilent('<M-j>', ':m .+1<CR>==')
nnoremapSilent('<M-k>', ':m .-2<CR>==')

-- Quicklist

nnoremapSilent('<C-j>', '<cmd>cnext<CR>')
nnoremapSilent('<C-k>', '<cmd>cprev<CR>')

-- Line reverse

vnoremapSilent('<space>lr', '<cmd><C-u>\'<,\'>!tac<CR>')

-- Ex commands to fill

nnoremap('<C-s>', ':<C-u>%s/')
vnoremap('<C-s>', ':<C-u>\'<,\'>s/')

-- Terminal

tnoremap('<Esc>', '<C-\\><C-n>')
