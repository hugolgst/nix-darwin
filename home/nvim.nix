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

      # Lualine: Status line plugin for enhanced visual information
      lualine = {
        enable = true;

        settings = {
          options = {
            # Theme configuration for lualine
            # These settings define colors for different vim modes
            theme = {
              normal = {
                a = {
                  fg = "#080808"; # Almost black foreground
                  bg = "#d183e8"; # Purple background
                };
                b = {
                  fg = "#c6c6c6"; # Light gray foreground
                  bg = "#303030"; # Dark gray background
                };
                c = {
                  fg = "#c6c6c6";
                }; # Light gray foreground, transparent background
              };

              insert = {
                a = {
                  fg = "#080808"; # Almost black foreground
                  bg = "#80a0ff"; # Blue background for insert mode
                };
              };

              visual = {
                a = {
                  fg = "#080808"; # Almost black foreground
                  bg = "#79dac8"; # Cyan background for visual mode
                };
              };

              replace = {
                a = {
                  fg = "#080808"; # Almost black foreground
                  bg = "#ff5189"; # Pink background for replace mode
                };
              };

              inactive = {
                a = {
                  fg = "#c6c6c6"; # Light gray foreground
                  bg = "#080808"; # Almost black background for inactive windows
                };
                b = {
                  fg = "#c6c6c6"; # Light gray foreground
                  bg = "#080808"; # Almost black background
                };
                c = {
                  fg = "#c6c6c6";
                }; # Light gray foreground, transparent background
              };
            };

            # Remove default component separators
            component_separators = {
              left = "";
              right = "";
            };

            # Remove default section separators
            section_separators = {
              left = "";
              right = "";
            };
          };

          # Configure statusline sections
          sections = {
            # Left side of the statusline
            lualine_a = [{
              __unkeyed-1 =
                "mode"; # Display current mode (NORMAL, INSERT, etc.)
              separator = { left = ""; }; # No left separator
              padding = { right = 2; }; # Add padding on the right
            }];
            lualine_b = [ "filename" "branch" ]; # Show filename and git branch
            lualine_c = [
              "%=" # Center aligned components placeholder
            ];
            lualine_x = [ ]; # Empty section
            lualine_y =
              [ "filetype" "progress" ]; # Show filetype and progress percentage

            # Right side of the statusline
            lualine_z = [{
              __unkeyed-1 = "location"; # Show cursor position
              separator = { right = ""; }; # No right separator
              padding = { left = 2; }; # Add padding on the left
            }];
          };

          # Configure inactive window statusline
          inactive_sections = {
            lualine_a = [ "filename" ]; # Show only filename
            lualine_b = [ ];
            lualine_c = [ ];
            lualine_x = [ ];
            lualine_y = [ ];
            lualine_z = [ "location" ]; # Show cursor position
          };

          tabline = { }; # No custom tabline
          extensions = [ ]; # No extensions
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
