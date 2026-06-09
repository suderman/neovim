vim.opt.laststatus = 3

local function lsp_names()
  local excluded_buf_ft = {
    toggleterm = true,
    NvimTree = true,
    ["neo-tree"] = true,
    snacks_picker_input = true,
  }

  if excluded_buf_ft[vim.bo.filetype] then
    return ""
  end

  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name ~= "null" then
      table.insert(names, client.name)
    end
  end
  return #names > 0 and table.concat(names, ", ") or "No Active LSP"
end

local function snacks_picker_cwd()
  local ok_snacks = pcall(require, "snacks")
  if not ok_snacks then
    return ""
  end

  local cwd = vim.fn.getcwd()
  local home = vim.env.HOME
  if cwd:find(home, 1, true) == 1 then
    cwd = "~" .. cwd:sub(#home + 1)
  end
  return cwd
end

local ok_lualine, lualine = pcall(require, "lualine")
if not ok_lualine then
  return
end

local lualine_x = {
  {
    function()
      local names = lsp_names()
      return names ~= "" and (" " .. names) or ""
    end,
    separator = { left = "" },
  },
  {
    "diagnostics",
    sources = { "nvim_diagnostic", "nvim_lsp" },
    symbols = { error = "󰅙  ", warn = "  ", info = "  ", hint = "󰌵 " },
    colored = true,
    update_in_insert = false,
    always_visible = false,
    diagnostics_color = {
      color_error = { fg = "red" },
      color_warn = { fg = "yellow" },
      color_info = { fg = "cyan" },
    },
  },
}

lualine.setup({
  options = {
    theme = "auto",
    globalstatus = true,
    icons_enabled = true,
    refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {
      {
        "mode",
        icons_enabled = true,
        separator = { left = "▎", right = "" },
      },
      {
        "",
        draw_empty = true,
        separator = { left = "", right = "" },
      },
    },
    lualine_b = {
      {
        "filetype",
        colored = true,
        icon_only = true,
        icon = { align = "left" },
      },
      {
        "filename",
        symbols = { modified = " ", readonly = " " },
        separator = { right = "" },
      },
      {
        "",
        draw_empty = true,
        separator = { left = "", right = "" },
      },
    },
    lualine_c = {
      {
        "diff",
        colored = false,
        diff_color = {
          added = "DiffAdd",
          modified = "DiffChange",
          removed = "DiffDelete",
        },
        symbols = { added = "+", modified = "~", removed = "-" },
        separator = { right = "" },
      },
    },
    lualine_x = lualine_x,
    lualine_y = {
      {
        "",
        draw_empty = true,
        separator = { left = "", right = "" },
      },
      {
        "searchcount",
        maxcount = 999,
        timeout = 120,
        separator = { left = "" },
      },
      {
        "branch",
        icon = " •",
        separator = { left = "" },
      },
    },
    lualine_z = {
      {
        "",
        draw_empty = true,
        separator = { left = "", right = "" },
      },
      {
        "progress",
        separator = { left = "" },
      },
      { "location" },
      {
        "fileformat",
        color = { fg = "black" },
        symbols = {
          unix = "",
          dos = "",
          mac = "",
        },
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {
    {
      filetypes = { "snacks_picker_list", "snacks_picker_input" },
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
