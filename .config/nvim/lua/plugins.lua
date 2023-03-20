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
	use({
		"cshuaimin/ssr.nvim",
		module = "ssr",
	})
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
	use("hrsh7th/cmp-vsnip")
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("cmp-config")
		end,
	})
	use("hrsh7th/vim-vsnip")
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
					require("null-ls").builtins.formatting.elm_format,
					require("null-ls").builtins.formatting.prettierd,
					require("null-ls").builtins.formatting.eslint_d,
					require("null-ls").builtins.formatting.stylua,
				},
			})
		end,
	})
	use("kyazdani42/nvim-web-devicons")
	use({
		"machakann/vim-highlightedyank",
		config = function()
			vim.g.highlightedyank_highlight_duration = 100
		end,
	})
	use({
		"luukvbaal/nnn.nvim",
		config = function()
			require("nnn").setup({
				picker = {
					style = {
						width = 0.9,
						height = 0.5,
						xoffset = 0.5,
						yoffset = 0.5,
						border = "double",
					},
					session = "",
				},
				mappings = {
					{ "<C-x>", require("nnn").builtin.open_in_split },
					{ "<C-v>", require("nnn").builtin.open_in_vsplit },
					{ "<C-e>", require("nnn").builtin.populate_cmdline },
				},
				buflisted = false,
			})
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
			require("orgmode").setup({
				mappings = {
					prefix = "<space>o",
					capture = {
						org_capture_finalize = "S",
						org_capture_refile = "R",
						org_capture_kill = "Q",
					},
				},
				win_split_mode = "float",
				org_agenda_files = { "~/Dropbox/Documents/OrgSync/**/*" },
				org_capture_templates = {
					t = {
						description = "Task",
						template = "* TODO %?",
						target = "~/Dropbox/Documents/OrgSync/Todo Daily.org",
					},
					l = { description = "Link", template = "* %?" },
				},
				org_default_notes_file = "~/Dropbox/Documents/OrgSync/Inbox.org",
				org_priority_highest = "A",
				org_priority_default = "B",
				org_priority_lowest = "E",
				org_tags_column = -64,
				org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAIT(w)", "|", "DONE(d)" },
				org_todo_keyword_faces = {
					TODO = ":foreground orange :weight bold",
					NEXT = ":foreground white :weight bold",
					WAIT = ":foreground red :weight bold",
					DONE = ":foreground lightgreen :weight bold",
				},
				org_blank_before_new_entry = {
					heading = false,
					plain_list_item = false,
				},
			})
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope-config")
		end,
	})
	use("nvim-telescope/telescope-symbols.nvim")
	use("nvim-telescope/telescope-ui-select.nvim")
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
	use("tpope/vim-repeat")
	use("tpope/vim-speeddating")
	use("tpope/vim-surround")

	-- colorschemes
	use({
		"phha/zenburn.nvim",
		config = function()
			vim.api.nvim_command([[:colorscheme zenburn]])
			vim.api.nvim_command([[:highlight Search guifg=#313633 guibg=#6d7f28]])
			vim.api.nvim_command([[:highlight CurSearch guifg=#313633 guibg=#aac445 gui=bold]])
		end,
	})

	-- language highlighting
	use({
		"ionide/Ionide-vim",
		run = "make fsautocomplete",
	})

	-- bootstrap sync check
	if packer_bootstrap then
		require("packer").sync()
	end
end)
