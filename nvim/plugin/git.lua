-- plugin/git.lua
-- Git integration migrated from nvf/git.nix

if vim.g.did_load_git_plugin then
  return
end
vim.g.did_load_git_plugin = true

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '│' },
    change = { text = '│' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  current_line_blame = false,
  word_diff = false,
  watch_gitdir = {
    follow_workers = false,
    auto_awatch = true,
  },
}

-- Diffview
require('diffview').setup {}

-- Neogit (minimal setup)
require('neogit').setup {
  kind = "tab",
  integrated_reloading = false,
}

-- Keymaps for git plugins
vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<CR>', { desc = 'Neogit' })
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = 'Diffview open' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>', { desc = 'Diffview file history' })
