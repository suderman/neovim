local M = {}

local disabled_filetypes = {
  [""] = true,
  netrw = true,
  qf = true,
  snacks_picker_input = true,
}

local php_root_markers = {
  ".php-cs-fixer.dist.php",
  ".php-cs-fixer.php",
  "composer.json",
  ".git",
}

local treefmt_root_markers = {
  "treefmt.nix",
}

local function php_project_root(filename)
  return vim.fs.root(filename, php_root_markers) or vim.fn.getcwd()
end

local function php_cs_fixer_command(_, ctx)
  local root = php_project_root(ctx.filename)
  local local_command = vim.fs.joinpath(root, "vendor", "bin", "php-cs-fixer")

  if vim.fn.executable(local_command) == 1 then
    return local_command
  end

  return "php-cs-fixer"
end

local function treefmt_project_root(filename)
  return vim.fs.root(filename, treefmt_root_markers)
end

local function with_treefmt(conform, formatters)
  return function(bufnr)
    if conform.get_formatter_info("treefmt", bufnr).available then
      return { "treefmt" }
    end

    return formatters
  end
end

local function format_on_save(bufnr)
  if vim.b[bufnr].disableFormatSave then
    return nil
  end

  if disabled_filetypes[vim.bo[bufnr].filetype] then
    return nil
  end

  return { timeout_ms = 5000, lsp_format = "fallback" }
end

function M.setup(conform)
  conform.setup({
    formatters_by_ft = {
      nix = with_treefmt(conform, { "alejandra" }),
      lua = { "stylua" },
      python = { "ruff_format", "ruff" },
      php = with_treefmt(conform, { "php_cs_fixer" }),
      twig = with_treefmt(conform, { "djlint" }),
      c = { "clang_format" },
      cpp = { "clang_format" },
      rust = { "rustfmt" },
      go = { "gofmt", "goimports" },
      javascript = with_treefmt(conform, { "prettierd", "prettier" }),
      typescript = with_treefmt(conform, { "prettierd", "prettier" }),
      javascriptreact = with_treefmt(conform, { "prettierd", "prettier" }),
      typescriptreact = with_treefmt(conform, { "prettierd", "prettier" }),
      html = with_treefmt(conform, { "prettierd", "prettier" }),
      css = with_treefmt(conform, { "prettierd", "prettier" }),
      json = with_treefmt(conform, { "prettierd", "prettier" }),
      yaml = with_treefmt(conform, { "prettierd", "prettier" }),
      markdown = with_treefmt(conform, { "prettierd", "prettier" }),
      sql = { "sqlfluff" },
      bash = { "shfmt" },
      sh = { "shfmt" },
    },
    formatters = {
      treefmt = {
        command = "treefmt",
        args = { "$RELATIVE_FILEPATH" },
        cwd = function(_, ctx)
          return treefmt_project_root(ctx.filename)
        end,
        require_cwd = true,
        stdin = false,
      },
      php_cs_fixer = {
        command = php_cs_fixer_command,
        args = { "fix", "$FILENAME" },
        stdin = false,
        cwd = function(_, ctx)
          return php_project_root(ctx.filename)
        end,
      },
    },
    format_on_save = format_on_save,
    notify_no_formatters = false,
  })
end

return M
