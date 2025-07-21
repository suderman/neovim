{...}: {
  vim.viAlias = true;
  vim.vimAlias = true;
  vim.enableLuaLoader = true;
  vim.globals.mapleader = "\\"; # default leader is \
  vim.globals.maplocalleader = ","; # localleader is ,
  vim.options.mouse = "nvi"; # normal, visual, insert, commandline, help, all, r
}
