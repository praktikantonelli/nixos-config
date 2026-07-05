{ inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./config.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
