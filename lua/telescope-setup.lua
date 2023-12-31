-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

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

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function get_visual_selection()
  local vstart = vim.fn.getpos "'<"
  local vend = vim.fn.getpos "'>"

  local line_start = vstart[2]
  local line_end = vend[2]

  -- or use api.nvim_buf_get_lines
  return vim.fn.getline(line_start, line_end)
end

--require('telescope.builtin').live_grep(lines)
local ivy = function()
  return require('telescope.themes').get_ivy { winblend = 10 }
end
local telescope = function()
  return require 'telescope.builtin'
end

vim.keymap.set('n', '<leader><leader>', function() telescope().find_files(ivy()) end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', telescope().builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', telescope().git_files, { desc = 'Search [G]it [F]iles' })

vim.keymap.set('v', '<S-f>', function() telescope().grep_string(ivy(), get_visual_selection()) end,
  { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<S-f>', function() telescope().live_grep(ivy()) end, { desc = '[F]ind text' })
vim.keymap.set('n', '<leader>ag', function() telescope().grep_string(ivy()) end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<Tab>', function() telescope().buffers(ivy()) end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>re', function() telescope().oldfiles(ivy()) end, { desc = '[R]recently opened files' })

-- vim: ts=2 sts=2 sw=2 et
