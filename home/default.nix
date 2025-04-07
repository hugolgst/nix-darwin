let
  vars = import ../variables.nix;
  username = vars.username;
  home = vars.home;
in {
  # System user configuration (for darwin's `users.users`)
  user = { pkgs, ... }: {
    ${username} = {
      name = username;
      shell = pkgs.fish;
      inherit home;
    };
  };

  # Home Manager configuration
  home-manager = { nixvim }: {
    ${username} = { pkgs, lib, ... }: {
      imports = [
        ./modules/iterm2.nix
        # ./experimental-nvim.nix
        ./nvim
        ./fish.nix
        nixvim.homeManagerModules.nixvim
        ./iterm2.nix
      ];

      fonts.fontconfig.enable = true;
      home = {
        inherit username;
        homeDirectory = builtins.toPath home;

        packages = [ (import ./geistmono.nix { inherit pkgs; }) ];

        stateVersion = "24.11";
      };
    };
  };
}
