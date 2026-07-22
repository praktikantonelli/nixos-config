{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    # swww
    swaybg
    inputs.hypr-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    hyprpicker
    grim
    slurp
    wl-clip-persist
    wf-recorder
    glib
    wayland
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    # UWSM owns the graphical-session lifecycle and environment.
    systemd.enable = false;

    configType = "lua";
    extraLuaFiles = { "config.lua" = ./config.lua; };
  };
}
