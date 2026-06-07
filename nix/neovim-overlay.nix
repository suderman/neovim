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

  treesitterPlugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    nvim-treesitter-context
  ];

  completionPlugins = with pkgs.vimPlugins; [
    blink-cmp
    friendly-snippets
  ];

  lspPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    trouble-nvim
    nvim-lint
    (mkNvimPlugin inputs.nvim-docs-view "nvim-docs-view")
  ];

  uiPlugins = with pkgs.vimPlugins; [
    lualine-nvim
    transparent-nvim
    fidget-nvim
    onedark-nvim
    render-markdown-nvim
    nvim-lightbulb
    nvim-scrollbar
    highlight-undo-nvim
    nvim-web-devicons
    which-key-nvim
  ];

  gitPlugins = with pkgs.vimPlugins; [
    gitsigns-nvim
    diffview-nvim
    neogit
    vim-fugitive
    git-conflict-nvim
  ];

  pickerPlugins = with pkgs.vimPlugins; [
    snacks-nvim
    oil-nvim
    plenary-nvim
    vim-tmux-navigator
    yazi-nvim
    flash-nvim
  ];

  editingPlugins = with pkgs.vimPlugins; [
    quicker-nvim
    mini-nvim
    vim-unimpaired
    conform-nvim
  ];

  utilityPlugins = with pkgs.vimPlugins; [
    sqlite-lua
  ];

  externalPlugins = [
    (mkNvimPlugin inputs.opencode-nvim "opencode-nvim")
  ];

  all-plugins =
    treesitterPlugins
    ++ completionPlugins
    ++ lspPlugins
    ++ uiPlugins
    ++ gitPlugins
    ++ pickerPlugins
    ++ editingPlugins
    ++ utilityPlugins
    ++ externalPlugins;

  cliTools = with pkgs; [
    nodejs
    python3
    uv
    opencode
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
  ];

  formatAndLintTools = with pkgs; [
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
    deadnix
    statix
    shellcheck
    rubocop
    eslint_d
    htmlhint
    markdownlint-cli2
  ];

  lspServers = with pkgs; [
    lua-language-server
    nil
    basedpyright
    bash-language-server
    clang-tools
    gopls
    marksman
    phpactor
    rubyPackages.solargraph
    sqls
    tailwindcss-language-server
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    rust-analyzer
  ];

  extraPackages = cliTools ++ formatAndLintTools ++ lspServers;
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
