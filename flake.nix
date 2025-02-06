{
  description = "hugolgst/nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      hostname = "Hugos-MacBook-Air";
      username = "hugolgst";
      home = "/Users/${username}";
      flakePath = "${home}/.config/nix-darwin";

      configuration = { pkgs, lib, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          # Utils
          git
          coreutils
          gnupg
          jq
          nerdfonts

          # Gadgets
          neofetch
          pfetch-rs

          vscode
          iterm2
          oh-my-fish

          # Nix stuff
          nixfmt
          nixpkgs-review

          nodejs_20
        ];

        nixpkgs = { config = { allowUnfree = true; }; };
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        services.nix-daemon.enable = true;

        # Set fish as default shell
        programs.fish = {
          enable = true;
          shellAliases = {
            nce = "nvim ${flakePath}/flake.nix";
            ncu =
              "nix flake update ${flakePath}; darwin-rebuild switch --flake ${flakePath}";
            ncp = ''
              cd ${flakePath}; git add -A; git commit -m "Update nixpkgs to $(jq -r '.nodes.nixpkgs.locked.rev' ${flakePath}/flake.lock)"; git push'';
            ss = "open -b com.apple.ScreenSaver.Engine";
            n = "nvim .";
          };

          loginShellInit = ''
            pfetch
          '';
        };
        users.users."${username}" = {
          shell = pkgs.fish;
          inherit home;
        };
        system.activationScripts.postActivation.text = ''
          # Set the default shell as fish for the user
          sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish ${username}

          sourcePath="${flakePath}/config/iterm2.json"
          destinationPath="${home}/Library/Application Support/iTerm2/DynamicProfiles/iterm2.json"
          if [ ! -f "$destinationPath" ]; then
              cp "$sourcePath" "$destinationPath"
          fi
        '';
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
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home;
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
    };
}
