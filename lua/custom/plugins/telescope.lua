require('telescope').load_extension('fzf')

require('telescope').setup {
  pickers = {
    buffers = {
      sort_lastused = true,
      ignore_current_buffer = true,
    }
  }
}

return {}
