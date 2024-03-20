{ pkgs, ... }:
let 
    lazyVimConfig = pkgs.runCommand "lazyvim-config" {} ''
      mkdir -p $out
      cp -r ${pkgs.fetchFromGitHub {
        owner = "LazyVim";
        repo = "starter";
        rev = "741ff3aa70336abb6c76ee4c49815ae589a1b852";
        sha256 = "0dwvv0ffzrvyx5b60gjv038pp7q52l9si9v98l405afk0l9xch0j";
      }}/.* $out/
      rm -rf $out/.git
    '';
in
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      LazyVim
      neogit
      vim-nix
      vim-lsp
      vim-markdown
      editorconfig-vim
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          tree-sitter-markdown
          tree-sitter-nix
        ]
      ))
    ];
     
   
  };
}
