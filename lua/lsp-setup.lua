-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local telescope = function()
    return require 'telescope.builtin'
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>fx', vim.lsp.buf.code_action, '[F]i[x]')

  nmap('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('<leader>gr', telescope().lsp_references, '[G]oto [R]eferences')
  nmap('<leader>gI', telescope().lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', telescope().lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', telescope().lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', telescope().lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  omnisharp = {},
  bashls = {},
  -- gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },

  jsonls = {},
  yamlls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    if server_name == 'omnisharp' then
      require('lspconfig').omnisharp.setup {
        enable_editorconfig_support = true,
        on_attach = on_attach,
        handlers = { ['textDocument/definition'] = require('omnisharp_extended').handler },
      }
    else
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
      }
    end
  end,
}

-- vim: ts=2 sts=2 sw=2 et
