local ok_which_key, which_key = pcall(require, "which-key")
if not ok_which_key then
  return
end

which_key.setup({
  preset = "modern",
  delay = 350,
  filter = function(mapping)
    return mapping.desc and mapping.desc ~= ""
  end,
  spec = {
    { "<leader>c", group = "code/clear/conflict" },
    { "<leader>g", group = "git" },
    { "<leader>h", group = "git hunk" },
    { "<leader>l", group = "lsp/docs" },
    { "<leader>lv", group = "docs view" },
    { "<leader>t", group = "toggle/find" },
    { "<leader>tb", group = "buffer" },
    { "<leader>w", group = "window" },
    { "<leader>x", group = "diagnostics/quickfix" },
    { ",", group = "opencode/local" },
    { ",d", group = "opencode debug/diff" },
    { ",r", group = "opencode revert/restore" },
    { ",t", group = "opencode toggles" },
  },
  icons = {
    group = "+",
    separator = "->",
  },
  win = {
    border = "rounded",
    padding = { 1, 2 },
    wo = { winblend = 0 },
  },
  layout = {
    width = { min = 20 },
    spacing = 3,
  },
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = true, suggestions = 20 },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
})

vim.keymap.set("n", "<leader>?", function()
  which_key.show({ global = false })
end, { desc = "Buffer keymaps" })

vim.keymap.set("n", "<C-w><space>", function()
  which_key.show({ keys = "<C-w>", loop = true })
end, { desc = "Window keymaps" })
