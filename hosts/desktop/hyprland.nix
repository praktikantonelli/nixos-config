{ ... }: {
  imports = [
    ../../modules/home/hyprland
  ];

  wayland.windowManager.hyprland.extraLuaFiles = {
    "desktop.lua" = ./desktop.lua;
  };
}
