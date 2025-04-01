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
  home-manager.${username} = { pkgs, ... }: {
    imports = [ ./nvim ./fish.nix ];

    home = {
      inherit username;
      homeDirectory = builtins.toPath home;
      stateVersion = "24.11";
    };
  };
}
