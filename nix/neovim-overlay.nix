# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
      doCheck = false;
    };

  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
      inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
    };

  # All plugins - from nixpkgs and external flake inputs
  all-plugins = with pkgs.vimPlugins; [
    # Treesitter and related
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring

    # Completion
    blink-cmp
    friendly-snippets

    # LSP and diagnostics
    nvim-lspconfig

    # UI and visuals
    lualine-nvim
    nvim-navic
    nvim-treesitter-context
    transparent-nvim
    fidget-nvim
    onedark-nvim
    render-markdown-nvim
    nvim-lightbulb
    nvim-scrollbar
    smartcolumn-nvim
    highlight-undo-nvim
    nvim-web-devicons

    # Git integration
    gitsigns-nvim
    diffview-nvim
    neogit
    vim-fugitive
    git-conflict-nvim

    # Picker/explorer
    oil-nvim
    plenary-nvim
    vim-tmux-navigator
    yazi-nvim

    # Quickfix
    quicker-nvim

    # Editing enhancements
    mini-nvim
    vim-unimpaired
    flash-nvim

    # Utility
    sqlite-lua
    which-key-nvim
    snacks-nvim
    conform-nvim

    # LSP helpers
    trouble-nvim
    nvim-lint
    (mkNvimPlugin inputs.nvim-docs-view "nvim-docs-view")
  ]
  ++ [
    # External flake-input plugins built via mkNvimPlugin
    (mkNvimPlugin inputs.opencode-nvim "opencode-nvim")
  ];

  # Runtime dependencies for tools used by plugins
  extraPackages = with pkgs; [
    # Language servers and tools
    lua-language-server
    nil
    nodejs
    python3
    uv
    opencode

    # Tools used by pickers and other plugins
    fd
    ripgrep
    git
    lazygit
    ghostscript
    imagemagick
    sqlite
    tectonic
    mermaid-cli
    yazi
    tree-sitter

    # Formatters/linters
    alejandra
    ruff
    stylua
    prettier
    prettierd
    gotools
    shfmt
    sqlfluff
    djlint
    gcc
    luaPackages.luacheck
    php83Packages.php-cs-fixer
    php83Packages.php-codesniffer
    phpstan

    # LSP servers
    basedpyright
    bash-language-server
    clang-tools
    gopls
    marksman
    phpactor
    rubyPackages.solargraph
    sqls
    superhtml
    tailwindcss-language-server
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    deadnix
    statix
    shellcheck
    rubocop
    eslint_d
    htmlhint
    markdownlint-cli2
    rust-analyzer
  ];
in {
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    withNodeJs = true;
    inherit extraPackages;
  };

  nvim-dev = mkNeovim {
    plugins = all-plugins;
    appName = "nvim-dev";
    wrapRc = false;
    inherit extraPackages;
  };

  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
