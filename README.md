# 🧠 suderman/neovim

A Lua-first Neovim configuration managed by [kickstart-nix.nvim](https://github.com/nix-community/kickstart-nix.nvim). 
The configuration lives in `nvim/` (plain Lua files) while Nix handles plugins, runtime dependencies, LSP
servers, formatters, and treesitter grammars.

## Structure

- `flake.nix` - Flake outputs using kickstart-nix.nvim style overlay
- `nix/mkNeovim.nix` - Neovim derivation builder
- `nix/neovim-overlay.nix` - Overlay with plugins and packages
- `nvim/` - Neovim configuration (init.lua, lua/suderman/, plugin/)

## Usage

```sh
# Run the configured Neovim
nix run .

# Development shell
nix develop

# Build
nix build .
```

## Local Config

Optional local Lua config can be placed at:
`~/.config/nvim/lua/local/init.lua`
