-- plugin/windows.lua
if vim.g.did_load_windows_plugin then
  return
end
vim.g.did_load_windows_plugin = true

require("edger").setup()

-- Snacks' sidebar is a window, but closing the last editor should close the sidebar instead.
vim.keymap.set("n", "<M-w>", function()
  local ok, snacks = pcall(require, "snacks")
  local explorer = ok and snacks.picker.get({ source = "explorer" })[1]
  if explorer then
    local splits = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(win).relative == "" and not vim.w[win].snacks_layout then
        splits = splits + 1
      end
    end
    if splits == 1 then
      explorer:close()
      return
    end
  end
  vim.cmd.EdgerClose()
end, { silent = true, desc = "Edger close" })

vim.keymap.set("n", "<leader>fq", function()
  vim.cmd("fclose!")
end, { silent = true, desc = "Close floating windows" })

local function resize_window(axis, factor)
  if axis == "width" then
    local width = vim.api.nvim_win_get_width(0)
    vim.api.nvim_win_set_width(0, math.floor(width * factor))
  else
    local height = vim.api.nvim_win_get_height(0)
    vim.api.nvim_win_set_height(0, math.floor(height * factor))
  end
end

vim.keymap.set("n", "<leader>w+", function()
  resize_window("width", 1.5)
end, { silent = true, desc = "Increase window width" })

vim.keymap.set("n", "<leader>w-", function()
  resize_window("width", 2 / 3)
end, { silent = true, desc = "Decrease window width" })

vim.keymap.set("n", "<leader>h+", function()
  resize_window("height", 1.5)
end, { silent = true, desc = "Increase window height" })

vim.keymap.set("n", "<leader>h-", function()
  resize_window("height", 2 / 3)
end, { silent = true, desc = "Decrease window height" })
