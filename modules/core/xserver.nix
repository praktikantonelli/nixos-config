{ ... }: {
  services = {
    xserver = {
      xkb.layout = "ch";
      xkb.variant = "";
    };
  };

  # Set keyboard layout to Swiss German QWERTZ
  console.keyMap = "sg";
}
