return {
  {
    'axkirillov/easypick.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    config = function()
      local easypick = require("easypick")

      easypick.setup {
        pickers = {
          -- add your custom pickers here
          -- below you can find some examples of what those can look like

          -- diff current branch with base_branch and show files that changed with respective diffs in preview
          {
            name = "changed_files",
            command = "git status --porcelain | awk '/^\\?\\?/ { print $2; }'",
          },

          -- list files that have conflicts with diffs in preview
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff()
          },
        }
      }
    end,
  },
}
