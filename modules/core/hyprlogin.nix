{ config, pkgs, lib, username, inputs, ... }:

let
  desktops = config.services.displayManager.sessionData.desktops;

  runtimePath = lib.makeBinPath [
    pkgs.bash
    pkgs.coreutils
    pkgs.gnugrep
    pkgs.gnused
    pkgs.hyprland
    pkgs.uwsm
    pkgs.hyprlogin
  ] + ":/run/current-system/sw/bin";

  hyprloginConfig = pkgs.writeText "hyprlogin.conf" ''

    general {
      exit_command = ${pkgs.hyprland}/bin/hyprctl dispatch exit
      debug_mode = true
      debug_log_path = /tmp/hyprlogin-debug.log
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
in {

  nixpkgs.overlays = [ inputs.nix-hyprlogin.overlays.default ];
  imports = [ inputs.nix-hyprlogin.nixosModules.default ];

  # Do not let the nix-hyprlogin module own greetd for now.
  services.hyprlogin.enable = lib.mkForce false;

  # Make sure ReGreet is not also configuring greetd.
  programs.regreet.enable = lib.mkForce false;

  # Keep your actual Hyprland session available system-wide.
  programs.hyprland.enable = true;

  # If you want the UWSM session, keep/enable UWSM.
  programs.uwsm.enable = true;

  # This makes the NixOS-generated desktop-session bundle visible
  # in /run/current-system/sw/share as well.
  environment.systemPackages =
    [ desktops pkgs.hyprlogin pkgs.hyprland pkgs.uwsm ];

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
    extraGroups = [ "video" "render" "input" ];
  };

  users.groups.greeter = { };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
