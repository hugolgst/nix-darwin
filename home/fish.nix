{ pkgs, ... }: {
  programs.fish = let
    username = "hugolgst";
    home = "/Users/${username}";
    flakePath = "${home}/.config/nix-darwin";
  in {
    enable = true;
    preferAbbrs = true;

    shellAliases = {
      nce = "nvim ${flakePath}/flake.nix";
      ncu =
        "nix flake update --flake ${flakePath}; darwin-rebuild switch --flake ${flakePath}";
      ncp = ''
        cd ${flakePath}; git add -A; git commit -m "Update nixpkgs to $(jq -r '.nodes.nixpkgs.locked.rev' ${flakePath}/flake.lock)"; git push'';
      ss = "open -b com.apple.ScreenSaver.Engine";
      n = "nvim .";
    };

    loginShellInit = ''
      pfetch
    '';

    # plugins = [{
    #   name = "bobthefish";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "oh-my-fish";
    #     repo = "theme-bobthefish";
    #     rev = "e3b4d4eafc23516e35f162686f08a42edf844e40";
    #     sha256 = "06v37hqy5yrv5a6ssd1p3cjd9y3hnp19d3ab7dag56fs1qmgyhbs";
    #   };
    # }];
  };
}
