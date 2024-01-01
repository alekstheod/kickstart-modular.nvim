-- autoformat.lua
--
-- Use your language server to automatically format your code on save.
-- Adds additional commands as well to manage the behavior

return {
  'sbdchd/neoformat',
  config = function()
    vim.cmd [[
		let g:neoformat_enabled_cpp = ['clangformat']
		let g:neoformat_enabled_csharp = ['clangformat']
		let g:neoformat_enabled_bash = ['shfmt']
	]]

    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        vim.cmd 'undojoin | Neoformat'
      end,
    })
  end,
}
