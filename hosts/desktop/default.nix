{ config, ... }: {
  imports = [ ./hardware-configuration.nix ./../../modules/core ];

  powerManagement.cpuFreqGovernor = "performance";
  hardware.graphics = { enable = true; };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
