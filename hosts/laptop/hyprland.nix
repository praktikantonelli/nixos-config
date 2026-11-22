{ ... }: {
  wayland.windowManager.hyprland.extraLuaFiles = {
    "laptop.lua" = ./laptop.lua;
  };
}
