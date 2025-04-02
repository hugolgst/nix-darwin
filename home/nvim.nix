{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "macchiato";
    };

    plugins = {
      ts-autotag.enable = true;

      lualine = {
        enable = true;

        settings = {
          options = {
            theme = {
              normal = {
                a = {
                  fg = "#080808";
                  bg = "#d183e8";
                };
                b = {
                  fg = "#c6c6c6";
                  bg = "#303030";
                };
                c = { fg = "#c6c6c6"; };
              };
              insert = {
                a = {
                  fg = "#080808";
                  bg = "#80a0ff";
                };
              };
              visual = {
                a = {
                  fg = "#080808";
                  bg = "#79dac8";
                };
              };
              replace = {
                a = {
                  fg = "#080808";
                  bg = "#ff5189";
                };
              };
              inactive = {
                a = {
                  fg = "#c6c6c6";
                  bg = "#080808";
                };
                b = {
                  fg = "#c6c6c6";
                  bg = "#080808";
                };
                c = { fg = "#c6c6c6"; };
              };
            };
            component_separators = {
              left = "";
              right = "";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };

          sections = {
            lualine_a = [{
              __unkeyed-1 = "mode";
              separator = { left = ""; };
              padding = { right = 2; };
            }];
            lualine_b = [ "filename" "branch" ];
            lualine_c = [
              "%=" # Center aligned components placeholder
            ];
            lualine_x = [ ];
            lualine_y = [ "filetype" "progress" ];
            lualine_z = [{
              __unkeyed-1 = "location";
              separator = { right = ""; };
              padding = { left = 2; };
            }];
          };

          inactive_sections = {
            lualine_a = [ "filename" ];
            lualine_b = [ ];
            lualine_c = [ ];
            lualine_x = [ ];
            lualine_y = [ ];
            lualine_z = [ "location" ];
          };

          tabline = { };
          extensions = [ ];
        };
      };

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
