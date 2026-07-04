{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      # LazyVim
      lua-language-server
      stylua
      # Telescope
      ripgrep
      # C compiler for treesitter
      gcc
      # prevents Mason from installing it in a non-working way
      tree-sitter
      # required for Mason
      unzip
      nodejs
      # required for nix
      statix
      nil

    ];
    # needed because of backwards compatibility
    withRuby = false;
    withPython3 = false;

    sideloadInitLua = true;

  };
}
