{ pkgs, ... }:

{
  system.fsPackages = [ pkgs.bindfs ];

  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };

    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [ gnome-themes-extra ];
      pathsToLink = [ "/share/icons" ];
    };

    # IMPORTANT: use a runtime path to avoid infinite recursion.
    # This directory is provided by the running system when fonts.fontDir.enable = true.
    systemX11Fonts = "/run/current-system/sw/share/X11/fonts";
  in {
    "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/local/share/fonts" = mkRoSymBind systemX11Fonts;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [ nerd-fonts.jetbrains-mono nerd-fonts.noto sn-pro ];
  };
}
