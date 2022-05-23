vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local packer = require 'packer'

return packer.startup(function()
  -- base packer
  use { 'wbthomason/packer.nvim' }

  -- plugins
  use { 'arthurxavierx/vim-caser' }
  use { 'editorconfig/editorconfig-vim' }
  use {
    'ggandor/lightspeed.nvim',
    config = function()
      require 'lightspeed'.setup {
        exit_after_idle_msecs = { labeled = nil, unlabeled = nil },
        safe_labels = nil,
        limit_ft_matches = 10,
      }

      vim.cmd 'highlight LightspeedOneCharMatch guifg=Black guibg=#b0b0ff gui=bold'
    end
  }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-vsnip' }
  use { 
    'hrsh7th/nvim-cmp',
    config = function()
      require 'cmp-config'
    end
  }
  use { 'hrsh7th/vim-vsnip' }
  -- use { 'hrsh7th/vscode-langservers-extracted' }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.code_actions.eslint_d,
          require("null-ls").builtins.diagnostics.eslint_d,
          require("null-ls").builtins.diagnostics.jsonlint,
          require("null-ls").builtins.formatting.prettierd.with {
            to_temp_file = false
          },
          require("null-ls").builtins.formatting.eslint_d.with {
            to_temp_file = false
          },
        },
      })
    end,
  }
  use {
    'kdheepak/lazygit.nvim',
    config = function()
      vim.g.lazygit_floating_window_use_plenary = 1
      vim.g.lazygit_floating_window_winblend = 1
    end
  }
  use { 'kyazdani42/nvim-web-devicons' }
  use {
    'machakann/vim-highlightedyank',
    config = function()
      vim.g.highlightedyank_highlight_duration = 100
    end
  }
  use {
    'mcchrish/nnn.vim',
    config = function()
      vim.g['nnn#set_default_mappings'] = 0
      vim.g['nnn#layout'] = {
        window = { width = 0.8, height = 0.7, highlight = 'Debug' }
      }
      vim.g['nnn#action'] = {
        ['<c-x>'] = 'split',
        ['<c-v>'] = 'vsplit',
        ['<esc>'] = 'close',
      }
    end
  }
  use { 'mg979/vim-visual-multi', branch = 'master' }
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require 'lsp-config' {
        -- 'dartls',
        -- 'gdscript',
        -- 'gopls',
        -- 'html',
        -- 'omnisharp',
        -- 'svelte',
        -- 'vuels',
        'cssls',
        'eslint',
        -- 'rust_analyzer',
        'tsserver',
      }
    end
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  use { 'nvim-lua/plenary.nvim' }
  use { 'nvim-telescope/telescope-ui-select.nvim' }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require 'telescope-config'
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'treesitter-config'
    end
  }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use {
    'phaazon/hop.nvim',
    config = function()
      require('hop').setup {
        char2_fallback_key = "<cr>",
        jump_on_sole_occurrence = true,
        teasing = false,
      }
    end,
  }
  use { 'romgrk/barbar.nvim' }
  use {
    'rlane/pounce.nvim',
    config = function()
      vim.cmd 'highlight PounceMatch guifg=Black guibg=#8080ff gui=bold'
      vim.cmd 'highlight PounceAccept guifg=Black guibg=#b0b0ff gui=bold'
      vim.cmd 'highlight PounceAcceptBest guifg=Black guibg=#e0e0ff gui=bold'
      vim.cmd 'highlight PounceGap guifg=Black guibg=#4040ff gui=bold'
    end,
  }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-speeddating' }
  use { 'tpope/vim-surround' }
  use { 'vim-airline/vim-airline' }

  -- colorschemes
  use {
    'phha/zenburn.nvim',
    config = function()
      vim.cmd 'colorscheme zenburn'
    end
  }

  -- language highlighting
  use { 'ionide/Ionide-vim', run = 'make fsautocomplete' }
end)
