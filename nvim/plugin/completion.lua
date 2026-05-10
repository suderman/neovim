-- plugin/completion.lua
-- Completion configuration migrated from nvf/completion.nix
-- Using nvim-cmp (blink-cmp not available in nixpkgs)

if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

-- Try to load friendly-snippets but don't fail if not available
pcall(function()
  require('luasnip.load.from_vscode').setup()
end)

vim.opt.completeopt = "menu,noselect"
vim.opt.omnifunc = ""

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-h>'] = cmp.mapping.close(),
    ['<C-space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
  }),
  completion = {
    ghost_text = true,
    auto_show = false,
  },
  window = {
    -- border = "rounded",
  },
  formatting = {
    format = lspkind.cmp_format(),
  },
}

-- Cmdline completion
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'cmdline_history' },
  }),
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
    { name = 'cmdline_history' },
  },
})

-- Snippets
luasnip.setup {
  history = true,
  update_events = "TextChanged,TextChangedI",
}

vim.keymap.set('i', '<C-l>', '<Space>', { desc = 'Insert space' })
