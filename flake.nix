{
  description = "hugolgst/nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim }:
    let
      hostname = "Hugos-MacBook-Air-2";

      configuration = { pkgs, lib, ... }: {
        environment.systemPackages = with pkgs; [
          # Utils
          git
          coreutils
          gnupg
          jq
          nerdfonts
          fzf
          ripgrep

          # Gadgets
          neofetch
          pfetch-rs

          iterm2
          oh-my-fish

          # Nix stuff
          nixfmt-classic
          nixpkgs-review

          nodejs_20
        ];

        nixpkgs = { config = { allowUnfree = true; }; };
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        services.nix-daemon.enable = true;

        programs.fish.enable = true;
        users.users = (import ./home).user { inherit pkgs; };

        # Enable sudo login with Touch ID
        security.pam.enableSudoTouchIdAuth = true;

        # MacOS system defaults
        system.defaults = {
          finder.AppleShowAllExtensions = true;
          screensaver.askForPassword = true;
          NSGlobalDomain."com.apple.swipescrolldirection" = false;
        };

        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users =
              (import ./home).home-manager { inherit nixvim; };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
    };
}
