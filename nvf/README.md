# nvf/ Directory - Migration Reference

This directory contains the **previous nvf-based Neovim configuration** that was
used before the migration to a kickstart-nix.nvim-style Lua-first setup.

## Purpose

Retained only as a **migration reference**. The old configuration is preserved
to aid in:
- Comparing old vs new behavior
- Identifying features that were not yet ported
- Understanding the original nvf module structure

## Preserved State

The canonical preserved state of this old configuration lives on:
- **Branch**: `nvf`
- **Tag**: `nvf-final`

To access the old state:
```sh
git checkout nvf          # branch with old nvf config
git checkout nvf-final     # tagged release of old config
```

## What Changed

The migration from nvf to Lua-first involved:

| Old (nvf) | New (kickstart-style) |
|-----------|------------------------|
| Nix module per feature (`vim.xxx`) | Plain Lua in `nvim/` |
| `blueprint` + `nvf` libraries | `flake-utils` + custom overlay |
| Generated via `neovimConfiguration` | Manual `mkNeovim` call |
| Mason for LSP/formatters | Nix packages for tools |
| nvf modules in `nvf/` | Lua files in `nvim/` |

## Not Ported (Known Gaps)

- Full LSP server setup via Mason (deferred, using lspconfig directly)
- Full CodeCompanion adapter chains (simplified)
- Some snacks.nvim advanced picker features
- `nvf/goose.nix`, `nvf/assistant.nix` (disabled/commented in old config)

## lib/ Subdirectory

The `lib/` subdirectory contained Nix helper functions (`ls.nix`, `keyMap.nix`,
`default.nix`) that were specific to the nvf/blueprint integration. These are
now irrelevant to the new Lua-first setup and are kept only within `nvf/lib/`
for historical reference.
