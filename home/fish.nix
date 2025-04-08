{ pkgs, ... }: {
  programs.fish = let flakePath = "~/.config/nix-darwin";
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

      # Disable git push --force
      function git
        set args $argv
        if test "$args[1]" = push; and contains -- "--force" $args || contains -- "--force-with-lease" $args
          echo "🚫 Warning: force pushes are disabled! Command aborted."
          echo "Run git pushf instead"
          return 1
        else
          command git $args
        end
      end
    '';

    plugins = [
      # Default oh-my-fish theme
      {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "e3b4d4eafc23516e35f162686f08a42edf844e40";
          sha256 = "sha256-cXOYvdn74H4rkMWSC7G6bT4wa9d3/3vRnKed2ixRnuA=";
        };
      }
    ];
  };
}
