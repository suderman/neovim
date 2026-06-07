# suderman/neovim

Personal Neovim config, packaged with Nix.

- Neovim: from `nixpkgs-unstable`.
- Config: plain Lua under `nvim/`.
- Plugins/tools: declared in `nix/neovim-overlay.nix`.
- Builder: kickstart-nix.nvim-style wrapper in `nix/mkNeovim.nix`.

## Use

```sh
# Run this config
nix run .

# Build the wrapped editor
nix build .

# Dev shell with nvim-dev and Lua tooling
nix develop
```

`nix develop` also links:

- `.luarc.json` -> generated Lua runtime metadata
- `~/.config/nvim-dev` -> this repo's `nvim/`

Then run `nvim-dev` to test the config as a separate app name.

## What is included

### Core stack

- Native Neovim 0.12 LSP: `vim.lsp.config` / `vim.lsp.enable`
- Completion: `blink.cmp`
- Snippets: native `vim.snippet` with `friendly-snippets`
- Picker/explorer: `snacks.nvim`, `oil.nvim`, `yazi.nvim`
- Formatting: `conform.nvim`
- Linting: `nvim-lint`
- Treesitter: native highlighting/folds plus `nvim-treesitter` parser/textobject tools

### Language/tool support

Main configured LSPs:

- Lua, Nix, Python, Go, C/C++, Rust
- TypeScript/JavaScript, HTML, CSS, Tailwind
- Bash, JSON, YAML, PHP, Markdown, Ruby, SQL

Formatters/linters are wrapped into the Neovim PATH by Nix. Not your host shell.

### OpenCode

OpenCode integration uses `sudo-tee/opencode.nvim`.

The plugin prefers the user's configured CLI at:

```text
~/.local/bin/opencode
```

If missing, it falls back to the Nix-wrapped `opencode`.

AI key prefix is comma:

- `,,` or `,g` toggle OpenCode
- `,i` input
- `,o` output
- `,s` session picker
- `,p` provider/model picker
- `,/` quick chat

## Common checks

```sh
nix build .

./result/bin/nvim --headless +'lua print("loaded")' +qa

./result/bin/nvim --headless \
  '+checkhealth vim.lsp vim.treesitter provider' \
  '+qa'

nix develop --command stylua --check nvim
```

## Local config

Optional local Lua config:

```text
~/.config/nvim/lua/local/init.lua
```

This is loaded by `suderman.util.load_local_config()`.

## Layout

```text
flake.nix                  flake outputs and dev shell
nix/neovim-overlay.nix      plugins and external tools
nix/mkNeovim.nix            wrapper/builder
nvim/init.lua               base options and module loading
nvim/lua/suderman/          personal options/keymaps/utilities
nvim/plugin/                plugin configs loaded by Neovim
```
