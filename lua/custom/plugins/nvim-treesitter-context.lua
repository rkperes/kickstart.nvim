return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      on_attach = function()
        vim.keymap.set('n', '[c', function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end, { silent = true })
      end,
    },
  },
}
