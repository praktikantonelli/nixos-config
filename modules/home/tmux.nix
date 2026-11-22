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
    # add keyboard bindings for splitting horizontally and vertically in same working directory
    # add extra blank space after host name in tmux status bar (better formatting)
    extraConfig = ''
      bind '"' run-shell 'tmux split-window -v -t "#{pane_id}" -c "$(readlink /proc/#{pane_pid}/cwd)"'
      bind '%' run-shell 'tmux split-window -h -t "#{pane_id}" -c "$(readlink /proc/#{pane_pid}/cwd)"'
      bind c run-shell 'tmux new-window -t "#{session_name}" -c "$(readlink /proc/#{pane_pid}/cwd)"'
      set -g status-right "#[bg=colour237,fg=colour239,nobold,nounderscore,noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h#[bg=colour248] "
    '';
  };
}
