{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space"; # Bind prefix to Ctrl+Spacebar
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      resurrect
      better-mouse-mode
      gruvbox
      yank
    ];
    # add keyboard bindings for splitting horizontally and vertically
    # add extra blank space after host name in tmux status bar (better formatting)
    extraConfig = ''
      bind '"' split-window -v -c "#{pane_current_path}"
      bind '%' split-window -h -c "#{pane_current_path}"
      set -g status-right "#[bg=colour237,fg=colour239,nobold,nounderscore,noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h#[bg=colour248] "
    '';
  };
}
