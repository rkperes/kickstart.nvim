-- Relative line numbers
vim.wo.relativenumber = true

-- Cursor centralized in the screen
vim.o.scrolloff = 999

vim.o.tabstop = 4
vim.o.shiftwidth = 4

--vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { trail = '·' }

-- Telescope
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
