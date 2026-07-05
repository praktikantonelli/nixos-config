{ pkgs, ... }: {
  programs.hyprland.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --config /etc/greetd/sway-config";
      };
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs.regreet = {
    enable = true;

    cageArgs = [
      "-s"
      "-d"
      "-mlast"
    ];
    settings = {
      skip_selection = true;
      background = {
        path = "${./../../wallpapers/lock-screen.png}";
        fit = "Cover"; # Fill, Contain, Cover, ScaleDown
      };

      GTK = {
        application_prefer_dark_theme = true;
      };

      appearance = {
        greeting_msg = "Welcome back";
      };

      widget = {
        clock = {
          format = "%a %d %b  %H:%M";
          resolution = "500ms";
        };
      };
    };

    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };

    font = {
      name = "SN Pro";
      size = 11;
    };

    extraCss = ''
      window {
        background-color: rgba(0, 0, 0, 0.20);
      }

      box {
        border-radius: 16px;
      }
    '';
  };

  environment.etc."greetd/sway-config".text = ''
    output DP-1 enable position 0 0 transform normal
    output DP-2 disable
    output HDMI-A-1 disable

    exec "${pkgs.regreet}/bin/regreet; ${pkgs.sway}/bin/swaymsg exit"

    include /etc/sway/config.d/*
  '';
}
