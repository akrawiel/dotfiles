local actions = require('telescope.actions')
local previewers = require('telescope.previewers')

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
        ["<C-n>"] = false,
        ["<C-p>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<M-a>"] = actions.toggle_all,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
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
