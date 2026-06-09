-- suderman opts.lua
local opt = vim.opt
local g = vim.g

-- Appearance
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "line"
opt.breakindent = true
opt.linebreak = true
opt.ruler = true
opt.wrap = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false
opt.colorcolumn = "100"
opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
}

-- Transparency
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
opt.path:append("**")
opt.lazyredraw = true
opt.showmatch = true
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.clipboard = "unnamedplus"
opt.mouse = "nvi"
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.virtualedit = "block,insert,onemore"
opt.formatoptions = "qjl1"
opt.listchars = {
  tab = "> ",
  extends = "…",
  precedes = "…",
  nbsp = "␣",
}
opt.list = true
opt.wildmode = "list:longest,list:full"
opt.history = 2000
opt.nrformats = { "bin", "hex" }
opt.undofile = true
opt.cmdheight = 0

-- Folding
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Neovide support
g.neovide_opacity = 0.8
