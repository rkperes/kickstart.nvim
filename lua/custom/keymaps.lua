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

local function get_current_function_name()
  -- Get the current buffer
  local buf_id = vim.api.nvim_get_current_buf()
  -- Get the current cursor position (row, col - 1 for 0-based column)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  col = col - 1

  -- Try to get the Treesitter parser for the current buffer
  local parser = vim.treesitter.get_parser(buf_id)
  if not parser then
    print 'Treesitter parser not available for this buffer.'
    return
  end

  -- Get the root node of the AST
  local current_node = vim.treesitter.get_node {
    buf = buf_id,
    -- The key 'pos' is optional; without it, it uses the current cursor position.
  }

  if not current_node then
    print 'Could not find Treesitter node at cursor.'
    return
  end

  -- Traverse up the AST to find the nearest function definition node
  local func_node = current_node
  while func_node do
    local node_type = func_node:type()

    -- Check for common function/method definition types across languages
    if
      node_type == 'function_definition' -- C, C++, Rust, etc.
      or node_type == 'method_declaration' -- Java, etc.
      or node_type == 'function_declaration' -- JavaScript, TypeScript
      or node_type == 'func_declaration' -- Go (example in prompt)
      or node_type == 'function' -- Lua, Python (def statement is often just 'function')
    then
      break -- Found a function node
    end

    func_node = func_node:parent()
  end

  if not func_node then
    print 'Not inside a function definition.'
    return
  end

  -- Find the *identifier* child node to get the function name
  local func_name = ''
  local has_receiver = false
  local identifier = nil
  for child in func_node:iter_children() do
    local child_type = child:type()

    -- 1. Detect the receiver (Specific to Go's Treesitter parser)
    if child_type == 'parameter_list' then
      -- In Go's grammar, a "parameter_list" that appears *first* -- (before the identifier) is the receiver list.
      local name_child = child:child(1) -- Check for the struct/interface name
      if name_child and name_child:type() == 'parameter_declaration' then
        has_receiver = true
        -- Stop searching for receiver after finding the first one
        -- (This assumes the Go grammar structure is consistent)
      end
    end

    -- 2. Detect the function name (identifier)
    if child_type == 'identifier' or child_type == 'field_identifier' or child_type == 'name' or child_type == 'function_name' then
      local start_row, start_col, end_row, end_col = child:range()
      local name_lines = vim.api.nvim_buf_get_text(buf_id, start_row, start_col, end_row, end_col, {})
      func_name = table.concat(name_lines, '\n')
    end
  end

  if identifier then
    -- Get the start/end coordinates of the identifier node
    local start_row, start_col, end_row, end_col = identifier:range()

    -- Extract the text of the identifier from the buffer
    -- (Need to use the original 1-based coordinates for nvim_buf_get_text)
    local func_name_lines = vim.api.nvim_buf_get_text(buf_id, start_row, start_col, end_row, end_col, {})

    func_name = table.concat(func_name_lines, '\n')
  else
    print "Function definition found, but couldn't locate the name identifier."
  end

  return func_name, has_receiver
end

local function get_current_buffer_relative_dirpath()
  local buf_id = vim.api.nvim_get_current_buf()
  local full_path = vim.api.nvim_buf_get_name(buf_id)
  local dir_path = '[No Name Buffer]'

  if full_path ~= '' then
    -- 1. Get the directory name using ':h'
    local dir_name = vim.fn.fnamemodify(full_path, ':h')

    -- 2. Use 'fnamemodify()' with the modifiers ':.' and ':~' to ensure it's relative
    -- The ':h' modifier is applied first to get the directory.
    -- The final string modification will be relative to CWD.
    local relative_dir_path = vim.fn.fnamemodify(dir_name, ':.')

    -- Handle the case where the file is at the root of the CWD,
    -- which should result in '.' not the CWD's absolute path.
    if relative_dir_path == '.' or relative_dir_path:match '^%.%/' then
      -- This ensures paths like './' are correctly displayed as '.'
      dir_path = '.'
    else
      dir_path = relative_dir_path
    end
  end

  return dir_path
end

vim.keymap.set('n', '<leader>tf', function()
  local func_name, has_receiver = get_current_function_name()
  if has_receiver then
    func_name = '.*/' .. func_name
  end

  local buf_id = vim.api.nvim_get_current_buf()
  local curr_buf = get_current_buffer_relative_dirpath()
  local escaped_info = vim.fn.shellescape(curr_buf .. ':all') .. ' --test_filter=' .. vim.fn.shellescape(func_name)
  local shell_cmd = 'echo ' .. escaped_info .. ' && bazel test ' .. escaped_info
  vim.cmd('vsplit | term ' .. shell_cmd)
end, { desc = 'Run Bazel Go test in current function' })
