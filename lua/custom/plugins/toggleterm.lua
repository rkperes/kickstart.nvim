return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup()

    local Terminal = require('toggleterm.terminal').Terminal

    -- 1. Basic LazyGit
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

    -- 2. Lazygit Filtered to CWD (log only)
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

    -- 3. Lazygit Filtered by Oil view ()
    function _lazygit_oil_toggle()
      local dir

      -- Check if we are currently in an Oil buffer
      if vim.bo.filetype == 'oil' then
        dir = require('oil').get_current_dir()
      else
        -- Fallback: If not in Oil, use the directory of the current open file
        dir = vim.fn.expand '%:p:h'
      end

      -- Safety fallback to standard CWD
      if not dir or dir == '' then
        dir = vim.fn.getcwd()
      end

      -- Spawn a terminal specifically for this path
      local lazygit_oil = Terminal:new {
        cmd = 'lazygit -f ' .. vim.fn.shellescape(dir),
        hidden = true,
        direction = 'float',
        float_opts = { border = 'curved' },
        -- We use a high 'count' (like 99) so this terminal instance
        -- doesn't collide with your main `<leader>gs` instance (count 1)
        count = 99,
        on_open = function(term)
          vim.keymap.set('t', '<leader>go', '<cmd>close<CR>', { buffer = term.bufnr })
          vim.keymap.set('t', 'q', '<cmd>close<CR>', { buffer = term.bufnr })
        end,
      }

      lazygit_oil:toggle()
    end

    -- The Keymap
    vim.keymap.set('n', '<leader>go', '<cmd>lua _lazygit_oil_toggle()<CR>', { desc = '[G]it [O]il (Current Dir)' })

    -- Toggle functions
    function _lazygit_toggle_full()
      lazygit_full:toggle()
    end
    function _lazygit_toggle_cwd()
      lazygit_cwd:toggle()
    end

    -- Keymaps
    vim.keymap.set('n', '<leader>gg', '<cmd>lua _lazygit_toggle_full()<CR>', { desc = 'Lazy[G]it [S]tatus (Full Repo)' })
    vim.keymap.set('n', '<leader>gl', '<cmd>lua _lazygit_toggle_cwd()<CR>', { desc = 'Lazy[G]it [C]WD (Filtered)' })
    vim.keymap.set('n', '<leader>go', '<cmd>lua _lazygit_oil_toggle()<CR>', { desc = 'Lazy[G]it [O]il (Filtered)' })
  end,
}
