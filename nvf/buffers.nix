{flake, ...}: let
  inherit (flake.lib) nmap luaCall;

  bufferList = luaCall "Snacks.picker.pick" {
    source = "buffers";
    focus = "list";
    auto_close = true;
    jump.close = false;
    layout = {
      preset = "dropdown";
      preview = false;
    };
    win.list.keys = {
      "l" = "confirm";
      "h" = "close";
      "K" = "close";
      "<Space>" = "close";
      "dd" = "bufdelete";
    };
  };
in {
  vim.utility.snacks-nvim.setupOpts.picker.enabled = true;
  vim.keymaps = [
    (nmap "K" bufferList "Buffers")
    (nmap "\\\\" "<C-^>" "Last Buffer")
  ];
}
