local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')
local Path = require('plenary.path')

require('telescope').setup {
  defaults = {
    prompt_prefix = '> ',
    disable_devicons = false,
    color_devicons = true,
    use_less = true,

    layout_config = {
      horizontal = {
        height = 0.5,
        width = 0.9,
      },
    },

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
        ["<esc>"] = actions.close
      }
    }
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
    }
  }
}

require('telescope').load_extension('fzf')

local M = {}

M.search_config = function()
  require('telescope.builtin').find_files({
    prompt_title = 'Config',
    cwd = '~/.config/nvim',
    file_ignore_patterns = { "undo/.*" },
    follow = true,
  })
end

return M
