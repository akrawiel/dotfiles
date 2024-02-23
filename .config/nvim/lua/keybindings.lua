local kc = require("keycommands")
local tb = require("telescope.builtin")

vim.g.mapleader = ","
vim.g.maplocalleader = ","

local cmd = function(cmd)
	return function()
		vim.cmd(cmd)
	end
end

local silent = { silent = true, noremap = true }
local noSilent = { silent = false, noremap = true }

local keybindings = {
	n = {
		{ "<C-h>", cmd("BufferPrevious") },
		{ "<C-l>", cmd("BufferNext") },
		{ "<F1>", tb.help_tags },
		{ "<F3>", cmd("noh") },
		{ "-", cmd("Oil") },
		{ "gd", tb.lsp_definitions },
		{ "gr", tb.lsp_references },
		{ "gt", cmd("BufferNext") },
		{ "gT", cmd("BufferPrevious") },
		{ "gx", cmd('silent exec "!setsid xdg-open <cWORD>"') },
		{ "#", kc.hlcword },
		{ "*", kc.hlcword },
		{ "<leader>d", kc.tmux({ "lazydocker" }) },
		{ "<leader>g", kc.tmux({ "lazygit" }) },
		{ "<leader>p", cmd("Format") },
		{ "<leader>t", kc.tmux({}) },
		{ "n", "nzzzv" },
		{ "N", "Nzzzv" },
		{ "s", cmd("Pounce") },
		{ "S", cmd("PounceRepeat") },
		{ "<C-j>", cmd("cnext") },
		{ "<C-k>", cmd("cprev") },
		{ "<space>bc", cmd("bufdo :bwipeout") },
		{ "<space>bd", cmd("BufferClose") },
		{ "<space>bD", cmd("BufferClose!") },
		{ "<space>bh", cmd("BufferMovePrevious") },
		{ "<space>bl", cmd("BufferMoveNext") },
		{ "<space>bo", cmd("BufferCloseAllButCurrent") },
		{ "<space><bs>", tb.resume },
		{ "<space>ca", vim.lsp.buf.code_action },
		{ "<space>cd", kc.curbufdiag },
		{ "<space>cD", tb.diagnostics },
		{ "<space>cO", tb.lsp_dynamic_workspace_symbols },
		{ "<space>co", tb.treesitter },
		{ "<space>fp", kc.config },
		{ "<space>fr", kc.grepstr },
		{ "<space>fs", cmd("update"), opts = noSilent },
		{ "<space>G", kc.conflictmarkers },
		{ "<space>g", tb.git_status },
		{ "<space>h", tb.search_history },
		{ "<space>j", tb.jumplist },
		{ "<space>k", '"+' },
		{ "<space>.", kc.filescurdir },
		{ "<space>n", kc.filesnotes },
		{ "<space>o", tb.oldfiles },
		{ "<space>S", cmd("Lazy sync") },
		{ "<space>q", tb.quickfix },
		{ "<space><return>", tb.commands },
		{ "<space>r", tb.registers },
		{ "<space><space>", kc.files },
		{ "<space><tab>", cmd("BufferPick") },
		{ "<space>/", tb.current_buffer_fuzzy_find },
		{ "<space>wc", "<C-w>c" },
		{ "<space>wh", "<C-w>h" },
		{ "<space>wH", "<C-w>H" },
		{ "<space>wj", "<C-w>j" },
		{ "<space>wJ", "<C-w>J" },
		{ "<space>wk", "<C-w>k" },
		{ "<space>wK", "<C-w>K" },
		{ "<space>wl", "<C-w>l" },
		{ "<space>wL", "<C-w>L" },
		{ "<space>wo", "<C-w>o" },
		{ "<space>wq", "<C-w>q" },
		{ "<space>ww", "<C-w>w" },
	},
	v = {
		{ "<C-j>", cmd("cnext") },
		{ "<C-k>", cmd("cprev") },
		{ "#", kc.hlsword },
		{ "*", kc.hlsword },
		{ "s", [[<cmd>Pounce<CR>]] },
		{ "<space>k", '"+' },
		{ "<space>tr", ":!tac<CR>" },
		{ "<space>ts", ":!sort<CR>" },
		{ "<space>tu", ":!uniq<CR>" },
	},
	i = {
		{ "!", "!<C-g>u" },
		{ ",", ",<C-g>u" },
		{ "-", "-<C-g>u" },
		{ ".", ".<C-g>u" },
		{ ":", ":<C-g>u" },
		{ "?", "?<C-g>u" },
		{ "_", "_<C-g>u" },
	},
	o = {
		{ "z", cmd("Pounce") },
	},
	x = {
		{ "<space>p", '"_dP' },
	},
}

for mode, bindings in pairs(keybindings) do
	for _, binding in pairs(bindings) do
		vim.keymap.set(mode, binding[1], binding[2], binding.opts or silent)
	end
end

-- Line moving

-- vnoremapSilent("<M-j>", [[:m \'>+1<CR>gv=gv]])
-- vnoremapSilent("<M-k>", [[:m \'<-2<CR>gv=gv]])
-- nnoremapSilent("<M-j>", [[:m .+1<CR>==]])
-- nnoremapSilent("<M-k>", [[:m .-2<CR>==]])
