-- From https://github.com/neovim/nvim-lspconfig/issues/115
local golang_organize_imports = function(bufnr, isPreflight)
  local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding(bufnr))
  params.context = { only = { 'source.organizeImports' } }

  if isPreflight then
    vim.lsp.buf_request(bufnr, 'textDocument/codeAction', params, function() end)
    return
  end

  local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 3000)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding(bufnr))
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

local golang_gazelle = function(bufnr)
  if vim.fn.executable 'gazelle' == 0 then
    print 'missing binary'
    return
  end

  local cwd = vim.fn.expand '%:h' .. '/'

  -- async
  vim.fn.jobstart('gazelle .', {
    cwd = cwd,
  })
end

local is_custom_golang_driver = function()
  local driver = os.getenv 'GOPACKAGESDRIVER'
  return driver ~= nil and driver ~= ''
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspFormatting', {}),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.name == 'gopls' then
      if is_custom_golang_driver() then
        vim.api.nvim_create_autocmd('BufWritePost', {
          pattern = '*.go',
          callback = function()
            golang_gazelle(bufnr)
          end,
        })
      end
    end
  end,
})

require('lspconfig').gopls.setup {
  flags = {
    debounce_text_changes = 100,
  },
  init_options = {
    analyses = {
      unusedvariable = true,
      unusedparams = true,
    },
    staticcheck = true,
    gofumpt = true,
    memoryMode = 'DegradeClosed',
  },
}

-- go install github.com/nametake/golangci-lint-langserver@latest
local lspconfig = require 'lspconfig'
local configs = require 'lspconfig/configs'

if not configs.golangcilsp then
  configs.golangcilsp = {
    default_config = {
      cmd = { 'golangci-lint-langserver' },
      root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
      init_options = {
        command = { 'golangci-lint', 'run', '--enable-all', '--disable', 'lll', '--out-format', 'json', '--issues-exit-code=1' },
      },
    },
  }
end
lspconfig.golangci_lint_ls.setup {
  filetypes = { 'go', 'gomod' },
}

-- templ
vim.filetype.add { extension = { templ = 'templ' } }
vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = vim.lsp.buf.format })

return {}
