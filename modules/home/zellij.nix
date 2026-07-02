{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    plugins = with pkgs.zellijPlugins; [ vim-zellij-navigator ];
    settings = { theme = "gruvbox-dark"; };
  };
}
