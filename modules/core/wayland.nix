{ inputs, ... }: {
  nixpkgs.overlays = [
    (final: _prev: {
      hyprland = inputs.hyprland.packages.${final.stdenv.hostPlatform.system}.hyprland;
    })
  ];

  programs.hyprland.enable = true;
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
