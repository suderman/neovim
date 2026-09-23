-- suderman keymaps.lua
local keymap = vim.keymap.set
local nmap = function(lhs, rhs, desc)
  keymap("n", lhs, rhs, { silent = true, desc = desc })
end
local vmap = function(lhs, rhs, desc)
  keymap("v", lhs, rhs, { silent = true, desc = desc })
end
local imap = function(lhs, rhs, desc)
  keymap("i", lhs, rhs, { silent = true, desc = desc })
end
local tmap = function(lhs, rhs, desc)
  keymap("t", lhs, rhs, { silent = true, desc = desc })
end

-- Leader
vim.g.mapleader = "\\"
vim.g.maplocalleader = ","

-- Prevent spacebar from doing anything on its own
nmap("<leader>", "<nop>", "No operation")

-- Enter command mode with semi-colon
nmap(";", ":", "Enter command mode")

-- Clear highlighted search
nmap("<leader>c", ":noh<CR>:match none<CR>:2match none<CR>:3match none<CR>", "Clear search")

-- Tab navigation
imap("<M-[>", "<Esc>:tabprevious<CR>", "Previous tab")
imap("<M-]>", "<Esc>:tabnext<CR>", "Next tab")

-- Wrapped lines navigation
nmap("j", "gj", "Down a row")
nmap("k", "gk", "Up a row")

-- Repeat indent/outdent
vmap("<", "<gv", "Outdent")
vmap(">", ">gv", "Indent")

-- Yank to end of line, matching Vim's D/C behavior.
nmap("Y", "y$", "Yank to end of line")

-- Previous window; directional navigation is configured by Edger in plugin/windows.lua.
nmap("<M-;>", "<C-w>p", "Navigate focus previous")

-- Navigate directly from terminal mode.
tmap("<M-h>", "<C-\\><C-n><cmd>EdgerLeft<CR>", "Navigate focus left")
tmap("<M-j>", "<C-\\><C-n><cmd>EdgerDown<CR>", "Navigate focus down")
tmap("<M-k>", "<C-\\><C-n><cmd>EdgerUp<CR>", "Navigate focus up")
tmap("<M-l>", "<C-\\><C-n><cmd>EdgerRight<CR>", "Navigate focus right")
for key, command in pairs({
  H = "ResizeLeft",
  J = "ResizeDown",
  K = "ResizeUp",
  L = "ResizeRight",
  t = "Tab",
  u = "Horizontal",
  i = "Vertical",
  w = "Close",
}) do
  tmap("<M-" .. key .. ">", "<C-\\><C-n><cmd>Edger" .. command .. "<CR>", "Edger " .. command)
end
tmap("<M-;>", "<C-\\><C-n><C-w>p", "Navigate focus previous")

-- Resize windows in visual mode
vmap("<M-h>", "<c-w><", "Resize window left")
vmap("<M-j>", "<c-w>+", "Resize window down")
vmap("<M-k>", "<c-w>-", "Resize window up")
vmap("<M-l>", "<c-w>>", "Resize window right")

-- Cursor movement in command mode
imap("<M-h>", "<Left>", "Move cursor left")
imap("<M-j>", "<Down>", "Move cursor down")
imap("<M-k>", "<Up>", "Move cursor up")
imap("<M-l>", "<Right>", "Move cursor right")

-- Split windows
nmap("<leader>u", ":sp<CR>", "Split horizontal")
nmap("<leader>i", ":vs<CR>", "Split vertical")
nmap("<M-U>", ":sp<CR>", "Split horizontal")
nmap("<M-I>", ":vs<CR>", "Split vertical")
nmap("gu", ":sp<CR>", "Split horizontal")
nmap("gi", ":vs<CR>", "Split vertical")

-- Quit split
nmap("<leader>q", ":q<CR>", "Quit split")
nmap(",q", ":q<CR>", "Quit split")
nmap("<M-q>", ":q<CR>", "Quit split")

-- Insert Ctrl-l inserts spaces
imap("<C-l>", "<Space>", "Insert space")

-- Buffer navigation
nmap("[b", ":bprevious<CR>", "Previous buffer")
nmap("]b", ":bnext<CR>", "Next buffer")
nmap("[B", ":bfirst<CR>", "First buffer")
nmap("]B", ":blast<CR>", "Last buffer")

-- Quickfix navigation
nmap("[c", ":cprevious<CR>", "Previous quickfix")
nmap("]c", ":cnext<CR>", "Next quickfix")
nmap("[C", ":cfirst<CR>", "First quickfix")
nmap("]C", ":clast<CR>", "Last quickfix")

-- Location list navigation
nmap("[l", ":lprevious<CR>", "Previous loclist")
nmap("]l", ":lnext<CR>", "Next loclist")
nmap("[L", ":lfirst<CR>", "First loclist")
nmap("]L", ":llast<CR>", "Last loclist")
