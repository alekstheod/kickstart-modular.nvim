-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")
local action_utils = require("telescope.actions.utils")

local function selection_by_index()
  local prompt_bufnr = vim.api.nvim_get_current_buf()
  local results = {}
  action_utils.map_selections(prompt_bufnr, function(entry)
    table.insert(results, entry.bufnr)
  end)
  return results
end

local function delete_buffers()
  local buffers = selection_by_index()
  for _, v in ipairs(buffers) do
    local command = "bd! " .. v
    vim.api.nvim_command(command)
  end
end

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-Space>"] = actions.toggle_selection,
        ["<del>"] = delete_buffers,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

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
  local vstart = vim.fn.getpos("'<")
  local vend = vim.fn.getpos("'>")

  local line_start = vstart[2]
  local line_end = vend[2]

  -- or use api.nvim_buf_get_lines
  return vim.fn.getline(line_start, line_end)
end

--require('telescope.builtin').live_grep(lines)
local ivy = require('telescope.themes').get_ivy({ winblend = 10 })
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<leader><leader>', function() telescope.find_files(ivy) end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', telescope.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', telescope.git_files, { desc = 'Search [G]it [F]iles' })

vim.keymap.set('v', '<S-f>', function() telescope.grep_string(ivy, get_visual_selection()) end,
  { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<S-f>', function() telescope.live_grep(ivy) end,
  { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>ag', function() telescope.grep_string(ivy) end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<Tab>', function() telescope.buffers(ivy) end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>re', function() telescope.oldfiles(ivy) end, { desc = '[R]recently opened files' })

-- vim: ts=2 sts=2 sw=2 et
