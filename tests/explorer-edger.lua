-- Run with the wrapped editor: nvim --headless -c 'luafile tests/explorer-edger.lua'
local function press(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "xt", false)
  vim.wait(150)
end

local function editor_windows()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_win_get_config(win).relative == "" and vim.bo[buf].buftype == "" then
      wins[#wins + 1] = win
    end
  end
  return wins
end

local function explorer()
  return require("snacks").picker.get({ source = "explorer" })[1]
end

local function open_explorer()
  require("snacks").explorer()
  assert(
    vim.wait(2000, function()
      return explorer() ~= nil
    end),
    "explorer did not open"
  )
end

local function check()
  vim.cmd("edit README.md")
  open_explorer()
  press("<M-i>")
  assert(#editor_windows() == 2, "Alt+i in explorer did not split editor")
  assert(explorer(), "Alt+i closed explorer")
  press("<M-w>")
  assert(#editor_windows() == 1, "Alt+w in editor did not close its extra split")
  assert(explorer(), "Alt+w in editor closed sidebar")
  press("<M-i>")
  assert(#editor_windows() == 2, "Alt+i in editor with explorer open did not split editor")
  press("<M-w>")
  assert(#editor_windows() == 1, "Alt+w in editor with explorer open did not close split")
  vim.api.nvim_set_current_win(explorer().list.win.win)
  press("<M-w>")
  assert(not explorer(), "Alt+w in explorer did not close sidebar")
  assert(#editor_windows() == 1, "Alt+w in explorer closed editor")

  open_explorer()
  vim.api.nvim_set_current_win(editor_windows()[1])
  press("<M-w>")
  assert(#editor_windows() == 1, "Alt+w with one editor closed last editor")
  assert(not explorer(), "Alt+w with one editor did not close sidebar")

  open_explorer()
  explorer():focus("input", { show = true })
  vim.cmd.stopinsert()
  press("<M-i>")
  assert(#editor_windows() == 2, "Alt+i in explorer input did not split editor")
  vim.api.nvim_set_current_win(explorer().input.win.win)
  press("<M-w>")
  assert(not explorer(), "Alt+w in explorer input did not close sidebar")
  assert(#editor_windows() == 2, "Alt+w in explorer input closed editor")
  vim.api.nvim_set_current_win(editor_windows()[2])
  press("<M-w>")
  assert(#editor_windows() == 1, "Alt+w after closing explorer did not close editor split")

  press("<M-i>")
  assert(#editor_windows() == 2, "Alt+i without explorer did not split editor")
  press("<M-w>")
  assert(#editor_windows() == 1, "Alt+w without explorer did not close split")
end

local ok, err = xpcall(check, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd("cquit 1")
end
print("explorer Edger keys passed")
vim.cmd("qa!")
