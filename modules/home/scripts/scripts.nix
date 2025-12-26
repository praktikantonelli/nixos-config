{ pkgs, ... }:
let
  wall-change = pkgs.writeShellScriptBin "wall-change"
    (builtins.readFile ./scripts/wall-change.sh);
  wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker"
    (builtins.readFile ./scripts/wallpaper-picker.sh);

  runbg =
    pkgs.writeShellScriptBin "runbg" (builtins.readFile ./scripts/runbg.sh);

  toggle_blur = pkgs.writeScriptBin "toggle_blur"
    (builtins.readFile ./scripts/toggle_blur.sh);
  toggle_oppacity = pkgs.writeScriptBin "toggle_oppacity"
    (builtins.readFile ./scripts/toggle_oppacity.sh);

  offload =
    pkgs.writeScriptBin "offload" (builtins.readFile ./scripts/offload.sh);

  maxfetch =
    pkgs.writeScriptBin "maxfetch" (builtins.readFile ./scripts/maxfetch.sh);

  compress =
    pkgs.writeScriptBin "compress" (builtins.readFile ./scripts/compress.sh);
  extract =
    pkgs.writeScriptBin "extract" (builtins.readFile ./scripts/extract.sh);

  shutdown-script = pkgs.writeScriptBin "shutdown-script"
    (builtins.readFile ./scripts/shutdown-script.sh);

  show-keybinds = pkgs.writeScriptBin "show-keybinds"
    (builtins.readFile ./scripts/keybinds.sh);

  connect-vpn = pkgs.writeScriptBin "connect-vpn"
    (builtins.readFile ./scripts/connect_vpn.sh);

  fzfdiff =
    pkgs.writeShellScriptBin "fzfdiff" (builtins.readFile ./scripts/fzfdiff.sh);

in {
  home.packages = with pkgs; [
    wall-change
    wallpaper-picker

    runbg

    toggle_blur
    toggle_oppacity

    offload

    maxfetch

    compress
    extract

    shutdown-script

    show-keybinds

    connect-vpn

    fzfdiff

  ];
}
