{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
     
    extraLuaConfig = builtins.readFile ./config.lua;
  };
}
