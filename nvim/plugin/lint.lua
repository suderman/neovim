-- plugin/lint.lua
-- Lint configuration migrated from nvf/languages.nix (nvim-lint section)

if vim.g.did_load_lint_plugin then
  return
end
vim.g.did_load_lint_plugin = true

-- Bail out early if nvim-lint is not available
local ok_lint, lint = pcall(require, 'lint')
if not ok_lint then
  return
end

-- Configure linters by filetype
lint.linters_by_ft = {
  html = { 'htmlhint' },
  lua = { 'luacheck' },
  markdown = { 'markdownlint-cli2' },
  nix = { 'statix', 'deadnix' },
  ruby = { 'rubocop' },
  sh = { 'shellcheck' },
  sql = { 'sqlfluff' },
  typescript = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
}

-- Configure linter-specific settings where needed.
-- Do not replace built-in linter definitions with partial tables, or we lose
-- parser/args/stdin settings and nvim-lint crashes when the linter runs.
local eslint_d = lint.linters.eslint_d
if eslint_d then
  eslint_d.required_files = {
    'eslint.config.js',
    'eslint.config.mjs',
    '.eslintrc',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc.js',
    '.eslintrc.yml',
  }
end

local function should_run_linter(name)
  local linter = lint.linters[name]
  if not linter then
    return false
  end

  if type(linter) == 'function' then
    linter = linter()
  end

  local required_files = linter.required_files
  if required_files == nil or vim.tbl_isempty(required_files) then
    return true
  end

  local cwd = linter.cwd or vim.fn.getcwd()
  for _, file in ipairs(required_files) do
    local path = vim.fs.joinpath(cwd, file)
    if vim.uv.fs_stat(path) then
      return true
    end
  end

  return false
end

local function lint_buffer(buf)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
  local names = lint._resolve_linter_by_ft(ft)
  if vim.tbl_isempty(names) then
    return
  end

  local eligible = vim.tbl_filter(should_run_linter, names)
  if vim.tbl_isempty(eligible) then
    return
  end

  lint.try_lint(eligible)
end

-- Attach lint-on-save for filetypes that have linters configured
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function(args)
    lint_buffer(args.buf)
  end,
})
