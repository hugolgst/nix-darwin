{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    #viAlias = true;
    #vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      LazyVim
      #catppuccin-nvim
      #gruvbox-nvim
    ];

  };
}
