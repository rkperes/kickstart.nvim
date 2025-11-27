return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      -- Neotest dependencies
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- Our adapter
      'sluongng/neotest-bazel',
    },
    config = function()
      local neotest = require 'neotest'
      neotest.setup {
        adapters = {
          -- Our adapter registration
          require 'neotest-bazel',
        },
      }
    end,
  },
}
