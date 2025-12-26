{ ... }: {
  hardware = {
    graphics = { enable = true; };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  hardware.enableRedistributableFirmware = true;

}
