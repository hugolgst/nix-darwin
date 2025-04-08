{ pkgs, ... }: {
  programs.git = let
    vars = import ../variables.nix;
    fullName = vars.fullName;
    email = vars.email;
  in {
    enable = true;

    userEmail = email;
    userName = fullName;

    diff-highlight.enable = true;
    maintenance.enable = true;

    aliases = {
      pushf = "!echo '$ git fetch origin' && git fetch origin"
        + "&& echo '$ git push --force-with-lease' && git push --force-with-lease";
      staash = "stash --all";
    };

    extraConfig = {
      column.ui = "auto";
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
  };
}
