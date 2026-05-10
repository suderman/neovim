-- suderman opts.lua
-- Basic Neovim options migrated from nvf/basic.nix, nvf/appearance.nix, nvf/editing.nix

local opt = vim.o
local g = vim.g

-- Appearance
opt.cursorlineopt = "line"
opt.breakindent = true
opt.linebreak = true
opt.number = true
opt.ruler = true
opt.wrap = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false

-- Transparency (from nvf/appearance.nix)
-- Note: transparent.nvim is loaded in plugin/ui.lua

-- Popup menu appearance
opt.pumblend = 10
opt.pumheight = 10
opt.winblend = 10

-- Split behavior
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Editing
opt.ignorecase = true
opt.smartcase = true
opt.virtualedit = "block,insert,onemore"
opt.formatoptions = "qjl1"
opt.listchars = "tab:> ,extends:…,precedes:…,nbsp:␣"
opt.list = true
opt.wildmode = "list:longest,list:full"

-- Neovide support (from nvf/clipboard.nix)
g.neovide_opacity = 0.8
