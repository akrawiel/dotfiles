-- Helpers

local nnoremapSilent = function(key, cmd, opts)
	vim.api.nvim_set_keymap("n", key, cmd, { noremap = true, silent = true, callback = opts and opts.callback or nil })
end

local nnoremap = function(key, cmd)
	vim.api.nvim_set_keymap("n", key, cmd, { noremap = true, silent = false })
end

local vnoremapSilent = function(key, cmd, opts)
	vim.api.nvim_set_keymap("v", key, cmd, { noremap = true, silent = true, callback = opts and opts.callback or nil })
end

local vnoremap = function(key, cmd)
	vim.api.nvim_set_keymap("v", key, cmd, { noremap = true, silent = false })
end

local onoremapSilent = function(key, cmd)
	vim.api.nvim_set_keymap("o", key, cmd, { noremap = true, silent = true })
end

local onoremap = function(key, cmd)
	vim.api.nvim_set_keymap("o", key, cmd, { noremap = true, silent = false })
end

local inoremapSilent = function(key, cmd)
	vim.api.nvim_set_keymap("i", key, cmd, { noremap = true, silent = true })
end

local xnoremapSilent = function(key, cmd)
	vim.api.nvim_set_keymap("x", key, cmd, { noremap = true, silent = true })
end

local tnoremap = function(key, cmd)
	vim.api.nvim_set_keymap("t", key, cmd, { noremap = true, silent = false })
end

-- File handling

nnoremap("<space>fs", [[<cmd>update<CR>]])

-- Barbar

nnoremapSilent("<space>bc", [[<cmd>bufdo :bwipeout<CR>]])
nnoremapSilent("<space>bd", [[<cmd>BufferClose<CR>]])
nnoremapSilent("<space>bD", [[<cmd>BufferClose!<CR>]])
nnoremapSilent("<space>bh", [[<cmd>BufferMovePrevious<CR>]])
nnoremapSilent("<space>bl", [[<cmd>BufferMoveNext<CR>]])
nnoremapSilent("<space>bo", [[<cmd>BufferCloseAllButCurrent<CR>]])
nnoremapSilent("gt", [[<cmd>BufferNext<CR>]])
nnoremapSilent("gT", [[<cmd>BufferPrevious<CR>]])
nnoremapSilent("<C-l>", [[<cmd>BufferNext<CR>]])
nnoremapSilent("<C-h>", [[<cmd>BufferPrevious<CR>]])
nnoremapSilent("<space><tab>", [[<cmd>BufferPick<CR>]])

-- Function keys

local function tmuxOrTerminal(cmd)
	if os.getenv("TMUX") ~= nil then
		vim.cmd["!"]({
			args = {
				"tmux neww -a",
				unpack(cmd),
			},
		})
	else
		vim.cmd.terminal({
			args = cmd,
		})
	end
end

nnoremapSilent("<F3>", [[<cmd>noh<CR>]])
vim.keymap.set("n", "<F4>", function()
	tmuxOrTerminal({
		"lf",
		"'" .. vim.fn.expand("%:p") .. "'",
	})
end, { silent = true })

-- Pounce

nnoremapSilent("s", [[<cmd>Pounce<CR>]])
nnoremapSilent("S", [[<cmd>PounceRepeat<CR>]])
vnoremapSilent("s", [[<cmd>Pounce<CR>]])
onoremapSilent("z", [[<cmd>Pounce<CR>]])

-- Search redefinition

nnoremapSilent("n", "nzzzv")
nnoremapSilent("N", "Nzzzv")

-- Leader operations

nnoremapSilent("<leader>p", [[<cmd>lua vim.lsp.buf.format { async = true }<CR>]])
vim.keymap.set("n", "<leader>t", function()
	tmuxOrTerminal({})
end, { silent = true })
vim.keymap.set("n", "<leader>g", function()
	tmuxOrTerminal({ "lazygit" })
end, { silent = true })
vim.keymap.set("n", "<leader>d", function()
	tmuxOrTerminal({ "lazydocker" })
end, { silent = true })

-- Current word search
local function highlightCurrentWord()
	vim.fn.setreg("/", string.lower(vim.fn.expand("<cword>")))
	vim.opt.hlsearch = true
end

nnoremapSilent("*", "", { callback = highlightCurrentWord })
nnoremapSilent("#", "", { callback = highlightCurrentWord })

local function highlightSelectedWord()
	if vim.fn.mode() ~= "v" then
		return
	end

	local _, csrow, cscol, cerow, cecol

	_, csrow, cscol, _ = unpack(vim.fn.getpos("."))
	_, cerow, cecol, _ = unpack(vim.fn.getpos("v"))

	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end

	local lines = vim.fn.getline(csrow, cerow)
	local n = #lines

	if n <= 0 then
		return ""
	end

	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)

	vim.fn.setreg("/", string.lower(table.concat(lines, "\\n")))

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

	vim.opt.hlsearch = true
