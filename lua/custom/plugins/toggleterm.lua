vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }

require('toggleterm').setup()

local Terminal = require('toggleterm.terminal').Terminal

local lazygit_full = Terminal:new {
  cmd = 'lazygit',
  hidden = true,
  direction = 'float',
  float_opts = { border = 'curved' },
  on_open = function(term)
    vim.keymap.set('t', '<leader>gs', '<cmd>close<CR>', { buffer = term.bufnr })
    vim.keymap.set('t', 'q', '<cmd>close<CR>', { buffer = term.bufnr })
  end,
}

local lazygit_cwd = Terminal:new {
  cmd = 'lazygit -f ' .. vim.fn.shellescape(vim.fn.getcwd()),
  hidden = true,
  direction = 'float',
  float_opts = { border = 'curved' },
  on_open = function(term)
    vim.keymap.set('t', '<leader>gc', '<cmd>close<CR>', { buffer = term.bufnr })
    vim.keymap.set('t', 'q', '<cmd>close<CR>', { buffer = term.bufnr })
  end,
}

function _lazygit_oil_toggle()
  local dir

  if vim.bo.filetype == 'oil' then
    dir = require('oil').get_current_dir()
  else
    dir = vim.fn.expand '%:p:h'
  end

  if not dir or dir == '' then dir = vim.fn.getcwd() end

  local lazygit_oil = Terminal:new {
    cmd = 'lazygit -f ' .. vim.fn.shellescape(dir),
    hidden = true,
    direction = 'float',
    float_opts = { border = 'curved' },
    count = 99,
    on_open = function(term)
      vim.keymap.set('t', '<leader>go', '<cmd>close<CR>', { buffer = term.bufnr })
      vim.keymap.set('t', 'q', '<cmd>close<CR>', { buffer = term.bufnr })
    end,
  }

  lazygit_oil:toggle()
end

function _lazygit_toggle_full()
  lazygit_full:toggle()
end

function _lazygit_toggle_cwd()
  lazygit_cwd:toggle()
end

vim.keymap.set('n', '<leader>gg', '<cmd>lua _lazygit_toggle_full()<CR>', { desc = 'Lazy[G]it [S]tatus (Full Repo)' })
vim.keymap.set('n', '<leader>gl', '<cmd>lua _lazygit_toggle_cwd()<CR>', { desc = 'Lazy[G]it [C]WD (Filtered)' })
vim.keymap.set('n', '<leader>go', '<cmd>lua _lazygit_oil_toggle()<CR>', { desc = 'Lazy[G]it [O]il (Filtered)' })
