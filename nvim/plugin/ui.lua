-- plugin/ui.lua
-- UI configuration migrated from nvf/appearance.nix

if vim.g.did_load_ui_plugin then
  return
end
vim.g.did_load_ui_plugin = true

-- Transparent.nvim
require('transparent').setup({
  extra_groups = {
    "NormalFloat",
  },
})

-- Fidget.nvim (LSP progress)
require('fidget').setup({
  notification = {
    window = {
      winblend = 0,
      border = "none",
    },
  },
})

-- Snacks.nvim (from nvf/appearance.nix and nvf/picker/*.nix)
-- Note: snacks-nvim provides picker, notifier, indent, scope, dim, input styles
-- Full snacks setup is deferred for simplicity; basic keymaps in keymaps.lua

-- Status column
require('statuscol').setup({
  setopt = true,
  segments = {
    { text = { " " }, click = "v:lua.Scroll" },
    { text = { "C" }, click = "v:lua.Scroll" },
    { text = { "%s", 2 }, click = "v:lua.Scroll" },
    { text = { "%l" }, click = "v:lua.Scroll" },
    { text = { " ", click = "v:lua.Scroll" } },
    { text = { "%p" }, click = "v:lua.Scroll" },
    { text = { "/" }, click = "v:lua.Scroll" },
    { text = { "%L" }, click = "v:lua.Scroll" },
    { text = { " ", click = "v:lua.Scroll" } },
  },
})

-- Colorizer - skip if not available
pcall(require, 'colorizer')

-- Oil.nvim (file explorer)
require('oil').setup({
  default_file_explorer = false,
  delete_to_trash = true,
  columns = { "icon", "permissions", "size", "mtime" },
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    natural_order = true,
    is_always_hidden = function(name, _)
      return name == '..' or name == '.git'
    end,
  },
  win_options = {
    wrap = true,
  },
})

-- Neovide specific (from nvf/appearance.nix)
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<D-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<D-->", function()
    change_scale_factor(1/1.25)
  end)
end
