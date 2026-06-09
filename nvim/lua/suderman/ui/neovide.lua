if not vim.g.neovide then
  return
end

vim.g.neovide_scale_factor = 1.0

local function change_scale_factor(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.keymap.set("n", "<D-=>", function()
  change_scale_factor(1.25)
end)

vim.keymap.set("n", "<D-->", function()
  change_scale_factor(1 / 1.25)
end)

vim.keymap.set("n", "<D-s>", ":w<CR>")
vim.keymap.set("v", "<D-c>", "+y")
vim.keymap.set("n", "<D-v>", "+P")
vim.keymap.set("v", "<D-v>", "+P")
vim.keymap.set("c", "<D-v>", "<C-R>+")
vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli')

vim.keymap.set("", "<D-v>", "+p<CR>", { silent = true })
vim.keymap.set("!", "<D-v>", "<C-R>+", { silent = true })
vim.keymap.set("t", "<D-v>", "<C-R>+", { silent = true })
vim.keymap.set("v", "<D-v>", "<C-R>+", { silent = true })
