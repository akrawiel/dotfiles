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
