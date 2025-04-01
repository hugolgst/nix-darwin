{ ... }: {
  imports = [ ./nvim ./fish.nix ];

  home = {
    username = "hugolgst";
    homeDirectory = builtins.toPath "/Users/hugolgst";
    stateVersion = "24.11";
  };
}
