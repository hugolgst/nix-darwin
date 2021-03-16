{ config, pkgs, lib, ... }:

{
  imports = [ ./modules/pam.nix ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    git
    neofetch
    vscode
    nixfmt
    nixpkgs-review
    coreutils
    gnupg
    iTerm2
  ];

  nixpkgs = {
    config = {
      allowUnsupportedSystem = true;
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
