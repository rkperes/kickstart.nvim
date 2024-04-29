require('telescope').setup {
  settings = {
    initial_mode = 'normal',
  },

  pickers = {
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
      initial_mode = 'normal',
    },
  },
}

return {}
