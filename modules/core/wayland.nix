{ inputs, pkgs, ... }: {
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
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
