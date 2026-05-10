# Build keymap attr and detect if action is lua
{lib, ...}: mode: key: action: desc: let
  inherit (lib) hasPrefix match stringLength;
in {
  inherit mode key action desc;
  noremap = true;
  silent = true;
  lua =
    if hasPrefix "function(" action
    then true
    else if match "^[A-Z]" action != null
    then true
    else
      !(hasPrefix ":" action
        || hasPrefix "<" action
        || stringLength action < 10);
}
