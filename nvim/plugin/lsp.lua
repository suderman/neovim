-- plugin/lsp.lua
-- LSP configuration migrated from nvf/debug.nix and nvf/languages.nix
-- Uses lspconfig (Neovim 0.11+ still supports lspconfig, with deprecation warnings)

if vim.g.did_load_lsp_plugin then
  return
end
vim.g.did_load_lsp_plugin = true

-- Suppress lspconfig deprecation warnings (use vim.lsp.config when ready)
vim.deprecate = function() end

-- Global diagnostics configuration (vim.diagnostic.config already in init.lua)

-- Treesitter context keymap
vim.keymap.set('n', 'gC', ':TSContext toggle<CR>', { desc = 'Toggle treesitter context' })

-- LSP keymaps
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { desc = 'Code Actions' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Error, Warnings, Hints' })
vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = 'LSP Hover' })

-- Trouble keymaps (from nvf/debug.nix)
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions (Trouble)' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })

-- Format toggle keymap (from nvf/languages.nix)
vim.keymap.set('n', '<leader>f', function()
  vim.b.disableFormatSave = not vim.b.disableFormatSave
  print("Autoformat: " .. (vim.b.disableFormatSave and "disabled" or "enabled"))
end, { desc = 'Toggle autoformat' })

-- LSP servers using lspconfig
local lspconfig = require('lspconfig')

-- Lua
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- Nix
lspconfig.nil_ls.setup({
  settings = {
    ['nil-ls'] = {
      formatting = { command = { "alejandra" } },
    },
  },
})

-- Python
lspconfig.pyright.setup({})

-- Go
lspconfig.gopls.setup({})

-- Rust
lspconfig.rust_analyzer.setup({
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
    },
  },
})

-- TypeScript/JavaScript (use ts_ls, not tsserver)
lspconfig.ts_ls.setup({})

-- HTML
lspconfig.html.setup({})

-- CSS
lspconfig.cssls.setup({})

-- Tailwind CSS
lspconfig.tailwindcss.setup({})

-- Bash
lspconfig.bashls.setup({})

-- JSON
lspconfig.jsonls.setup({})

-- YAML
lspconfig.yamlls.setup({})
