{ pkgs, ... }: 
{
  imports = [ ./home/nvim.nix ];
  
  home.stateVersion = "24.05";
}
