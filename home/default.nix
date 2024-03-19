{ pkgs, ... }: 
{
  imports = [ ./nvim.nix ];
  
  home.stateVersion = "24.05";
}
