{ inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default
  ];

  # stop fighting home manager to lua translations and just use lua directly
  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;

}
