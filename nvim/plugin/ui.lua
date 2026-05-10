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

-- Native/quiet gutter
-- Keep the normal number/signcolumn behavior from suderman.opts.
-- Avoid custom statuscolumn chrome here.

-- nvim-cursorline: match old config by disabling cursorline/cursorword
local ok_cursorline, cursorline = pcall(require, 'nvim-cursorline')
if ok_cursorline then
  cursorline.setup({
    cursorline = { enable = false, number = false, timeout = 1000 },
    cursorword = { enable = false, hl = { underline = true }, min_length = 3, timeout = 1000 },
  })
end

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
  local buf_ft = vim.bo.filetype
  local excluded_buf_ft = {
    toggleterm = true,
    NvimTree = true,
    ["neo-tree"] = true,
    TelescopePrompt = true,
  }

  if excluded_buf_ft[buf_ft] then
    return ''
  end

  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name ~= 'null' then
      table.insert(names, client.name)
    end
  end
  return #names > 0 and table.concat(names, ', ') or 'No Active LSP'
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

-- Optional mcphub status
local function mcphub_status()
  if not vim.g.loaded_mcphub then
    return ''
  end
  local count = vim.g.mcphub_servers_count or 0
  local status = vim.g.mcphub_status or 'stopped'
  local executing = vim.g.mcphub_executing
  if status == 'stopped' then
    return '󰐻 -'
  end
  if executing or status == 'starting' or status == 'restarting' then
    local frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    local frame = math.floor(vim.loop.now() / 100) % #frames + 1
    return '󰐻 ' .. frames[frame]
  end
  if status == 'ready' or status == 'restarted' then
    return '󰐻 ' .. count
  end
  return '󰐻 ' .. status
end

local function mcphub_status_color()
  if not vim.g.loaded_mcphub then
    return { fg = '#6c7086' }
  end

  local status = vim.g.mcphub_status or 'stopped'
  if status == 'ready' or status == 'restarted' then
    return { fg = '#50fa7b' }
  elseif status == 'starting' or status == 'restarting' then
    return { fg = '#ffb86c' }
  end

  return { fg = '#ff5555' }
end

