{ pkgs, username, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/core/steam.nix
    ../../modules/core/tailscale-client.nix
    ../../modules/core/sops.nix
    ../../modules/core/work.nix
    ../../modules/services
  ];

  services.power-profiles-daemon.enable = true;

  hardware.graphics.enable32Bit = true;

  boot.initrd.kernelModules = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    vulkan-tools
    libva-utils
    wayland-utils
  ];

  users.users.${username}.extraGroups = [
    "video"
    "render"
    "media"
  ];

}
