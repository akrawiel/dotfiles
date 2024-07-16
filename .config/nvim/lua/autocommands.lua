local autocommands = {
	{
		"TermOpen",
		{ command = "startinsert", pattern = "*" },
	},
	{
		"TermClose",
		{
			callback = function(event)
				if not event.status then
					vim.api.nvim_input("<CR>")
				end
			end,
			pattern = "*",
		},
	},
	{
		{ "BufNewFile", "BufRead" },
		{ command = "set ft=html", pattern = "*.njk" },
	},
}

for _, autocmd in pairs(autocommands) do
	vim.api.nvim_create_autocmd(unpack(autocmd))
end

local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {
	clear = true,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
	group = highlight_yank_group,
})
