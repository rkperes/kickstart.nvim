return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf_lua = require 'fzf-lua'
      local actions = fzf_lua.actions

      local file_ignore_patterns = {
        '/test[^/]*/',
        '/[^/]*test/',
        '_test.go$',
        'BUILD.bazel',
      }

      -- calling `setup` is optional for customization
      fzf_lua.setup {
        keymap = {
          builtin = {
            true,
            ['<C-h>'] = 'toggle-preview',
            ['<C-d>'] = 'preview-page-down',
            ['<C-u>'] = 'preview-page-up',
          },
        },

        file_ignore_patterns = file_ignore_patterns,
        hls = { normal = 'Normal', preview_normal = 'Normal', border = 'Function', preview_border = 'Function' },
        winopts = {
          height = 0.5,
          width = 0.7,
          row = 0.5,
          -- preview = { hidden = 'hidden' },
          border = 'thicc',
          treesitter = { enabled = true },
          preview = {
            vertical = 'down:45%', -- up|down:size
            horizontal = 'right:40%', -- right|left:size
            layout = 'flex', -- horizontal|vertical|flex
            flip_columns = 100, -- #cols to switch to horizontal on flex
            scrollbar = false, -- `false` or string:'float|border'
          },
        },
        fzf_opts = {
          ['--no-info'] = '',
          ['--info'] = 'hidden',
          ['--padding'] = '3%,3%,3%,3%',
          ['--header'] = ' ',
          ['--no-scrollbar'] = '',
        },
        files = {
          formatter = 'path.filename_first',
          git_icons = true,
          prompt = ':',
          no_header = false,
          cwd_prompt = true,
          cwd_prompt_shorten_len = 8, -- shorten prompt beyond this length
          cwd_prompt_shorten_val = 1, -- shortened path parts length
          cwd_header = false,
          winopts = {
            title = ' files ',
            title_pos = 'center',
          },
          actions = {
            ['ctrl-g'] = { actions.toggle_ignore },
          },
        },
        buffers = {
          formatter = 'path.filename_first',
          prompt = ':',
          no_header = true,
          winopts = {
            height = 0.3,
            width = 0.4,
            preview = { hidden = 'hidden' },
            title = ' buffers ',
            title_pos = 'center',
          },
        },
        grep = {
          formatter = 'path.filename_first',
          winopts = {
            preview = { hidden = 'hidden' },
          },
        },
      }

      vim.keymap.set('n', '<leader>fr', require('fzf-lua').resume, { desc = 'Resume' })
      vim.keymap.set('n', '<leader>ff', require('fzf-lua').files, { desc = 'Files' })
      vim.keymap.set('n', '<leader>fg', require('fzf-lua').grep_project, { desc = 'Grep' })
      vim.keymap.set('n', '<leader>fw', require('fzf-lua').grep_cword, { desc = 'Grep current word' })
      vim.keymap.set('n', '<leader>f.', function()
        local oil = require 'oil'
        local cwd = oil.get_current_dir() or vim.fn.expand '%:p:h'
        fzf_lua.grep_project {
          cwd = cwd,
        }
      end, { desc = 'Grep current directory (oil)' })

      vim.keymap.set('n', '<leader><leader>', require('fzf-lua').buffers, { desc = '[ ] Find existing buffers' })

      -- git related
      vim.keymap.set('n', '<leader>gs', require('fzf-lua').git_status, { desc = 'Git status' })
    end,
  },
}
