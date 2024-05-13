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
    return
  end

  local cwd = vim.fn.expand '%:h' .. '/'

  vim.fn.jobstart('gazelle .', {
    cwd = cwd,
    -- on_exit = function()
    --   vim.notify('gazelle exit', vim.log.levels.INFO)
    -- end,
    -- on_stderr = function(chanid, data, name)
    --   print('gazelle:', vim.inspect(data))
    -- end,
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspFormatting', {}),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.name == 'gopls' then
      -- hack: Preflight async request to gopls, which can prevent blocking when save buffer on first time opened
      golang_organize_imports(bufnr, true)

      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        group = vim.api.nvim_create_augroup('LspGolangOrganizeImports.' .. bufnr, {}),
        callback = function()
          golang_organize_imports(bufnr)
        end,
      })

      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*.go',
        callback = function()
          golang_gazelle(bufnr)
        end,
      })
    end
  end,
})
-- end goimports

require('lspconfig').gopls.setup {
  -- on_attach = on_attach,

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
  -- capabilities = capabilities,
}

return {}
