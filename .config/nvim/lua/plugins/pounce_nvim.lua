return {
	"rlane/pounce.nvim",
	config = function()
		vim.cmd("highlight PounceMatch guifg=Black guibg=#8080ff gui=bold")
		vim.cmd("highlight PounceAccept guifg=Black guibg=#b0b0ff gui=bold")
		vim.cmd("highlight PounceAcceptBest guifg=Black guibg=#e0e0ff gui=bold")
		vim.cmd("highlight PounceGap guifg=Black guibg=#4040ff gui=bold")
	end,
}
