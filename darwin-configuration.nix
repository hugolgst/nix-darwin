{ config, pkgs, lib, ... }:

let 
  username = "hugolageneste";
  home = "/Users/${username}";
in
{
  imports = [ <home-manager/nix-darwin> ./modules/pam.nix ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Programming
    git
    neofetch
    vscode
    nixfmt
    nixpkgs-review
    coreutils
    gnupg
    nodejs

    # Desktop apps
    iTerm2
    figma
  ];

  nixpkgs = {
    config = {
      allowUnsupportedSystem = false;
      allowUnfree = true;
    };

    overlays = [ (import ./overlays/apps.nix) ];
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];

  # Enable sudo login with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  # MacOS system defaults
  system.defaults = { finder.AppleShowAllExtensions = true; };

  # Set the default shell for user
  users.users."${username}" = {
    inherit home;
    shell = pkgs.fish;
  };

  # The home-manager configuration for the user
  home-manager.useUserPackages = true;
  home-manager.users."${username}" = import ./home;

  system.activationScripts.postActivation.text = ''
    # Set the default shell as fish for the user
    sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish ${username}
  '';

  programs.fish.shellAliases = {
    ss = "open -b com.apple.ScreenSaver.Engine";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
