require'orgmode'.setup_ts_grammar()

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "astro",
    "css",
    "dart",
    "dockerfile",
    "elm",
    "fennel",
    "fish",
    "gdscript",
    "go",
    "haskell",
    "javascript",
    "json",
    "lua",
    "markdown",
    "org",
    "pug",
    "python",
    "regex",
    "rust",
    "scss",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'}
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "ai",
      scope_incremental = "as",
      node_decremental = "ad",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aF"] = "@call.outer",
        ["iF"] = "@call.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["aC"] = "@class.outer",
        ["iC"] = "@class.inner",
        ["aP"] = "@parameter.outer",
        ["iP"] = "@parameter.inner",
      },
    },
  },
}

require'treesitter-context'.setup {
  enable = true,
  max_lines = 0,
  trim_scope = 'outer',
  patterns = {
    default = {
      'class',
      'function',
      'method',
      'for',
      'while',
      'if',
      'switch',
      'case',
    },
    rust = {
      'impl_item',
      'struct',
      'enum',
    },
    markdown = {
      'section',
    },
    json = {
      'pair',
    },
    yaml = {
      'block_mapping_pair',
    },
  },
}
