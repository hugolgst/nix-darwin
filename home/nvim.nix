{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "macchiato";
    };

    plugins = {
      ts-autotag.enable = true;

      treesitter = {
        enable = true;

        settings = {
          highlight.enable = true;
          indent.enable = true;

          # List of grammars to install
          ensureInstalled = [
            "bash"
            "c"
            "diff"
            "html"
            "javascript"
            "jsdoc"
            "json"
            "jsonc"
            "lua"
            "luadoc"
            "luap"
            "markdown"
            "markdown_inline"
            "printf"
            "python"
            "query"
            "regex"
            "toml"
            "tsx"
            "typescript"
            "vim"
            "vimdoc"
            "xml"
            "yaml"
          ];
        };
      };

      # Enable Treesitter textobjects plugin
      treesitter-textobjects = { enable = true; };
    };
  };
}
