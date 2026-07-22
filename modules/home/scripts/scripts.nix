{
  host,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  mkScript = name: runtimeInputs: file:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = builtins.readFile file;
    };

  wall-change = mkScript "wall-change" (with pkgs; [ procps swaybg ]) ./scripts/wall-change.sh;
  wallpaper-picker = mkScript "wallpaper-picker" (with pkgs; [
    coreutils
    findutils
    fuzzel
    wall-change
  ]) ./scripts/wallpaper-picker.sh;

  runbg = mkScript "runbg" [ pkgs.coreutils ] ./scripts/runbg.sh;

  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  toggle_blur = mkScript "toggle_blur" [ pkgs.gnugrep hyprland ] ./scripts/toggle_blur.sh;
  toggle_opacity = mkScript "toggle_opacity" [ pkgs.gnugrep hyprland ] ./scripts/toggle_oppacity.sh;
  toggle_oppacity = pkgs.writeShellApplication {
    name = "toggle_oppacity";
    runtimeInputs = [ toggle_opacity ];
    text = ''exec toggle_opacity "$@"'';
  };

  offload = mkScript "offload" [ ] ./scripts/offload.sh;

  maxfetch = mkScript "maxfetch" (with pkgs; [
    coreutils
    gawk
    gnused
    ncurses
    nix
    procps
  ]) ./scripts/maxfetch.sh;

  archiveInputs = with pkgs; [ coreutils gnutar gzip ];
  compress = mkScript "compress" archiveInputs ./scripts/compress.sh;
  extract = mkScript "extract" archiveInputs ./scripts/extract.sh;

  shutdown-script = mkScript "shutdown-script" (with pkgs; [
    coreutils
    fuzzel
    libnotify
    systemd
  ]) ./scripts/shutdown-script.sh;

  connect-vpn = mkScript "connect-vpn" (with pkgs; [
    openfortivpn
    openfortivpn-webview
    sudo
  ]) ./scripts/connect_vpn.sh;

  fzfdiff = mkScript "fzfdiff" (with pkgs; [ fzf git ]) ./scripts/fzfdiff.sh;

  record = pkgs.writeShellApplication {
    name = "record";
    runtimeInputs = with pkgs; [
      coreutils
      ffmpeg
      gifsicle
      hyprland
      jq
      libnotify
      procps
      slurp
      systemd
      wf-recorder
      wl-clipboard
      zenity
    ];
    text = builtins.readFile ./scripts/record.sh;
  };

in
{
  home.packages = [
    wall-change
    wallpaper-picker

    runbg

    toggle_blur
    toggle_opacity
    toggle_oppacity

    maxfetch

    compress
    extract

    shutdown-script

    connect-vpn

    fzfdiff

    record
  ] ++ lib.optionals (host == "laptop") [ offload ];
}
