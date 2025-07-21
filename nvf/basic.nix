{...}: {
  vim.viAlias = true; # Enables the alias 'vi' for Neovim command
  vim.vimAlias = true; # Enables the alias 'vim' for Neovim command
  vim.enableLuaLoader = true; # Enables Lua loader for improved performance/loading
  vim.globals.mapleader = "\\"; # Sets the default <leader> key to '\'
  vim.globals.maplocalleader = ","; # Sets <localleader> key to ','
  vim.options.mouse = "nvi"; # Enables mouse in normal, visual, and insert modes
}
