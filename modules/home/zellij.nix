{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    plugins = with pkgs.zellijPlugins; [ vim-zellij-navigator ];
    settings = {
      theme = "gruvbox-dark";
      show_startup_tips = false;
      focus_follows_mouse = true;
      mouse_mode = true;

      default_mode = "normal";
      default_shell = "${pkgs.nushell}/bin/nu";

      # tmux-resurrect-like behavior
      session_serialization = true;
      pane_viewport_serialization = true;
      scrollback_lines_to_serialize = 10000;

      session_name = "main";
      attach_to_session = true;

      # Detach rather than kill the session on terminal close.
      on_force_close = "detach";

      # settings for zellij web, only used on homelab
      web_server_ip = "127.0.0.1";
      web_server_port = 8082;
      web_sharing = "on";

      keybinds = {
        _props.clear-defaults = true;

        # key binds for normal mode
        normal._children = [
          {
            bind = {
              _args = [
                "Ctrl Space"
              ];
              SwitchToMode = [ "Tmux" ];
            };
          }
          {
            bind = {
              _args = [
                "Ctrl c"
              ];
              Write = [ 3 ];
            };
          }
          {
            bind = {
              _args = [
                "Ctrl d"
              ];
              Write = [ 4 ];
            };
          }
        ];

        # key binds for tmux mode
        tmux._children = [
          {
            bind = {
              _args = [
                "Ctrl Space"
                "Esc"
              ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "Ctrl c"
              ];
              Write = [ 3 ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "Ctrl d"
              ];
              Write = [ 4 ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "\""
              ];
              NewPane = [ "Down" ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "%"
              ];
              NewPane = [ "Right" ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "c"
              ];
              NewTab = [ ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "x"
              ];
              CloseFocus = [ ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "X"
              ];
              CloseTab = [ ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "h"
                "Left"
              ];
              MoveFocus = [
                "Left"
              ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "j"
                "Down"
              ];
              MoveFocus = [
                "Down"
              ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "k"
                "Up"
              ];
              MoveFocus = [
                "Up"
              ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "l"
                "Right"
              ];
              MoveFocus = [
                "Right"
              ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "n"
              ];
              GoToNextTab = [ ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "p"
              ];
              GoToPreviousTab = [ ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "o"
              ];
              FocusNextPane = [ ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "1"
              ];
              GoToTab = [ 1 ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "2"
              ];
              GoToTab = [ 2 ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "3"
              ];
              GoToTab = [ 3 ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "4"
              ];
              GoToTab = [ 4 ];
              SwitchToMode = [ "Normal" ];
            };
          }
          {
            bind = {
              _args = [
                "5"
              ];
              GoToTab = [ 5 ];
              SwitchToMode = [ "Normal" ];
            };
          }
        ];
      };
    };
  };
}
