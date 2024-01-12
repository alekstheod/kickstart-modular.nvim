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
		let g:neoformat_enabled_yaml = ['google_yamlfmt']
	]]

    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      callback = function()
        if vim.bo.filetype == 'cs' then
          vim.lsp.buf.format()
        else
          vim.cmd 'Neoformat'
        end
      end,
    })
  end,
}
