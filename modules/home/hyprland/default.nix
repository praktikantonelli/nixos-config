{ inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./config2.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
