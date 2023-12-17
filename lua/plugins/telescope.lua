return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},
	},
	config = function()
		local actions = function()
			return require 'telescope.actions'
		end
		local action_utils = function()
			return require 'telescope.actions.utils'
		end

		local function selection_by_index()
			local prompt_bufnr = vim.api.nvim_get_current_buf()
			local results = {}
			action_utils().map_selections(prompt_bufnr, function(entry)
				table.insert(results, entry.bufnr)
			end)
			return results
		end

		local function delete_buffers()
			local buffers = selection_by_index()
			for _, v in ipairs(buffers) do
				local command = 'bd! ' .. v
				vim.api.nvim_command(command)
			end
		end
		require('telescope').setup {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
						['<esc>'] = actions().close,
						['<C-j>'] = actions().move_selection_next,
						['<C-k>'] = actions().move_selection_previous,
						['<C-Space>'] = actions().toggle_selection,
						['<del>'] = delete_buffers,
					},
				},
			},
		}
	end,
}
