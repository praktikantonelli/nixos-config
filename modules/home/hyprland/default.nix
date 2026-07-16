{ inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default
  ];

}
