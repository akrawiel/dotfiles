local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local packer_bootstrap

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	print("Downloading packer.nvim...")

	packer_bootstrap = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})

	print(packer_bootstrap)

	print("Packer.nvim installed")
	print("Restart neovim now")

	vim.cmd([[2sleep]])
	vim.cmd([[qa]])
end

return require("packer").startup(function(use)
	vim.cmd([[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
  ]])

	-- base packer
	use("wbthomason/packer.nvim")

	-- plugins
	use("arthurxavierx/vim-caser")
	use("editorconfig/editorconfig-vim")
	use({
		"echasnovski/mini.nvim",
		config = function()
			require("mini.jump").setup({})
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
	})
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-nvim-lsp")
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("cmp-config")
		end,
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup({
				sources = {
					require("null-ls").builtins.code_actions.eslint_d,
					require("null-ls").builtins.diagnostics.eslint_d,
					require("null-ls").builtins.diagnostics.fish,
					require("null-ls").builtins.diagnostics.jsonlint,
					require("null-ls").builtins.diagnostics.luacheck,
					require("null-ls").builtins.diagnostics.yamllint,
					require("null-ls").builtins.formatting.prettierd,
					require("null-ls").builtins.formatting.eslint_d,
					require("null-ls").builtins.formatting.stylua,
				},
			})
		end,
	})
	use("kyazdani42/nvim-web-devicons")
	use({
		"L3MON4D3/LuaSnip",
		tag = "v1.*",
		run = "make install_jsregexp",
	})
	use({
		"machakann/vim-highlightedyank",
		config = function()
			vim.g.highlightedyank_highlight_duration = 100
		end,
	})
	use({
		"mg979/vim-visual-multi",
		branch = "master",
	})
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp-config")()
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use("nvim-lua/plenary.nvim")
	use({
		"nvim-orgmode/orgmode",
		config = function()
			require("orgmode-config")()
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope-config")
		end,
	})
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("treesitter-config")
		end,
	})
	use("nvim-treesitter/nvim-treesitter-context")
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("romgrk/barbar.nvim")
	use({
		"rlane/pounce.nvim",
		config = function()
			vim.cmd("highlight PounceMatch guifg=Black guibg=#8080ff gui=bold")
			vim.cmd("highlight PounceAccept guifg=Black guibg=#b0b0ff gui=bold")
			vim.cmd("highlight PounceAcceptBest guifg=Black guibg=#e0e0ff gui=bold")
			vim.cmd("highlight PounceGap guifg=Black guibg=#4040ff gui=bold")
		end,
	})
	use("saadparwaiz1/cmp_luasnip")
	use({
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	})
	use("tpope/vim-repeat")
	use("tpope/vim-speeddating")
	use("tpope/vim-surround")

	-- colorschemes
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			vim.api.nvim_command([[:colorscheme catppuccin-frappe]])
		end,
	})

	-- bootstrap sync check
	if packer_bootstrap then
		require("packer").sync()
	end
end)
