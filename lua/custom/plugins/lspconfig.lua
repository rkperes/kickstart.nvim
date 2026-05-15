local golang_uber_ulsp = function(bufnr)
  if vim.fn.executable 'uexec' == 0 then
    print 'missing binary for ulsp'
    return
  end
  vim.fn.jobstart '! pgrep ulsp && $HOME/run-ulsp.sh'
end

local is_custom_golang_driver = function()
  local driver = os.getenv 'GOPACKAGESDRIVER'
  local ulspdriver = os.getenv 'GOPACKAGESDRIVER_ULSP_MODE'
  return (driver ~= nil and driver ~= '') or (ulspdriver ~= nil and ulspdriver ~= '')
end

-- 1. Setup gopls blueprints
vim.lsp.config('gopls', {
  cmd = {
    'gopls',
    '-remote=auto',
    '-rpc.trace',
    '-v',
  },
  flags = {
    debounce_text_changes = 100,
  },
  init_options = {
    staticcheck = true,
    gofumpt = true,
  },
  settings = {
    gofumpt = true,
    usePlaceholders = true,
    completeUnimported = true,
    staticcheck = true,
    directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
    semanticTokens = true,
    codelenses = {
      gc_details = false,
      generate = true,
      regener_cgo = true,
      run_govulncheck = true,
      test = true,
      tidy = true,
      upgrade_dependency = true,
      vendor = true,
    },
    hints = {
      assignVariableTypes = true,
      compositeLiteralFields = true,
      compositeLiteralTypes = true,
      constantValues = true,
      functionTypeParameters = true,
      parameterNames = true,
      rangeVariableTypes = true,
    },
    analyses = {
      assign = true,
      bools = true,
      composites = true,
      copylocks = true,
      defers = true,
      deprecated = true,
      errorsas = true,
      fillreturns = true,
      gofix = true,
      httpresponse = true,
      ifaceassert = true,
      infertypeargs = true,
      lostcancel = true,
      modernize = true,
      nilfunc = true,
      nilness = true,
      nonewvars = true,
      noresultvalues = true,
      printf = true,
      shadow = true,
      unusedparams = true,
      unusedresult = true,
      unusedvariable = true,
      unusedwrite = true,
      unreachable = true,
      waitgroup = true,
      yield = true,
      fieldalignment = false,
    },
  },
})

-- 2. Define and enable custom 'ulsp' configuration natively
if is_custom_golang_driver() then
  vim.lsp.config('ulsp', {
    cmd = { 'socat', '-', 'tcp:localhost:27883,ignoreeof' },
    filetypes = { 'go', 'java' },
    root_markers = { '.git' },
    single_file_support = false,
    flags = {
      debounce_text_changes = 1000,
    },
  })
  vim.lsp.enable('ulsp')
end

-- 3. Setup eslint blueprints
local cwd = vim.fn.getcwd()
local lsputils = require 'lspconfig.util'
local root_dir = lsputils.root_pattern '.yarn'(cwd)

vim.lsp.config('eslint', {
  settings = cwd:match 'web%-code' and {
    nodePath = root_dir .. '/.yarn/sdks',
  } or {},
})

-- 4. Instruct Neovim to actively start target servers
vim.lsp.enable({ 'gopls', 'eslint' })

-- 5. Formatting & Hook automations on attachment
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

    -- Let eslint handle formatting
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

-- Templ filetype tracking
vim.filetype.add { extension = { templ = 'templ' } }
vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = vim.lsp.buf.format })
