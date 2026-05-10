-- plugin/ui.lua
-- UI configuration migrated from nvf/appearance.nix

if vim.g.did_load_ui_plugin then
  return
end
vim.g.did_load_ui_plugin = true

-- Transparent.nvim
require('transparent').setup({
  extra_groups = {
    "NormalFloat",
  },
})

-- Fidget.nvim (LSP progress)
require('fidget').setup({
  notification = {
    window = {
      winblend = 0,
      border = "none",
    },
  },
})

-- Onedark colorscheme (from nvf/appearance.nix)
-- style = "darker", transparent = true
require('onedark').setup({
  style = 'darker',
  transparent = true,
})
require('onedark').load()

-- Render markdown setup for markdown and codecompanion filetypes
-- Module name is 'render-markdown' (not 'render-md')
local ok_rm, rm = pcall(require, 'render-markdown')
if ok_rm then
  rm.setup({
    file_types = { 'markdown', 'codecompanion' },
  })
end

-- Snacks.nvim (from nvf/appearance.nix and nvf/picker/*.nix)
-- Note: snacks-nvim provides picker, notifier, indent, scope, dim, input styles
-- Full snacks setup is in plugin/picker.lua (consolidated from old generated init)

-- Status column
require('statuscol').setup({
  setopt = true,
  segments = {
    { text = { " " }, click = "v:lua.Scroll" },
    { text = { "C" }, click = "v:lua.Scroll" },
    { text = { "%s", 2 }, click = "v:lua.Scroll" },
    { text = { "%l" }, click = "v:lua.Scroll" },
    { text = { " ", click = "v:lua.Scroll" } },
    { text = { "%p" }, click = "v:lua.Scroll" },
    { text = { "/" }, click = "v:lua.Scroll" },
    { text = { "%L" }, click = "v:lua.Scroll" },
    { text = { " ", click = "v:lua.Scroll" } },
  },
})

-- Colorizer - skip if not available
pcall(require, 'colorizer')

-- Oil.nvim (file explorer)
require('oil').setup({
  default_file_explorer = false,
  delete_to_trash = true,
  columns = { "icon", "permissions", "size", "mtime" },
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    natural_order = true,
    is_always_hidden = function(name, _)
      return name == '..' or name == '.git'
    end,
  },
  win_options = {
    wrap = true,
  },
})

-- Neovide specific (from nvf/appearance.nix)
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<D-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<D-->", function()
    change_scale_factor(1/1.25)
  end)

  -- Neovide clipboard keybindings (from generated init.lua)
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", "+y") -- Copy
  vim.keymap.set("n", "<D-v>", "+P") -- Paste normal mode
  vim.keymap.set("v", "<D-v>", "+P") -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  -- Global fallback mappings for D-v (used when no mode-specific mapping matches)
  vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
end

-- ============================================================
-- Lualine statusline (from nvf/appearance.nix and nvf/codecompanion/mcphub.nix)
-- Guard to prevent double-loading if this file is ever imported standalone
if vim.g.did_load_statusline_plugin then
  return
end
vim.g.did_load_statusline_plugin = true

-- Global statusline: laststatus=3 enables global statusline (Neovim 0.11+)
vim.opt.laststatus = 3

-- Helper: active LSP names for lualine_x
local function lsp_names()
  local names = {}
  for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
    if client.name ~= 'null' then
      table.insert(names, client.name)
    end
  end
  return #names > 0 and table.concat(names, ' ') or ''
end

-- Helper: diagnostic icons
local function diag_icon(level)
  local icons = {
    ERROR = '󰅚',
    WARN = '⚠',
    INFO = 'ⓘ',
    HINT = '󰌶',
  }
  return icons[level] or '■'
end

local function diag_count(level)
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
  return count > 0 and (diag_icon(level) .. count) or ''
end

-- Snacks picker cwd extension helper
local function snacks_picker_cwd()
  local ok_snacks, Snacks = pcall(require, 'snacks')
  if not ok_snacks then
    return ''
  end
  local cwd = vim.fn.getcwd()
  local home = vim.env.HOME
  if cwd:find(home, 1, true) == 1 then
    cwd = '~' .. cwd:sub(#home + 1)
  end
  return cwd
end

-- Optional mcphub status (guarded, simple)
local function mcphub_status()
  if not vim.g.loaded_mcphub then
    return ''
  end
  local count = vim.g.mcphub_servers_count or 0
  local status = vim.g.mcphub_status or 'stopped'
  if status == 'stopped' then
    return '󰐻 -'
  end
  if status == 'ready' or status == 'restarted' then
    return '󰐻 ' .. count
  end
  return '󰐻 ' .. status
end

-- Lualine configuration
local ok_lualine, lualine = pcall(require, 'lualine')
if ok_lualine then
  lualine.setup({
    options = {
      theme = 'auto',
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        {
          'branch',
          icon = '',
        },
        {
          'searchcount',
          icon = 'magnifying_glass',
        },
      },
      lualine_c = {
        {
          'progress',
          icon = '>',
        },
        {
          'location',
          icon = '@',
        },
      },
      lualine_x = {
        -- Diagnostics with counts
        function()
          local parts = {}
          for _, level in ipairs({ 'ERROR', 'WARN', 'INFO', 'HINT' }) do
            local d = diag_count(level)
            if d ~= '' then
              table.insert(parts, d)
            end
          end
          return table.concat(parts, ' ')
        end,
        -- Active LSP names
        function()
          local names = lsp_names()
          return names ~= '' and ('⚙ ' .. names) or ''
        end,
        -- Snacks picker cwd when in a picker buffer
        function()
          local filetype = vim.bo.filetype
          if filetype:find('snacks_picker', 1, true) then
            return snacks_picker_cwd()
          end
          return ''
        end,
        -- File format with icon
        {
          'fileformat',
          icon = {
            'unix',
            'dos',
            'mac',
          },
          symbols = {
            unix = 'LF',
            dos = 'CRLF',
            mac = 'CR',
          },
        },
      },
      lualine_y = {
        {
          'diagnostics',
          sources = { 'nvim' },
          symbols = {
            error = '󰅚',
            warn = '⚠',
            info = 'ⓘ',
            hint = '󰌶',
          },
          update_in_insert = false,
          always_visible = false,
        },
      },
      lualine_z = {
        function()
          return '%=%'
        end,
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  })
end
