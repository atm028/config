return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    local mason = require('mason')

    local mason_lspconfig = require('mason-lspconfig')

    local mason_tool_installer = require('mason-tool-installer')

    mason.setup({
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        'typescript-language-server',
        'java-language-server',
        'html',
        'cssls',
        'tailwindcss',
        'svelte',
        'lua_ls',
        'graphql',
        'emmet_ls',
        'prismals',
        'pyright',
        'ltex',
        'grammarly',
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        'prettier', -- prettier formatter
        'stylua', -- lua formatter
        'isort', -- python formatter
        'black', -- python formatter
        'pylint',
        'eslint_d',
      },
    })
  end,
}
