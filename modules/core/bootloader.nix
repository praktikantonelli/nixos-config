{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = false;
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };

    plymouth.enable = true;
    consoleLogLevel = 3;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
    ];

  };
}
