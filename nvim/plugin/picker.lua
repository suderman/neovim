-- plugin/picker.lua
-- Picker/explorer configuration migrated from nvf/picker/*.nix
-- Uses snacks.nvim picker (primary) and telescope (fallback)

if vim.g.did_load_picker_plugin then
  return
end
vim.g.did_load_picker_plugin = true

-- Check if snacks is available
local ok_snacks, Snacks = pcall(require, 'snacks')

-- Try to setup snacks picker if available
if ok_snacks then
  Snacks.setup({
    picker = {
      enabled = true,
      focus = "input",
      layout = { preset = "dropdown", preview = false },
      win = {
        input = {
          keys = {
            h = "close",
            l = "confirm",
          },
        },
        list = {
          keys = {
            h = "close",
            l = "confirm",
          },
        },
      },
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
      finder = "explorer",
      layout = { preset = "dropdown", hidden = { "input", "preview" } },
    },
  })
end

-- Telescope setup (used as fallback for some pickers)
local ok_telescope, telescope = pcall(require, 'telescope')
if ok_telescope then
  local actions = require('telescope.actions')

  telescope.setup({
    defaults = {
      path_display = { 'truncate' },
      layout_strategy = 'vertical',
      layout_config = {
        vertical = {
          width = function(_, max_columns)
            return math.floor(max_columns * 0.99)
          end,
          height = function(_, _, max_lines)
            return math.floor(max_lines * 0.99)
          end,
          prompt_position = 'bottom',
          preview_cutoff = 0,
        },
      },
      mappings = {
        i = {
          ['<C-q>'] = actions.send_to_qflist,
          ['<C-l>'] = actions.send_to_loclist,
        },
        n = {
          q = actions.close,
        },
      },
      history = {
        path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
        limit = 1000,
      },
      color_devicons = true,
      set_env = { ['COLORTERM'] = 'truecolor' },
      prompt_prefix = '   ',
      initial_mode = 'insert',
      vimgrep_arguments = {
        'rg', '-L', '--color=never', '--no-heading', '--with-filename',
        '--line-number', '--column', '--smart-case',
      },
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })

  telescope.load_extension('fzy_native')
end

-- === Snacks picker keymaps (from nvf/picker/default.nix) ===
-- <space> - Smart picker
if ok_snacks then
  vim.keymap.set('n', '<space>', function()
    Snacks.picker.pick({
      source = "smart",
      focus = "input",
    })
  end, { desc = 'Smart Find Files' })

  -- K - Buffers
  vim.keymap.set('n', 'K', function()
    Snacks.picker.pick({
      source = "buffers",
      focus = "list",
      auto_close = true,
    })
  end, { desc = 'Buffers' })

  -- Explorer
  vim.keymap.set('n', '<leader>e', function()
    Snacks.explorer()
  end, { desc = 'File Explorer' })

  vim.keymap.set('n', 'H', function()
    Snacks.explorer()
  end, { desc = 'File Explorer' })

  -- Files (via telescope fallback if snacks can't)
  vim.keymap.set('n', '<leader>tp', function()
    Snacks.picker.pick({ source = "files", focus = "input" })
  end, { desc = '[Telescope] find files' })

  -- Grep
  vim.keymap.set('n', '<C-g>', function()
    Snacks.picker.pick({ source = "grep", focus = "input" })
  end, { desc = '[Snacks] live grep' })

  -- Quickfix
  vim.keymap.set('n', '<leader>F', function()
    Snacks.picker.pick({ source = "qflist", focus = "list" })
  end, { desc = '[Snacks] quickfix' })

  -- Undo
  vim.keymap.set('n', 'u', function()
    Snacks.picker.pick({ source = "undo", focus = "list" })
  end, { desc = '[Snacks] undo' })

  -- Marks
  vim.keymap.set('n', 'm', function()
    Snacks.picker.pick({ source = "marks", focus = "list" })
  end, { desc = '[Snacks] marks' })

  -- Jumps
  vim.keymap.set('n', 'J', function()
    Snacks.picker.pick({ source = "jumps", focus = "list" })
  end, { desc = '[Snacks] jumps' })

  -- Diagnostics (buffer)
  vim.keymap.set('n', 'd', function()
    Snacks.picker.pick({ source = "diagnostics_buffer", focus = "list" })
  end, { desc = '[Snacks] buffer diagnostics' })

  -- Diagnostics (all)
  vim.keymap.set('n', 'D', function()
    Snacks.picker.pick({ source = "diagnostics", focus = "list" })
  end, { desc = '[Snacks] all diagnostics' })

  -- Notifications
  vim.keymap.set('n', 'n', function()
    Snacks.picker.pick({ source = "notifications", focus = "list" })
  end, { desc = '[Snacks] notifications' })

  -- Commands
  vim.keymap.set('n', ':', function()
    Snacks.picker.pick({ source = "commands", focus = "input" })
  end, { desc = '[Snacks] commands' })

  -- Command history
  vim.keymap.set('n', ';', function()
    Snacks.picker.pick({ source = "command_history", focus = "list" })
  end, { desc = '[Snacks] command history' })

else
  -- Fallback to telescope if snacks not available
  vim.keymap.set('n', '<space>', function()
    require('telescope.builtin').find_files()
  end, { desc = 'find files' })

  vim.keymap.set('n', 'K', function()
    require('telescope.builtin').buffers()
  end, { desc = 'Buffers' })

  vim.keymap.set('n', '<leader>e', function()
    require('telescope.builtin').find_files()
  end, { desc = 'File Explorer' })

  vim.keymap.set('n', 'H', function()
    require('telescope.builtin').find_files()
  end, { desc = 'File Explorer' })

  vim.keymap.set('n', '<leader>tp', function()
    require('telescope.builtin').find_files()
  end, { desc = 'find files' })

  vim.keymap.set('n', '<C-g>', function()
    require('telescope.builtin').live_grep()
  end, { desc = 'live grep' })
end

-- === Telescope-only keymaps (not in snacks) ===
if ok_telescope then
  -- \\ - Last buffer
  vim.keymap.set('n', '\\\\', '<C-^>', { desc = 'Last Buffer' })

  -- <M-p> - Oldfiles
  vim.keymap.set('n', '<M-p>', function()
    require('telescope.builtin').oldfiles()
  end, { desc = 'old files' })

  -- <leader>tg - Project files
  vim.keymap.set('n', '<leader>tg', function()
    local ok = pcall(require('telescope.builtin').git_files)
    if not ok then
      require('telescope.builtin').find_files()
    end
  end, { desc = 'project files' })

  -- <leader>tbb - Buffers
  vim.keymap.set('n', '<leader>tbb', function()
    require('telescope.builtin').buffers()
  end, { desc = 'buffers' })

  -- <leader>tc - Quickfix
  vim.keymap.set('n', '<leader>tc', function()
    require('telescope.builtin').quickfix()
  end, { desc = 'quickfix list' })

  -- <leader>tq - Command history
  vim.keymap.set('n', '<leader>tq', function()
    require('telescope.builtin').command_history()
  end, { desc = 'command history' })

  -- <leader>tl - Location list
  vim.keymap.set('n', '<leader>tl', function()
    require('telescope.builtin').loclist()
  end, { desc = 'loclist' })
end

-- === Oil.nvim explorer ===
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Oil file explorer' })

-- === Yazi-nvim (from nvf/picker/files.nix) ===
vim.keymap.set('n', '<leader>y', '<cmd>Yazi<cr>', { desc = 'Yazi file picker' })
vim.keymap.set('n', '<leader>cw', '<cmd>Yazi cwd<cr>', { desc = 'Yazi at cwd' })
