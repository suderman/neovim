# suderman/neovim

A Lua-first Neovim configuration managed by Nix. The configuration lives in
`nvim/` (plain Lua files) while Nix handles plugins, runtime dependencies, LSP
servers, formatters, and treesitter grammars.

## Structure

- `flake.nix` - Flake outputs using kickstart-nix.nvim style overlay
- `nix/mkNeovim.nix` - Neovim derivation builder
- `nix/neovim-overlay.nix` - Overlay with plugins and packages
- `nvim/` - Neovim configuration (init.lua, lua/suderman/, plugin/)
- `nvf/` - **Previous nvf-based configuration preserved as reference**
  - The canonical old state is preserved on branch `nvf` with tag `nvf-final`

## Usage

```sh
# Run the configured Neovim
nix run .

# Development shell
nix develop

# Build
nix build .
```

## Migration Notes

The previous nvf/blueprint configuration has been replaced with a
kickstart-nix.nvim-style Lua-first setup. Key changes:

- Plain Lua configs in `nvim/` instead of nvf Nix modules
- Nix manages plugin installation via `neovim-overlay.nix` and `mkNeovim.nix`
- No more `blueprint`/`nvf` dependency; no more `package.nix`
- Some features may differ; see `nvf/` for the old implementation

## Local Config

Optional local Lua config can be placed at:
`~/.config/nvim/lua/local/init.lua`
