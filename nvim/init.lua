vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o

-- Search down into subfolders
opt.path = vim.o.path .. '**'

-- Basic options
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true
opt.incsearch = true
opt.hlsearch = true

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.history = 2000
opt.nrformats = 'bin,hex'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.colorcolumn = '100'

-- Prevent spacebar from doing anything on its own
vim.g.mapleader = "\\"
vim.g.maplocalleader = ","

-- Mouse enabled
opt.mouse = "nvi"

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter')

-- let sqlite.lua know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

-- Load suderman configuration modules
require('suderman.opts')
require('suderman.diagnostics')
require('suderman.keymaps')
require('suderman.util')

-- Load local config if exists
require('suderman.util').load_local_config()

-- Plugins are loaded via Neovim's standard packpath mechanism managed by Nix
