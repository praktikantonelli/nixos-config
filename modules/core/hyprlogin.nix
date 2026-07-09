{
  config,
  pkgs,
  lib,
  username,
  inputs,
  ...
}:

let
  desktops = config.services.displayManager.sessionData.desktops;

  runtimePath =
    lib.makeBinPath [
      pkgs.bash
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.hyprland
      pkgs.uwsm
      pkgs.hyprlogin
    ]
    + ":/run/current-system/sw/bin";

  hyprloginConfig = pkgs.writeText "hyprlogin.conf" ''

        general {
          exit_command = ${pkgs.hyprland}/bin/hyprctl dispatch exit
          disable_loading_bar = true
          hide_cursor = true
        }

        sessions {
          wayland_path = ${desktops}/share/wayland-sessions
          x11_path = ${desktops}/share/xsessions

          default_user = ${username}
          default_session = hyprland-uwsm.desktop
        }

        $red = rgb(cc241d)
        $yellow = rgb(d79921)
        $lavender = rgb(458588)

        $mauve = rgb(b16286)
        $mauveAlpha = b16286

        $base = rgb(1e1e2e)
        $surface0 = rgb(313244)
        $text = rgb(fbf1c7)
        $textAlpha = fbf1c7

        $accent = $lavender
        $accentAlpha = $mauveAlpha
        $font = JetBrainsMono Nerd Font

        # BACKGROUND
        background {
          monitor =
          path = ${./../../wallpapers/lock-screen.png}
          color = $base
          blur_passes = 0
        }

        # TIME
        label {
          monitor =
          text = cmd[update:30000] echo "<b><big> $(date +"%R") </big></b>"
          color = $text
          font_size = 110
          font_family = $font
          shadow_passes = 3
          shadow_size = 3

          position = 0, -100
          halign = center
          valign = top
        }

        # DATE 
        label {
          monitor = 
          text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
          color = $text
          font_size = 18
          font_family = $font
          position = 0, -300
          halign = center
          valign = top
        }

        # USER AVATAR

        image {
          monitor = 
          size = 125
          border_color = $accent

          position = 0, -450
          halign = center
          valign = center
        }

        # INPUT FIELD
        input-field {
          monitor =
          size = 300, 60
          outline_thickness = 4
          dots_size = 0.2
          dots_spacing = 0.4
          dots_center = true
          outer_color = $accent
          inner_color = $surface0
          font_color = $text
          fade_on_empty = false
          placeholder_text = <span foreground="##$textAlpha"><i>󰌾</i></span>
          hide_input = false
          check_color = $accent
          fail_color = $red
          fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
          capslock_color = $yellow
          position = 0, -100
          halign = center
          valign = center
        }
    }

    sessions {
      wayland_path = ${desktops}/share/wayland-sessions
      x11_path = ${desktops}/share/xsessions

      default_user = ${username}
      default_session = hyprland-uwsm.desktop
    }
  '';

  hyprlandGreeterConfig = pkgs.writeText "hyprland-greeter.conf" ''
    monitor = ,preferred,auto,1

    input {
      kb_layout = ch
    }

    exec-once = ${pkgs.hyprlogin}/bin/hyprlogin -c ${hyprloginConfig}
  '';

  startHyprloginGreeter = pkgs.writeShellScript "start-hyprlogin-greeter" ''
    export PATH="${runtimePath}"
    export XDG_DATA_DIRS="${desktops}/share:/run/current-system/sw/share:/usr/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

    if command -v start-hyprland >/dev/null 2>&1; then
      exec start-hyprland -- --config ${hyprlandGreeterConfig}
    else
      exec ${pkgs.hyprland}/bin/Hyprland --config ${hyprlandGreeterConfig}
    fi
  '';
in
{

  nixpkgs.overlays = [ inputs.nix-hyprlogin.overlays.default ];
  imports = [ inputs.nix-hyprlogin.nixosModules.default ];

  programs.uwsm.enable = true;

  environment.systemPackages = [
    desktops
    pkgs.hyprlogin
    pkgs.hyprland
    pkgs.uwsm
  ];

  services.greetd = {
    enable = true;

    settings = {
      terminal.vt = 1;

      default_session = {
        command = "${startHyprloginGreeter}";
        user = "greeter";
      };
    };
  };

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    extraGroups = [
      "video"
      "render"
      "input"
    ];
  };

  users.groups.greeter = { };
}
