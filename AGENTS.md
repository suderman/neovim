# Agent notes

- Keep diffs small. User commits between slices.
- Run `git status --short` first. Treat dirty files as user-owned.
- Use `nix build .` and headless `./result/bin/nvim --headless +'lua print("loaded")' +qa` before done.
- `nix develop` creates `.luarc.json`. It is ignored, but remove it if it appears in status.
- Config source is `nvim/`. New Lua files must be tracked by git or Nix clean source may miss them.
- LSP is native 0.12. Do not use `require("lspconfig")`.
- Keep `nvim-lspconfig` package unless all server `cmd/filetypes/root_markers` are made explicit.
- Treesitter: no `nvim-treesitter.configs`. Use `vim.treesitter.start`, native foldexpr, nvim-treesitter indent/textobjects.
- Completion is `blink.cmp` + native snippets. Do not re-add `nvim-cmp` or LuaSnip unless asked.
- Picker is Snacks. Do not re-add Telescope.
- Conform owns `format_on_save`. Do not add a second `BufWritePre` formatter.
- OpenCode plugin should prefer `~/.local/bin/opencode`; Nix package may lag user config.
- Entrypoints in `nvim/plugin/` should stay thin. Real code lives under `nvim/lua/suderman/`.
- Recent cleanup split UI, LSP, picker, git, Treesitter, completion, formatting,
  lint, and OpenCode config. Keep this pattern.
- Nix overlay plugin/tool lists are grouped by purpose. Avoid churn there unless
  adding or removing packages.

## Cleanup status

The 2026 config cleanup plan is complete. For future work, keep changes small,
preserve native Neovim 0.12 patterns, and run the standard Nix build plus
headless load before done.
