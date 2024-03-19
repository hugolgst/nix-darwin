{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    # Specify your Neovim plugins here
    plugins = with pkgs; [
      vimPlugins.LazyVim
      # Add more plugins as needed
    ];
    # You can also set Neovim configurations here, such as custom settings or key mappings
  };
}
