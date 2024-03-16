{
  description = "hugolgst/nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    hostname = "Hugo-Work-Macbook-Pro";
    username = "hugolageneste";
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [ 
        git
        neofetch
        vscode
        nixfmt
        nixpkgs-review
        coreutils
        gnupg
        nodejs  
        iterm2
        neovim
        vimPlugins.LazyVim
        oh-my-fish
      ];

      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      services.nix-daemon.enable = true;

      # Set fish as default shell
      programs.fish.enable = true;
      users.users."${username}" = {
        inherit home;
        shell = pkgs.fish;
      };
      programs.fish.shellAliases = {
        ss = "open -b com.apple.ScreenSaver.Engine";
      };
      system.activationScripts.postActivation.text = ''
        # Set the default shell as fish for the user
        sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish ${username}
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
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
  };
}
