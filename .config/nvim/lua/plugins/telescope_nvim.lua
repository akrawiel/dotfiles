return {
	"nvim-telescope/telescope.nvim",
	config = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		require("telescope").setup({
			defaults = {
				prompt_prefix = " 💻 ",
				entry_prefix = "    ",
				selection_caret = " 👉 ",
				multi_icon = " ✅ ",
				disable_devicons = false,
				color_devicons = true,

				layout_config = {
					height = 40,
					prompt_position = "bottom",
					mirror = true,
				},
				layout_strategy = "vertical",
				results_title = false,
				sorting_strategy = "descending",

				mappings = {
					i = {
						["<C-n>"] = function() end,
						["<C-p>"] = function() end,
						["<C-t>"] = function() end,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<tab>"] = actions.toggle_selection + actions.move_selection_next,
						["<M-a>"] = actions.toggle_all,
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						["<C-h>"] = actions.which_key,
						["<C-space>"] = function(prompt_bufnr, mode, target)
							local picker = action_state.get_current_picker(prompt_bufnr)

							actions.close(prompt_bufnr)

							for _, entry in ipairs(picker:get_multi_selection()) do
								pcall(vim.cmd, string.format("edit %s", entry.value))
							end
						end,
						["<esc>"] = function(prompt_bufnr, mode, target)
							actions.close(prompt_bufnr, mode, target)
							vim.cmd([[stopinsert]])
						end,
						["<CR>"] = function(prompt_bufnr, mode, target)
							actions.select_default(prompt_bufnr, mode, target)
							vim.cmd([[stopinsert]])
						end,
					},
				},
			},

			pickers = {
				live_grep = {
					layout_config = {
						mirror = true,
					},
				},
				find_files = {
					previewer = false,
				},
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		require("telescope").load_extension("fzf")
	end,
}
