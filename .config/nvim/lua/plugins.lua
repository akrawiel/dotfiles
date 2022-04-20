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
  use { 'famiu/bufdelete.nvim' }
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
  use { 'hrsh7th/vscode-langservers-extracted' }
  use { 'kyazdani42/nvim-web-devicons' }
  -- use {
  --   'ggandor/lightspeed.nvim',
  --   config = function()
  --     require 'lightspeed'.setup {
  --       exit_after_idle_msecs = { labeled = nil, unlabeled = nil },
  --       safe_labels = nil,
  --     }
  --   end
  -- }
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
    'mhartington/formatter.nvim',
    config = function()
      local prettier = function()
        return {
          exe = "prettierd",
          args = {vim.api.nvim_buf_get_name(0)},
          stdin = true,
        }
      end

      require('formatter').setup {
        filetype = {
          javascript = {prettier},
          javascriptreact = {prettier},
          typescript = {prettier},
          typescriptreact = {prettier},
          rust = {
            function()
              return {
                exe = "rustfmt",
                args = {"--emit=stdout"},
                stdin = true
              }
            end
          },
        }
      }
    end
  }
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
  use { 'nvim-lua/plenary.nvim' }
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
    end
  }
  use { 'romgrk/barbar.nvim' }
  use { 'Shougo/context_filetype.vim' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-speeddating' }
  use { 'tpope/vim-surround' }
  use { 'tyru/caw.vim' }
  use { 'vim-airline/vim-airline' }

  -- colorschemes
  use {
    'chriskempson/base16-vim',
    config = function()
      vim.cmd 'colorscheme base16-dracula'
    end
  }

  -- language highlighting
  use {
    'ElmCast/elm-vim',
    config = function()
      vim.g.elm_setup_keybindings = 0
    end
  }
  use { 'HerringtonDarkholme/yats.vim' }
  use { 'cespare/vim-toml' }
  use {
    'elzr/vim-json',
    config = function()
      vim.g.vim_json_syntax_conceal = 0
    end
  }
  use { 'habamax/vim-godot' }
  use { 'ionide/Ionide-vim', run = 'make fsautocomplete' }
  use {
    'leafOfTree/vim-svelte-plugin',
    config = function()
      vim.g.vim_svelte_plugin_use_typescript = 1
      vim.g.vim_svelte_plugin_use_sass = 1
    end
  }
  use { 'pangloss/vim-javascript' }
  use {
    'posva/vim-vue',
    config = function()
      vim.g.vue_pre_processors = {}
    end
  }
  use { 'rust-lang/rust.vim' }
  use { 'tbastos/vim-lua' }
end)
