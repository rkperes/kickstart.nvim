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
    print 'missing binary for gazelle'
    return
  end

  local cwd = vim.fn.expand '%:h' .. '/'

  -- async
  vim.fn.jobstart('gazelle .', {
    cwd = cwd,
  })
end

local golang_uber_ulsp = function(bufnr)
  if vim.fn.executable 'uexec' == 0 then
    print 'missing binary for ulsp'
    return
  end

  -- start ulsp daemon if not started
  -- async
  vim.fn.jobstart '! pgrep ulsp && ULSP_ENVIRONMENT=local UBER_CONFIG_DIR=$HOME/go-code/src/code.uber.internal/devexp/ide/ulsp-daemon/config uexec $HOME/go-code/tools/ide/ulsp/ulsp-daemon'
end

local is_custom_golang_driver = function()
  local driver = os.getenv 'GOPACKAGESDRIVER'
  return driver ~= nil and driver ~= ''
end

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

if is_custom_golang_driver() then
  local util = require 'lspconfig.util'
  local async = require 'lspconfig.async'

  require('lspconfig.configs').ulsp = {
    default_config = {
      cmd = { 'socat', '-', 'tcp:localhost:27883,ignoreeof' },
      flags = {
        debounce_text_changes = 1000,
      },
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      filetypes = { 'go', 'java' },
      root_dir = function(fname)
        local result = async.run_command { 'git', 'rev-parse', '--show-toplevel' }
        if result and result[1] then
          return vim.trim(result[1])
        end
        return util.root_pattern '.git'(fname)
      end,
      single_file_support = false,
      docs = {
        description = [[
            uLSP brought to you by the IDE team!
            By utilizing uLSP in Neovim, you acknowledge that this integration is provided 'as-is' with no warranty, express or implied.
            We make no guarantees regarding its functionality, performance, or suitability for any purpose, and absolutely no support will be provided.
            Use at your own risk, and may the code gods have mercy on your soul
        ]],
      },
    },
  }

  require('lspconfig')['ulsp'].setup {}
end

local cwd = vim.fn.getcwd()
local lsputils = require 'lspconfig.util'
local root_dir = lsputils.root_pattern '.yarn'(cwd)

require('lspconfig').eslint.setup {
  settings = cwd:match 'web%-code' and {
    nodePath = root_dir .. '/.yarn/sdks',
  } or {},
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspFormatting', {}),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client == nil then
      return
    end

    if client.name == 'ulsp' then
      vim.api.nvim_create_autocmd('VimEnter', {
        pattern = '*.go',
        callback = function()
          golang_uber_ulsp(bufnr)
        end,
      })
    end

    if not is_custom_golang_driver() and client.name == 'gopls' then
      local diag = {}
      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function(_)
          vim.lsp.buf.format()
          vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' }, diagnostics = diag }, apply = true }
          vim.lsp.buf.code_action { context = { only = { 'source.fixAll' }, diagnostics = diag }, apply = true }
        end,
      })
    end

    -- let eslint handle fmting
    if client.name == 'eslint' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })

      client.server_capabilities.documentFormattingProvider = true
    elseif client.name == 'tsserver' then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
})

-- go install github.com/nametake/golangci-lint-langserver@latest
-- local lspconfig = require 'lspconfig'
-- local configs = require 'lspconfig/configs'
--
-- if not configs.golangcilsp then
--   configs.golangcilsp = {
--     default_config = {
--       cmd = { 'golangci-lint-langserver' },
--       root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
--       init_options = {
--         command = { 'golangci-lint', 'run', '--enable-all', '--disable', 'lll', '--out-format', 'json', '--issues-exit-code=1' },
--       },
--     },
--   }
-- end
-- lspconfig.golangci_lint_ls.setup {
--   filetypes = { 'go', 'gomod' },
-- }

-- templ
vim.filetype.add { extension = { templ = 'templ' } }
vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = vim.lsp.buf.format })

return {}
