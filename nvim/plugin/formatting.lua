-- plugin/formatting.lua
-- Formatting configuration using conform.nvim
-- Migrated from nvf/languages.nix

if vim.g.did_load_formatting_plugin then
  return
end
vim.g.did_load_formatting_plugin = true

-- Check if conform.nvim is available (installed by Nix)
local ok_conform, conform = pcall(require, 'conform')
if not ok_conform then
  return
end

conform.setup({
  formatters_by_ft = {
    nix = { "alejandra" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff" },
    rust = { "rustfmt" },
    go = { "gofmt", "goimports" },
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    javascriptreact = { "prettierd", "prettier" },
    typescriptreact = { "prettierd", "prettier" },
    html = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    yaml = { "prettierd", "prettier" },
    markdown = { "prettierd", "prettier" },
    sql = { "sqlfluff" },
    bash = { "shfmt" },
    sh = { "shfmt" },
  },
  format_on_save = function(bufnr)
    -- Don't format if disabled for this buffer
    if vim.b[bufnr].disableFormatSave then
      return nil
    end
    -- Also skip for non-regular buffers
    local filetype = vim.bo[bufnr].filetype
    if filetype == '' or filetype == 'qf' or filetype == 'netrw' then
      return nil
    end
    return { timeout_ms = 5000 }
  end,
  -- Use conform's native format on save (BufWritePre -> format -> BufWritePost)
  notify_no_formatters = false,
})

-- Also set up format on save via autocmd as backup
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.b[bufnr].disableFormatSave then
      return
    end
    local filetype = vim.bo[bufnr].filetype
    if filetype == '' or filetype == 'qf' or filetype == 'netrw' or filetype == 'snacks_picker_input' then
      return
    end
    -- Let conform handle it if available
    if ok_conform then
      vim.schedule(function()
        pcall(conform.format, { bufnr = bufnr, timeout_ms = 5000 })
      end)
    end
  end,
})
