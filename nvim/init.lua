vim.loader.enable()

local cmd = vim.cmd

-- Native plugins
cmd("filetype plugin indent on")
cmd.packadd("cfilter")

-- let sqlite.lua know where to find sqlite
vim.g.sqlite_clib_path = require("luv").os_getenv("LIBSQLITE")

-- Load suderman configuration modules
require("suderman.opts")
require("suderman.diagnostics")
require("suderman.keymaps")
require("suderman.util")

-- Load local config if exists
require("suderman.util").load_local_config()

-- Plugins are loaded via Neovim's standard packpath mechanism managed by Nix
