return {
  {
    'nvim-telescope/telescope-file-browser.nvim',

    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },

    config = function()
      vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope file_browser<CR>', { noremap = true, desc = 'Open file browser (cwd)' })

      -- open file_browser with the path of the current buffer
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fc',
        ':Telescope file_browser path=%:p:h select_buffer=true<CR>',
        { noremap = true, desc = 'Open file browser (current buffer)' }
      )

      require('telescope').load_extension 'file_browser'

      require('telescope').setup {
        extensions = {
          file_browser = {
            select_buffer = true,
            hidden = { file_browser = true, folder_browser = true },
          },
        },
      }
    end,
  },
}
