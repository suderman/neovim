{flake, ...}: let
  inherit (flake.lib) nmap lua luaCall;
in {
  vim = {
    utility.snacks-nvim.setupOpts.picker.sources.explorer = {
      enabled = true;
      replace_netrw = true;
      finder = "explorer";
      layout.hidden = ["input" "preview"];
      win.list.keys = {
        "<Esc>" = {
          "@1" = "false";
          "mode" = ["n" "x"];
        };
      };
      win.input.keys = {
        "<Esc>" = {
          "@1" = "false";
          "mode" = ["n" "x"];
        };
      };
    };

    keymaps = [
      (nmap "-" "<cmd>Oil<cr>" "Oil")
      (nmap "<leader>e" (luaCall "Snacks.explorer" {}) "File Explorer")
      (nmap "H" (luaCall "Snacks.explorer" {}) "File Explorer")
      (nmap "\\]" (luaCall "Snacks.explorer" {}) "File Explorer")
      (nmap "\\=" (luaCall "Snacks.explorer" {}) "File Explorer")
    ];

    # Image previews
    utility.snacks-nvim.setupOpts.image = {
      enabled = true;
      force = true;
      inline = true;
    };

    # https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md
    utility.snacks-nvim.setupOpts.bigfile.enable = true;

    # Edit directories like a buffer
    utility.oil-nvim.enable = true;
    utility.oil-nvim.setupOpts = {
      default_file_explorer = false;
      delete_to_trash = true;
      columns = ["icon" "permissions" "size" "mtime"];
      skip_confirm_for_simple_edits = true;
      view_options = {
        show_hidden = true;
        natural_order = true;
        is_always_hidden =
          lua
          # lua
          ''
            function(name, _)
              return name == '..' or name == '.git'
            end
          '';
      };
      win_options.wrap = true;
    };

    # https://github.com/keonly/nvf-config/blob/af0cabe84288798f018c70d411a23a0ebc9a2932/config/plugins/utility/yazi-nvim.nix
    utility.yazi-nvim = {
      enable = true;

      mappings = {
        openYazi = "<leader>y";
        openYaziDir = "<leader>cw";
        yaziToggle = "<C-y>";
      };

      setupOpts = {
        open_for_directories = false;
      };
    };
  };
}
