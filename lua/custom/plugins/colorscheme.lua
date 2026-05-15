vim.pack.add { 'https://github.com/catppuccin/nvim' }

require('catppuccin').setup {
  flavour = 'mocha',
  transparent_background = true,
  show_end_of_buffer = false,
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = 'dark',
    percentage = 0.15,
  },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { 'italic' },
    conditionals = { 'italic' },
    loops = { 'italic' },
    functions = {},
    keywords = { 'italic' },
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = '',
    },
    telescope = {
      enabled = true,
      style = 'nvchad',
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
      },
      underlines = {
        errors = { 'underline' },
        hints = { 'underline' },
        warnings = { 'underline' },
        information = { 'underline' },
      },
      inlay_hints = {
        background = true,
      },
    },
  },
}

vim.cmd.colorscheme 'catppuccin'

vim.pack.add { 'https://github.com/rose-pine/neovim' }

require('rose-pine').setup {
  variant = 'auto',
  dark_variant = 'main',
  dim_inactive_windows = false,
  extend_background_behind_borders = true,

  enable = {
    terminal = true,
    legacy_highlights = true,
    migrations = true,
  },

  styles = {
    bold = true,
    italic = true,
    transparency = false,
  },

  groups = {
    border = 'muted',
    link = 'iris',
    panel = 'surface',

    error = 'love',
    hint = 'iris',
    info = 'foam',
    note = 'pine',
    todo = 'rose',
    warn = 'gold',

    git_add = 'foam',
    git_change = 'rose',
    git_delete = 'love',
    git_dirty = 'rose',
    git_ignore = 'muted',
    git_merge = 'iris',
    git_rename = 'pine',
    git_stage = 'iris',
    git_text = 'rose',
    git_untracked = 'subtle',

    h1 = 'iris',
    h2 = 'foam',
    h3 = 'rose',
    h4 = 'gold',
    h5 = 'pine',
    h6 = 'foam',
  },

  highlight_groups = {},

  before_highlight = function(group, highlight, palette) end,
}

-- vim.cmd 'colorscheme rose-pine'
-- vim.cmd 'colorscheme rose-pine-main'
-- vim.cmd 'colorscheme rose-pine-moon'
-- vim.cmd 'colorscheme rose-pine-dawn'
