-- [[ Configure plugins ]]
require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Editor plugins
  'machakann/vim-sandwich',
  'dyng/ctrlsf.vim',
  'preservim/nerdcommenter',
  'mbbill/undotree',
  'Decodetalkers/csharpls-extended-lsp.nvim',
  'nvim-neotest/nvim-nio',

  {
    -- vim colorshcemes
    'rafi/awesome-vim-colorschemes',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  { import = 'plugins' },
}, {})

-- vim: ts=2 sts=2 sw=2 et
