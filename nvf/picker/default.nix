{
  pkgs,
  flake,
  ...
}: let
  inherit (flake.lib) ls nmap lua luaCall;

  # win = {
  #   list = {
  #     ["l"] = "confirm",
  #     ["h"] = "close",
  #   }
  picker = source: focus: ''
    function(picker)
      picker:close()
      Snacks.picker.pick {
        source = "${source}",
        focus = "${focus}",
      }
    end
  '';
in {
  imports = ls ./.;

  vim.utility.snacks-nvim.enable = true;
  vim.utility.snacks-nvim.setupOpts.styles.notification.wo.wrap = true;

  vim.utility.snacks-nvim.setupOpts.picker = {
    enabled = true;
    layout.cycle = true;
    focus = "list"; # input
    win.input.keys."s" = {
      "@1" = "flash";
      "mode" = ["n"];
    };
    win.input.keys."<c-s>" = {
      "@1" = "flash";
      "mode" = ["i"];
    };
    win.input.keys."h" = "close";
    win.list.keys."h" = "close";
    win.input.keys."l" = "confirm";
    win.list.keys."l" = "confirm";

    actions.explorer = lua (picker "explorer" "list");
    actions.files = lua (picker "files" "input");
    actions.quickfix = lua (picker "qflist" "list");
    actions.buffers = lua (picker "buffers" "list");
    actions.grep = lua (picker "grep" "input");
    actions.notifications = lua (picker "notifications" "list");
    actions.commands = lua (picker "commands" "input");
    actions.command_history = lua (picker "command_history" "list");
    actions.keymaps = lua (picker "keymaps" "input");
    actions.undo = lua (picker "undo" "list");
    actions.jumps = lua (picker "jumps" "list");
    actions.marks = lua (picker "marks" "list");
    actions.diagnostics = lua (picker "diagnostics" "list");
    actions.diagnostics_buffer = lua (picker "diagnostics_buffer" "list");
    actions.pickers = lua "function() Snacks.picker {} end ";
    actions.flash =
      lua
      # lua
      ''
         function(picker)
           require("flash").jump({
             pattern = "^",
             label = { after = { 0, 0 } },
             search = {
               mode = "search",
               exclude = {
                 function(win)
                   return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                end,
               },
             },
             action = function(match)
               local idx = picker.list:row2idx(match.pos[1])
               picker.list:_move(idx, true, true)
            end,
           })
        end
      '';
  };

  vim.keymaps = [
    (nmap "<space>" (luaCall "Snacks.picker.pick" {
      source = "smart";
      focus = "input"; # list
      win.list.keys."p" = "pickers";
      win.input.keys."p" = "pickers";
      win.list.keys."e" = "explorer";
      win.input.keys."e" = "explorer";
      win.list.keys."g" = "grep";
      win.input.keys."g" = "grep";
      win.list.keys."n" = "notifications";
      win.input.keys."n" = "notifications";
      win.list.keys.":" = "commands";
      win.input.keys.":" = "commands";
      win.list.keys.";" = "command_history";
      win.input.keys.";" = "command_history";
      win.list.keys."f" = "files";
      win.input.keys."f" = "files";
      win.list.keys."F" = "quickfix";
      win.input.keys."F" = "quickfix";
      win.list.keys."b" = "buffers";
      win.input.keys."b" = "buffers";
      win.list.keys."K" = "keymaps";
      win.input.keys."K" = "keymaps";
      win.list.keys."J" = "jumps";
      win.input.keys."J" = "jumps";
      win.list.keys."u" = "undo";
      win.input.keys."u" = "undo";
      win.list.keys."m" = "marks";
      win.input.keys."m" = "marks";
      win.list.keys."d" = "diagnostics_buffer";
      win.input.keys."d" = "diagnostics_buffer";
      win.list.keys."D" = "diagnostics";
      win.input.keys."D" = "diagnostics";
    }) "Smart Find Files")
  ];

  vim.extraPackages = with pkgs; [
    fd
    ghostscript
    git
    imagemagick
    lazygit
    mermaid-cli
    ripgrep
    sqlite
    tectonic
  ];
}
