-- plugin/picker.lua
-- Picker/explorer configuration migrated from nvf/picker/*.nix
-- Uses snacks.nvim picker

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
      input = { keys = { i_esc = { "<esc>" } } },
      notification = { wo = { wrap = true } },
    },
  })
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

  -- Files
  vim.keymap.set('n', '<leader>tp', function()
    Snacks.picker.pick({ source = "files", focus = "input" })
  end, { desc = '[Snacks] find files' })

  -- Grep
  vim.keymap.set('n', '<C-g>', function()
    Snacks.picker.pick({ source = "grep", focus = "input" })
  end, { desc = '[Snacks] live grep' })

end

-- \\ - Last buffer
vim.keymap.set('n', '\\\\', '<C-^>', { desc = 'Last Buffer' })

if ok_snacks then
  vim.keymap.set('n', '<M-p>', function()
    Snacks.picker.pick({ source = "recent", focus = "list" })
  end, { desc = 'old files' })

  vim.keymap.set('n', '<leader>tg', function()
    Snacks.picker.pick({ source = "git_files", focus = "input" })
  end, { desc = 'project files' })

  vim.keymap.set('n', '<leader>tbb', function()
    Snacks.picker.pick({ source = "buffers", focus = "list" })
  end, { desc = 'buffers' })

  vim.keymap.set('n', '<leader>tc', function()
    Snacks.picker.pick({ source = "qflist", focus = "list" })
  end, { desc = 'quickfix list' })

  vim.keymap.set('n', '<leader>tq', function()
    Snacks.picker.pick({ source = "command_history", focus = "list" })
  end, { desc = 'command history' })

  vim.keymap.set('n', '<leader>tl', function()
    Snacks.picker.pick({ source = "loclist", focus = "list" })
  end, { desc = 'loclist' })
end

-- === Oil.nvim explorer ===
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Oil file explorer' })

-- === Yazi-nvim (from nvf/picker/files.nix) ===
vim.keymap.set('n', '<leader>y', '<cmd>Yazi<cr>', { desc = 'Yazi file picker' })
vim.keymap.set('n', '<leader>cw', '<cmd>Yazi cwd<cr>', { desc = 'Yazi at cwd' })
vim.keymap.set('n', '<C-y>', '<cmd>Yazi toggle<cr>', { desc = 'Resume last Yazi session' })
