{ pkgs, ... }: {

  # Enable NixVim, a Nix-based Neovim configuration system
  programs.nixvim = {
    enable = true;

    # Set Catppuccin as the colorscheme with macchiato flavor
    # Catppuccin is a soothing pastel theme for development environments
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "macchiato"; # Other options: latte, frappe, mocha
    };

    # extraPlugins = [
    #   (pkgs.vimUtils.buildVimPlugin {
    #     name = "LazyVim";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "LazyVim";
    #       repo = "LazyVim";
    #       rev = "ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd";
    #       hash = "sha256-lwT39h97ZyF/SFJhkOqZ2vU5f3QpCpe7L1MVDPEXN28=";
    #     };
    #   })
    # ];

    plugins = {
      # Auto-close HTML/JSX tags
      ts-autotag.enable = true;

      # Enable Nerd Font icons
      web-devicons.enable = true;

      # Neo-tree: File explorer plugin, a modern replacement for NERDTree
      neo-tree = {
        enable = true;

        # Configure which sources to show in Neo-tree
        # filesystem: File explorer
        # buffers: Open buffers list
        # git_status: Git status view
        sources = [ "filesystem" "buffers" "git_status" ];

        # Filesystem source configuration
        filesystem = {
          bindToCwd =
            false; # Don't always use the current working directory as root
          followCurrentFile = {
            enabled = true;
          }; # Automatically highlight current file
          useLibuvFileWatcher =
            true; # Use libuv's filesystem watcher for auto-refresh
        };

        # Window configuration for Neo-tree
        window = {
          position = "right"; # Display Neo-tree on the right side of the screen

          # Key mappings for Neo-tree
          mappings = {
            l =
              "open"; # Use 'l' to open files/directories (Vim-like navigation)
            h = "close_node"; # Use 'h' to close nodes (Vim-like navigation)
            "<space>" = "none"; # Disable space key binding

            # Custom mapping to copy the path to clipboard
            Y = {
              __raw = ''
                function(state)
                  local node = state.tree:get_node()
                  local path = node:get_id()
                  vim.fn.setreg("+", path, "c")
                end
              '';
              desc = "Copy Path to Clipboard";
            };

            # Custom mapping to open file with system default application
            O = {
              __raw = ''
                function(state)
                  require("lazy.util").open(state.tree:get_node().path, { system = true })
                end
              '';
              desc = "Open with System Application";
            };

            # Configure preview toggle
            P = {
              command = "toggle_preview";
              config = {
                use_float = false;
              }; # Use split window instead of floating window
            };
          };
        };

        # Configure default components appearance
        defaultComponentConfigs = {
          # Indentation settings
          indent = {
            withExpanders = true; # Show expander icons for directories
            expanderCollapsed = ""; # Icon for collapsed directories
            expanderExpanded = ""; # Icon for expanded directories
            expanderHighlight =
              "NeoTreeExpander"; # Highlight group for expanders
          };

          # Git status icons
          gitStatus = {
            symbols = {
              unstaged = "󰄱"; # Icon for unstaged changes
              staged = "󰱒"; # Icon for staged changes
            };
          };
        };
      };

      telescope = {
        enable = true;
        highlightTheme = "Catppuccin Macchiato";
        extensions = {
          fzf-native.enable = true;
          ui-select = {
            enable = true;
            settings = {
              __unkeyed-1.__raw =
                ''require("telescope.themes").get_dropdown{}'';
              specific_opts = { codeactions = true; };
            };
          };
        };

        settings.defaults = {
          prompt_prefix = "   ";
          color_devicons = true;
          set_env.COLORTERM = "truecolor";
          file_ignore_patterns = [
            "^.git/"
            "^.mypy_cache/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "%.ipynb"
          ];

          mappings = {
            i = {
              # Have Telescope not to enter a normal-like mode when hitting escape (and instead exiting), you can map <Esc> to do so via:
              "<esc>".__raw = ''
                function(...)
                  return require("telescope.actions").close(...)
                end'';
              "<c-t>".__raw = ''
                function(...)
                  require('trouble.providers.telescope').open_with_trouble(...);
                end
              '';
            };
            n = {
              "<c-t>".__raw = ''
                function(...)
                  require('trouble.providers.telescope').open_with_trouble(...);
                end
              '';
            };
          };
          # trim leading whitespace from grep
          vimgrep_arguments = [
            "${pkgs.ripgrep}/bin/rg"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
            "--trim"
          ];
        };
        keymaps = {
          "<leader>ft" = {
            action = "todo-comments";
            options.desc = "View Todo";
          };
          "<leader><space>" = {
            action = "find_files hidden=true";
            options.desc = "Find project files";
          };
          "<leader>/" = {
            action = "live_grep";
            options.desc = "Grep (root dir)";
          };
          "<leader>f:" = {
            action = "command_history";
            options.desc = "View Command History";
          };
          "<leader>fr" = {
            action = "oldfiles";
            options.desc = "View Recent files";
          };
          "<c-p>" = {
            mode = [ "n" "i" ];
            action = "registers";
            options.desc = "Select register to paste";
          };
          "<leader>gc" = {
            action = "git_commits";
            options.desc = "commits";
          };
          "<leader>fa" = {
            action = "autocommands";
            options.desc = "Auto Commands";
          };
          "<leader>fc" = {
            action = "commands";
            options.desc = "View Commands";
          };
          "<leader>fd" = {
            action = "diagnostics bufnr=0";
            options.desc = "View Workspace diagnostics";
          };
          "<leader>fh" = {
            action = "help_tags";
            options.desc = "View Help pages";
          };
          "<leader>fk" = {
            action = "keymaps";
            options.desc = "View Key maps";
          };
          "<leader>fm" = {
            action = "man_pages";
            options.desc = "View Man pages";
          };
          "<leader>f'" = {
            action = "marks";
            options.desc = "View Marks";
          };
          "<leader>fo" = {
            action = "vim_options";
            options.desc = "View Options";
          };
          "<leader>uC" = {
            action = "colorscheme";
            options.desc = "Colorscheme preview";
          };
        };
      };

      # Lualine: Status line plugin for enhanced visual information
      lualine = {
        enable = true;
        settings = {
          options = {
            theme.__raw = let
              blue = "#80a0ff";
              cyan = "#79dac8";
              black = "#080808";
              white = "#c6c6c6";
              red = "#ff5189";
              violet = "#d183e8";
              grey = "#303030";
            in ''
              {
                normal = {
                  a = { fg = "${black}", bg = "${violet}" },
                  b = { fg = "${white}", bg = "${grey}" },
                  c = { fg = "${white}" },
                },
                insert = { a = { fg = "${black}", bg = "${blue}" } },
                visual = { a = { fg = "${black}", bg = "${cyan}" } },
                replace = { a = { fg = "${black}", bg = "${red}" } },
                inactive = {
                  a = { fg = "${white}", bg = "${black}" },
                  b = { fg = "${white}", bg = "${black}" },
                  c = { fg = "${white}" },
                },
              }
            '';
            component_separators = "";
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
            lualine_c = [{ __unkeyed-1.__raw = "function() return '%=' end"; }];
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

      # Treesitter: Advanced syntax highlighting and code navigation
      treesitter = {
        enable = true;

        settings = {
          highlight.enable = true; # Enable syntax highlighting
          indent.enable = true; # Enable indentation based on syntax

          # List of language grammars to install
          # This provides proper syntax highlighting and parsing for these languages
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

      # Treesitter textobjects: Enhanced text objects based on syntax tree
      # Allows selecting and operating on syntax-aware regions of code
      treesitter-textobjects = { enable = true; };
    };
  };
}
