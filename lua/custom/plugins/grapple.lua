return {
  'cbochs/grapple.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
  },
  opts = {
    scope = 'git_branch', -- or 'git'
  },
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'Grapple',
  keys = {
    { '<leader>m', '<cmd>Grapple toggle<cr>', desc = 'Tag (Grapple)' },
    { '<leader>M', '<cmd>Grapple toggle_tags<cr>', desc = 'Show tags (Grapple)' },

    { '<leader>1', '<cmd>Grapple select index=1<cr>', desc = 'Tag 1 (Grapple)' },
    { '<leader>2', '<cmd>Grapple select index=2<cr>', desc = 'Tag 2 (Grapple)' },
    { '<leader>3', '<cmd>Grapple select index=3<cr>', desc = 'Tag 3 (Grapple)' },
    { '<leader>4', '<cmd>Grapple select index=4<cr>', desc = 'Tag 4 (Grapple)' },
    { '<leader>5', '<cmd>Grapple select index=5<cr>', desc = 'Tag 5 (Grapple)' },
    { '<leader>6', '<cmd>Grapple select index=5<cr>', desc = 'Tag 5 (Grapple)' },

    { '<leader>i', '<cmd>Grapple cycle_tags next<cr>', desc = 'Next tag (Grapple)' },
    { '<leader>o', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Previous tag (Grapple)' },
  },
}
