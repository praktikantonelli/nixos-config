{ ... }: {
  wayland.windowManager.hyprland.extraLuaFiles = {
    "desktop.lua" = ./desktop.lua;
  };
}