-- Lualine configuration
local ok_lualine, lualine = pcall(require, 'lualine')
if ok_lualine then
  local lualine_x = {
    {
      function()
        local names = lsp_names()
        return names ~= '' and (' ' .. names) or ''
      end,
      separator = { left = '' },
    },
    {
      'diagnostics',
      sources = { 'nvim_lsp', 'nvim_diagnostic', 'nvim_diagnostic', 'vim_lsp', 'coc' },
      symbols = { error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 ' },
      colored = true,
      update_in_insert = false,
      always_visible = false,
      diagnostics_color = {
        color_error = { fg = 'red' },
        color_warn = { fg = 'yellow' },
        color_info = { fg = 'cyan' },
      },
    },
    {
      function()
        return mcphub_status()
      end,
      color = mcphub_status_color,
    },
  }

  if vim.g.loaded_codecompanion then
    table.insert(lualine_x, 'codecompanion')
  end

  lualine.setup({
    options = {
      theme = 'auto',
      globalstatus = true,
      icons_enabled = true,
      refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {
        {
          'mode',
          icons_enabled = true,
          separator = { left = '▎', right = '' },
        },
        {
          '',
          draw_empty = true,
          separator = { left = '', right = '' },
        },
      },
      lualine_b = {
        {
          'filetype',
          colored = true,
          icon_only = true,
          icon = { align = 'left' },
        },
        {
          'filename',
          symbols = { modified = ' ', readonly = ' ' },
          separator = { right = '' },
        },
        {
          '',
          draw_empty = true,
          separator = { left = '', right = '' },
        },
      },
      lualine_c = {
        {
          'diff',
          colored = false,
          diff_color = {
            added = 'DiffAdd',
            modified = 'DiffChange',
            removed = 'DiffDelete',
          },
          symbols = { added = '+', modified = '~', removed = '-' },
          separator = { right = '' },
        },
      },
      lualine_x = lualine_x,
      lualine_y = {
        {
          '',
          draw_empty = true,
          separator = { left = '', right = '' },
        },
        {
          'searchcount',
          maxcount = 999,
          timeout = 120,
          separator = { left = '' },
        },
        {
          'branch',
          icon = ' •',
          separator = { left = '' },
        },
      },
      lualine_z = {
        {
          '',
          draw_empty = true,
          separator = { left = '', right = '' },
        },
        {
          'progress',
          separator = { left = '' },
        },
        { 'location' },
        {
          'fileformat',
          color = { fg = 'black' },
          symbols = {
            unix = '',
            dos = '',
            mac = '',
          },
        },
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
      extensions = {
        {
          filetypes = { 'snacks_picker_list', 'snacks_picker_input' },
          sections = {
            lualine_a = {
              function()
                return snacks_picker_cwd()
              end,
            },
          },
        },
      },
  })
end

-- ============================================================
-- Editing enhancements: mini plugins, comment, lightbulb, highlight-undo
-- (folded from formerly untracked plugin/editing.lua)
-- ============================================================

-- mini.nvim suite
local ok_mini, mini = pcall(require, 'mini')
if ok_mini then
  local ok_ai, mini_ai = pcall(require, 'mini.ai')
  if ok_ai then
    mini_ai.setup({
      custom_textobjects = nil,
      matter = nil,
      moves = nil,
    })
    pcall(function()
      local gen = require('mini.ai')
      if gen.gen_source and gen.gen_source.none then end
    end)
  end

  local ok_align = pcall(require, 'mini.align')
  if ok_align then
    require('mini.align').setup()
  end

  local ok_bracketed = pcall(require, 'mini.bracketed')
  if ok_bracketed then
    require('mini.bracketed').setup()
  end

  local ok_surround = pcall(require, 'mini.surround')
  if ok_surround then
    require('mini.surround').setup()
  end

  local ok_diff = pcall(require, 'mini.diff')
  if ok_diff then
    require('mini.diff').setup({
      source = require('mini.diff').gen_source.none(),
    })
  end
end

-- Comment.nvim
local ok_comment = pcall(require, 'Comment')
if ok_comment then
  require('Comment').setup({
    mappings = {
      basic = false,
      extra = false,
    },
  })
end

-- nvim-lightbulb
local ok_lightbulb = pcall(require, 'nvim-lightbulb')
if ok_lightbulb then
  require('nvim-lightbulb').setup({
    sign = {
      enabled = true,
      text = "💡",
      texthl = "LightBulbSign",
    },
    virtual_text = { enabled = false },
    float = { enabled = false },
    status_text = { enabled = false },
  })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    callback = function()
      pcall(vim.lsp.buf.code_action, { context = { only = { "quickfix" } } })
    end,
  })
end

-- nvim-web-devicons
local ok_icons = pcall(require, 'nvim-web-devicons')
if ok_icons then
  require('nvim-web-devicons').setup({
    color_icons = true,
    override = {},
  })
end

-- highlight-undo
local ok_hlundo = pcall(require, 'highlight-undo')
if ok_hlundo then
  require('highlight-undo').setup({
    undo = { hlgroup = "HighlightUndo", duration = 300 },
    redo = { hlgroup = "HighlightUndo", duration = 300 },
  })
end

-- smartcolumn
local ok_smartcol = pcall(require, 'smartcolumn')
if ok_smartcol then
  require('smartcolumn').setup({
    colorcolumn = "100",
    custom_colorcolumn = { default = "100" },
    disabled_filetypes = {
      "netrw", "TelescopePrompt", "TelescopeResults", "neo-tree", "NvimTree",
      "qf", "help", "dashboard", "lazy", "mason", "DiffviewFiles", "DiffviewFileHistory",
    },
  })
end

-- nvim-scrollbar
local ok_scrollbar = pcall(require, 'scrollbar')
if ok_scrollbar then
  require('scrollbar').setup({
    excluded_filetypes = {
      "prompt", "TelescopePrompt", "neo-tree", "NvimTree", "Notify", "alpha",
      "dashboard", "fern", "fzf", "hg", "mason", "neogit", "nerdtree",
      "null-ls", "snacks", "snacks_picker", "snacks_picker_input", "telescope",
      "qf", "help", "lspinfo", "man",
    },
    excluded_buftypes = { "terminal" },
  })
end

-- nvim-docs-view
local ok_docsview = pcall(require, 'docs-view')
if ok_docsview then
  require('docs-view').setup({
    height = 10,
    position = 'right',
    update_mode = 'auto',
    width = 60,
  })
  vim.keymap.set('n', '<leader>lvt', '<cmd>DocsViewToggle<CR>', { desc = 'DocsView: Toggle panel' })
  vim.keymap.set('n', '<leader>lvu', '<cmd>DocsViewUpdate<CR>', { desc = 'DocsView: Update panel' })
end
