return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
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
    config = function()
      require('copilot_cmp').setup()

      local cmp = require 'cmp'
      local config = cmp.get_config()
      table.insert(config.sources, { name = 'copilot' })
      cmp.setup(config)
    end,
  },
}
