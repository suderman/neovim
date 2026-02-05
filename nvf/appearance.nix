{
  lib,
  pkgs,
  flake,
  ...
}: let
  inherit (lib) mkForce;
  inherit (flake.lib) lua;
in {
  vim.options.cursorlineopt = "line"; # line, screenline, number, both
  vim.options.breakindent = true; # indent wrapped lines to match line start
  vim.options.linebreak = true; # wrap long lines at 'breakat' (if 'wrap' is set)
  vim.options.number = true; # show line numbers
  vim.options.ruler = true; # show cursor position in command line
  vim.options.wrap = true; # display long lines as just one line
  vim.options.signcolumn = "yes"; # always show sign column (otherwise it will shift text)
  vim.options.fillchars = "eob: "; # don't show `~` outside of buffer
  vim.options.termguicolors = true; # enable gui colors

  vim.statusline.lualine.enable = true;
  vim.options.showmode = mkForce false; # show mode in command line

  # vim.mini.animate.enable = true;

  vim.theme.enable = true;
  vim.theme.transparent = true;

  vim.options.pumblend = 10; # make builtin completion menus slightly transparent
  vim.options.pumheight = 10; # make popup menu smaller
  vim.options.winblend = 10; # make floating windows slightly transparent

  vim.visuals.nvim-scrollbar.enable = true;
  vim.visuals.nvim-web-devicons.enable = true;
  vim.visuals.nvim-cursorline.enable = true;
  # vim.visuals.cinnamon-nvim.enable = true;
  vim.visuals.highlight-undo.enable = true;
  # vim.visuals.indent-blankline.enable = true;

  vim.ui.borders.enable = true;
  vim.ui.colorizer.enable = true;
  vim.ui.smartcolumn = {
    enable = true;
    setupOpts.custom_colorcolumn = {
      nix = "110";
      ruby = "120";
      java = "130";
      go = ["90" "130"];
    };
  };

  vim.utility.snacks-nvim.setupOpts.scroll = {
    enabled = true;
    animate.duration.step = 10;
    animate.duration.total = 200;
  };

  vim.utility.snacks-nvim.setupOpts.scope.enabled = true;
  vim.utility.snacks-nvim.setupOpts.dim = {
    enabled = true;
    animate.duration.step = 10;
    animate.duration.total = 200;
  };

  vim.utility.snacks-nvim.setupOpts.input.enabled = true;
  vim.utility.snacks-nvim.setupOpts.styles.input.keys = {
    i_esc =
      lua
      # lua
      "{ [2] = {'cmp_close', '<esc>'} }";
  };

  vim.utility.snacks-nvim.setupOpts.notifier = {
    enabled = true;
    level = "INFO";
    style = "minimal";
    top_down = false;
  };

  vim.visuals.fidget-nvim = {
    enable = true;
    # setupOpts.notification.window.winblend = 100;
    setupOpts.notification.window.winblend = 0;
    setupOpts.notification.window.border = "none";
  };

  vim.extraPlugins = {
    "transparent.nvim" = {
      package = pkgs.vimPlugins.transparent-nvim;
      setup =
        # lua
        ''
          require("transparent").setup({
          	extra_groups = {
          		"NormalFloat",
          	},
          })
        '';
    };
  };

  vim.globals.neovide_opacity = 0.8;

  vim.luaConfigRC.remote-tuning =
    # lua
    ''
      -- Remote (SSH) tuning
      -- Rationale: TUI redraws, transparency, animations, and inline images can feel
      -- extremely slow over SSH even on decent RTT due to many sequential frames.
      local is_ssh = (vim.env.SSH_CONNECTION ~= nil) or (vim.env.SSH_TTY ~= nil)

      if is_ssh then
        -- Reduce terminal blending (extra redraw cost on many terminals)
        pcall(function()
          vim.opt.winblend = 0
          vim.opt.pumblend = 0
        end)

        -- Disable/short-circuit Snacks UI features that emit lots of redraw work
        pcall(function()
          local snacks = require("snacks")
          snacks.setup({
            image = {
              enabled = false,
              inline = false,
              force = false,
            },
            scroll = {
              animate = { duration = { step = 0, total = 0 } },
            },
            dim = {
              animate = { duration = { step = 0, total = 0 } },
            },
          })
        end)
      end
    '';

  vim.luaConfigRC.neovide-scale =
    # lua
    ''
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
      end
    '';

  # vim.ui.noice.enable = true;
  # vim.ui.noice.setupOpts = {
  #   cmdline.view = "cmdline";
  # };
}
