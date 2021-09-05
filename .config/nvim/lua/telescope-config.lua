local actions = require('telescope.actions')
local previewers = require('telescope.previewers')

require('telescope').setup {
  defaults = {
    prompt_prefix = '> ',
    color_devicons = false,
    use_less = false,

    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,

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
    file_ignore_patterns = { "undo/.*" }
  })
end

return M
