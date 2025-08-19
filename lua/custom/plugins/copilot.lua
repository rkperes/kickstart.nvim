return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    enabled = false,
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    enabled = false,
    config = function()
      require('copilot_cmp').setup()

      local cmp = require 'cmp'
      local config = cmp.get_config()
      table.insert(config.sources, { name = 'copilot' })
      cmp.setup(config)
    end,
  },
}
