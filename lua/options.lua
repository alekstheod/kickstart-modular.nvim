vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 1000

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.tabstop = 4
vim.o.encoding = 'UTF-8'
vim.o.shiftwidth = 4
vim.o.autochdir = false
vim.o.wrap = false
vim.g.mapleader = ' '
vim.o.hlsearch = true
vim.cmd [[
  hi VertSplit ctermfg=none guifg=none
  hi Normal guibg=none ctermbg=none guifg=none ctermfg=none
]]

-- vim: ts=2 sts=2 sw=2 et
