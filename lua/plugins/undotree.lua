return {
	'mbbill/undotree',
	config = function()
		vim.keymap.set({ 'n', 'v', 'i' }, '<leader>ht', '<Cmd>UndotreeToggle<CR>', { silent = true })
	end,
}
