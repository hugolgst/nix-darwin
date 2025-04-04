let
  username = "hugolgst";
  home = "/Users/${username}";
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
        ./nvim
        ./fish.nix
        nixvim.homeManagerModules.nixvim
        ./iterm2.nix
      ];

      home = {
        inherit username;
        homeDirectory = builtins.toPath home;
        stateVersion = "24.11";
      };
    };
  };
}
