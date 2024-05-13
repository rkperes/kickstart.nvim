vim.keymap.set('n', '<leader>bd', ':%bd|e#<CR>')

-- Disable line annotations to allow raw-copying
local function toggle_line_annotations()
  -- sort of a "ternary" operator in lua
  vim.o.signcolumn = vim.o.signcolumn == 'yes' and 'no' or 'yes'
  vim.o.relativenumber = not vim.o.relativenumber
  vim.o.nu = not vim.o.nu
  vim.cmd ':IBLToggle'
end

vim.keymap.set('n', '<leader>C', toggle_line_annotations, { desc = 'Toggle line annotations (allow raw copy)' })