end

vnoremapSilent("*", "", { callback = highlightSelectedWord })
vnoremapSilent("#", "", { callback = highlightSelectedWord })

-- External operations

nnoremapSilent("<space>k", '"+')
vnoremapSilent("<space>k", '"+')

-- Telescope

nnoremapSilent("<F1>", [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
nnoremapSilent("gd", [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]])
nnoremapSilent("gr", [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]])
nnoremapSilent("<space>ca", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
nnoremapSilent("<space>cd", [[<cmd>lua require('telescope.builtin').diagnostics({ bufnr = 0 })<CR>]])
nnoremapSilent("<space>cD", [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]])
nnoremapSilent("<space>co", [[<cmd>lua require('telescope.builtin').treesitter()<CR>]])
nnoremapSilent("<space>cO", [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>]])
nnoremapSilent("<space>r", [[<cmd>lua require('telescope.builtin').registers()<CR>]])
nnoremapSilent("<space>g", [[<cmd>lua require('telescope.builtin').git_status()<CR>]])
nnoremapSilent("<space>G", [[<cmd>lua require('telescope.builtin').grep_string({ search = "<<<<<<<" })<CR>]])
vim.keymap.set("n", "<space>fp", function()
	require("telescope.builtin").find_files({
		prompt_title = "Config",
		cwd = vim.fn.stdpath("config"),
		file_ignore_patterns = { "undo/.*" },
		follow = true,
	})
end)
vim.keymap.set("n", "<space>fr", function()
	local search = vim.fn.input("Enter search term: ")

	if #search > 0 then
		require("telescope.builtin").grep_string({ search = search })
	else
		print("No search term provided")
	end
end)
nnoremapSilent("<space>j", [[<cmd>lua require('telescope.builtin').jumplist()<CR>]])
nnoremapSilent("<space>q", [[<cmd>lua require('telescope.builtin').quickfix()<CR>]])
nnoremapSilent("<space>o", [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
nnoremapSilent("<space>h", [[<cmd>lua require('telescope.builtin').search_history()<CR>]])
nnoremapSilent(
	"<space>.",
	[[<cmd>lua require('telescope.builtin').find_files({ hidden = true, follow = true, cwd = require('telescope.utils').buffer_dir('.') })<CR>]]
)
nnoremapSilent("<space>/", [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
nnoremapSilent("<space><bs>", [[<cmd>lua require('telescope.builtin').resume()<CR>]])
nnoremapSilent("<space><return>", [[<cmd>lua require('telescope.builtin').commands()<CR>]])
nnoremapSilent(
	"<space><space>",
	[[<cmd>lua require('telescope.builtin').find_files({ find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' } })<CR>]]
)

-- Windows

nnoremapSilent("<space>wc", "<C-w>c")
nnoremapSilent("<space>wh", "<C-w>h")
nnoremapSilent("<space>wH", "<C-w>H")
nnoremapSilent("<space>wj", "<C-w>j")
nnoremapSilent("<space>wJ", "<C-w>J")
nnoremapSilent("<space>wk", "<C-w>k")
nnoremapSilent("<space>wK", "<C-w>K")
nnoremapSilent("<space>wl", "<C-w>l")
nnoremapSilent("<space>wL", "<C-w>L")
nnoremapSilent("<space>wq", "<C-w>q")
nnoremapSilent("<space>ww", "<C-w>w")

-- Yanking

xnoremapSilent("<space>p", '"_dP')

-- Packer

nnoremapSilent("<space>Ps", [[<cmd>PackerSync<CR>]])

-- Undo markers

inoremapSilent("!", "!<C-g>u")
inoremapSilent(",", ",<C-g>u")
inoremapSilent(".", ".<C-g>u")
inoremapSilent(":", ":<C-g>u")
inoremapSilent("-", "-<C-g>u")
inoremapSilent("_", "_<C-g>u")
inoremapSilent("?", "?<C-g>u")

-- Line moving

vnoremapSilent("<M-j>", [[:m \'>+1<CR>gv=gv]])
vnoremapSilent("<M-k>", [[:m \'<-2<CR>gv=gv]])
nnoremapSilent("<M-j>", [[:m .+1<CR>==]])
nnoremapSilent("<M-k>", [[:m .-2<CR>==]])

-- Quicklist

nnoremapSilent("<C-j>", [[<cmd>cnext<CR>]])
nnoremapSilent("<C-k>", [[<cmd>cprev<CR>]])

-- Text operations

vnoremapSilent("<space>tr", [[:!tac<CR>]])
vnoremapSilent("<space>ts", [[:!sort<CR>]])
vnoremapSilent("<space>tu", [[:!uniq<CR>]])

-- Auto keybindings reload

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost keybindings.lua source <afile>
  augroup end
]])
