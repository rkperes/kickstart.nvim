vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-context' }

require('treesitter-context').setup {
  max_lines = 10,
  multiline_threshold = 2,
  on_attach = function()
    vim.keymap.set('n', '[p', function()
      require('treesitter-context').go_to_context(vim.v.count1)
    end, { silent = true, desc = 'Jump to context root' })
  end,
}
