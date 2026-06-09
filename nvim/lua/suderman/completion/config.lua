local M = {}

local function cmdline_sources()
  local type = vim.fn.getcmdtype()
  if type == "/" or type == "?" then
    return { "buffer" }
  end
  if type == ":" or type == "@" then
    return { "cmdline", "path" }
  end
  return {}
end

function M.setup(blink)
  vim.opt.completeopt = "menu,menuone,noselect"

  blink.setup({
    keymap = {
      preset = "none",
      ["<C-h>"] = { "hide", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = { "select_and_accept", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-d>"] = { "scroll_documentation_up", "fallback" },
      ["<C-u>"] = { "scroll_documentation_down", "fallback" },
    },
    completion = {
      documentation = { auto_show = false },
      ghost_text = { enabled = true },
      menu = { auto_show = false },
    },
    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
    },
    snippets = { preset = "default" },
    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      sources = cmdline_sources,
    },
    signature = { enabled = true },
  })

  vim.keymap.set("i", "<C-l>", "<Space>", { desc = "Insert space" })
end

return M
