return {
  {
    'jay-babu/mason-null-ls.nvim',
	enabled = false,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
  },
}
