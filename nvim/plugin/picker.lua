-- plugin/picker.lua
-- Picker/explorer configuration migrated from nvf/picker/*.nix
-- Uses snacks.nvim picker (primary) and telescope (fallback)

if vim.g.did_load_picker_plugin then
  return
end
vim.g.did_load_picker_plugin = true

-- Check if snacks is available
local ok_snacks, Snacks = pcall(require, 'snacks')

-- Full snacks setup migrated from old generated init (lines 1351+)
if ok_snacks then
  local function picker_action(source, focus)
    return function(picker)
      picker:close()
      Snacks.picker.pick({
        source = source,
        focus = focus,
      })
    end
  end

  Snacks.setup({
    bigfile = { enabled = true },
    dim = {
      animate = { duration = { step = 10, total = 200 } },
      enabled = true,
    },
    image = {
      enabled = true,
      force = true,
      inline = true,
    },
    indent = {
      animate = { duration = { step = 10, total = 200 } },
      enabled = true,
      scope = { enabled = true, hl = "LineNr", underline = true },
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      level = "INFO",
      style = "minimal",
      top_down = false,
    },
    picker = {
      actions = {
        buffers = picker_action('buffers', 'list'),
        command_history = picker_action('command_history', 'list'),
        commands = picker_action('commands', 'input'),
        diagnostics = picker_action('diagnostics', 'list'),
        diagnostics_buffer = picker_action('diagnostics_buffer', 'list'),
        explorer = picker_action('explorer', 'list'),
        files = picker_action('files', 'input'),
        grep = picker_action('grep', 'input'),
        jumps = picker_action('jumps', 'list'),
        keymaps = picker_action('keymaps', 'input'),
        marks = picker_action('marks', 'list'),
        notifications = picker_action('notifications', 'list'),
        pickers = function()
          Snacks.picker({})
        end,
        quickfix = picker_action('qflist', 'list'),
        undo = picker_action('undo', 'list'),
      },
      enabled = true,
      focus = "list",
      layout = { cycle = true },
      sources = {
        explorer = {
          enabled = true,
          finder = "explorer",
          layout = { hidden = { "input", "preview" } },
          replace_netrw = true,
          win = {
            input = { keys = { ["<Esc>"] = { "false", mode = { "n", "x" } } } },
            list = { keys = { ["<Esc>"] = { "false", mode = { "n", "x" } } } },
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<c-s>"] = { "flash", mode = { "i" } },
            h = "close",
            l = "confirm",
            s = { "flash", mode = { "n" } },
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
    scope = { enabled = true },
    scroll = {
      animate = { duration = { step = 10, total = 200 } },
      enabled = true,
    },
    styles = {
      -- Old nvf config used a blink-cmp-specific escape action here.
      -- Keep plain <esc> behavior with nvim-cmp.
      input = { keys = { i_esc = { "<esc>" } } },
      notification = { wo = { wrap = true } },
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
      win = {
        input = {
          keys = {
            [":"] = "commands",
            [";"] = "command_history",
            D = "diagnostics",
            F = "quickfix",
            J = "jumps",
            K = "keymaps",
            b = "buffers",
            d = "diagnostics_buffer",
            e = "explorer",
            f = "files",
            g = "grep",
            m = "marks",
            n = "notifications",
            p = "pickers",
            u = "undo",
          },
        },
        list = {
          keys = {
            [":"] = "commands",
            [";"] = "command_history",
            D = "diagnostics",
            F = "quickfix",
            J = "jumps",
            K = "keymaps",
            b = "buffers",
            d = "diagnostics_buffer",
            e = "explorer",
            f = "files",
            g = "grep",
            m = "marks",
            n = "notifications",
            p = "pickers",
            u = "undo",
          },
        },
      },
    })
  end, { desc = 'Smart Find Files' })

  -- K - Buffers (migrated from old generated init)
  vim.keymap.set('n', 'K', function()
    Snacks.picker.pick({
      auto_close = true,
      focus = "list",
      jump = { close = false },
      layout = { preset = "dropdown", preview = false },
      source = "buffers",
      win = {
        list = {
          keys = {
            ["<Space>"] = "close",
            K = "close",
            dd = "bufdelete",
            h = "close",
            l = "confirm",
          },
        },
      },
    })
  end, { desc = 'Buffers' })

  -- Explorer
  vim.keymap.set('n', '<leader>e', function()
    Snacks.explorer()
  end, { desc = 'File Explorer' })

  vim.keymap.set('n', 'H', function()
    Snacks.explorer()
  end, { desc = 'File Explorer' })

  vim.keymap.set('n', '\\]', function()
    Snacks.explorer()
  end, { desc = 'File Explorer' })

  vim.keymap.set('n', '\\=', function()
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
vim.keymap.set('n', '<C-y>', '<cmd>Yazi toggle<cr>', { desc = 'Resume last Yazi session' })
