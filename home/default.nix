{ pkgs, ... }: 
{
  imports = [ 
    ./nvim.nix
  ];
  
  home.stateVersion = "23.11";
}
