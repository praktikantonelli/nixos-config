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

  services = {
    power-profiles-daemon.enable = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    xserver.videoDrivers = [ "amdgpu" ];
    seatd.enable = true;
  };

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "amdgpu" ];
  };

  environment.systemPackages = with pkgs; [
    mesa
    vulkan-tools
    libva-utils
    wayland-utils
  ];

  users.users.${username}.extraGroups = [
    "wheel"
    "networkmanager"
    "video"
    "render"
    "seat"
  ];

}
