{
  inputs,
  pkgs,
  ...
}:
let
  mkScript =
    name: runtimeInputs: file:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = builtins.readFile file;
    };

  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

  maxfetch = mkScript "maxfetch" (with pkgs; [
    coreutils
    gawk
    gnused
    ncurses
    nix
    procps
  ]) ./scripts/maxfetch.sh;

  archiveInputs = with pkgs; [
    coreutils
    gnutar
    gzip
  ];
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

  fzfdiff = mkScript "fzfdiff" (with pkgs; [
    fzf
    git
  ]) ./scripts/fzfdiff.sh;

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
    maxfetch

    compress
    extract

    shutdown-script

    connect-vpn

    fzfdiff

    record
  ];
}
