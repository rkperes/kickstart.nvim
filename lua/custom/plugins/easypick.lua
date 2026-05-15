vim.pack.add { 'https://github.com/axkirillov/easypick.nvim' }

local easypick = require 'easypick'

easypick.setup {
  pickers = {
    {
      name = 'changed_files',
      command = "git status --porcelain | awk '/^\\?\\?/ { print $2; }'",
    },
    {
      name = 'conflicts',
      command = 'git diff --name-only --diff-filter=U --relative',
      previewer = easypick.previewers.file_diff(),
    },
  },
}
