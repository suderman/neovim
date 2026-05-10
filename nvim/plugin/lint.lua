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

-- Configure linter-specific settings where needed
lint.linters.deadnix = {
  cmd = 'deadnix',
}

lint.linters.eslint_d = {
  cmd = 'eslint_d',
  required_files = {
    'eslint.config.js',
    'eslint.config.mjs',
    '.eslintrc',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc.js',
    '.eslintrc.yml',
  },
}

lint.linters.htmlhint = {
  cmd = 'htmlhint',
}

lint.linters.luacheck = {
  cmd = 'luacheck',
}

lint.linters.markdownlint_cli2 = {
  cmd = 'markdownlint-cli2',
}

lint.linters.rubocop = {
  cmd = 'rubocop',
}

lint.linters.shellcheck = {
  cmd = 'shellcheck',
}

lint.linters.sqlfluff = {
  cmd = 'sqlfluff',
  args = { 'lint', '--format=json', '--dialect=ansi' },
}

lint.linters.statix = {
  cmd = 'statix',
}

-- Old-style lint-on-save function (mirrors nvf behavior)
local function nvf_lint(buf)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
  local linters_by_ft = require('lint').linters_by_ft[ft]
  if linters_by_ft == nil then
    return
  end

  for _, name in ipairs(linters_by_ft) do
    local linter = require('lint').linters[name]
    if not linter then
      goto continue
    end

    if type(linter) == 'function' then
      linter = linter()
    end
    linter.name = linter.name or name

    local required_files = linter.required_files
    if required_files == nil or next(required_files) == nil then
      require('lint').lint(linter)
    else
      local cwd = linter.cwd or vim.fn.getcwd()
      for _, fn in ipairs(required_files) do
        local path = vim.fs.joinpath(cwd, fn)
        if vim.uv.fs_stat(path) then
          require('lint').lint(linter)
          break
        end
      end
    end

    ::continue::
  end
end

-- Attach lint-on-save for filetypes that have linters configured
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function(args)
    nvf_lint(args.buf)
  end,
})
