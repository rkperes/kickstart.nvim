require('telescope').load_extension('fzf')

require('telescope').setup {
  pickers = {
    buffers = {
      sort_lastused = true,
      ignore_current_buffer = true,
    }
  }
}

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles (cwd)' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[F]ind Files ([G]it root)' })

return {}
