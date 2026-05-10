-- plugin/treesitter.lua
-- Treesitter configuration migrated from nvf/languages.nix and nvf/debug.nix

if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

-- nvim-treesitter-textobjects setup

-- Select textobjects
vim.keymap.set({ 'x', 'o' }, 'af', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
end, {})

vim.keymap.set({ 'x', 'o' }, 'if', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
end, {})

vim.keymap.set({ 'x', 'o' }, 'ac', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
end, {})

vim.keymap.set({ 'x', 'o' }, 'ic', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
end, {})

vim.keymap.set({ 'x', 'o' }, 'as', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
end, {})

-- Swap next/previous
vim.keymap.set('n', '<leader>a', function()
  require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
end, {})

vim.keymap.set('n', '<leader>A', function()
  require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
end, {})

-- Move between functions/parameters
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function (start)' })

vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
end, { desc = 'Next function (end)' })

vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects')
end, { desc = 'Next parameter (start)' })

vim.keymap.set({ 'n', 'x', 'o' }, ']P', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects')
end, { desc = 'Next parameter (end)' })

vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function (start)' })

vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'Previous function (end)' })

vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects')
end, { desc = 'Previous parameter (start)' })

vim.keymap.set({ 'n', 'x', 'o' }, '[P', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects')
end, { desc = 'Previous parameter (end)' })

-- Treesitter context
require('treesitter-context').setup {
  max_lines = 3,
}

-- TS context commentstring
require('ts_context_commentstring').setup()

-- Tree-sitter based folding
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
