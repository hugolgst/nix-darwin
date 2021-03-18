{ pkgs, ... }: {
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        vim-airline
        nerdtree
        gruvbox
        vim-go
        coc-go
        coc-nvim
        vim-gitgutter
      ];

      extraConfig = ''
        set clipboard=unnamedplus
        set nobackup
        set noswapfile
        " Set the line numbers to non relative
        set number relativenumber
        set nornu
        " Allow the mouse usage
        set mouse=a
        " Set the tab, trail, extends and precedes characters
        set listchars=tab:\|\ \,trail:~,extends:>,precedes:<
        set list
        " Set default splitting methods
        set splitbelow
        set splitright
        set autoindent
        set autoread
        nnoremap d "_d
        vnoremap d "_d
        " Set the colorscheme
        colorscheme gruvbox
        set bg=dark
        hi Normal guibg=NONE ctermbg=NONE
        " Set the airline configuration
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#formatter = 'unique_tail'
        let g:airline_left_sep = ''
        let g:airline_left_alt_sep = ''
        let g:airline_right_sep = ''
        let g:airline_right_alt_sep = ''
        " Set NERDTreeToggle to F3 and auto toogle NERDTree
        au VimEnter *  NERDTree
        nnoremap <F3> :NERDTreeToggle<CR>
        let g:NERDTreeWinPos = "right"
        nnoremap <F2> :12split term://fish<CR>
        " Nix formatter
        autocmd BufWritePost *.nix :silent! !nixfmt <afile>
        au filetype go inoremap <buffer> . .<C-x><C-o>
        let g:go_fmt_command = "goimports"
        " Set tab sizes
        set noexpandtab
        set shiftwidth=2
        set softtabstop=2
        set tabstop=2
        " Auto completing quotes etc..
        inoremap ( ()<Esc>i
        inoremap { {}<Esc>i
        inoremap {<CR> {<CR>}<Esc>O
        inoremap [ []<Esc>i
        inoremap \' \'\'<Esc>i
        inoremap " ""<Esc>i
      '';
    };
}