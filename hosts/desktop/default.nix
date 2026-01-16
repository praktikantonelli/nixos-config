{ config, pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ./../../modules/core ];

  powerManagement.cpuFreqGovernor = "performance";
  hardware.graphics = { 
    enable = true; 
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["amdgpu"];

  environment.systemPackages = with pkgs; [
    mesa
    vulkan-tools
    libva-utils
    wayland-utils
  ];

  services.seatd.enable = true;

  users.users.${username}.extraGroups = ["wheel" "networkmanager" "video" "render" "seat"];

}
