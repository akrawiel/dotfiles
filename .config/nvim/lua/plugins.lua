local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print 'Downloading packer.nvim...'

  packer_bootstrap = vim.fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }

  print(packer_bootstrap)

  print 'Packer.nvim installed'
  print 'Restart neovim now'

  vim.cmd [[2sleep]]
  vim.cmd [[qa]]
end

return require 'packer'.startup(function()
  vim.cmd [[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
  ]]

  -- base packer
  use 'wbthomason/packer.nvim'

  -- plugins
  use 'arthurxavierx/vim-caser'
  use 'editorconfig/editorconfig-vim'
  use {
    'ggandor/lightspeed.nvim',
    config = function()
      require 'lightspeed'.setup {
        exit_after_idle_msecs = {
          labeled = nil,
          unlabeled = nil
        },
        safe_labels = nil,
        limit_ft_matches = 10,
      }

      vim.cmd 'highlight LightspeedOneCharMatch guifg=Black guibg=#b0b0ff gui=bold'
    end
  }
  use {
    'folke/which-key.nvim',
    config = function()
      require 'which-key'.setup()
    end
  }
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-vsnip'
  use { 
    'hrsh7th/nvim-cmp',
    config = function()
      require 'cmp-config'
    end
  }
  use 'hrsh7th/vim-vsnip'
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require 'null-ls'.setup {
        sources = {
          require 'null-ls'.builtins.code_actions.eslint_d,
          require 'null-ls'.builtins.diagnostics.eslint_d,
          require 'null-ls'.builtins.diagnostics.jsonlint,
          require 'null-ls'.builtins.formatting.prettierd.with {
            to_temp_file = false
          },
          require 'null-ls'.builtins.formatting.eslint_d.with {
            to_temp_file = false
          },
        },
      }
    end,
  }
  use {
    'kdheepak/lazygit.nvim',
    config = function()
      vim.g.lazygit_floating_window_use_plenary = 1
      vim.g.lazygit_floating_window_winblend = 1
    end
  }
  use 'kyazdani42/nvim-web-devicons'
  use {
    'machakann/vim-highlightedyank',
    config = function()
      vim.g.highlightedyank_highlight_duration = 100
    end
  }
  use {
    'mcchrish/nnn.vim',
    config = function()
      require 'nnn'.setup {
        action = {
          ['<c-x>'] = 'split',
          ['<c-v>'] = 'vsplit',
          ['<esc>'] = 'close',
        },
        layout = {
          window = {
            width = 0.8,
            height = 0.7,
            highlight = 'Debug'
          },
        },
        replace_netrw = 1,
        set_default_mappings = 0,
      }
    end
  }
  use {
    'mg979/vim-visual-multi',
    branch = 'master'
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
        -- 'rust_analyzer',
        -- 'svelte',
        'cssls',
        'emmet_ls',
        'eslint',
        'tsserver',
        'vuels',
      }
    end
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
      require 'Comment'.setup()
    end
  }
  use 'nvim-lua/plenary.nvim'
  use {
    'nvim-neorg/neorg',
    config = function()
      require 'neorg'.setup {
        load = {
          ['core.defaults'] = {},
          ['core.gtd.base'] = {
            config = {
              workspace = 'gtd',
            }
          },
          ['core.norg.completion'] = {},
          ['core.norg.dirman'] = {
            config = {
              autochdir = false,
              default_workspace = 'notes',
              workspaces = {
                gtd = '~/NorgSync/gtd',
                journal = '~/NorgSync/journal',
                notes = '~/NorgSync/notes',
              },
            },
          },
          ['core.norg.journal'] = {
            config = {
              strategy = 'nested',
              workspace = 'journal',
            },
          },
          ['core.norg.manoeuvre'] = {},
        }
      }
    end,
    requires = 'nvim-lua/plenary.nvim'
  }
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require 'telescope-config'
    end
  }
  use {
    'nvim-telescope/telescope-frecency.nvim',
    config = function()
      require 'telescope'.load_extension 'frecency'
    end,
    requires = { 'tami5/sqlite.lua' }
  }
  use 'nvim-telescope/telescope-ui-select.nvim'
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'treesitter-config'
    end
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use {
    'phaazon/hop.nvim',
    config = function()
      require 'hop'.setup {
        char2_fallback_key = "<cr>",
        jump_on_sole_occurrence = true,
        teasing = false,
      }
    end,
  }
  use 'romgrk/barbar.nvim'
  use {
    'rlane/pounce.nvim',
    config = function()
      vim.cmd 'highlight PounceMatch guifg=Black guibg=#8080ff gui=bold'
      vim.cmd 'highlight PounceAccept guifg=Black guibg=#b0b0ff gui=bold'
      vim.cmd 'highlight PounceAcceptBest guifg=Black guibg=#e0e0ff gui=bold'
      vim.cmd 'highlight PounceGap guifg=Black guibg=#4040ff gui=bold'
    end,
  }
  use 'tpope/vim-repeat'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-surround'

  -- colorschemes
  use {
    'phha/zenburn.nvim',
    config = function()
      vim.api.nvim_command [[:colorscheme zenburn]]
      vim.api.nvim_command [[:highlight Search guifg=#313633 guibg=#6d7f28]]
      vim.api.nvim_command [[:highlight CurSearch guifg=#313633 guibg=#aac445 gui=bold]]
    end
  }

  -- language highlighting
  use {
    'ionide/Ionide-vim',
    run = 'make fsautocomplete'
  }

  -- bootstrap sync check
  if packer_bootstrap then
    require 'packer'.sync()
  end
end)
