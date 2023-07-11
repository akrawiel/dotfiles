return {
	"neovim/nvim-lspconfig",
	config = function()
		require("lsp-config")()
	end,
}
