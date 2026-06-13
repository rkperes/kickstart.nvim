vim.pack.add {
  "https://github.com/milanglacier/minuet-ai.nvim",
}

require('minuet').setup {
  provider = 'openai_fim_compatible',
  provider_options = {
    openai_fim_compatible = {
      api_key = 'DEEPSEEK_API_KEY', -- name of env var, not the key itself
      name = 'Deepseek',
      end_point = 'https://api.deepseek.com/beta/completions',
      model = 'deepseek-chat', -- routes to V4-Flash, cheapest tier
      stream = true,
      optional = {
        max_tokens = 256,
        top_p = 0.9,
        stop = { '\n\n' },
      },
    },
  },

  virtualtext = {
    auto_trigger_ft = { '*' }, -- or list specific filetypes, e.g. { 'lua', 'python', 'go', 'javascript', 'typescript' }
    show_on_completion_menu = false, -- never overlap with blink popup

    keymap = {
      accept = '<A-y>',
      accept_line = '<A-l>',
      accept_n_lines = '<A-z>',
      prev = '<A-[>',
      next = '<A-]>',
      dismiss = '<A-c>', 
    },
  }
}
