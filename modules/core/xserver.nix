{ ... }: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "ch";
      xkb.variant = "";
    };

    libinput = {
      enable = true;
      # mouse = {
      #   accelProfile = "flat";
      # };
    };
  };

  # Set keyboard layout to Swiss German QWERTZ
  console.keyMap = "sg";
}
