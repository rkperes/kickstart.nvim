vim.pack.add { 'https://github.com/cbochs/grapple.nvim' }

require('grapple').setup {
  scope = 'git_branch',
}

vim.keymap.set('n', '<leader>m', '<cmd>Grapple toggle<cr>', { desc = 'Tag (Grapple)' })
vim.keymap.set('n', '<leader>M', '<cmd>Grapple toggle_tags<cr>', { desc = 'Show tags (Grapple)' })

vim.keymap.set('n', '<leader>1', '<cmd>Grapple select index=1<cr>', { desc = 'Tag 1 (Grapple)' })
vim.keymap.set('n', '<leader>2', '<cmd>Grapple select index=2<cr>', { desc = 'Tag 2 (Grapple)' })
vim.keymap.set('n', '<leader>3', '<cmd>Grapple select index=3<cr>', { desc = 'Tag 3 (Grapple)' })
vim.keymap.set('n', '<leader>4', '<cmd>Grapple select index=4<cr>', { desc = 'Tag 4 (Grapple)' })
vim.keymap.set('n', '<leader>5', '<cmd>Grapple select index=5<cr>', { desc = 'Tag 5 (Grapple)' })
vim.keymap.set('n', '<leader>6', '<cmd>Grapple select index=5<cr>', { desc = 'Tag 5 (Grapple)' })

vim.keymap.set('n', '<leader>i', '<cmd>Grapple cycle_tags next<cr>', { desc = 'Next tag (Grapple)' })
vim.keymap.set('n', '<leader>o', '<cmd>Grapple cycle_tags prev<cr>', { desc = 'Previous tag (Grapple)' })
