-- plugin/completion.lua
-- Completion configuration migrated from nvf/completion.nix
-- Uses blink.cmp

if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local blink = require('blink.cmp')
local luasnip = require('luasnip')

-- Try to load friendly-snippets but don't fail if not available
pcall(function()
  require('luasnip.loaders.from_vscode').lazy_load()
end)

vim.opt.completeopt = "menu,menuone,noselect"

blink.setup({
  keymap = {
    preset = 'none',
    ['<C-h>'] = { 'hide', 'fallback' },
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<Tab>'] = { 'select_and_accept', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },
    ['<C-k>'] = { 'select_prev', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_down', 'fallback' },
  },
  completion = {
    documentation = { auto_show = false },
    ghost_text = { enabled = true },
    menu = { auto_show = false },
  },
  sources = {
    default = { 'lsp', 'snippets', 'path', 'buffer' },
  },
  snippets = { preset = 'luasnip' },
  cmdline = {
    enabled = true,
    keymap = { preset = 'cmdline' },
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == '/' or type == '?' then
        return { 'buffer' }
      end
      if type == ':' or type == '@' then
        return { 'cmdline', 'path' }
      end
      return {}
    end,
  },
  signature = { enabled = true },
})

-- Snippets
luasnip.setup {
  history = true,
  update_events = "TextChanged,TextChangedI",
}

vim.keymap.set('i', '<C-l>', '<Space>', { desc = 'Insert space' })
