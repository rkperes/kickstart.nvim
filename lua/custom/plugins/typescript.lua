return {
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup()
      local mason_null_ls = require 'mason-null-ls'
      mason_null_ls.setup {
        ensure_installed = { 'prettierd' },
        handlers = {
          prettierd = function(source_name, methods)
            null_ls.register(null_ls.builtins.formatting.prettierd)
          end,
        },
      }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    ft = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}
