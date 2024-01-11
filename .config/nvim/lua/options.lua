local opts = {
	autoindent = true,
	backspace = { "indent", "eol", "start" },
	backup = false,
	backupcopy = "yes",
	cmdheight = 2,
	compatible = false,
	completeopt = { "menuone", "noselect", "noinsert" },
	conceallevel = 0,
	cursorline = true,
	expandtab = false,
	foldenable = false,
	hidden = true,
	hlsearch = true,
	ignorecase = true,
	incsearch = true,
	laststatus = 3,
	lcs = "tab:> ,eol:⏎,leadmultispace:· ,nbsp:·",
	linebreak = true,
	list = true,
	mouse = "",
	mousemodel = "extend",
	number = true,
	relativenumber = true,
	ruler = true,
	scrolloff = 4,
	shiftwidth = 2,
	shortmess = vim.opt.shortmess:append({ c = true }),
	showbreak = "+++",
	showmatch = true,
	showmode = false,
	showtabline = 2,
	signcolumn = "yes",
	smartcase = true,
	smartindent = true,
	smarttab = true,
	softtabstop = 0,
	statusline = "%-10.10(%#StatusLineBold#%{mode()}%#StatusLine# %m%) %= %#StatusLineBold# %0.80f %#StatusLine# %= %10.10(%H%W%R%)",
	swapfile = false,
	tabstop = 2,
	termguicolors = true,
	textwidth = 100,
	timeoutlen = 1000,
	undodir = vim.fn.expand("~/.config/nvim/undo"),
	undofile = true,
	undolevels = 100,
	updatetime = 200,
	wrap = false,
	writebackup = false,
}

for key, value in pairs(opts) do
	vim.opt[key] = value
end
