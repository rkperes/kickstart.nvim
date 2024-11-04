function fugitive_uber_sourcegraph(opts)
  local repo = string.match(opts.remote, '[^%s]+:([^%s]+)')
  repo = string.gsub(repo, '@', '-') -- e.g. grail@production
  local url = 'https://sourcegraph.uberinternal.com/code.uber.internal/' .. repo .. '@' .. opts.commit .. '/-/' .. opts.type .. '/' .. opts.path
  if opts.line1 > 0 then
    url = url .. '#L' .. opts.line1
  end
  if opts.line2 > 0 then
    url = url .. '-' .. opts.line2
  end
  return url
end

return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.g.fugitive_browse_handlers = { fugitive_uber_sourcegraph }
      vim.keymap.set({ 'n', 'v' }, '<leader>gb', ':GBrowse!<cr>', { silent = true })
    end,
  },
}
